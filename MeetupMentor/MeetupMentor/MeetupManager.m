//
//  MeetupManager.m
//  MeetupMentor
//
//  Created by Jackie Meggesto on 10/31/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "MeetupManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation MeetupManager

+(void)fetchMeetupsForParameters:(NSDictionary*)parameters
             withCompletionBlock:(void (^)(id response, NSError *error))completionBlock
{
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    
    NSMutableString* URLString = [NSMutableString stringWithString:@"https://api.meetup.com/topics?key=144a6d614e37349b607f7e456066"];
    
    for(NSString* parameter in parameters){
        
        [URLString appendString:[NSString stringWithFormat:@"&%@=%@", parameter, parameters[parameter]]];
        
    }
    
    
    
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completionBlock(responseObject, nil);
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
}

@end
