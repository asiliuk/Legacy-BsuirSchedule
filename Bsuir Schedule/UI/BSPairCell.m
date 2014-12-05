//
//  BSPairCell.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 18.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSPairCell.h"
#import "BSTriangleView.h"
#import "NSDate+Compare.h"

@interface BSPairCell()
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet BSTriangleView *triangleView;
@property (strong, nonatomic) IBOutlet UIView *pairTypeIndicator;
@property (strong, nonatomic) IBOutlet UILabel *subjectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *auditoryLabel;
@property (strong, nonatomic) IBOutlet UIView *pairView;
@property (strong, nonatomic) IBOutlet UILabel *lecturerNameLabel;

@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (strong, nonatomic) NSString *timeText;
@end
@implementation BSPairCell
@dynamic timeText;

#define CORNER_RADIUS 0.0
- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    
    [self.lecturerIV.layer setCornerRadius:self.lecturerIV.bounds.size.width / 2.0];
    self.lecturerIV.layer.masksToBounds = YES;
    
    [self.pairView.layer setCornerRadius:CORNER_RADIUS];
    self.pairView.layer.masksToBounds = YES;
    
    self.showingLecturerName = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleThumbnailTap:)];
    [self addGestureRecognizer:tap];
}

#define OFFSET 10.0
#define PAIR_CELL_ANIMATION_DURATION 0.3
- (void)makeSelected:(BOOL)selected {
    if (self.lecturerNameLabel.hidden || [self.lecturerNameLabel.text isEqual:@""]) {
        return;
    }
    CGRect lecturerIVFrame = self.lecturerIV.frame;
    CGRect lecturerNameFrame = self.lecturerNameLabel.frame;

    if (selected) {
        lecturerIVFrame.origin.x = CGRectGetMaxX(self.timeLabel.frame) + OFFSET;
        CGRect nearFrame = (self.lecturerIV.hidden) ? self.timeLabel.frame : lecturerIVFrame;
        lecturerNameFrame.origin.x = CGRectGetMaxX(nearFrame) + OFFSET;
    } else {
        lecturerIVFrame.origin.x = CGRectGetMaxX(self.pairView.frame) - OFFSET - CGRectGetWidth(lecturerIVFrame);
        lecturerNameFrame.origin.x = CGRectGetMaxX(self.pairView.frame) + OFFSET;
    }

    CGFloat rotateAngelPart = ((self.showingLecturerName) ? 1 : -1)*2*M_PI/3.0;
    
    [UIView beginAnimations:@"lecturer IV animations 1" context:nil];
    [UIView setAnimationDuration:PAIR_CELL_ANIMATION_DURATION];
    self.lecturerIV.transform = CGAffineTransformMakeRotation(rotateAngelPart);
    [UIView commitAnimations];

    [UIView beginAnimations:@"lecturer IV animations 2" context:nil];
    [UIView setAnimationDuration:PAIR_CELL_ANIMATION_DURATION];
    self.lecturerIV.transform = CGAffineTransformMakeRotation(2*rotateAngelPart);
    [UIView commitAnimations];

    [UIView beginAnimations:@"lecturer IV animations 3" context:nil];
    [UIView setAnimationDuration:PAIR_CELL_ANIMATION_DURATION];
    self.lecturerIV.transform = CGAffineTransformMakeRotation(3*rotateAngelPart);
    [UIView commitAnimations];

    [UIView beginAnimations:@"Movement animations" context:nil];
    [UIView setAnimationDuration:PAIR_CELL_ANIMATION_DURATION];
    self.lecturerIV.frame = lecturerIVFrame;
    self.lecturerNameLabel.frame = lecturerNameFrame;
    self.subjectNameLabel.alpha = (selected) ? 0.0 : 1.0;
    self.auditoryLabel.alpha = (selected) ? 0.0 : 1.0;
    
    [UIView commitAnimations];
    self.showingLecturerName = selected;
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (NSString*)timeText {
    return [self.timeLabel.attributedText string];
}

#define LINE_HEIGHT 16.0
#define FONT_SIZE 16.0
- (void)setTimeText:(NSString *)timeText {
    NSMutableAttributedString* attrTimeString = [[NSMutableAttributedString alloc] initWithString:timeText];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setMaximumLineHeight:LINE_HEIGHT];
    [style setAlignment:NSTextAlignmentCenter];
    [attrTimeString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [timeText length])];

    [attrTimeString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"OpenSans-Light" size:FONT_SIZE]
                           range:NSMakeRange(0, [timeText length])];
    self.timeLabel.attributedText = attrTimeString;
}

- (void)makeCurrentPairCell:(BOOL)isCurrent {
    if (isCurrent) {
        self.triangleView.hidden = NO;
        [self.triangleView setNeedsDisplay];
    } else {
        self.triangleView.hidden = YES;
    }
}

- (void)setPairTypeIndicatorColor:(UIColor *)pairTypeIndicatorColor{
    _pairTypeIndicatorColor = pairTypeIndicatorColor;
    self.pairTypeIndicator.backgroundColor = pairTypeIndicatorColor;
    self.triangleView.fillColor = pairTypeIndicatorColor;
}

- (void)setupWithPair:(BSPair*)pair cellForCurrentDay:(BOOL)cellForCurrentDay{
    BSLecturer *lecturer = pair.lecturer;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeString = [NSString stringWithFormat:@"%@\n-\n%@", [formatter stringFromDate:pair.startTime],[formatter stringFromDate:pair.endTime]];
    [self setTimeText:timeString];
    [self.subjectNameLabel setText:pair.subject.name];
    [self.auditoryLabel setText:pair.auditory.address];
    UIImage *thumbnail = [lecturer thumbnail];
    [self.lecturerIV setImage:thumbnail];
    self.lecturerIV.hidden = thumbnail == nil;
    CGRect subjectNameFrame = self.subjectNameLabel.frame;
    subjectNameFrame.size.width = CGRectGetMaxX(self.frame) - subjectNameFrame.origin.x - OFFSET;
    if (thumbnail != nil) {
        subjectNameFrame.size.width -= (CGRectGetWidth(self.lecturerIV.frame) + OFFSET);
    }
    self.lecturerNameLabel.hidden = lecturer == nil;
    self.subjectNameLabel.frame = subjectNameFrame;
    
    if (lecturer) {
        [self.lecturerNameLabel setText:[NSString stringWithFormat:@"%@ %@.%@.",
                                         lecturer.lastName,
                                         [lecturer.firstName substringToIndex:1],
                                         [lecturer.middleName substringToIndex:1]]];
    }
    self.pairTypeIndicatorColor = [pair colorForPairType];
    NSDate *today = [NSDate date];
    BOOL currentPair = [today isTimeBetweenTime:pair.startTime andTime:pair.endTime] && cellForCurrentDay;
    [self makeCurrentPairCell:currentPair];
}

- (void)updateUIForWidget {
    self.timeLabel.textColor = [UIColor whiteColor];
    self.subjectNameLabel.textColor = [UIColor whiteColor];
    self.auditoryLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    self.pairView.backgroundColor = [UIColor clearColor];
    if (!self.effectView) {
        UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        self.effectView.frame = self.pairView.bounds;
        [self.pairView addSubview:self.effectView];
        [self.pairView sendSubviewToBack:self.effectView];
    }
}

- (void)handleThumbnailTap:(id)sender {
    [self.delegate thumbnailGetTappedOnCell:self];
}
@end
