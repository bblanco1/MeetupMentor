//
//  MeetupManager.h
//  MeetupMentor
//
//  Created by Jackie Meggesto on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetupManager : NSObject

+(void)fetchMeetupsForParameters:(NSDictionary*)parameters
             withCompletionBlock:(void (^)(id response, NSError *error))completionBlock;

@end
