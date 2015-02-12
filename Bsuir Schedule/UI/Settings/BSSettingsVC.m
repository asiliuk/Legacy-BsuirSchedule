//
//  BSSettingsVC.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 20.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//toring

#import "BSSettingsVC.h"
#import "BSDataManager.h"
#import "BSConstants.h"
#import "UIView+Screenshot.h"
#import "NSUserDefaults+Share.h"

#import "SlideNavigationContorllerAnimator.h"
#import "BSScheduleAddVC.h"
#import "AppDelegate.h"

#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "BSScheduleParser.h"

#import "BSUtils.h"

@interface BSSettingsVC () <UITableViewDataSource,  UITableViewDelegate, MGSwipeTableCellDelegate, BSScheduleAddVCDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSUserDefaults *sharedDefaults;
@property (strong, nonatomic) NSMutableArray *schedules;

@property (strong, nonatomic) UIView *loadindicatorView;
@end

@implementation BSSettingsVC

static NSString * const kScheduleCellID = @"kScheduleCellID";

- (instancetype)init
{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
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


#define BORDER_WIDTH 2.0
#define CORNER_RADIUS 5.0
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LZD(@"L_Groups");
    
    self.sharedDefaults = [NSUserDefaults sharedDefaults];
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                      target:self
                                                                                      action:@selector(addGroup)];
    addBarButtonItem.tintColor = [UIColor whiteColor];
    addBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    [self.tableView registerClass:[MGSwipeTableCell class] forCellReuseIdentifier:kScheduleCellID];
    
    self.schedules = [[[BSDataManager sharedInstance] schelules] mutableCopy];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.navigationController.view addSubview:self.loadindicatorView];
    self.loadindicatorView.hidden = YES;
}
- (void)addGroup {
    BSScheduleAddVC *scheduleAddVC = [[BSScheduleAddVC alloc] init];
    scheduleAddVC.delegate = self;
    [self.navigationController pushViewController:scheduleAddVC animated:YES];
}

//===============================================MG SWYPE CELL===========================================
#pragma mark - MG Swype cell
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    if (cellIndexPath.row >= 0) {
        BSSchedule *schedule = [self.schedules objectAtIndex:cellIndexPath.row];
        [self.schedules removeObject:schedule];
        [[BSDataManager sharedInstance] deleteSchedule:schedule];
        [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    return YES;
}

//===============================================SCHEDULE ADD VC DELEGATe===========================================
#pragma mark - BSScheduleAddVC delegate

- (void)scheduleAddVC:(BSScheduleAddVC *)scheduleAddVC saveGroupWithGroupNumber:(NSString *)groupNumber subgroupNumber:(NSInteger)subgroupNumber {
    BSSchedule *schedule = [[BSDataManager sharedInstance] scheduleWithGroupNumber:groupNumber
                                                                     andSubgroup:subgroupNumber
                                                               createIfNotExists:YES];
    [self showLoadingView];
    __weak typeof(self) weakSelf = self;
    [BSScheduleParser scheduleForGroup:schedule.group
                           withSuccess:^{
                               typeof(weakSelf) self = weakSelf;
                               [self hideLoadingView];
                               [self.schedules addObject:schedule];
                               
                               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.schedules count]-1 inSection:0];
                               [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                           } failure:^{
                               typeof(weakSelf) self = weakSelf;
                               [BSUtils showAlertWithTitle:LZD(@"L_Error") message:LZD(@"L_LoadError") inVC:self];
                               [self hideLoadingView];
                           }];
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

//===============================================TABLE VIEW===========================================
#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)table
{
    if ([self.schedules count] == 0) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.textColor = BS_GRAY;
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:20];
        [messageLabel sizeToFit];
        
        messageLabel.text = LZD(@"L_NoGroups");

        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = nil;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.schedules count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kScheduleCellID forIndexPath:indexPath];
    BSSchedule *schedule = [self.schedules objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@/%ld",schedule.group.groupNumber,(long)[schedule.subgroup integerValue]]];
    MGSwipeButton *deleteBtn = [MGSwipeButton buttonWithTitle:LZD(@"L_Delete") backgroundColor:[UIColor redColor]];
    cell.rightButtons = @[deleteBtn];
    cell.delegate = self;
    return cell;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu;
{
    return YES;
}


@end
