//
//  NSDate+Compare.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 21.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "NSDate+Compare.h"
#import "BSConstants.h"
#import <UIKit/UIDevice.h>
@implementation NSDate (Compare)

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)isEqualToDateWithoutTime:(NSDate*)date {
    BOOL equal = NO;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger comps;
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    } else {
        comps = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    }
    
    NSDateComponents *date1Components = [calendar components:comps
                                                    fromDate: self];
    NSDateComponents *date2Components = [calendar components:comps
                                                    fromDate: date];
    
    NSDate *date1 = [calendar dateFromComponents:date1Components];
    NSDate *date2 = [calendar dateFromComponents:date2Components];
    
    NSComparisonResult result = [date1 compare:date2];
    if (result != NSOrderedAscending && result != NSOrderedDescending) {
        equal = YES;
    }
    return equal;
}
#pragma GCC diagnostic pop

- (BOOL)isTimeBetweenTime:(NSDate *)firstDate andTime:(NSDate *)secondDate {
    NSDate *myTime = [self onlyTime];
    NSDate *firstTime = [firstDate onlyTime];
    NSDate *secondTime = [secondDate onlyTime];
    return [myTime compare:firstTime] == NSOrderedDescending && [myTime compare:secondTime] == NSOrderedAscending;
}

- (NSDate*)onlyTime {
    unsigned int flags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSComparisonResult)compareTime:(NSDate*)date {
    return [[self onlyTime] compare:[date onlyTime]];
}
@end
