//
//  UIView+Screenshot.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 05.12.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "UIView+Screenshot.h"
#import "UIImage+ImageEffects.h"

@implementation UIView (Screenshot)
- (UIImage*)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)bluredScreenshot {
    UIImage *screenshot = [self screenshot];
    return [screenshot applyDarkEffect];
}
@end
