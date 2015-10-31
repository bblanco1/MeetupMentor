//
//  MentorCollectionViewCell.m
//  MeetupMentor
//
//  Created by Daniel Distant on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "MentorCollectionViewCell.h"

@implementation MentorCollectionViewCell

- (void)awakeFromNib {
    
    self.mentorPhoto.layer.cornerRadius = 10.0;
    self.mentorBio.layer.cornerRadius = 10.0;
}

@end
