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

static NSString * const kCellID = @"today view cell";

@interface TodayViewController () <NCWidgetProviding, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *dayInfoLabel;
@property (strong, nonatomic) BSDayWithWeekNum *dayToHighlight;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dayToHighlight = [[BSDataManager sharedInstance] dayToHighlight];
    self.preferredContentSize = CGSizeMake(0, CGRectGetMinY(self.tableView.frame) + [self.dayToHighlight.pairs count] * CELL_HEIGHT);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSPairCell class]) bundle:nil] forCellReuseIdentifier:kCellID];
    BOOL hasDataToDisplay = NO;
    if (self.dayToHighlight.dayOfWeek) {
        [self updateDayInfo];
        hasDataToDisplay = YES;
    }
    NCWidgetController *widgetController = [[NCWidgetController alloc] init];
    [widgetController setHasContent:hasDataToDisplay forWidgetWithBundleIdentifier:@"com.saute.Bsuir-Schedule.Schedule"];
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
                               NSLocalizedString([dayWithWeekNum.dayOfWeek name], nil),
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
    BSDayWithWeekNum *day = [[BSDataManager sharedInstance] dayToHighlight];
    
    if ([self.dayToHighlight isEqual:day]) {
        completionHandler(NCUpdateResultNoData);
    } else {
        self.dayToHighlight = day;
        [self.tableView reloadData];
        completionHandler(NCUpdateResultNewData);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"will appear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"did appear");
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

//===============================================TABLE VIEW===========================================
#pragma mark - Table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dayToHighlight.pairs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSPairCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    NSArray *pairs = [self.dayToHighlight pairs];
    BSPair *pair = [pairs objectAtIndex:indexPath.row];
    [cell setupWithPair:pair inDay:self.dayToHighlight];
    [cell updateUIForWidget];
    return cell;
}

@end
