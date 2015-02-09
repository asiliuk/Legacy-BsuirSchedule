//
//  BSDayWithWeekNum+DayProtocol.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 09.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSDayWithWeekNum+DayProtocol.h"
#import "BSDayOfWeek+Number.h"

@implementation BSDayWithWeekNum (DayProtocol)
- (NSArray*)allPairs {
    return self.pairs;
}
- (BOOL)isEqualToDayWithWeekNum:(BSDayWithWeekNum *)object {
    return [self isEqual:object];
}
- (BOOL)isEqualToDay:(BSDayOfWeek *)object {
    return [self.dayOfWeek isEqualToDay:object];
}
- (NSString*)dayOfWeekName {
    return self.dayOfWeek.name;
}
@end
