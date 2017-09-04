//
//  BSWeekNumber+CoreDataProperties.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSWeekNumber+CoreDataProperties.h"

@implementation BSWeekNumber (CoreDataProperties)

+ (NSFetchRequest<BSWeekNumber *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BSWeekNumber"];
}

@dynamic weekNumber;
@dynamic pairs;

@end
