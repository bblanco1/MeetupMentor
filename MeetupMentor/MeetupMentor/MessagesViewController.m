//
//  MessagesViewController.m
//  MeetupMentor
//
//  Created by Elber Carneiro on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "MessagesViewController.h"
#import "Message.h"
#import "MessageCell.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface MessagesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) NSMutableArray *messagesArray;
@property (strong, nonatomic) UITextField *activeTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardOffsetConstraint;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageTextField.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.navigationItem.title = self.chatMateID;
    
    self.messagesArray = [NSMutableArray new];
    
    [self retrieveMessagesFromParseWithChatMateID:self.chatMateID];
    
    UIGestureRecognizer *tapTableGR = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView)];
    [self.tableView addGestureRecognizer:tapTableGR];
    
    [self registerForKeyboardNotifications];
}

- (void)retrieveMessagesFromParseWithChatMateID:(NSString *)chatMateID {
    NSArray *userNames = @[self.myUserID, chatMateID];
    
    PFQuery *query = [PFQuery queryWithClassName:@"SinchMessage"];
    [query whereKey:@"senderId" containedIn:userNames];
    [query whereKey:@"recipientId" containedIn:userNames];
    [query orderByAscending:@"timestamp"];
    
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *chatMessageArray, NSError *error) {
        if (!error) {
            // store all retrieved messages into the message array
            for (int i = 0; i < [chatMessageArray count]; i++) {
                Message *chatMessage = [Message new];
                [chatMessage setMessageId:chatMessageArray[i][@"messageId"]];
                [chatMessage setSenderId:chatMessageArray[i][@"senderId"]];
                [chatMessage setRecipientIds:[NSArray arrayWithObject:chatMessageArray[i][@"recipientId"]]];
                [chatMessage setText:chatMessageArray[i][@"text"]];
                [chatMessage setTimestamp:chatMessageArray[i][@"timestamp"]];
                
                [weakSelf.messagesArray addObject:chatMessage];
            }
            NSLog(@"%@", weakSelf.messagesArray);
            [weakSelf updateTableview:weakSelf.tableView withMessages:weakSelf.messagesArray];
            [weakSelf scrollTableToBottom];
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
}

- (void)updateTableview:(UITableView *)tableView withMessages:(NSMutableArray *)messagesArray {
    
    [tableView reloadData];
    
    /*
     if the height of the tableview's content becomes bigger that the tableview's
     frame height, we scroll the tableview to the last cell
     */
    if (tableView.contentSize.height > tableView.frame.size.height) {
        
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

// setup keyboard notifications
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Interface behavior
- (void)didTapOnTableView {
    [self.activeTextField resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (self.keyboardOffsetConstraint.constant == 8) {
        self.keyboardOffsetConstraint.constant += kbSize.height;
        [self scrollTableToBottom];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    self.keyboardOffsetConstraint.constant = 8;

    if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Functional methods
- (void)scrollTableToBottom {
    NSInteger rowNumber = [self.tableView numberOfRowsInSection:0];
    
    if (rowNumber > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber - 1 inSection:0]
                                                atScrollPosition:UITableViewScrollPositionBottom
                                                        animated:YES];
    }
}

#pragma mark - UITableViewSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"messageCellIdentifier"
                                                                      forIndexPath:indexPath];
    [self configureCell:messageCell forIndexPath:indexPath];
    
    return messageCell;
}

- (void)configureCell:(MessageCell *)messageCell forIndexPath:(NSIndexPath *)indexPath {
    Message *chatMessage = self.messagesArray[indexPath.row];
    
    NSString *tempText = [NSString new];
    
    if ([chatMessage.text isEqualToString:@""]) {
        
        tempText = @"Got it.";
        
    } else {
        
        tempText = chatMessage.text;
        
    }
        
    if ([chatMessage.senderId isEqualToString:self.myUserID]) {
        // if the message was sent by myself
        messageCell.titleLabel.text = @"You:";
        messageCell.detailLabel.text = tempText;
        messageCell.titleLabel.textColor = [UIColor purpleColor];
    } else {
   
    }

}

#pragma mark - UITextfieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
        
    // Send the message to the server
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate sendTextMessage:self.messageTextField.text toRecipient:self.chatMateID];
    
    // Update the message on the screen without contacting server?
    Message *outgoingMessage = [Message new];
    outgoingMessage.text = self.messageTextField.text;
    outgoingMessage.senderId = self.myUserID;
    [self.messagesArray addObject:outgoingMessage];
    [self.tableView reloadData];
    [self scrollTableToBottom];
    
    // Clear text in textfield
    self.messageTextField.text = @"";
    //[self.messageTextField setNeedsDisplay];
    
    return YES;
}

@end
