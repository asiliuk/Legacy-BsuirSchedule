//
//  BSLecturer+CoreDataProperties.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSLecturer+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BSLecturer (CoreDataProperties)

+ (NSFetchRequest<BSLecturer *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *academicDepartment;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSNumber *lecturerID;
@property (nullable, nonatomic, copy) NSString *middleName;
@property (nullable, nonatomic, copy) NSString *avatarURL;
@property (nullable, nonatomic, retain) NSSet<BSPair *> *pairs;

@end

@interface BSLecturer (CoreDataGeneratedAccessors)

- (void)addPairsObject:(BSPair *)value;
- (void)removePairsObject:(BSPair *)value;
- (void)addPairs:(NSSet<BSPair *> *)values;
- (void)removePairs:(NSSet<BSPair *> *)values;

@end

NS_ASSUME_NONNULL_END
