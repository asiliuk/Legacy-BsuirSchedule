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
#import "BSConstants.h"
#import "BSLecturerPreview.h"
#import "BSLabelWithImage.h"

#import "BSDayOfWeek+Number.h"
#import "BSDayWithWeekNum+DayProtocol.h"

@interface BSPairCell()
@property (strong, nonatomic) NSMutableArray *lecturersPreviews;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet BSTriangleView *triangleView;
@property (strong, nonatomic) IBOutlet UIView *pairTypeIndicator;
@property (strong, nonatomic) IBOutlet BSLabelWithImage *subjectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *auditoryLabel;
@property (strong, nonatomic) IBOutlet UIView *pairView;

@property (strong, nonatomic) IBOutlet BSLabelWithImage *weeksLabel;
@property (strong, nonatomic) IBOutlet BSLabelWithImage *subgroupsLabel;

@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (strong, nonatomic) NSString *timeText;
@end
@implementation BSPairCell
@dynamic timeText;

- (NSMutableArray*)lecturersPreviews {
    if (!_lecturersPreviews) {
        _lecturersPreviews = [[NSMutableArray alloc] init];
    }
    return _lecturersPreviews;
}

#define CORNER_RADIUS 0.0
- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    
    [self.pairView.layer setCornerRadius:CORNER_RADIUS];
    self.pairView.layer.masksToBounds = YES;
    
    self.showingLecturers = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleThumbnailTap:)];
    [self addGestureRecognizer:tap];
}

#define OFFSET 10.0
#define PAIR_CELL_ANIMATION_DURATION 0.3
- (void)makeSelected:(BOOL)selected {
    if ([self.lecturersPreviews count] < 2) {
        return;
    }
    for (BSLecturerPreview *lecturerPreview in self.lecturersPreviews) {
        NSInteger lectorerPreviewIndex = [self.lecturersPreviews indexOfObject:lecturerPreview];
        CGRect lecturerPreviewFrame = lecturerPreview.frame;

        CGFloat edgeX = CGRectGetMaxX(self.timeLabel.frame) + OFFSET;

        CGFloat minX;
        CGFloat maxX = CGRectGetMaxX(self.pairView.frame) - OFFSET - CGRectGetWidth(lecturerPreviewFrame);
        if (selected) {
            minX = maxX -([self.lecturersPreviews count] - 1)*(CGRectGetWidth(lecturerPreviewFrame) + OFFSET);
        } else {
            minX = CGRectGetMaxX(self.pairView.frame) - CGRectGetWidth(lecturerPreviewFrame) - OFFSET*[self.lecturersPreviews count];
        }
        if (minX < edgeX) {
            minX = edgeX;
        }
        CGFloat distance = (maxX - minX) / (CGFloat)([self.lecturersPreviews count] - 1);
        lecturerPreviewFrame.origin.x = minX + lectorerPreviewIndex*distance;
        lecturerPreviewFrame.origin.y += (selected ? -1 : 1) * 5.0f;

        CGFloat rotateAngelPart = ((self.showingLecturers) ? 1 : -1)*2*M_PI/3.0;
        
        [UIView beginAnimations:@"lecturer IV animations 1" context:nil];
        [UIView setAnimationDuration:PAIR_CELL_ANIMATION_DURATION];
        lecturerPreview.transform = CGAffineTransformMakeRotation(rotateAngelPart);
        [UIView commitAnimations];

        [UIView beginAnimations:@"lecturer IV animations 2" context:nil];
        [UIView setAnimationDuration:PAIR_CELL_ANIMATION_DURATION];
        lecturerPreview.transform = CGAffineTransformMakeRotation(2*rotateAngelPart);
        [UIView commitAnimations];

        [UIView beginAnimations:@"lecturer IV animations 3" context:nil];
        [UIView setAnimationDuration:PAIR_CELL_ANIMATION_DURATION];
        lecturerPreview.transform = CGAffineTransformMakeRotation(3*rotateAngelPart);
        [UIView commitAnimations];

        [UIView beginAnimations:@"Movement animations" context:nil];
        [UIView setAnimationDuration:PAIR_CELL_ANIMATION_DURATION];
        lecturerPreview.frame = lecturerPreviewFrame;
        lecturerPreview.lecturerNameLabel.hidden = !selected;
        [UIView commitAnimations];
    }
    
    [UIView beginAnimations:@"Name disappear animation" context:nil];
    [UIView setAnimationDuration:PAIR_CELL_ANIMATION_DURATION];
    self.subjectNameLabel.alpha = (selected) ? 0.0 : 1.0;
    self.auditoryLabel.alpha = (selected) ? 0.0 : 1.0;
    
    [UIView commitAnimations];
    self.showingLecturers = selected;
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (NSString*)timeText {
    return [self.timeLabel.attributedText string];
}

#define LINE_HEIGHT 16.0
#define FONT_SIZE_24_h 16.0
#define FONT_SIZE_12_h 14.0

- (void)setTimeText:(NSString *)timeText {
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.timeLabel setAdjustsFontSizeToFitWidth:NO];
    }
    NSMutableAttributedString* attrTimeString = [[NSMutableAttributedString alloc] initWithString:timeText];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setMaximumLineHeight:LINE_HEIGHT];
    [style setAlignment:NSTextAlignmentCenter];
    [attrTimeString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [timeText length])];

    [attrTimeString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"OpenSans-Light" size:[self is24format] ? FONT_SIZE_24_h : FONT_SIZE_12_h]
                           range:NSMakeRange(0, [timeText length])];
    self.timeLabel.attributedText = attrTimeString;
}

