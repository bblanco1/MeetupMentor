//
//  MessageCell.h
//  MeetupMentor
//
//  Created by Elber Carneiro on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
