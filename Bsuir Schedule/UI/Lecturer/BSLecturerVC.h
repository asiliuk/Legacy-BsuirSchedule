//
//  BSLecturerVC.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.12.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSDataManager.h"
@interface BSLecturerVC : UIViewController
- (instancetype)initWithLecturer:(BSLecturer*)lecturer startFrame:(CGRect)startFrame;
@end
