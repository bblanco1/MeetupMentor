//
//  SearchMentorsViewController.m
//  MeetupMentor
//
//  Created by Daniel Distant on 11/1/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "SearchMentorsViewController.h"
#import "ChatTableViewController.h"

@interface SearchMentorsViewController () <UITextFieldDelegate>

// r 225/255.0 g 57/255.0 b 66/255.0

@property (weak, nonatomic) IBOutlet UITextField *searchMentorTextField;

@end

@implementation SearchMentorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchMentorTextField.delegate = self;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    [self performSegueWithIdentifier:@"MentorSegue" sender:self];
    
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UITabBarController *tabBarController = segue.destinationViewController;
    UINavigationController *navController = tabBarController.viewControllers[1];
    ChatTableViewController *tvc = (ChatTableViewController *)navController.topViewController;
    tvc.myUserID = self.myUserID;
    
}


@end
