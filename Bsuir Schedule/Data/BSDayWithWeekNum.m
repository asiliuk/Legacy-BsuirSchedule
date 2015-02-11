//
//  BSDayWithWeekNum.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 21.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSDayWithWeekNum.h"
#import "BSDataManager.h"
#import "NSDate+Compare.h"
#import "BSConstants.h"
#import "NSUserDefaults+Share.h"

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
    if (!_pairs) {
        NSUserDefaults *sharedDefaults = [NSUserDefaults sharedDefaults];
        NSNumber *subgroupNumber = @([[sharedDefaults objectForKey:kUserSubgroup] integerValue]);
        NSSortDescriptor *sortD = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES];
        NSArray *pairs = [self.dayOfWeek.pairs sortedArrayUsingDescriptors:@[sortD]];
        NSMutableArray *weekPairs = [NSMutableArray array];
        for (BSPair *pair in pairs) {
            if ([pair.weeks containsObject:self.weekNumber] && ([pair.subgroupNumber isEqual:@(0)] || [pair.subgroupNumber isEqual:subgroupNumber])) {
                [weekPairs addObject:pair];
            }
        }
        _pairs = weekPairs;
    }
    return _pairs;
}

- (BOOL)isEqual:(BSDayWithWeekNum *)object {
    BOOL equal = NO;
    BOOL equalWeekDay = [self.dayOfWeek isEqual:object.dayOfWeek] || (self.dayOfWeek == nil && object.dayOfWeek == nil);
    BOOL equalWeekNum = [self.weekNumber isEqual:object.weekNumber] || (self.weekNumber == nil && object.weekNumber == nil);
    BOOL equalDate = [self.date isEqualToDateWithoutTime:object.date];
    equal = equalWeekDay && equalWeekNum && equalDate;
    return equal;
}

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
