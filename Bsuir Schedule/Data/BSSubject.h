//
//  BSSubject.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BSPair;

@interface BSSubject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *daysSchedule;
@end

@interface BSSubject (CoreDataGeneratedAccessors)

- (void)addDaysScheduleObject:(BSPair *)value;
- (void)removeDaysScheduleObject:(BSPair *)value;
- (void)addDaysSchedule:(NSSet *)values;
- (void)removeDaysSchedule:(NSSet *)values;

@end
