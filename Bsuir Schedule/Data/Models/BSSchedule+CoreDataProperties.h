//
//  BSSchedule+CoreDataProperties.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSSchedule+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BSSchedule (CoreDataProperties)

+ (NSFetchRequest<BSSchedule *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createdAt;
@property (nullable, nonatomic, copy) NSNumber *subgroup;
@property (nullable, nonatomic, retain) BSGroup *group;

@end

NS_ASSUME_NONNULL_END
