//
//  ViewController.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSSchedule+CoreDataProperties.h"

@interface BSScheduleVC : UIViewController
@property (nonatomic) BOOL weekFormat;
@property (strong, nonatomic) BSSchedule *schedule;
- (instancetype)initWithSchedule:(BSSchedule*)schedule;
@end

