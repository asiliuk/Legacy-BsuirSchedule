//
//  NSDate+Compare.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 21.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Compare)
- (BOOL)isEqualToDateWithoutTime:(NSDate*)date;
- (BOOL)isTimeBetweenTime:(NSDate *)firstDate andTime:(NSDate *)secondDate;
@end
