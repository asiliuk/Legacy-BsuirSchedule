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

#import "BSScheduleAddVC.h"
#import "AppDelegate.h"

#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "BSAchivementCell.h"
#import "BSScheduleParser.h"

#import "BSUtils.h"

#import "BSAchivementManager.h"
#import <Parse/Parse.h>

#import "UIViewController+Achivements.h"

@interface BSSettingsVC () <UITableViewDataSource,  UITableViewDelegate, MGSwipeTableCellDelegate, BSScheduleAddVCDelegate, SKPaymentTransactionObserver>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSUserDefaults *sharedDefaults;
@property (strong, nonatomic) NSMutableArray *schedules;

@property (strong, nonatomic) UIView *loadindicatorView;

@property (nonatomic) BOOL updateCells;
@end

@implementation BSSettingsVC

static NSString * const kScheduleCellID = @"kScheduleCellID";
static NSString * const kAchivementCellID = @"kAchivementCellID";

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
    
    self.title = LZD(@"L_Settings");
    
    self.sharedDefaults = [NSUserDefaults sharedDefaults];
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                      target:self
                                                                                      action:@selector(addGroup)];
    addBarButtonItem.style = UIBarButtonItemStylePlain;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        addBarButtonItem.tintColor = [UIColor whiteColor];
    } else {
        addBarButtonItem.tintColor = BS_BLUE;
    }
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    [self.tableView registerClass:[MGSwipeTableCell class] forCellReuseIdentifier:kScheduleCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSAchivementCell class]) bundle:nil] forCellReuseIdentifier:kAchivementCellID];

    self.schedules = [[[BSDataManager sharedInstance] schelules] mutableCopy];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.navigationController.view addSubview:self.loadindicatorView];
    self.loadindicatorView.hidden = YES;
    
    [self registerPurchasesLogic];
}

- (void)addGroup {
    [self restorePurchases];
//    [PFPurchase buyProduct:kSuperSupporterAchivementID block:nil];
    return;
    BSScheduleAddVC *scheduleAddVC = [[BSScheduleAddVC alloc] init];
    for (MGSwipeTableCell *cell in [self.tableView visibleCells]) {
        [cell hideSwipeAnimated:YES];
    }
    scheduleAddVC.delegate = self;
    [self.navigationController pushViewController:scheduleAddVC animated:YES];
}

//===============================================PURCHASES===========================================
#pragma mark - TransactionsDeleagte
- (void)registerPurchasesLogic {
    [PFPurchase addObserverForProduct:kSupporterAchivementID block:^(SKPaymentTransaction *transaction) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [self.tableView reloadData];
            [self triggerAchivementWithType:BSAchivementTypeSupporter];
        } else if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            [[BSAchivementManager sharedInstance] triggerAchivementWithType:BSAchivementTypeSupporter];
        }
    }];
    [PFPurchase addObserverForProduct:kSuperSupporterAchivementID block:^(SKPaymentTransaction *transaction) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [self.tableView reloadData];
            [self triggerAchivementWithType:BSAchivementTypeSuperSupporter];
        } else if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            [[BSAchivementManager sharedInstance] triggerAchivementWithType:BSAchivementTypeSuperSupporter];
        }
    }];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)restorePurchases {
    [self showLoadingView];
    [PFPurchase restore];
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    [self hideLoadingView];
    [self.tableView reloadData];
    [BSUtils showAlertWithTitle:LZD(@"L_PurchaseRestore") message:LZD(@"L_PurchaseRestoreSuccess") inVC:self];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    [self hideLoadingView];
    [BSUtils showAlertWithTitle:LZD(@"L_Error") message:[LZD(@"L_PurchaseRestoreError") stringByAppendingString:error.localizedDescription] inVC:self];

}

//===============================================MG SWYPE CELL===========================================
#pragma mark - MG Swype cell

- (void)swipeTableCell:(MGSwipeTableCell *)cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive {
    if (state == MGSwipeStateNone && self.updateCells) {
        [self.tableView reloadData];
        self.updateCells = NO;
    }
}

- (NSArray*)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings {
    NSMutableArray *btns = [NSMutableArray array];
    if (direction == MGSwipeDirectionRightToLeft) {
        __weak typeof(self) weakself = self;
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
        BSSchedule *schedule = [self.schedules objectAtIndex:cellIndexPath.row];
        MGSwipeButton *deleteBtn = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"trash"] backgroundColor:[UIColor redColor] padding:30.0 callback:^BOOL(MGSwipeTableCell *sender) {
            typeof(weakself) self = weakself;
            
            
            [self.schedules removeObject:schedule];
            [[BSDataManager sharedInstance] deleteSchedule:schedule];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            return YES;
        }];
        [btns addObject:deleteBtn];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            UIImage *starImg;
            if ([schedule isEqual:[BSDataManager sharedInstance].currentWidgetSchedule]) {
                starImg = [UIImage imageNamed:@"star_filled"];
            } else {
                starImg = [UIImage imageNamed:@"star"];
            }
            MGSwipeButton *starBtn = [MGSwipeButton buttonWithTitle:@"" icon:starImg backgroundColor:BS_YELLOW callback:^BOOL(MGSwipeTableCell *sender) {
                typeof(weakself) self = weakself;
                [BSDataManager sharedInstance].currentWidgetSchedule = schedule;
                self.updateCells = YES;
                return YES;
            }];
            [btns addObject:starBtn];
        }

    }
    return btns;
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
                               if (![self.schedules containsObject:schedule]) {
                                   [self.schedules addObject:schedule];
                                   
                                   if ([BSDataManager sharedInstance].currentWidgetSchedule == nil) {
                                       [BSDataManager sharedInstance].currentWidgetSchedule = schedule;
                                   }
                                   
                                   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.schedules count]-1 inSection:0];
                                   [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                               }
                           } failure:^{
                               typeof(weakSelf) self = weakSelf;
                               [[BSDataManager sharedInstance] deleteSchedule:schedule];
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

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.schedules count];
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[BSAchivementManager sharedInstance] achivements] count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kScheduleCellID forIndexPath:indexPath];
//    BSSchedule *schedule = [self.schedules objectAtIndex:indexPath.row];
//    [cell.textLabel setText:[NSString stringWithFormat:@"%@/%ld",schedule.group.groupNumber,(long)[schedule.subgroup integerValue]]];
//    
//    cell.delegate = self;
    BSAchivement *achivement = [[[BSAchivementManager sharedInstance] achivements] objectAtIndex:indexPath.row];
    BSAchivementCell *cell = [tableView dequeueReusableCellWithIdentifier:kAchivementCellID forIndexPath:indexPath];
    [cell setupWithAchivement:achivement];
    return cell;
}



@end
