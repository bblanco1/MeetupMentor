//
//  CustomUser.h
//  MeetupMentor
//
//  Created by Elber Carneiro on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "PFUser.h"

@interface CustomUser : PFUser <PFSubclassing>

@property (retain) NSString* favoriteNumber;

@end
