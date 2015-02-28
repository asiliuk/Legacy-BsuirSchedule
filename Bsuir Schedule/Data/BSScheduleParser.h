//
//  BSScheduleParser.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 27.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSGroup.h"

@interface BSScheduleParser : NSObject
+ (BOOL)scheduleExpiresForGroup:(BSGroup*)group;
+ (void)scheduleForGroup:(BSGroup *)group withSuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end
