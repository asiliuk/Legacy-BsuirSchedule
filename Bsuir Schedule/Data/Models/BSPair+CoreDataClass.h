//
//  BSPair+CoreDataClass.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.17.
//  Copyright © 2017 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BSAuditory, BSDayOfWeek, BSGroup, BSLecturer, BSSubject, BSWeekNumber;

NS_ASSUME_NONNULL_BEGIN

@interface BSPair : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "BSPair+CoreDataProperties.h"
