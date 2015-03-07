//
//  BSSchedule.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 12.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BSGroup;

@interface BSSchedule : NSManagedObject

@property (nonatomic, retain) NSNumber * subgroup;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) BSGroup *group;

@end
