//
//  AppDelegate.h
//  MeetupMentor
//
//  Created by Elber Carneiro on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Sinch/Sinch.h>
#import "Config.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SINClientDelegate, SINMessageClientDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<SINClient> sinchClient;
@property (strong, nonatomic) id<SINMessageClient> sinchMessageClient;

- (void)initSinchClient:(NSString *)userID;
- (void)sendTextMessage:(NSString *)messageText toRecipient:(NSString *)recipientID;

@end

