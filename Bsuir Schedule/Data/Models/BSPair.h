//
//  BSPair.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 12.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BSAuditory, BSDayOfWeek, BSGroup, BSLecturer, BSSubject, BSWeekNumber;

@interface BSPair : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * pairType;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * subgroupNumber;
@property (nonatomic, retain) NSSet *auditories;
@property (nonatomic, retain) BSDayOfWeek *day;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) NSSet *lecturers;
@property (nonatomic, retain) BSSubject *subject;
@property (nonatomic, retain) NSSet *weeks;
@end

@interface BSPair (CoreDataGeneratedAccessors)

- (void)addAuditoriesObject:(BSAuditory *)value;
- (void)removeAuditoriesObject:(BSAuditory *)value;
- (void)addAuditories:(NSSet *)values;
- (void)removeAuditories:(NSSet *)values;

- (void)addGroupsObject:(BSGroup *)value;
- (void)removeGroupsObject:(BSGroup *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

- (void)addLecturersObject:(BSLecturer *)value;
- (void)removeLecturersObject:(BSLecturer *)value;
- (void)addLecturers:(NSSet *)values;
- (void)removeLecturers:(NSSet *)values;

- (void)addWeeksObject:(BSWeekNumber *)value;
- (void)removeWeeksObject:(BSWeekNumber *)value;
- (void)addWeeks:(NSSet *)values;
- (void)removeWeeks:(NSSet *)values;

@end
