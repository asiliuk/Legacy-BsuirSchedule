//
//  BSTriangleView.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 21.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSTriangleView.h"

@implementation BSTriangleView

-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint   (ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));  // top left
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMidY(rect));  // mid right
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));  // bottom left
    CGContextClosePath(ctx);
    if (self.fillColor) {
        const CGFloat *components = CGColorGetComponents(self.fillColor.CGColor);
        CGContextSetRGBFillColor(ctx, components[0], components[1], components[2], components[3]);
    }
    CGContextFillPath(ctx);
}

@end
