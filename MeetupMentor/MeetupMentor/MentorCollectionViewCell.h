//
//  MentorCollectionViewCell.h
//  MeetupMentor
//
//  Created by Daniel Distant on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MentorCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mentorPhoto;
@property (weak, nonatomic) IBOutlet UILabel *mentorBio;
@property (weak, nonatomic) IBOutlet UIImageView *notificationImageView;


@end
