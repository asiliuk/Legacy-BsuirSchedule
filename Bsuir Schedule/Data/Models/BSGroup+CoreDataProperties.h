//
//  BSGroup+CoreDataProperties.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSGroup+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BSGroup (CoreDataProperties)

+ (NSFetchRequest<BSGroup *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *groupNumber;
@property (nullable, nonatomic, copy) NSDate *lastUpdate;
@property (nullable, nonatomic, copy) NSString *scheduleStamp;
@property (nullable, nonatomic, retain) NSSet<BSPair *> *pairs;
@property (nullable, nonatomic, retain) NSSet<BSSchedule *> *schedules;

@end

@interface BSGroup (CoreDataGeneratedAccessors)

- (void)addPairsObject:(BSPair *)value;
- (void)removePairsObject:(BSPair *)value;
- (void)addPairs:(NSSet<BSPair *> *)values;
- (void)removePairs:(NSSet<BSPair *> *)values;

- (void)addSchedulesObject:(BSSchedule *)value;
- (void)removeSchedulesObject:(BSSchedule *)value;
- (void)addSchedules:(NSSet<BSSchedule *> *)values;
- (void)removeSchedules:(NSSet<BSSchedule *> *)values;

@end

NS_ASSUME_NONNULL_END
