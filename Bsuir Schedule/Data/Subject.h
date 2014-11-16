//
//  Subject.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubjectToDay;

@interface Subject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *daysSchedule;
@property (nonatomic, retain) NSManagedObject *lecturer;
@end

@interface Subject (CoreDataGeneratedAccessors)

- (void)addDaysScheduleObject:(SubjectToDay *)value;
- (void)removeDaysScheduleObject:(SubjectToDay *)value;
- (void)addDaysSchedule:(NSSet *)values;
- (void)removeDaysSchedule:(NSSet *)values;

@end
