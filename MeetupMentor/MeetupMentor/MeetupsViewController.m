//
//  MeetupsViewController.m
//  MeetupMentor
//
//  Created by Daniel Distant on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "MeetupsViewController.h"

#import "MeetupManager.h"

@interface MeetupsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UITextField* textField;

@property (nonatomic) NSMutableArray* meetupResultsArray;

@end

@implementation MeetupsViewController

- (void)viewDidLoad

{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.textField.delegate = self;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return self.meetupResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MeetupCell" forIndexPath:indexPath];
    
    
    cell.textLabel.text = self.meetupResultsArray[indexPath.row];
    
    
    
    return cell;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField endEditing:YES];
    
    [MeetupManager fetchMeetupsForParameters:@{@"search" : textField.text} withCompletionBlock:^(id response, NSError *error) {
        
        NSArray *results = response[@"results"];
        
        self.meetupResultsArray = [[NSMutableArray alloc]init];
        
        for(NSDictionary* result in results){
            
            [self.meetupResultsArray addObject:result[@"name"]];
            
        }
        
        [self.tableView reloadData];
    }];
    
    
    return YES;
}



@end
