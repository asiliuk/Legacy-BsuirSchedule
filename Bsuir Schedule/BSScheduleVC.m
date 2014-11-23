//
//  ViewController.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSScheduleVC.h"
#import "BSConstants.h"
#import "BSDataManager.h"
#import "BSPairCell.h"
#import "BSDayWithWeekNum.h"

#import "BSLecturer+Thumbnail.h"
#import "NSString+Transiterate.h"
#import "NSDate+Compare.h"

#import "BSSettingsVC.h"


static NSString * const kCellID = @"Pair cell id";

#define DAYS_LOAD_STEP 10
#define DAY_IN_SECONDS 24*3600
#define PREVIOUS_DAY_COUNT 2

#define OFFSET 10.0

#define ANIMATION_DURATION 0.3
#define SETTINGS_SCREEN_ANIMATION_DURATION 0.4

#define HEADER_HEIGHT 25.0
#define HEADER_LABEL_FONT_SIZE 17.0
#define HEADER_LABEL_OFFSET_X 10.0
#define HEADER_LABEL_OFFSET_Y 5.0


@interface BSScheduleVC () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, BSSettingsVCDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *daysWithWeekNumber;

@property (strong, nonatomic) UIView *loadindicatorView;
@property (strong, nonatomic) BSDayWithWeekNum *dayToHighlight;
@end

@implementation BSScheduleVC

- (instancetype)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
    }
    return self;
}
- (UIView*)loadindicatorView {
    if (!_loadindicatorView) {
        _loadindicatorView = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
        _loadindicatorView.backgroundColor = [UIColor blackColor];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center = CGPointMake(_loadindicatorView.bounds.size.width / 2.0, _loadindicatorView.bounds.size.height / 2.0);
        [_loadindicatorView addSubview:activityIndicator];
        [activityIndicator startAnimating];
    }
    return _loadindicatorView;
}

- (NSMutableArray*)daysWithWeekNumber {
    if (!_daysWithWeekNumber) {
        _daysWithWeekNumber = [NSMutableArray array];
    }
    return _daysWithWeekNumber;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"L_Schedule", nil);
    
    [self.navigationController.navigationBar setBarTintColor:BS_BLUE];
    UIFont *titleFont = [UIFont fontWithName:@"OpenSans" size:20.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName: titleFont}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tools"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettingsScreen)];
    settingsButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = settingsButton;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSPairCell class]) bundle:nil] forCellReuseIdentifier:kCellID];
    [self getScheduleData];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kUserSubgroup]) {
        [self showSettingsScreen];
    }
    


}

- (void)getScheduleData {
    NSString *groupNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kUserGroup];
    if (groupNumber) {
        if ([[BSDataManager sharedInstance]scheduleNeedUpdateForGroup:groupNumber]) {
            [self showLoadingView];
            [[BSDataManager sharedInstance] scheduleForGroupNumber:groupNumber withSuccess:^{
                [self updateSchedule];
            } failure:^{
                [self hideLoadingView];
                NSString *errorMessage = NSLocalizedString(@"L_LoadError", nil);
                NSString *errorTitle = NSLocalizedString(@"L_Error", nil);
                NSString *okButtonTitle = NSLocalizedString(@"L_Ok", nil);
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:errorTitle
                                                                                     message:errorMessage
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alertVC addAction:okAction];
                    [self presentViewController:alertVC animated:YES completion:nil];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorTitle
                                                                    message:errorMessage
                                                                   delegate:nil
                                                          cancelButtonTitle:okButtonTitle otherButtonTitles: nil];
                    [alert show];
                }
            }];
        } else {
            [self updateSchedule];
        }
    }
}

