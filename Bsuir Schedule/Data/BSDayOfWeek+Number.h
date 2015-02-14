//
//  BSDayOfWeek+Number.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 09.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSDayOfWeek.h"
#import "BSDay.h"

@interface BSDayOfWeek (Number) <BSDay>
- (NSArray*)pairsForSchedule:(BSSchedule *)schedule weekFormat:(BOOL)weekFormat;
- (NSString*)dayOfWeekName;
- (BOOL)isEqualToDayWithWeekNum:(BSDayWithWeekNum*)object;
- (BOOL)isEqualToDay:(BSDayOfWeek*)object;
@end
