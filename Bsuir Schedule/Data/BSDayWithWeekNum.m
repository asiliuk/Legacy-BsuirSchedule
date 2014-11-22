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
- (NSArray*)pairs {
    NSNumber *subgroupNumber = @([[[NSUserDefaults standardUserDefaults] objectForKey:kUserSubgroup] integerValue]);
    NSSortDescriptor *sortD = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES];
    NSArray *pairs = [self.dayOfWeek.pairs sortedArrayUsingDescriptors:@[sortD]];
    NSMutableArray *weekPairs = [NSMutableArray array];
    for (BSPair *pair in pairs) {
        if ([pair.weeks containsObject:self.weekNumber] && ([pair.subgroupNumber isEqual:@(0)] || [pair.subgroupNumber isEqual:subgroupNumber])) {
            [weekPairs addObject:pair];
        }
    }
    return weekPairs;
}
@end
