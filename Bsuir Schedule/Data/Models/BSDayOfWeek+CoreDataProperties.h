//
//  BSDayOfWeek+CoreDataProperties.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSDayOfWeek+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BSDayOfWeek (CoreDataProperties)

+ (NSFetchRequest<BSDayOfWeek *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<BSPair *> *pairs;

@end

@interface BSDayOfWeek (CoreDataGeneratedAccessors)

- (void)addPairsObject:(BSPair *)value;
- (void)removePairsObject:(BSPair *)value;
- (void)addPairs:(NSSet<BSPair *> *)values;
- (void)removePairs:(NSSet<BSPair *> *)values;

@end

NS_ASSUME_NONNULL_END