- (BOOL)is24format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    return is24h;
}


- (void)setPairTypeIndicatorColor:(UIColor *)pairTypeIndicatorColor{
    _pairTypeIndicatorColor = pairTypeIndicatorColor;
    self.pairTypeIndicator.backgroundColor = pairTypeIndicatorColor;
    self.triangleView.fillColor = pairTypeIndicatorColor;
}

- (void)setupWithPair:(BSPair *)pair inDay:(id<BSDay>)day {
    [self setupWithPair:pair inDay:day weekMode:NO];
}
- (void)setupWithPair:(BSPair*)pair inDay:(id<BSDay>)day weekMode:(BOOL)weekMode{

    //-------------------------------Weeks label---------------------------------
    self.weeksLabel.hidden = !weekMode;
    NSArray *weeks = [pair.weeks sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"weekNumber" ascending:YES]]];
    
    NSMutableString *weekNumbersStr = [NSMutableString string];
    for (BSWeekNumber *weekNum in weeks) {
        NSInteger weekNumber = [weekNum.weekNumber integerValue];
        if (weekNumber == 0) {
            weekNumbersStr = [NSMutableString stringWithString:@"1,2,3,4"];
            break;
        } else {
            if (![weekNumbersStr isEqual:@""]) {
                [weekNumbersStr appendString:@","];
            }
            [weekNumbersStr appendFormat:@"%ld",(long)weekNumber];
        }
    }

    
    [self.weeksLabel setText:weekNumbersStr];
    [self.weeksLabel addImage:[UIImage imageNamed:@"calendar"] withAligment:BSImageAligmentLeft];

    //-------------------------------Subgroups label---------------------------------
    NSInteger subgroupNum = [pair.subgroupNumber integerValue];
    self.subgroupsLabel.hidden = !weekMode || subgroupNum == 0;
    NSString *subgrStr = [NSString stringWithFormat:@"%ld",(long)subgroupNum];
    
    [self.subgroupsLabel setText:subgrStr];
    [self.subgroupsLabel addImage:[UIImage imageNamed:@"group"] withAligment:BSImageAligmentLeft];

    //-------------------------------Other---------------------------------
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:NO];

    [self.subjectNameLabel setText:pair.subject.name];
    if ([pair.subgroupNumber integerValue] != 0 && !weekMode) {
        [self.subgroupsLabel addImage:[UIImage imageNamed:@"group"] withAligment:BSImageAligmentRight];
    }

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeString = [NSString stringWithFormat:@"%@\n-\n%@", [formatter stringFromDate:pair.startTime],[formatter stringFromDate:pair.endTime]];
    [self setTimeText:timeString];
    [self.auditoryLabel setText:pair.auditory.address];
    
    [self clearLecturersPreviews];
    NSArray *lecturers = [[pair.lecturers allObjects] sortedArrayUsingDescriptors:@[nameSort]];
    for (BSLecturer *lecturer in lecturers) {
        NSInteger lecturerIndex = [lecturers indexOfObject:lecturer];
        NSInteger lecturerReverseIndex = [lecturers count] - lecturerIndex;
        CGFloat lecturerX = self.pairView.frame.size.width  - LECTURER_IMAGE_WIDTH - lecturerReverseIndex *OFFSET;
        BSLecturerPreview *lecturerPreview = [[BSLecturerPreview alloc] initWithFrame:CGRectMake(lecturerX,
                                                                                                 0,
                                                                                                 LECTURER_IMAGE_WIDTH,
                                                                                                 self.pairView.frame.size.height)];
        [lecturerPreview setupWithLecturer:lecturer];
        [self.pairView addSubview:lecturerPreview];
        [self.lecturersPreviews addObject:lecturerPreview];
    }
    
    CGRect subjectNameFrame = self.subjectNameLabel.frame;
    subjectNameFrame.size.width = CGRectGetMaxX(self.frame) - subjectNameFrame.origin.x - OFFSET;
