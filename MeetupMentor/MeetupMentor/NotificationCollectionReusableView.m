//
//  NotificationCollectionReusableView.m
//  MeetupMentor
//
//  Created by Daniel Distant on 11/1/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "NotificationCollectionReusableView.h"
#import <UIImageViewSoftFrameAnimations/UIImageView+SoftFrameAnimations.h>

@implementation NotificationCollectionReusableView

- (void)awakeFromNib {
    
    [self.notificationImageView softFrameAnimateWithImageName:@"tmp-" numberOfDigits:3 firstDigit:1 andExtension:@"jpeg" loop:NO loopCount:0 andFPS:1/268.0];
}

@end
