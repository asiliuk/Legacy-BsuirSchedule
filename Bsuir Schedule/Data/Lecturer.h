//
//  Lecturer.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Subject;

@interface Lecturer : NSManagedObject

@property (nonatomic, retain) NSString * academicDepartment;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSSet *subjects;
@end

@interface Lecturer (CoreDataGeneratedAccessors)

- (void)addSubjectsObject:(Subject *)value;
- (void)removeSubjectsObject:(Subject *)value;
- (void)addSubjects:(NSSet *)values;
- (void)removeSubjects:(NSSet *)values;

@end
