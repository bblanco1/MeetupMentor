//
//  MentorCollectionViewCell.m
//  MeetupMentor
//
//  Created by Daniel Distant on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "MentorCollectionViewCell.h"
#import <UIImageViewSoftFrameAnimations/UIImageView+SoftFrameAnimations.h>


@implementation MentorCollectionViewCell

- (void)awakeFromNib {
    
    self.mentorPhoto.layer.cornerRadius = 10.0;
    self.mentorBio.layer.cornerRadius = 15.0;
    self.mentorBio.clipsToBounds = YES;
    
    self.notificationImageView.layer.borderWidth = 2.0;
    self.notificationImageView.layer.borderColor = [UIColor magentaColor].CGColor;
    self.notificationImageView.layer.cornerRadius = 10.0;
//    self.notificationImageView.hidden = YES;
    
    [self.notificationImageView softFrameAnimateWithImageName:@"tmp-" numberOfDigits:3 firstDigit:1 andExtension:@"jpeg" loop:NO loopCount:0 andFPS:1/268.0];
}

@end
