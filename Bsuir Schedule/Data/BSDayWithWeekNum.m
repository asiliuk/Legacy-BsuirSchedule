//
//  BSDayWithWeekNum.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 21.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSDayWithWeekNum.h"
#import "BSDataManager.h"

@implementation BSDayWithWeekNum

- (instancetype)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        self.date = date;
        self.weekNumber = [[BSDataManager sharedInstance] weekNumberWithDate:date];
        self.dayOfWeek = [[BSDataManager sharedInstance] dayWithDate:date];
    }
    return self;
}

@end
