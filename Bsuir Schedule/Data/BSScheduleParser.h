//
//  BSScheduleParser.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 27.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSScheduleParser : NSObject
+ (BOOL)scheduleNeedUpdateForGroup:(NSString *)groupNumber;
+ (void)scheduleForGroupNumber:(NSString *)groupNumber withSuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end