- (void)updateSchedule {
    [self hideLoadingView];
    NSDate *now = [NSDate date];
    BSDayWithWeekNum *today = [[BSDayWithWeekNum alloc] initWithDate:now];
    NSDate *todayLastPairEnd = [[[today pairs] lastObject] endTime]; //need pairs of 'today' to highlight tomorrow section header
    BOOL todayPairsEnded = [todayLastPairEnd compareTime:now] == NSOrderedAscending || [today.pairs count] == 0;
    if (!(todayPairsEnded || today.dayOfWeek == nil)) {
        self.dayToHighlight = today;
    } else {
        self.dayToHighlight = [[BSDayWithWeekNum alloc] initWithDate:[now dateByAddingTimeInterval:DAY_IN_SECONDS]];
    }
    
    self.daysWithWeekNumber = nil;
    [self loadScheduleForNextDaysCount:DAYS_LOAD_STEP];
    
    [self.tableView reloadData];
    NSInteger highlightedSectionIndex = 0;
    for (NSInteger index = 0; index < [self.daysWithWeekNumber count]; index++) {
        BSDayWithWeekNum *dayWithWeekNum = [self.daysWithWeekNumber objectAtIndex:index];
        if ([dayWithWeekNum isEqual:self.dayToHighlight]) {
            highlightedSectionIndex = index;
            break;
        }
    }

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:highlightedSectionIndex]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (void)loadScheduleForNextDaysCount:(NSInteger)daysCount {
    NSDate *dayDate = [NSDate dateWithTimeIntervalSinceNow:-(1 + PREVIOUS_DAY_COUNT)*DAY_IN_SECONDS]; // to show two previous days
    if ([self.daysWithWeekNumber count] > 0) {
        dayDate = [[self.daysWithWeekNumber lastObject] date];
    }
    NSInteger daysAdded = 0;
    while (daysAdded < daysCount) {
        dayDate = [dayDate dateByAddingTimeInterval:DAY_IN_SECONDS];
        BSDayWithWeekNum *dayWithWeekNum = [[BSDayWithWeekNum alloc] initWithDate:dayDate];
        if (dayWithWeekNum.dayOfWeek && [[dayWithWeekNum pairs] count] > 0) {
            [self.daysWithWeekNumber addObject:dayWithWeekNum];
            daysAdded++;
        }
    }
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.saute.Bsuir_Schedule" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//===============================================TABLE VIEW===========================================
#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.daysWithWeekNumber count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.daysWithWeekNumber objectAtIndex:section] pairs] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSPairCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    BSDayWithWeekNum *dayWithWeekNum = [self.daysWithWeekNumber objectAtIndex:indexPath.section];
    NSArray *pairs = [dayWithWeekNum pairs];
    BSPair *pair = [pairs objectAtIndex:indexPath.row];
    BSLecturer *lecturer = pair.lecturer;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeString = [NSString stringWithFormat:@"%@\n-\n%@", [formatter stringFromDate:pair.startTime],[formatter stringFromDate:pair.endTime]];
    [cell setTimeText:timeString];
    [cell.subjectNameLabel setText:pair.subject.name];
    [cell.auditoryLabel setText:pair.auditory.address];
    UIImage *thumbnail = [lecturer thumbnail];
    [cell.lecturerIV setImage:thumbnail];
        cell.lecturerIV.hidden = thumbnail == nil;
    CGRect subjectNameFrame = cell.subjectNameLabel.frame;
    subjectNameFrame.size.width = CGRectGetMaxX(cell.frame) - subjectNameFrame.origin.x - OFFSET;
    if (thumbnail != nil) {
        subjectNameFrame.size.width -= (CGRectGetWidth(cell.lecturerIV.frame) + OFFSET);
    }
    cell.lecturerNameLabel.hidden = lecturer == nil;
    cell.subjectNameLabel.frame = subjectNameFrame;

    if (lecturer) {
        [cell.lecturerNameLabel setText:[NSString stringWithFormat:@"%@ %@.%@.",
                                         lecturer.lastName,
                                         [lecturer.firstName substringToIndex:1],
                                         [lecturer.middleName substringToIndex:1]]];
    }
    cell.pairTypeIndicatorColor = [pair colorForPairType];
    NSDate *today = [NSDate date];
    BOOL currentPair = [today isTimeBetweenTime:pair.startTime andTime:pair.endTime] && [today isEqualToDateWithoutTime:dayWithWeekNum.date];
    [cell makeCurrentPairCell:currentPair];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BSPairCell *pairCell = (BSPairCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (pairCell) {
        if (!pairCell.showingLecturerName) {
            [self deselectVisibleCells];
        }
        [pairCell makeSelected:!pairCell.showingLecturerName];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self deselectVisibleCells];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollingFinishScrollView:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollingFinishScrollView:scrollView];
}
- (void)scrollingFinishScrollView:(UIScrollView*)scrollView {
    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
        NSLog(@"load more rows");
        [self loadScheduleForNextDaysCount:DAYS_LOAD_STEP];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.daysWithWeekNumber.count - DAYS_LOAD_STEP, DAYS_LOAD_STEP)];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
    }
    
}

- (void)deselectVisibleCells {
    for (BSPairCell *pairCell in [self.tableView visibleCells]) {
        if (pairCell.showingLecturerName) {
            [pairCell makeSelected:NO];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BSDayWithWeekNum *dayWithWeekNum = [self.daysWithWeekNumber objectAtIndex:section];
    NSDate *now = [NSDate date];
    BOOL currentDay = [now isEqualToDateWithoutTime:dayWithWeekNum.date];
    BOOL tomorrow = [[now dateByAddingTimeInterval:DAY_IN_SECONDS] isEqualToDateWithoutTime:dayWithWeekNum.date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd.MM.YY"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(HEADER_LABEL_OFFSET_X, HEADER_LABEL_OFFSET_Y,
                                                               tableView.frame.size.width, HEADER_HEIGHT)];
    [label setFont:[UIFont fontWithName:@"OpenSans" size:HEADER_LABEL_FONT_SIZE]];

    [label setTextColor:BS_GRAY];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]];
    
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
        [label setTextColor:BS_RED];
    }
    [label setText:dayInfoString];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT+5.0;
}
//===============================================UI===========================================
#pragma mark - UI

- (void)showSettingsScreen {
    BSSettingsVC *settingsVC = [[BSSettingsVC alloc] init];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        settingsVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    } else {
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [self presentViewController:settingsVC animated:NO completion:nil];
    settingsVC.delegate = self;

}

//===============================================SETTINGS SCREEN DELEAGTE===========================================
#pragma mark - Settings screen delegate 

- (void)settingsScreen:(BSSettingsVC *)settingsVC dismissWithChanges:(BOOL)changes {
    if (changes) {
        [self getScheduleData];
    }

}

//===============================================LOADING SCREEN===========================================
#pragma mark - Loading screen
- (void)showLoadingView {
    [self.navigationController.view addSubview:self.loadindicatorView];
    self.loadindicatorView.alpha = 0;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.loadindicatorView.alpha = 0.5;
    }];
}

- (void)hideLoadingView {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.loadindicatorView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.loadindicatorView removeFromSuperview];
        }
    }];
}
@end
