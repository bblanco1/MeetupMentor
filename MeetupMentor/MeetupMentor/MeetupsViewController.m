//
//  MeetupsViewController.m
//  MeetupMentor
//
//  Created by Daniel Distant on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "MeetupsViewController.h"

#import "MeetupManager.h"

#import "MeetupDetailViewController.h"

#import <CoreLocation/CoreLocation.h>


@interface MeetupsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UITextField* textField;

@property (nonatomic) NSMutableArray* meetupResultsArray;

@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) CLLocation* currentLocation;


@end

@implementation MeetupsViewController

- (void)viewDidLoad

{
    [super viewDidLoad];
    
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.textField.delegate = self;
    
    
}

#pragma mark CoreLocation

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations

{
    self.currentLocation = locations.lastObject;
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"There was a problem in updating your location"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
    
    [errorAlertView show];
    
    
}




#pragma mark TableViewDataSource Methods

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

#pragma mark TableViewDelegate Method


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    MeetupDetailViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetupDetailViewController"];
    
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
}
#pragma mark TextFieldDelegate Method

-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [textField endEditing:YES];
    
    NSString* formattedString = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [MeetupManager fetchMeetupsForParameters:@{@"text" : formattedString,
                                               @"lat" : [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude],
                                               @"lon" : [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude]
                                                }
                         withCompletionBlock:^(id response, NSError *error) {
        
        
        
        self.meetupResultsArray = [[NSMutableArray alloc]init];
        
        for(NSDictionary* result in response){
            
            [self.meetupResultsArray addObject:result[@"name"]];
            
        }
        
        [self.tableView reloadData];
    }];
    
    
    return YES;
}


@end
