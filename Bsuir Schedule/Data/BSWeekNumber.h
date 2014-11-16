//
//  BSWeekNumber.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 17.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BSPair;

@interface BSWeekNumber : NSManagedObject

@property (nonatomic, retain) NSNumber * weekNumber;
@property (nonatomic, retain) NSSet *pairs;
@end

@interface BSWeekNumber (CoreDataGeneratedAccessors)

- (void)addPairsObject:(BSPair *)value;
- (void)removePairsObject:(BSPair *)value;
- (void)addPairs:(NSSet *)values;
- (void)removePairs:(NSSet *)values;

@end
