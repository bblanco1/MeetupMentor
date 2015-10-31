//
//  LoginViewController.m
//  MeetupMentor
//
//  Created by Elber Carneiro on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomUser.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.warningLabel.text = @"";
    self.warningLabel.hidden = YES;
    
    // set up gesture to hide keyboard when user taps outside the text fields
    UITapGestureRecognizer *tapViewGR = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(didTapOnView)];
    [self.view addGestureRecognizer:tapViewGR];
}

#pragma mark - User interface behavioral methods
// if you tap outside the text fields, this method will be used to hide the keyboard
- (void)didTapOnView {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark - Functional methods
- (IBAction)didTapSignup:(UIButton *)sender {
    // Parse SDK user class
    
    CustomUser *user = (CustomUser *)[CustomUser object];
    //PFUser *pfUser = [PFUser user];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    user.favoriteNumber = @"10";
    
    // This block of code will only be used after the signup process finishes so
    // we create a weak reference to the view controller to be used after signup
    // to handle the success or failure of the process. One should usually use weak
    // references to self in a callback block.
    __weak typeof(self) weakSelf = self;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            weakSelf.warningLabel.textColor = [UIColor greenColor];
            weakSelf.warningLabel.text = @"Signup successful!";
            weakSelf.warningLabel.hidden = NO;
        } else {
            weakSelf.warningLabel.textColor = [UIColor redColor];
            weakSelf.warningLabel.text = [error userInfo][@"error"];
            weakSelf.warningLabel.hidden = NO;
        }
    }];
}

- (IBAction)didTapLogin:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [PFUser logInWithUsernameInBackground:self.usernameField.text
                                 password:self.passwordField.text
                                    block:^(PFUser *pfUser, NSError *error)
     {
         
         if (pfUser && !error) {
             // proceed to next screen after successful login
             weakSelf.warningLabel.hidden = YES;
             
             [weakSelf performSegueWithIdentifier:@"LoginSegue" sender:self];
             
         } else {
             // the login failed, show error
             weakSelf.warningLabel.textColor = [UIColor redColor];
             weakSelf.warningLabel.text = [error userInfo][@"error"];
             weakSelf.warningLabel.hidden = NO;
         }
     }];
}

@end
