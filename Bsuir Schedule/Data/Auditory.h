//
//  Auditory.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubjectToDay;

@interface Auditory : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSSet *subjectsSchedule;
@end

@interface Auditory (CoreDataGeneratedAccessors)

- (void)addSubjectsScheduleObject:(SubjectToDay *)value;
- (void)removeSubjectsScheduleObject:(SubjectToDay *)value;
- (void)addSubjectsSchedule:(NSSet *)values;
- (void)removeSubjectsSchedule:(NSSet *)values;

@end
