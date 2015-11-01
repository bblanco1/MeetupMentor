//
//  MessagesViewController.h
//  MeetupMentor
//
//  Created by Elber Carneiro on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *myUserID;
@property (strong, nonatomic) NSString *chatMateID;

@end
