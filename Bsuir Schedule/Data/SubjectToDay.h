//
//  SubjectToDay.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day, Subject;

@interface SubjectToDay : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * subgroupNumber;
@property (nonatomic, retain) NSString * subjectType;
@property (nonatomic, retain) NSManagedObject *auditory;
@property (nonatomic, retain) Day *day;
@property (nonatomic, retain) Subject *subject;

@end