//    if (thumbnail != nil) {
//        subjectNameFrame.size.width -= (CGRectGetWidth(self.lecturerIV.frame) + OFFSET);
//    }
    self.subjectNameLabel.frame = subjectNameFrame;
    
    self.pairTypeIndicatorColor = [pair colorForPairType];
    [self setupTriangleForPair:pair inDay:day];
}

- (void)clearLecturersPreviews {
    for (BSLecturerPreview *lecturerPreview in self.lecturersPreviews) {
        [lecturerPreview removeFromSuperview];
    }
    [self.lecturersPreviews removeAllObjects];
    
}

- (void)setupTriangleForPair:(BSPair*)pair inDay:(id<BSDay>)day {
    NSDate *now = [NSDate date];
    BOOL cellForCurrentDay = NO;
    if ([day isKindOfClass:[BSDayWithWeekNum class]]) {
        cellForCurrentDay = [now isEqualToDateWithoutTime:[(BSDayWithWeekNum*)day date]];
    }
    
    NSDate *startOfTimeInterval = pair.startTime;
    NSDate *endOfTimeInterval = pair.endTime;
    NSDate *startOfTimeIntervalWithOffset = pair.startTime;
    NSDate *endOfTimeIntervalWithOffset = pair.endTime;
    NSInteger currentPairIndex = [[day allPairs] indexOfObject:pair];
    NSTimeInterval pairLength = fabs([[pair.endTime onlyTime] timeIntervalSinceDate:[pair.startTime onlyTime]]);
    NSTimeInterval indicatorTimeLength = pairLength * CGRectGetHeight(self.triangleView.bounds)/(2.0* CGRectGetHeight(self.bounds));
    if (currentPairIndex != 0) { //not first
        startOfTimeInterval = [[[day allPairs] objectAtIndex:currentPairIndex-1] endTime];
        startOfTimeIntervalWithOffset = [startOfTimeInterval dateByAddingTimeInterval:-indicatorTimeLength];
    }
    if (currentPairIndex != [[day allPairs] count] - 1) { // not last
        endOfTimeInterval = [[[day allPairs] objectAtIndex:currentPairIndex+1] startTime];
        endOfTimeIntervalWithOffset = [endOfTimeInterval dateByAddingTimeInterval:indicatorTimeLength];
    }
    BOOL showIndicator = [now isTimeBetweenTime:startOfTimeIntervalWithOffset andTime:endOfTimeIntervalWithOffset] && cellForCurrentDay;
    if (showIndicator) {
        CGFloat triangleOriginrY = -CGRectGetHeight(self.triangleView.bounds);
        if ([now isTimeBetweenTime:startOfTimeInterval andTime:pair.startTime]) {
            triangleOriginrY = -self.triangleView.bounds.size.height / 2.0;
        } else if ([now isTimeBetweenTime:pair.endTime andTime:endOfTimeInterval]) {
            triangleOriginrY = CGRectGetHeight(self.frame) - 2 - self.triangleView.bounds.size.height / 2.0;
        } else {
            NSTimeInterval firstBreak = fabs([[pair.startTime onlyTime] timeIntervalSinceDate:[startOfTimeInterval onlyTime]]);
            NSTimeInterval secondBreak = fabs([[pair.endTime onlyTime] timeIntervalSinceDate:[endOfTimeInterval onlyTime]]);
            NSTimeInterval intervalLength = pairLength + 2*indicatorTimeLength ;
            //???
            NSTimeInterval timePassed = fabs([[now onlyTime] timeIntervalSinceDate:[[startOfTimeInterval dateByAddingTimeInterval:-indicatorTimeLength] onlyTime]]);
            if ([now compareTime:pair.startTime] == NSOrderedDescending) {
                timePassed -= firstBreak;
            }
            if ([now compareTime:pair.endTime] == NSOrderedDescending) {
                timePassed -= secondBreak;
            }
            triangleOriginrY += (CGRectGetHeight(self.frame) - 2 + CGRectGetHeight(self.triangleView.bounds))* (CGFloat)timePassed / intervalLength;
            
        }
        [self.pairView.constraints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSLayoutConstraint *constraint = (NSLayoutConstraint *)obj;
            if (constraint.firstItem == self.triangleView || constraint.secondItem == self.triangleView) {
                [self.pairView removeConstraint:constraint];
            }
        }];
        [self.triangleView removeConstraints:self.triangleView.constraints];
        NSDictionary *metrics = @{@"triangleOriginrY" : @(triangleOriginrY), @"offset" : @(self.pairTypeIndicator.frame.size.width)};
        NSDictionary *views = NSDictionaryOfVariableBindings(_triangleView);
        [self.pairView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-offset-[_triangleView(5.0)]" options:0 metrics:metrics views:views]];
        [self.pairView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-triangleOriginrY-[_triangleView(20.0)]" options:0 metrics:metrics views:views]];

        self.triangleView.hidden = NO;
        [self.triangleView setNeedsDisplay];
    } else {
        self.triangleView.hidden = YES;
    }

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

- (void)handleThumbnailTap:(UITapGestureRecognizer*)sender {
    if ([self.lecturersPreviews count] < 2) {
        BSLecturerPreview *lecturerPreview = [self.lecturersPreviews lastObject];
        CGRect thumbFrame = [self convertRect:lecturerPreview.lecturerIV.frame fromView:lecturerPreview];
        [self.delegate thumbnailForLecturer:lecturerPreview.lecturer withStartFrame:thumbFrame getTappedOnCell:self];
    } else {
        if (self.showingLecturers) {
            BOOL findObject = NO;
            CGPoint tapPoint = [sender locationInView:self];
            for (BSLecturerPreview *lecturerPreview in self.lecturersPreviews) {
                if (CGRectContainsPoint(lecturerPreview.frame, tapPoint)) {
                    CGRect thumbFrame = [self convertRect:lecturerPreview.lecturerIV.frame fromView:lecturerPreview];
                    [self.delegate thumbnailForLecturer:lecturerPreview.lecturer withStartFrame:thumbFrame getTappedOnCell:self];
                    findObject = YES;
                }
            }
            if (!findObject) {
                [self makeSelected:!self.showingLecturers];
            }
        } else {
            [self makeSelected:!self.showingLecturers];
        }
    }

}
@end
