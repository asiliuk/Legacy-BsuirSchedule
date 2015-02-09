//
//  BSDayWithWeekNum+DayProtocol.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 09.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSDayWithWeekNum.h"
#import "BSDay.h"

@interface BSDayWithWeekNum (DayProtocol) <BSDay>
- (NSArray*)allPairs;
- (NSString*)dayOfWeekName;
- (BOOL)isEqualToDayWithWeekNum:(BSDayWithWeekNum*)object;
- (BOOL)isEqualToDay:(BSDayOfWeek*)object;
@end
