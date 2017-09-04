//
//  BSLecturer+CoreDataProperties.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import "BSLecturer+CoreDataProperties.h"

@implementation BSLecturer (CoreDataProperties)

+ (NSFetchRequest<BSLecturer *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BSLecturer"];
}

@dynamic academicDepartment;
@dynamic firstName;
@dynamic lastName;
@dynamic lecturerID;
@dynamic middleName;
@dynamic avatarURL;
@dynamic pairs;

@end
