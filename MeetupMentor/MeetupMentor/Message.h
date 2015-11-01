//
//  Message.h
//  MeetupMentor
//
//  Created by Elber Carneiro on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Sinch/Sinch.h>

@interface Message : NSObject <SINMessage>

@property (strong, nonatomic) NSString *messageId;
@property (strong, nonatomic) NSArray *recipientIds;
@property (strong, nonatomic) NSString *senderId;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDictionary *headers;
@property (strong, nonatomic) NSDate *timestamp;

@end
