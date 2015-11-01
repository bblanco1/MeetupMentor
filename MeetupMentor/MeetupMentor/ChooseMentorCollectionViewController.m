//
//  ChooseMentorCollectionViewController.m
//  MeetupMentor
//
//  Created by Daniel Distant on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "ChooseMentorCollectionViewController.h"
#import "MentorDummy.h"
#import "MentorCollectionViewCell.h"

@interface ChooseMentorCollectionViewController ()

//@property (nonatomic) UIView *notificationViewContainer;

@end

@implementation ChooseMentorCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Choose A Mentor";
    self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crumpled-white-paper-texture"]];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MentorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.layer.backgroundColor = [UIColor whiteColor].CGColor;

    self.mentors = [[NSMutableArray alloc] init];
    
    UIImage *elberImage = [UIImage imageNamed:@"elber"];
    
    MentorDummy *elber = [[MentorDummy alloc] init];
  
    elber.photo = elberImage;
    elber.bio = @"Elber is an Objective-C developer\n This developer has been to NY Tech Meetup";

    UIImage *jackieImage = [UIImage imageNamed:@"jackie"];
    
    MentorDummy *jackie = [[MentorDummy alloc] init];
    
    jackie.photo = jackieImage;
    jackie.bio = @"Jackie is an Objective-C developer\n This developer has been to NY Tech Meetup";
    
    UIImage *brianImage = [UIImage imageNamed:@"brian"];
    
    MentorDummy *brian = [[MentorDummy alloc] init];
    
    brian.photo = brianImage;
    brian.bio = @"Brian is an Objective-C developer\n This developer has been to NY Tech Meetup";
    
    UIImage *danielImage = [UIImage imageNamed:@"daniel"];
    
    MentorDummy *daniel = [[MentorDummy alloc] init];
    
    daniel.photo = danielImage;
    daniel.bio = @"Daniel is an Objective-C developer\n This developer has been to NY Tech Meetup";
    
    UIImage *dianaImage = [UIImage imageNamed:@"diana"];
    
    MentorDummy *diana = [[MentorDummy alloc] init];
    
    diana.photo = dianaImage;
    diana.bio = @"Diana is an Objective-C developer\n This developer has been to NY Tech Meetup";
    
    UIImage *hennaImage = [UIImage imageNamed:@"henna"];
    
    MentorDummy *henna = [[MentorDummy alloc] init];
    
    henna.photo = hennaImage;
    henna.bio = @"Henna is an Objective-C developer\n This developer has been to NY Tech Meetup";
    
    UIImage *derekImage = [UIImage imageNamed:@"derek"];
    
    MentorDummy *derek = [[MentorDummy alloc] init];
    
    derek.photo = derekImage;
    derek.bio = @"Derek is an Objective-C developer\n This developer has been to NY Tech Meetup";
    
    UIImage *fatimaImage = [UIImage imageNamed:@"fatima"];
    
    MentorDummy *fatima = [[MentorDummy alloc] init];
    
    fatima.photo = fatimaImage;
    fatima.bio = @"Kaira Brian is an Objective-C developer\n This developer has been to NY Tech Meetup";
    
    [self.mentors addObject:brian];
    [self.mentors addObject:elber];
    [self.mentors addObject:jackie];
    [self.mentors addObject:daniel];
    [self.mentors addObject:derek];
    [self.mentors addObject:henna];
    [self.mentors addObject:fatima];
    [self.mentors addObject:diana];
}

- (void) fireNotification {
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.mentors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MentorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    MentorDummy *mentorDummy = [self.mentors objectAtIndex:indexPath.row];
    cell.mentorBio.text = mentorDummy.bio;
    cell.mentorPhoto.image = mentorDummy.photo;
    
    return cell;
    
}

#pragma mark - UICollectionView customization

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0,0,0,0);
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    // Determine which table cell the scrolling will stop on.
    CGFloat cellWidth = self.collectionView.bounds.size.width;
    NSInteger cellIndex = floor(targetContentOffset->x / cellWidth);
    
    // Round to the next cell if the scrolling will stop over halfway to the next cell.
    if ((targetContentOffset->x - (floor(targetContentOffset->x / cellWidth) * cellWidth)) > cellWidth) {
        cellIndex++;
    }
    
    // Adjust stopping point to exact beginning of cell.
    targetContentOffset->x = cellIndex * cellWidth;
}

#pragma mark <UICollectionViewDelegate>

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* selectMentor = [UIAlertAction actionWithTitle:@"Select mentor" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
//                                                              MentorDummy *mentorDummy = [self.mentors objectAtIndex:indexPath.row];
//                                                              [[NSUserDefaults standardUserDefaults] setObject:mentorDummy forKey:@"connection1"];
                                                              [self performSelector:@selector(fireNotification) withObject:self afterDelay:2.0];
                                                          }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    
    [alert addAction:selectMentor];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    return YES;
}


/*
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
