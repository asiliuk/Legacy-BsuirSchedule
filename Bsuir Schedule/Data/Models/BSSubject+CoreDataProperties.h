//
//  BSSubject+CoreDataProperties.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSSubject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BSSubject (CoreDataProperties)

+ (NSFetchRequest<BSSubject *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<BSPair *> *daysSchedule;

@end

@interface BSSubject (CoreDataGeneratedAccessors)

- (void)addDaysScheduleObject:(BSPair *)value;
- (void)removeDaysScheduleObject:(BSPair *)value;
- (void)addDaysSchedule:(NSSet<BSPair *> *)values;
- (void)removeDaysSchedule:(NSSet<BSPair *> *)values;

@end

NS_ASSUME_NONNULL_END
