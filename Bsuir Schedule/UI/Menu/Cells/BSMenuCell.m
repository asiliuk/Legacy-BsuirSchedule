//
//  BMWMenuCell.m
//  BMW club
//
//  Created by Anton Siliuk on 12.12.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSMenuCell.h"
#import "BSConstants.h"

@interface BSMenuCell()
@end
@implementation BSMenuCell

- (void)awakeFromNib {
    self.badgeLabel.layer.masksToBounds = YES;
    self.badgeLabel.layer.cornerRadius = self.badgeLabel.bounds.size.height / 2.0;
    self.badgeLabel.backgroundColor = BS_DARK;
}

#define SEPARATOR_HEIGHT 0.5
#define IMAGE_OFFSET 5.0
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    self.separator = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                                                 self.bounds.size.height - SEPARATOR_HEIGHT,
                                                                 self.bounds.size.width - CGRectGetMinX(self.titleLabel.frame),
                                                                 SEPARATOR_HEIGHT)];
    self.separator.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self addSubview:self.separator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        self.backgroundColor = BS_GRAY;
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [self setSelected:highlighted animated:animated];
}

@end
