//
//  BSLabelWithImage.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 09.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSLabelWithImage.h"

@interface BSLabelWithImage()
@property (nonatomic) BSImageAligment aligment;
@end
@implementation BSLabelWithImage

- (void)addImage:(UIImage *)image withAligment:(BSImageAligment)aligment {
    [self.imageView removeFromSuperview];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.aligment = aligment;
    if (aligment == BSImageAligmentLeft) {
        self.text = [@"     " stringByAppendingString:self.text];
    } else if (aligment == BSImageAligmentRight) {
        self.text = [self.text stringByAppendingString:@"     "];
    }
    [self addSubview:self.imageView];
}

- (void)layoutSubviews {
    self.imageView.center = CGPointMake(self.imageView.center.x, self.frame.size.height / 2.0);
    if (self.aligment == BSImageAligmentRight) {
        CGRect ivFrame = self.imageView.frame;
        ivFrame.origin.x = self.bounds.size.width - ivFrame.size.width;
        self.imageView.frame = ivFrame;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
