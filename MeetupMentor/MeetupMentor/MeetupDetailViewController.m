//
//  MeetupDetailViewController.m
//  MeetupMentor
//
//  Created by Daniel Distant on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "MeetupDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MeetupDetailViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) IBOutlet UIImageView* meetupImageView;
@property (nonatomic, weak) IBOutlet UITextView* textView;
@property (nonatomic, weak) IBOutlet UIPickerView* pickerView;

@property (nonatomic) NSArray* pickerViewData;

@end

@implementation MeetupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.pickerViewData = [[NSArray alloc]init];
    self.pickerViewData = @[@"I am a mentor", @"I need a mentor"];

    
    
    [self.textView scrollRangeToVisible:NSMakeRange(0, 1)];
    
    self.meetupImageView.layer.borderColor = [UIColor colorWithRed:225/255.0 green:57/255.0 blue:66/255.0 alpha:1].CGColor;
    self.meetupImageView.layer.borderWidth = 2.0;
    self.meetupImageView.layer.cornerRadius = 10.0;
    
    self.pickerView.layer.cornerRadius = 10.0;
    self.pickerView.layer.borderWidth = 2.0;
    self.pickerView.layer.borderColor = [UIColor colorWithRed:225/255.0 green:57/255.0 blue:66/255.0 alpha:1].CGColor;


    
    NSLog(@"%@", self.meetupDataObject.meetupGroupDescription);
    [self.textView setText:self.meetupDataObject.meetupGroupDescription];
    [self.meetupImageView sd_setImageWithURL:[NSURL URLWithString:self.meetupDataObject.meetupImageURL]
                      placeholderImage:nil
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                                 self.meetupImageView.image = image;
                                 
                             }];
    
}

#pragma mark PickerView methods

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerViewData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerViewData[row];
}

@end
