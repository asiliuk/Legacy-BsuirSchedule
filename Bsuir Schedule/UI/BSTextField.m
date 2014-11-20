//
//  BSTextField.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 20.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSTextField.h"

@implementation BSTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self editingRectForBounds:bounds];
}
#define INSET 10.0
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds, INSET, 0);
}

@end
