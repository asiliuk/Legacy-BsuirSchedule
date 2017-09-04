//
//  BSLecturer+Thumbnail.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 18.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSLecturer+CoreDataProperties.h"
#import <UIKit/UIKit.h>

@interface BSLecturer (Thumbnail)
- (void)loadLecturerImageIn:(UIImageView*)imageView;
- (void)loadLecturerImageIn:(UIImageView *)imageView thumb:(BOOL)thumb;
@end
