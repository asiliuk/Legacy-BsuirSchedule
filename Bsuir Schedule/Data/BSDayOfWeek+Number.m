//
//  BSDayOfWeek+Number.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 09.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSDayOfWeek+Number.h"
#import "BSDayWithWeekNum.h"
#import "BSDataManager.h"

@implementation BSDayOfWeek (Number)

- (NSArray*)pairsForSchedule:(BSSchedule *)schedule weekFormat:(BOOL)weekFormat {
    NSArray *sortedPairs = [[BSDataManager sharedInstance] sortPairs:[self.pairs allObjects]];
    return [[BSDataManager sharedInstance] filterPairs:sortedPairs
                                           forSchedule:schedule
                                          forWekFormat:weekFormat];

}


- (BOOL)isEqualToDayWithWeekNum:(BSDayWithWeekNum *)object {
    return [self isEqualToDay:object.dayOfWeek];
}

- (BOOL)isEqualToDay:(BSDayOfWeek *)object {
    
    return  [[[BSDataManager sharedInstance] dayNumberForDay:object] isEqual:[[BSDataManager sharedInstance]dayNumberForDay:self]];
}
- (NSString*)dayOfWeekName {
    return self.name;
}
@end
