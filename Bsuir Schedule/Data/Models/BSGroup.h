//
//  BSGroup.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 12.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BSPair, BSSchedule;

@interface BSGroup : NSManagedObject

@property (nonatomic, retain) NSString * groupNumber;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSString * scheduleStamp;
@property (nonatomic, retain) NSSet *pairs;
@property (nonatomic, retain) NSSet *schedules;
@end

@interface BSGroup (CoreDataGeneratedAccessors)

- (void)addPairsObject:(BSPair *)value;
- (void)removePairsObject:(BSPair *)value;
- (void)addPairs:(NSSet *)values;
- (void)removePairs:(NSSet *)values;

- (void)addSchedulesObject:(BSSchedule *)value;
- (void)removeSchedulesObject:(BSSchedule *)value;
- (void)addSchedules:(NSSet *)values;
- (void)removeSchedules:(NSSet *)values;

@end
