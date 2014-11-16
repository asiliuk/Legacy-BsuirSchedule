//
//  BSPair.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 17.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BSAuditory, BSDayOfWeek, BSLecturer, BSSubject, BSWeekNumber;

@interface BSPair : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * subgroupNumber;
@property (nonatomic, retain) NSString * subjectType;
@property (nonatomic, retain) BSAuditory *auditory;
@property (nonatomic, retain) BSDayOfWeek *day;
@property (nonatomic, retain) BSLecturer *lecturer;
@property (nonatomic, retain) BSSubject *subject;
@property (nonatomic, retain) NSSet *weeks;
@end

@interface BSPair (CoreDataGeneratedAccessors)

- (void)addWeeksObject:(BSWeekNumber *)value;
- (void)removeWeeksObject:(BSWeekNumber *)value;
- (void)addWeeks:(NSSet *)values;
- (void)removeWeeks:(NSSet *)values;

@end
