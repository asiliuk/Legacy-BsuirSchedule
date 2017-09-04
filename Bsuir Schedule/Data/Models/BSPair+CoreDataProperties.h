//
//  BSPair+CoreDataProperties.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSPair+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BSPair (CoreDataProperties)

+ (NSFetchRequest<BSPair *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *endTime;
@property (nullable, nonatomic, copy) NSNumber *pairType;
@property (nullable, nonatomic, copy) NSDate *startTime;
@property (nullable, nonatomic, copy) NSNumber *subgroupNumber;
@property (nullable, nonatomic, retain) NSSet<BSAuditory *> *auditories;
@property (nullable, nonatomic, retain) BSDayOfWeek *day;
@property (nullable, nonatomic, retain) NSSet<BSGroup *> *groups;
@property (nullable, nonatomic, retain) NSSet<BSLecturer *> *lecturers;
@property (nullable, nonatomic, retain) BSSubject *subject;
@property (nullable, nonatomic, retain) NSSet<BSWeekNumber *> *weeks;

@end

@interface BSPair (CoreDataGeneratedAccessors)

- (void)addAuditoriesObject:(BSAuditory *)value;
- (void)removeAuditoriesObject:(BSAuditory *)value;
- (void)addAuditories:(NSSet<BSAuditory *> *)values;
- (void)removeAuditories:(NSSet<BSAuditory *> *)values;

- (void)addGroupsObject:(BSGroup *)value;
- (void)removeGroupsObject:(BSGroup *)value;
- (void)addGroups:(NSSet<BSGroup *> *)values;
- (void)removeGroups:(NSSet<BSGroup *> *)values;

- (void)addLecturersObject:(BSLecturer *)value;
- (void)removeLecturersObject:(BSLecturer *)value;
- (void)addLecturers:(NSSet<BSLecturer *> *)values;
- (void)removeLecturers:(NSSet<BSLecturer *> *)values;

- (void)addWeeksObject:(BSWeekNumber *)value;
- (void)removeWeeksObject:(BSWeekNumber *)value;
- (void)addWeeks:(NSSet<BSWeekNumber *> *)values;
- (void)removeWeeks:(NSSet<BSWeekNumber *> *)values;

@end

NS_ASSUME_NONNULL_END
