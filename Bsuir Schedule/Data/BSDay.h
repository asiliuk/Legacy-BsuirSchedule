//
//  BSDay.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 09.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSDayWithWeekNum.h"
@protocol BSDay <NSObject>
- (NSArray*)allPairs;
- (NSString*)dayOfWeekName;
- (BOOL)isEqualToDayWithWeekNum:(BSDayWithWeekNum*)object;
- (BOOL)isEqualToDay:(BSDayOfWeek*)object;
@end
