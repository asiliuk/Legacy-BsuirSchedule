//
//  BMWLecturerPreview.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 23.01.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSLecturerPreview.h"
#import <Bolts/Bolts.h>
#import <SDWebImage/UIImageView+WebCache.h>

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

    [self loadImageForLecturer:lecturer];

    self.lecturerIV.contentMode = UIViewContentModeScaleAspectFill;
    [self.lecturerIV.layer setCornerRadius:LECTURER_IMAGE_WIDTH / 2.0];
    self.lecturerIV.layer.masksToBounds = YES;
    
    [self addSubview:self.lecturerIV];
    
    self.lecturerIV.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_lecturerIV(width)]" options:0  metrics:@{@"width":@(LECTURER_IMAGE_WIDTH)} views:NSDictionaryOfVariableBindings(_lecturerIV)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lecturerIV(height)]" options:0 metrics:@{@"height":@(LECTURER_IMAGE_WIDTH)} views:NSDictionaryOfVariableBindings(_lecturerIV)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lecturerIV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lecturerIV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    UILabel *lecturerLastNameLabel = [[UILabel alloc] init];
    [lecturerLastNameLabel setText:lecturer.lastName];
    [lecturerLastNameLabel setFont:[UIFont fontWithName:@"OpenSans" size:LECTURER_NAME_FONT_SIZE]];
    lecturerLastNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lecturerLastNameLabel];
    
    lecturerLastNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-offset-[lecturerLastNameLabel]-offset-|" options:0 metrics:@{@"offset": @(HORISONTAL_OFFSET)} views:NSDictionaryOfVariableBindings(lecturerLastNameLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lecturerIV]-offset-[lecturerLastNameLabel(14.0)]" options:0 metrics:@{@"offset": @(VERTICAL_OFFSET)} views:NSDictionaryOfVariableBindings(_lecturerIV,lecturerLastNameLabel)]];
    
    
    lecturerLastNameLabel.hidden = YES;
    self.lecturerNameLabel = lecturerLastNameLabel;
    
    self.lecturer = lecturer;
}

- (void)updateWithLecturer:(BSLecturer *)lecturer {
    self.lecturer = lecturer;
    [self loadImageForLecturer:lecturer];
    [self.lecturerNameLabel setText:lecturer.lastName];
}

- (void)loadImageForLecturer:(BSLecturer *)lecturer {
    NSURL *url = [NSURL URLWithString:lecturer.avatarURL];
    [self.lecturerIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noavatar"]];
}

@end
