//
//  BSSubject+CoreDataProperties.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSSubject+CoreDataProperties.h"

@implementation BSSubject (CoreDataProperties)

+ (NSFetchRequest<BSSubject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BSSubject"];
}

@dynamic name;
@dynamic daysSchedule;

@end
