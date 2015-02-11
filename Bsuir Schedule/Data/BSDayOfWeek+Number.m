//
//  BSDayOfWeek+Number.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 09.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSDayOfWeek+Number.h"
#import "BSDayWithWeekNum.h"

@implementation BSDayOfWeek (Number)
- (NSInteger)number {
    NSArray *dayOrder = @[@"Понедельник", @"Вторник", @"Среда", @"Четверг", @"Пятница", @"Суббота", @"Воскресенье"];
    return [dayOrder indexOfObject:self.name];

}

- (NSArray*)allPairs {
    NSSortDescriptor *sortD = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES];
    return [self.pairs sortedArrayUsingDescriptors:@[sortD]];
}

- (BOOL)isEqualToDayWithWeekNum:(BSDayWithWeekNum *)object {
    return [self isEqualToDay:object.dayOfWeek];
}

- (BOOL)isEqualToDay:(BSDayOfWeek *)object {
    return [object number] == [self number];
}
- (NSString*)dayOfWeekName {
    return self.name;
}
@end
