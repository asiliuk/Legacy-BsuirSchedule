//
//  BSPair.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BSAuditory, BSDayOfWeek, BSLecturer, BSSubject;

@interface BSPair : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * subgroupNumber;
@property (nonatomic, retain) NSString * subjectType;
@property (nonatomic, retain) BSAuditory *auditory;
@property (nonatomic, retain) BSDayOfWeek *day;
@property (nonatomic, retain) BSSubject *subject;
@property (nonatomic, retain) BSLecturer *lecturer;

@end
