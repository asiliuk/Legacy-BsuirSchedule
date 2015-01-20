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
#import "UIView+Screenshot.h"

#import "BSSettingsVC.h"
#import "BSScheduleParser.h"
#import "BSLecturerVC.h"
#import "NSUserDefaults+Share.h"

static NSString * const kCellID = @"Pair cell id";


@interface BSScheduleVC () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate,
BSSettingsVCDelegate, BSPairCellDelegate>

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
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = BS_LIGHT_GRAY;
    [self.tableView setBackgroundView:bview];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.navigationController.navigationBar setBarTintColor:BS_BLUE];
    } else {
        self.navigationController.navigationBar.tintColor = BS_BLUE;
    }
    UIFont *titleFont = [UIFont fontWithName:@"OpenSans" size:20.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName: titleFont}];
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.frame = CGRectMake(0, 0, 40, 40);
    [settingsButton setImage:[UIImage imageNamed:@"tools"] forState:UIControlStateNormal];
    [settingsButton setImage:[UIImage imageNamed:@"tools"] forState:UIControlStateNormal | UIControlStateHighlighted];
    [settingsButton addTarget:self action:@selector(showSettingsScreen) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc]initWithCustomView:settingsButton];
    settingsButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = settingsBarButton;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSPairCell class]) bundle:nil] forCellReuseIdentifier:kCellID];
    [self getScheduleData];
    [self.navigationController.view addSubview:self.loadindicatorView];
    self.loadindicatorView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSUserDefaults *sharedDefaults = [NSUserDefaults sharedDefaults];
    if (![sharedDefaults objectForKey:kUserSubgroup]) {
        [self showSettingsScreen];
    }
}

- (void)getScheduleData {
    NSUserDefaults *sharedDefaults = [NSUserDefaults sharedDefaults];
    NSString *groupNumber = [sharedDefaults objectForKey:kUserGroup];
    if (groupNumber) {
        if ([BSScheduleParser scheduleNeedUpdateForGroup:groupNumber]) {
            [self showLoadingView];
            [BSScheduleParser scheduleForGroupNumber:groupNumber withSuccess:^{
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
            if ([BSScheduleParser scheduleExpires]) {
                [BSScheduleParser scheduleForGroupNumber:groupNumber withSuccess:^{
                    [self updateSchedule];
                } failure:nil];
            }
            [self updateSchedule];
        }
    }
}

- (void)updateSchedule {
    [self hideLoadingView];
    self.dayToHighlight = [[BSDataManager sharedInstance] dayToHighlight];
    
    self.daysWithWeekNumber = nil;
    
    [self loadScheduleForDaysCount:PREVIOUS_DAY_COUNT backwards:YES];
    [self loadScheduleForDaysCount:DAYS_LOAD_STEP backwards:NO];
    
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

- (void)loadScheduleForDaysCount:(NSInteger)daysCount backwards:(BOOL)backwards {
    NSDate *now = [NSDate date];
    NSDate *dayDate = now; // to show two previous days
    if ([self.daysWithWeekNumber count] > 0) {
        if (backwards) {
            dayDate = [[self.daysWithWeekNumber firstObject] date];
        } else {
            dayDate = [[[self.daysWithWeekNumber lastObject] date] dateByAddingTimeInterval:DAY_IN_SECONDS];
        }
    }
    NSInteger daysAdded = 0;
    while (daysAdded < daysCount) {
        BSDayWithWeekNum *dayWithWeekNum = [[BSDayWithWeekNum alloc] initWithDate:dayDate];
        if (dayWithWeekNum.dayOfWeek && [[dayWithWeekNum pairs] count] > 0 && !([dayDate isEqual:now] && backwards)) {
            if (backwards) {
                [self.daysWithWeekNumber insertObject:dayWithWeekNum atIndex:0];
            } else {
                [self.daysWithWeekNumber addObject:dayWithWeekNum];

            }
            daysAdded++;
        }
        dayDate = [dayDate dateByAddingTimeInterval:(backwards ? -1 : 1)*DAY_IN_SECONDS];
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
    cell.delegate = self;
    [cell setupWithPair:pair inDay:dayWithWeekNum];
    return cell;
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
    [view setBackgroundColor:BS_LIGHT_GRAY];
    [label setBackgroundColor:[UIColor clearColor]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 73.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return HEADER_HEIGHT+5.0;
    return 30.0;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}
//-------------------------------Scroll view---------------------------------

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
        [self loadScheduleForDaysCount:DAYS_LOAD_STEP backwards:NO];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.daysWithWeekNumber.count - DAYS_LOAD_STEP, DAYS_LOAD_STEP)];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
    }
    
}

//-------------------------------Lecturer name view---------------------------------


//- (void)deselectVisibleCells {
//    for (BSPairCell *pairCell in [self.tableView visibleCells]) {
//        if (pairCell.showingLecturerName) {
//            [pairCell makeSelected:NO];
//        }
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    BSPairCell *pairCell = (BSPairCell*)[tableView cellForRowAtIndexPath:indexPath];
//    if (pairCell) {
//        if (!pairCell.showingLecturerName) {
//            [self deselectVisibleCells];
//        }
//        [pairCell makeSelected:!pairCell.showingLecturerName];
//    }
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self deselectVisibleCells];
//}

//===============================================UI===========================================
#pragma mark - UI

- (void)showSettingsScreen {
    BSSettingsVC *settingsVC = [[BSSettingsVC alloc] init];
    [self presentVCInCurrentContext:settingsVC];
    settingsVC.delegate = self;

}

- (void)showLecturerVCForLecturer:(BSLecturer*)lecturer withStartFrame:(CGRect)startFrame{
    if (lecturer) {
        BSLecturerVC *lecturerVC = [[BSLecturerVC alloc] initWithLecturer:lecturer startFrame:startFrame];
        [self presentVCInCurrentContext:lecturerVC];
    }
}

- (void)presentVCInCurrentContext:(UIViewController*)vc {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    } else {
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [self presentViewController:vc animated:NO completion:nil];
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
    if (self.loadindicatorView.hidden) {
        self.loadindicatorView.hidden = NO;
        self.loadindicatorView.alpha = 0;
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.loadindicatorView.alpha = 0.5;
        }];
    }
}

- (void)hideLoadingView {
    if (!self.loadindicatorView.hidden) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.loadindicatorView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                self.loadindicatorView.hidden = YES;
            }
        }];
    }
}
//===============================================BSPairCell DELEGATE===========================================
#pragma mark - BSPairCell delegate

- (void)thumbnailGetTappedOnCell:(BSPairCell *)cell {
    NSIndexPath *indexPathOfCell = [self.tableView indexPathForCell:cell];
    if (indexPathOfCell) {
        BSDayWithWeekNum *dayWithWeekNum = [self.daysWithWeekNumber objectAtIndex:indexPathOfCell.section];
        BSPair *pair = [dayWithWeekNum.pairs objectAtIndex:indexPathOfCell.row];
        
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        BSLecturer *lecturer = [[[pair.lecturers allObjects] sortedArrayUsingDescriptors:@[nameSort]] firstObject];
        
        CGRect startFrame = [self.view convertRect:cell.lecturerIV.frame fromView:cell];
        [self showLecturerVCForLecturer:lecturer withStartFrame:startFrame];
    }
}

@end
