//
//  Day.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubjectToDay;

@interface Day : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *subjectSchedule;
@end

@interface Day (CoreDataGeneratedAccessors)

- (void)addSubjectScheduleObject:(SubjectToDay *)value;
- (void)removeSubjectScheduleObject:(SubjectToDay *)value;
- (void)addSubjectSchedule:(NSSet *)values;
- (void)removeSubjectSchedule:(NSSet *)values;

@end
