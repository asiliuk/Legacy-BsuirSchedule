//
//  BSScheduleParser.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 27.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSGroup.h"

extern NSString * const kGroupName;
extern NSString * const kGroupID;

@interface BSScheduleParser : NSObject
+ (BOOL)scheduleExpiresForGroup:(BSGroup*)group;
+ (void)scheduleForGroup:(BSGroup *)group withSuccess:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)allGroupsWithSuccess:(void (^)(NSArray *groups))success failure:(void (^)(NSError*))failure;
@end
