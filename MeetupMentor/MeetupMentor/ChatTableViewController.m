//
//  ChatTableViewController.m
//  MeetupMentor
//
//  Created by Elber Carneiro on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "ChatTableViewController.h"
#import "MessagesViewController.h"
#import "CustomUser.h"

@interface ChatTableViewController ()

@property (strong, nonatomic) NSMutableArray *connectionsArray;
@property (strong, nonatomic) MessagesViewController *activeMessagesViewController;

@end

@implementation ChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.myUserID;
    self.connectionsArray = [NSMutableArray new];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crumpled-white-paper-texture"]];
    
    self.activeMessagesViewController = nil;
    [self retrieveConnectionsFromParse];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.connectionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"connectionIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = self.connectionsArray[indexPath.row];
    cell.layer.backgroundColor = [UIColor clearColor].CGColor;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - Functional methods
- (void)retrieveConnectionsFromParse {
    // clear the array in order to have the most up-to-date information
    [self.connectionsArray removeAllObjects];
    
    // create a query to retrieve app usernames (registered users), but excluding
    // our own username
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query whereKey:@"username" notEqualTo:self.myUserID];
    
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *connectionsArray, NSError *error) {
        if (!error) {
            for (int i = 0; i < [connectionsArray count]; i++) {
                [weakSelf.connectionsArray addObject:connectionsArray[i][@"username"]];
            }
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"Error %@", error.description);
        }
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"openMessagesSegue"]) {
        self.activeMessagesViewController = [segue destinationViewController];
        
        // get the index of the cell
        NSInteger chatMateIndex = [[self.tableView indexPathForCell:(UITableViewCell *)sender] row];
        
        // set the user name of the person you are taling to according to the cell index. This will
        // be used for the navigation bar title of the destination tableview.
        self.activeMessagesViewController.chatMateID = self.connectionsArray[chatMateIndex];
        
        self.activeMessagesViewController.myUserID = self.myUserID;
    }
}


@end
