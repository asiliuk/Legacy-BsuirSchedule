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

@interface BSDayWithWeekNum : NSObject
@property (strong, nonatomic) BSWeekNumber *weekNumber;
@property (strong, nonatomic) BSDayOfWeek *dayOfWeek;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSArray *pairs;
- (instancetype)initWithDate:(NSDate*)date;
- (BOOL)isEqual:(BSDayWithWeekNum*)object;
@end
