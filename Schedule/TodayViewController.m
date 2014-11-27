//
//  TodayViewController.m
//  Schedule
//
//  Created by Anton Siliuk on 27.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "BSDataManager.h"
#import "BSDayWithWeekNum.h"
#import "BSPairCell.h"
#import "NSDate+Compare.h"
#import "BSConstants.h"

static NSString *kCellID = @"today widget cell reuse id";

@interface TodayViewController () <NCWidgetProviding, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) BSDayWithWeekNum *dayToHighlight;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *dayDescriprionLabel;
@end

@implementation TodayViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dayToHighlight = [[BSDataManager sharedInstance] dayToHighlight];
    
    self.preferredContentSize = CGSizeMake(0, CGRectGetMinY(self.tableView.frame) + CELL_HEIGHT*[self.dayToHighlight.pairs count]);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSPairCell class]) bundle:nil] forCellReuseIdentifier:kCellID];
    
    NSDate *now = [NSDate date];
    BOOL currentDay = [now isEqualToDateWithoutTime:self.dayToHighlight.date];
    BOOL tomorrow = [[now dateByAddingTimeInterval:DAY_IN_SECONDS] isEqualToDateWithoutTime:self.dayToHighlight.date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd.MM.YY"];
    
    NSString *dayInfoString = [NSString stringWithFormat:@"%@  %@  %@  %@",
                               NSLocalizedString([self.dayToHighlight.dayOfWeek name], nil),
                               [df stringFromDate:self.dayToHighlight.date],
                               NSLocalizedString(@"L_Week", nil),
                               self.dayToHighlight.weekNumber.weekNumber];
    if ([self.dayToHighlight isEqual:self.dayToHighlight]) {
        if (currentDay) {
            dayInfoString = [NSString stringWithFormat:@"(%@)  %@",NSLocalizedString(@"L_Today", nil), dayInfoString];
        } else if (tomorrow) {
            dayInfoString = [NSString stringWithFormat:@"(%@)  %@",NSLocalizedString(@"L_Tomorrow", nil), dayInfoString];
        }
    }
    self.dayDescriprionLabel.text = dayInfoString;
    
    BOOL hasDataToDisplay = [self.dayToHighlight.pairs count] > 0;
    NCWidgetController *widgetController = [[NCWidgetController alloc] init];
    [widgetController setHasContent:hasDataToDisplay forWidgetWithBundleIdentifier:@"com.saute.Bsuir-Schedule.Schedule"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    BSDayWithWeekNum *day = [[BSDataManager sharedInstance] dayToHighlight];
    if ([day isEqual:self.dayToHighlight]) {
        completionHandler(NCUpdateResultNoData);
    } else {
        self.dayToHighlight = day;
        [self.tableView reloadData];
        completionHandler(NCUpdateResultNewData);
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
////    return [self.dayToHighlight.pairs count];
    return [self.dayToHighlight.pairs count];
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    BSPairCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    NSArray *pairs = self.dayToHighlight.pairs;
    BSPair *pair = [pairs objectAtIndex:indexPath.row];
    [cell setupWithPair:pair cellForCurrentDay:[[NSDate date] isEqualToDateWithoutTime:self.dayToHighlight.date]];
    [cell updateUIForWidget];
    return cell;
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

@end
