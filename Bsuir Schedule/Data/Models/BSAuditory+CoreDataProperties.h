//
//  BSAuditory+CoreDataProperties.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSAuditory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BSAuditory (CoreDataProperties)

+ (NSFetchRequest<BSAuditory *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, retain) NSSet<BSPair *> *subjectsSchedule;

@end

@interface BSAuditory (CoreDataGeneratedAccessors)

- (void)addSubjectsScheduleObject:(BSPair *)value;
- (void)removeSubjectsScheduleObject:(BSPair *)value;
- (void)addSubjectsSchedule:(NSSet<BSPair *> *)values;
- (void)removeSubjectsSchedule:(NSSet<BSPair *> *)values;

@end

NS_ASSUME_NONNULL_END
