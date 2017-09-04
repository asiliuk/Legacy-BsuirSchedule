//
//  BSGroup+CoreDataProperties.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSGroup+CoreDataProperties.h"

@implementation BSGroup (CoreDataProperties)

+ (NSFetchRequest<BSGroup *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BSGroup"];
}

@dynamic groupNumber;
@dynamic lastUpdate;
@dynamic scheduleStamp;
@dynamic pairs;
@dynamic schedules;

@end
