//
//  BMWLecturerPreview.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 23.01.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSLecturerPreview.h"

@implementation BSLecturerPreview

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    self.backgroundColor = [UIColor clearColor];
}
#define HORISONTAL_OFFSET -5.0f
#define VERTICAL_OFFSET 0.0f
#define LECTURER_NAME_FONT_SIZE 10.0f

- (void)setupWithLecturer:(BSLecturer*)lecturer {
    self.lecturerIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LECTURER_IMAGE_WIDTH, LECTURER_IMAGE_WIDTH)];
    self.lecturerIV.image = [lecturer thumbnail];
    self.lecturerIV.contentMode = UIViewContentModeScaleAspectFill;
    self.lecturerIV.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    [self.lecturerIV.layer setCornerRadius:self.lecturerIV.bounds.size.width / 2.0];
    self.lecturerIV.layer.masksToBounds = YES;
    
    [self addSubview:self.lecturerIV];
    
    UILabel *lecturerLastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(HORISONTAL_OFFSET, CGRectGetMaxY(self.lecturerIV.frame) + VERTICAL_OFFSET, self.frame.size.width - 2*HORISONTAL_OFFSET, 14.0)];
    [lecturerLastNameLabel setText:lecturer.lastName];
    [lecturerLastNameLabel setFont:[UIFont fontWithName:@"OpenSans" size:LECTURER_NAME_FONT_SIZE]];
    lecturerLastNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lecturerLastNameLabel];
    lecturerLastNameLabel.hidden = YES;
    self.lecturerNameLabel = lecturerLastNameLabel;
    
    self.lecturer = lecturer;
}
@end
