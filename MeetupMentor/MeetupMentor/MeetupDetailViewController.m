//
//  MeetupDetailViewController.m
//  MeetupMentor
//
//  Created by Daniel Distant on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "MeetupDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MeetupDetailViewController () 

@property (nonatomic, weak) IBOutlet UIImageView* meetupImageView;
@property (nonatomic, weak) IBOutlet UITextView* textView;

@end

@implementation MeetupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = self.meetupDataObject.meetupGroupDescription;
    [self.meetupImageView sd_setImageWithURL:[NSURL URLWithString:self.meetupDataObject.meetupImageURL]
                      placeholderImage:nil
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                                 self.meetupImageView.image = image;
                                 
                             }];
    
}

@end
