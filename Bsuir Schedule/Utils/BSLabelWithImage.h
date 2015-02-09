//
//  BSLabelWithImage.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 09.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BSImageAligment) {
    BSImageAligmentLeft,
    BSImageAligmentRight
};
@interface BSLabelWithImage : UILabel
@property (strong, nonatomic) UIImageView *imageView;
- (void)addImage:(UIImage*)image withAligment:(BSImageAligment)aligment;
@end
