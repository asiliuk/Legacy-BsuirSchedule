//
//  BSAuditory+CoreDataProperties.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSAuditory+CoreDataProperties.h"

@implementation BSAuditory (CoreDataProperties)

+ (NSFetchRequest<BSAuditory *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BSAuditory"];
}

@dynamic address;
@dynamic subjectsSchedule;

@end
