//
//  BSAuditory.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BSPair;

@interface BSAuditory : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSSet *subjectsSchedule;
@end

@interface BSAuditory (CoreDataGeneratedAccessors)

- (void)addSubjectsScheduleObject:(BSPair *)value;
- (void)removeSubjectsScheduleObject:(BSPair *)value;
- (void)addSubjectsSchedule:(NSSet *)values;
- (void)removeSubjectsSchedule:(NSSet *)values;

@end
