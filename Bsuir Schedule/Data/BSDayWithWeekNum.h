//
//  BSDayWithWeekNum.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 21.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSWeekNumber.h"
#import "BSDayOfWeek.h"
#import "BSDay.h"

@interface BSDayWithWeekNum : NSObject <BSDay>
@property (strong, nonatomic) BSWeekNumber *weekNumber;
@property (strong, nonatomic) BSDayOfWeek *dayOfWeek;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSArray *pairs;
- (instancetype)initWithDate:(NSDate*)date;
- (BOOL)isEqual:(BSDayWithWeekNum*)object;
- (NSArray*)allPairs;
- (NSString*)dayOfWeekName;
- (BOOL)isEqualToDayWithWeekNum:(BSDayWithWeekNum*)object;
- (BOOL)isEqualToDay:(BSDayOfWeek*)object;
@end
