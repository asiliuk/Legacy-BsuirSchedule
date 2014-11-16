//
//  BSDayOfWeek.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BSPair;

@interface BSDayOfWeek : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *pairs;
@end

@interface BSDayOfWeek (CoreDataGeneratedAccessors)

- (void)addPairsObject:(BSPair *)value;
- (void)removePairsObject:(BSPair *)value;
- (void)addPairs:(NSSet *)values;
- (void)removePairs:(NSSet *)values;

@end
