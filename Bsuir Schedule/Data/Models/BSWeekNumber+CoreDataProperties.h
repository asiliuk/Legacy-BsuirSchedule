//
//  BSWeekNumber+CoreDataProperties.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSWeekNumber+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BSWeekNumber (CoreDataProperties)

+ (NSFetchRequest<BSWeekNumber *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *weekNumber;
@property (nullable, nonatomic, retain) NSSet<BSPair *> *pairs;

@end

@interface BSWeekNumber (CoreDataGeneratedAccessors)

- (void)addPairsObject:(BSPair *)value;
- (void)removePairsObject:(BSPair *)value;
- (void)addPairs:(NSSet<BSPair *> *)values;
- (void)removePairs:(NSSet<BSPair *> *)values;

@end

NS_ASSUME_NONNULL_END
