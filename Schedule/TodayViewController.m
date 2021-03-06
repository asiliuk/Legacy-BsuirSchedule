//
//  TodayViewController.m
//  Schedule
//
//  Created by Anton Siliuk on 30.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "BSPairCell.h"
#import "BSDataManager.h"
#import "NSDate+Compare.h"
#import "BSConstants.h"
#import "NSUserDefaults+Share.h"

#import "BSDayWithWeekNum.h"

#import "AYVibrantButton.h"


static NSString * const kCellID = @"today view cell";

@interface TodayViewController () <NCWidgetProviding, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *dayInfoLabel;
@property (strong, nonatomic) BSDayWithWeekNum *dayToHighlight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;

@property (strong, nonatomic) BSSchedule *schedule;

@property (readonly, assign, nonatomic) CGSize maxSize;

@property (strong, nonatomic) NSArray *pairs;

@end

@implementation TodayViewController

- (CGSize)maxSize {
    return CGSizeMake(0, CGRectGetMinY(self.tableView.frame) + [self.pairs count] * CELL_HEIGHT + ABS(self.tableBottomConstraint.constant));
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *shared = [NSUserDefaults sharedDefaults];
    NSString *groupNumber = [shared objectForKey:kWidgetGroup];
    NSInteger subgroup = [shared integerForKey:kWidgetSubgroup];

    self.schedule = [[BSDataManager sharedInstance] scheduleWithGroupNumber:groupNumber andSubgroup:subgroup createIfNotExists:NO];
    self.dayToHighlight = [[BSDataManager sharedInstance] dayToHighlightInSchedule:self.schedule weekMode:NO];
    self.pairs = [self.dayToHighlight pairsForSchedule:self.schedule weekFormat:NO];

    if (SYSTEM_VERSION_LESS_THAN(@"10.0")) {
        self.tableBottomConstraint.constant = 44;
        self.preferredContentSize = self.maxSize;
    } else {
        self.tableBottomConstraint.constant = 0;
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
        self.preferredContentSize = [self widgetMaximumSizeForDisplayMode: self.extensionContext.widgetActiveDisplayMode];
    }

    [self.view layoutSubviews];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSPairCell class]) bundle:nil] forCellReuseIdentifier:kCellID];
    BOOL hasDataToDisplay = NO;
    if (self.dayToHighlight.dayOfWeek) {
        [self updateDayInfo];
        hasDataToDisplay = YES;
    }
    NCWidgetController *widgetController = [[NCWidgetController alloc] init];
    [widgetController setHasContent:hasDataToDisplay forWidgetWithBundleIdentifier:kWidgetID];

    if (SYSTEM_VERSION_LESS_THAN(@"10.0")) {

        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect notificationCenterVibrancyEffect]];
        effectView.frame = self.view.bounds;
        [self.view addSubview:effectView];

        effectView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[effectView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(effectView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[effectView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(effectView)]];

        AYVibrantButton *invertButton = [[AYVibrantButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40) style:AYVibrantButtonStyleInvert];
        invertButton.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        invertButton.text = LZD(@"L_OpenApp");
        invertButton.font = [UIFont fontWithName:@"OpenSans" size:14.0];
        [effectView.contentView addSubview:invertButton];

        invertButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:invertButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:effectView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];

        [effectView addConstraint:centerX];
        [effectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[invertButton(220)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(invertButton)]];
        [effectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[invertButton(30)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(invertButton)]];

        [invertButton addTarget:self action:@selector(openApp:) forControlEvents:UIControlEventTouchUpInside];
    }

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        self.tableView.rowHeight = 72;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDayInfo {
    BSDayWithWeekNum *dayWithWeekNum = self.dayToHighlight;
    NSDate *now = [NSDate date];
    BOOL currentDay = [now isEqualToDateWithoutTime:dayWithWeekNum.date];
    BOOL tomorrow = [[now dateByAddingTimeInterval:DAY_IN_SECONDS] isEqualToDateWithoutTime:dayWithWeekNum.date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd.MM.YY"];
    NSString *dayInfoString = [NSString stringWithFormat:@"%@  %@  %@  %@",
                               NSLocalizedString([@"Sh_" stringByAppendingString:[dayWithWeekNum.dayOfWeek name]], nil),
                               [df stringFromDate:dayWithWeekNum.date],
                               NSLocalizedString(@"L_Week", nil),
                               dayWithWeekNum.weekNumber.weekNumber];
    if ([dayWithWeekNum isEqual:self.dayToHighlight]) {
        if (currentDay) {
            dayInfoString = [NSString stringWithFormat:@"(%@)  %@",NSLocalizedString(@"L_Today", nil), dayInfoString];
        } else if (tomorrow) {
            dayInfoString = [NSString stringWithFormat:@"(%@)  %@",NSLocalizedString(@"L_Tomorrow", nil), dayInfoString];
        }
    }
    [self.dayInfoLabel setText:dayInfoString];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    BSDayWithWeekNum *day = [[BSDataManager sharedInstance] dayToHighlightInSchedule:self.schedule weekMode:NO];
    
    if ([self.dayToHighlight isEqual:day]) {
        completionHandler(NCUpdateResultNoData);
    } else {
        self.dayToHighlight = day;
        [self.tableView reloadData];
        completionHandler(NCUpdateResultNewData);
    }
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

- (void)openApp:(id)sender {
    NSURL *url = [NSURL URLWithString:[@"bsuirschedule://?group=" stringByAppendingString:self.schedule.group.groupNumber]];
    [self.extensionContext openURL:url completionHandler:nil];
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    CGSize requredSize = [self widgetMaximumSizeForDisplayMode:activeDisplayMode];
    if (requredSize.height > maxSize.height) {
        self.preferredContentSize = maxSize;
    } else {
        self.preferredContentSize = requredSize;
    }
}

- (CGSize)widgetMaximumSizeForDisplayMode:(NCWidgetDisplayMode)displayMode {
    return self.maxSize;
}

//===============================================TABLE VIEW===========================================
#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pairs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSPairCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    BSPair *pair = [self.pairs objectAtIndex:indexPath.row];
    [cell setupWithPair:pair inDay:self.dayToHighlight forSchedule:self.schedule widgetMode:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

@end
