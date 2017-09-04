//
//  BSDayOfWeek+CoreDataProperties.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSDayOfWeek+CoreDataProperties.h"

@implementation BSDayOfWeek (CoreDataProperties)

+ (NSFetchRequest<BSDayOfWeek *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BSDayOfWeek"];
}

@dynamic name;
@dynamic pairs;

@end
