//
//  AppDelegate.m
//  MeetupMentor
//
//  Created by Elber Carneiro on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomUser.h"
#import <ChameleonFramework/Chameleon.h>


@interface AppDelegate ()

@property (nonatomic, weak) id<SINMessageClientDelegate> delegate;

@end

@implementation AppDelegate

@synthesize delegate;

#pragma mark -
#pragma mark - Lifecycle methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [Chameleon setGlobalThemeUsingPrimaryColor:[UIColor colorWithHexString:@"E13942"] withContentStyle:UIContentStyleContrast];
    [CustomUser registerSubclass];
    [Parse setApplicationId:PARSE_APPLICATION_ID clientKey:PARSE_CLIENT_KEY];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [CustomUser logOut];
}

#pragma mark - 
#pragma mark - functional methods

// Initialize the Sinch client
- (void)initSinchClient:(NSString *)userID {
    self.sinchClient = [Sinch clientWithApplicationKey:SINCH_APPLICATION_KEY applicationSecret:SINCH_APPLICATION_SECRET environmentHost:SINCH_ENVIRONMENT_HOST userId:userID];
    self.sinchClient.delegate = self;
    
    NSLog(@"Sinch version: %@, userID: %@", [Sinch version], [self.sinchClient userId]);
    
    [self.sinchClient setSupportMessaging:YES];
    [self.sinchClient start];
    [self.sinchClient startListeningOnActiveConnection];
}

- (void)sendTextMessage:(NSString *)messageText toRecipient:(NSString *)recipientID {
    // create the message
    SINOutgoingMessage *outgoingMessage = [SINOutgoingMessage messageWithRecipient:recipientID text:messageText];
    
    // pass message to message client
    [self.sinchClient.messageClient sendMessage:outgoingMessage];
}

// Sinch provides 30 days of storage for the messages, but Parse is better because it lets us
// create a history beyond 30 days and with any devide, tying it to the Parse user name!
- (void)saveMessagesOnParse:(id<SINMessage>)message {
    PFQuery *query = [PFQuery queryWithClassName:@"SinchMessage"];
    [query whereKey:@"messageId" equalTo:[message messageId]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *messageArray, NSError *error) {
        if (!error) {
            // If the message is not already saved on Parse, save it
            if ([messageArray count] <= 0) {
                PFObject *messageObject = [PFObject objectWithClassName:@"SinchMessage"];
                messageObject[@"messageId"] = [message messageId];
                messageObject[@"senderId"] = [message senderId];
                messageObject[@"recipientId"] = [message recipientIds][0];
                messageObject[@"text"] = [message text];
                messageObject[@"timestamp"] = [message timestamp];
                
                [messageObject saveInBackground];
            }
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
}

#pragma mark - SINClientDelegate protocol methods
- (void)clientDidStart:(id<SINClient>)client {
    NSLog(@"Start SINClient successful!");
    // We must first create a sinch client and then use the sinch client to
    // initialize a sinch message client
    self.sinchMessageClient = [self.sinchClient messageClient];
    self.sinchMessageClient.delegate = self;
}

- (void)clientDidFail:(id<SINClient>)client error:(NSError *)error {
    NSLog(@"Start SINClient failed. Description: %@. Reason: %@", error.localizedDescription, error.localizedFailureReason);
}

#pragma mark - SINMessageClientDelegate protocol methods
// Receive an incoming message
- (void)messageClient:(id<SINMessageClient>)messageClient didReceiveIncomingMessage:(id<SINMessage>)message {
    [self saveMessagesOnParse:message];
    [[NSNotificationCenter defaultCenter] postNotificationName:SINCH_MESSAGE_RECEIVED object:self userInfo:@{@"message" : message}];
}

// Finish sending a message
- (void)messageSent:(id<SINMessage>)message recipientId:(NSString *)recipientId {
    [self saveMessagesOnParse:message];
    [[NSNotificationCenter defaultCenter] postNotificationName:SINCH_MESSAGE_SENT object:self userInfo:@{@"message" : message}];
}

// Handle failed message
- (void)messageFailed:(id<SINMessage>)message info:(id<SINMessageFailureInfo>)messageFailureInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:SINCH_MESSAGE_FAILED object:self userInfo:@{@"message" : message}];
    NSLog(@"MessageBoard: message to %@ failed. Description: %@. Reason: %@.", messageFailureInfo.recipientId, messageFailureInfo.error.localizedDescription, messageFailureInfo.error.localizedFailureReason);
}

// Handle successful message delivery
- (void)messageDelivered:(id<SINMessageDeliveryInfo>)info {
    [[NSNotificationCenter defaultCenter] postNotificationName:SINCH_MESSAGE_DELIVERED object:self];
}


@end
