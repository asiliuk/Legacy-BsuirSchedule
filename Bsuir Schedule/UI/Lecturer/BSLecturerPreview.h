//
//  BMWLecturerPreview.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 23.01.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSLecturer+Thumbnail.h"
#import <ParseUI/PFImageView.h>

#define LECTURER_IMAGE_WIDTH 50.0f
@interface BSLecturerPreview : UIView
@property (strong, nonatomic) BSLecturer *lecturer;
@property (strong, nonatomic) PFImageView *lecturerIV;
@property (strong, nonatomic) UILabel *lecturerNameLabel;

- (void)setupWithLecturer:(BSLecturer*)lecturer;
@end
