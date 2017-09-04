//
//  BSPair+CoreDataProperties.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSPair+CoreDataProperties.h"

@implementation BSPair (CoreDataProperties)

+ (NSFetchRequest<BSPair *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BSPair"];
}

@dynamic endTime;
@dynamic pairType;
@dynamic startTime;
@dynamic subgroupNumber;
@dynamic auditories;
@dynamic day;
@dynamic groups;
@dynamic lecturers;
@dynamic subject;
@dynamic weeks;

@end
