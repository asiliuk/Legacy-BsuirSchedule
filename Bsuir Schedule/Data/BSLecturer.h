//
//  BSLecturer.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 17.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BSPair;

@interface BSLecturer : NSManagedObject

@property (nonatomic, retain) NSString * academicDepartment;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * lecturerID;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSSet *pairs;
@end

@interface BSLecturer (CoreDataGeneratedAccessors)

- (void)addPairsObject:(BSPair *)value;
- (void)removePairsObject:(BSPair *)value;
- (void)addPairs:(NSSet *)values;
- (void)removePairs:(NSSet *)values;

@end
