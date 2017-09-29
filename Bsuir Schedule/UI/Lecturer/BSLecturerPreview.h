//
//  BMWLecturerPreview.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 23.01.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSLecturer+CoreDataProperties.h"

#define LECTURER_IMAGE_WIDTH 50.0f
@interface BSLecturerPreview : UIView
@property (strong, nonatomic) BSLecturer *lecturer;
@property (strong, nonatomic) UIImageView *lecturerIV;
@property (strong, nonatomic) UILabel *lecturerNameLabel;

- (void)setupWithLecturer:(BSLecturer*)lecturer;
- (void)updateWithLecturer:(BSLecturer*)lecturer;
@end
