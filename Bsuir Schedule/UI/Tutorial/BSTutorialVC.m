//
//  BSTutorialVC.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 10.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSTutorialVC.h"
#import "BSDataManager.h"
#import "BSPairCell.h"
#import "BSConstants.h"

#import "UIImage+ImageEffects.h"
@interface BSTutorialVC ()
@property (strong, nonatomic) IBOutlet UIView *lectureColorView;
@property (strong, nonatomic) IBOutlet UIView *laborColorView;
@property (strong, nonatomic) IBOutlet UIView *practiceColorView;

@property (strong, nonatomic) IBOutlet UIImageView *weeklyIcon;
@property (strong, nonatomic) IBOutlet UIImageView *dailyIcon;

@property (strong, nonatomic) IBOutlet UIImageView *lecturerIV;

@property (strong, nonatomic) IBOutlet UILabel *colorsLabel;
@property (strong, nonatomic) IBOutlet UILabel *iconsLabel;

@property (strong, nonatomic) IBOutlet UILabel *lectureLabel;
@property (strong, nonatomic) IBOutlet UILabel *labourLabel;
@property (strong, nonatomic) IBOutlet UILabel *practiceLabel;

@property (strong, nonatomic) IBOutlet UILabel *dayViewLabel;
@property (strong, nonatomic) IBOutlet UILabel *weekViewLabel;
@property (strong, nonatomic) IBOutlet UILabel *subgroupLabel;
@property (strong, nonatomic) IBOutlet UILabel *weekLabel;

@property (strong, nonatomic) IBOutlet UILabel *pairTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *subjectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *auditoryLabel;

@property (strong, nonatomic) IBOutlet UIView *pairIndicatorView;

@property (weak, nonatomic) IBOutlet UILabel *settingSwipeLabel;
@property (weak, nonatomic) IBOutlet UIView *starButton;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;

@property (weak, nonatomic) IBOutlet UILabel *subgroupIndMeaningLabel;


@end

@implementation BSTutorialVC

- (instancetype)init {
    return [self initWithNibName:NSStringFromClass([BSTutorialVC class]) bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lectureColorView.backgroundColor = [BSPair colorForPairType:BSPairTypeLecture];
    self.practiceColorView.backgroundColor = [BSPair colorForPairType:BSPairTypePractical];
    self.laborColorView.backgroundColor = [BSPair colorForPairType:BSPairTypeLaboratory];
    
    self.title = LZD(@"L_Info");
    
    [self.weeklyIcon setImage:[[UIImage imageNamed:@"weekly"] imageWithOverlayColor:BS_DARK]];
    [self.dailyIcon setImage:[[UIImage imageNamed:@"daily"] imageWithOverlayColor:BS_DARK]];

    self.lecturerIV.layer.masksToBounds = YES;
    self.lecturerIV.layer.cornerRadius = self.lecturerIV.frame.size.width/2.0;
    
    self.colorsLabel.text = LZD(@"L_Colors");
    self.iconsLabel.text = LZD(@"L_Icons");
    
    self.lectureLabel.text = LZD(@"L_Lecture");
    self.practiceLabel.text = LZD(@"L_Practice");
    self.labourLabel.text = LZD(@"L_Labour");
    
    self.dayViewLabel.text = LZD(@"L_DayView");
    self.weekViewLabel.text = LZD(@"L_WeekView");
    self.subgroupLabel.text = LZD(@"L_Subgroup");
    self.weekLabel.text = LZD(@"L_Week");
    
    self.subjectNameLabel.text = LZD(@"L_SubjectName");
    self.auditoryLabel.text = [NSString stringWithFormat:@"%@-%@",LZD(@"L_Room"),LZD(@"L_Housing")];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeString = [NSString stringWithFormat:@"%@\n-\n%@", LZD(@"L_StartTime"),LZD(@"L_EndTime")];
    [self setTimeText:timeString];
    
    self.pairIndicatorView.backgroundColor = [BSPair colorForPairType:BSPairTypeLecture];
    
    self.starButton.hidden = SYSTEM_VERSION_LESS_THAN(@"8.0");
    self.starButton.backgroundColor = BS_YELLOW;
    
    self.settingSwipeLabel.textColor = BS_DARK;
    [self.settingSwipeLabel setText:LZD(@"L_SettingsSwipe")];
    
    [self.starLabel setText:LZD(@"L_StarMeaning")];

    [self.subgroupIndMeaningLabel setText:[NSString stringWithFormat:@"%@\n☟",LZD(@"L_SubgroupMeaning")]];

    self.navigationController.navigationBar.translucent = NO;
}


#define LINE_HEIGHT 16.0
#define FONT_SIZE_24_h 16.0
#define FONT_SIZE_12_h 14.0

- (void)setTimeText:(NSString *)timeText {
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.pairTimeLabel setAdjustsFontSizeToFitWidth:NO];
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
    self.pairTimeLabel.attributedText = attrTimeString;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end
