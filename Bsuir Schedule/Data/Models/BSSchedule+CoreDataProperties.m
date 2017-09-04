//
//  BSSchedule+CoreDataProperties.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSSchedule+CoreDataProperties.h"

@implementation BSSchedule (CoreDataProperties)

+ (NSFetchRequest<BSSchedule *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BSSchedule"];
}

@dynamic createdAt;
@dynamic subgroup;
@dynamic group;

@end
