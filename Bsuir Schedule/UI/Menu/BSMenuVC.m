//
//  BMWMenuVC.m
//  BMW club
//
//  Created by Anton Siliuk on 11.12.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSMenuVC.h"
#import "SlideNavigationController.h"
#import "BSMenuCell.h"
#import "BSScheduleVC.h"
#import "BSTutorialVC.h"
#import "BSSettingsVC.h"
#import "BSDataManager.h"

#import "BSConstants.h"
@import MessageUI;

static NSString * const kBSMenuItemType = @"kBSMenuItemType";

static NSString * const kBSMenuItemTitle = @"kBSMenuItemTitle";
static NSString * const kBSMenuItemImage = @"kBSMenuItemImage";
static NSString * const kBSMenuItemBadgeCount = @"kBSMenuItemBadgeCount";
static NSString * const kBSMenuItemClass = @"kBSMenuItemClass";

static NSString * const kBSMenuItemSchedule = @"kBSMenuItemSchedule";

static NSString * const kBSMenuCell = @"kBSMenuCell";

typedef NS_ENUM(NSInteger, BSMenuItem) {
    BSMenuItemFeedback       = 1,
    BSMenuItemSettings       = 2,
    BSMenuItemInfo           = 3,
    BSMenuItemSchedule       = 4,

};

@interface BSMenuVC () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIView *fixView;
@end

@implementation BSMenuVC

- (instancetype)init
{
    self = [super initWithNibName:NSStringFromClass([BSMenuVC class]) bundle:nil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self updateMenuItems];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSMenuCell class]) bundle:nil] forCellReuseIdentifier:kBSMenuCell];

    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leftMenuDidOpen)
                                                 name:SlideNavigationControllerDidOpen
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(schedulesUpdate)
                                                 name:kSchedulesGetUpdated
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//===============================================SLIDE MENU DELEGATE===========================================
#pragma mark - Slide menu delegate


- (void)leftMenuDidOpen {
    NSIndexPath *currVCIndexPath = [self currentControllerIndexPath];
    if (currVCIndexPath) {
        [self selectCellAtIndexPath:currVCIndexPath];
    }
}

- (NSIndexPath*)currentControllerIndexPath {
    NSIndexPath *currentControllerIndexPath;
    UIViewController *currentController = [SlideNavigationController sharedInstance].topViewController;
    BSSchedule *currentSchedule;
    if ([currentController isKindOfClass:[BSScheduleVC class]]) {
        currentSchedule = [(BSScheduleVC*)currentController schedule];
    }
    [self.tableView reloadData];
    for (NSDictionary *itemData in self.menuItems) {
        BOOL scheduleCell = NO;
        if ([itemData[kBSMenuItemType] isEqual:@(BSMenuItemSchedule)] && currentSchedule) {
            BSSchedule *itemSchedule = itemData[kBSMenuItemSchedule];
            scheduleCell = [itemSchedule isEqual:currentSchedule];
        }
        if ([NSStringFromClass([currentController class]) isEqual:NSStringFromClass(itemData[kBSMenuItemClass])] || scheduleCell) {
            NSInteger itemIndex = [self.menuItems indexOfObject:itemData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:itemIndex inSection:0];
            currentControllerIndexPath = indexPath;
            break;
        }
    }
    return currentControllerIndexPath;
}

//===============================================DATA===========================================
#pragma mark - Data

- (void)schedulesUpdate {
    [self updateMenuItems];
    [self.tableView reloadData];
}

- (void)updateMenuItems{
    NSMutableArray *menuItems = [NSMutableArray array];
    NSDictionary *itemData;
    
    NSArray *schedules = [[BSDataManager sharedInstance] schelules];
    for (BSSchedule *schedule in schedules) {
        NSInteger subgroup = [[schedule subgroup] integerValue];
        NSString* title = [NSString stringWithFormat:@"%@/%ld",schedule.group.groupNumber, (long)subgroup];
        itemData = @{kBSMenuItemType: @(BSMenuItemSchedule),
                     kBSMenuItemTitle: title,
                     kBSMenuItemImage: [UIImage imageNamed:@"menu_schedule"],
                     kBSMenuItemSchedule: schedule};
        [menuItems addObject:itemData];
    }

    
    itemData = @{kBSMenuItemType: @(BSMenuItemFeedback),
                 kBSMenuItemTitle: NSLocalizedString(@"L_Feedback", @"menu item title"),
                 kBSMenuItemImage: [UIImage imageNamed:@"menu_feedback"]};
    [menuItems addObject:itemData];

    itemData = @{kBSMenuItemType: @(BSMenuItemSettings),
                 kBSMenuItemTitle: NSLocalizedString(@"L_Settings", @"menu item title"),
                 kBSMenuItemImage: [UIImage imageNamed:@"menu_settings"],
                 kBSMenuItemClass: [BSSettingsVC class]};
    [menuItems addObject:itemData];

    itemData = @{kBSMenuItemType: @(BSMenuItemInfo),
                 kBSMenuItemTitle: NSLocalizedString(@"L_Info", @"menu item title"),
                 kBSMenuItemImage: [UIImage imageNamed:@"menu_info"],
                 kBSMenuItemClass: [BSTutorialVC class]};
    [menuItems addObject:itemData];

    self.menuItems = menuItems;
}

//===============================================UI===========================================
#pragma mark - UI

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//===============================================TABLE VIEW===========================================
#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *menuItemData = [self.menuItems objectAtIndex:indexPath.row];
    
    BSMenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:kBSMenuCell forIndexPath:indexPath];
    NSString *title = menuItemData[kBSMenuItemTitle];
     [menuCell.titleLabel setText:title];
    [menuCell.iconIV setImage:menuItemData[kBSMenuItemImage]];


    menuCell.badgeLabel.hidden = YES;
    NSIndexPath *selectedCellIndexPath = [tableView indexPathForSelectedRow];
    menuCell.separator.hidden = (selectedCellIndexPath.row == indexPath.row || selectedCellIndexPath.row - 1 == indexPath.row) ? YES : NO;
    menuCell.backgroundColor = [UIColor clearColor];
    return menuCell;
}

- (void)selectCellAtIndexPath:(NSIndexPath*)indexPath {
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        if ([cell isKindOfClass:[BSMenuCell class]]) {
            [[(BSMenuCell*)cell separator] setHidden:NO];
        }
    }
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    UITableViewCell *currCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([currCell isKindOfClass:[BSMenuCell class]]) {
        [[(BSMenuCell*)currCell separator] setHidden:YES];
    }
    NSIndexPath *prevCellIndexPath = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:0];
    UITableViewCell *prevCell = [self.tableView cellForRowAtIndexPath:prevCellIndexPath];
    if (prevCell && [prevCell isKindOfClass:[BSMenuCell class]]) {
        [[(BSMenuCell*)prevCell separator] setHidden:YES];
    }
}

#define DEFAULT_CELL_HEIGHT 44.0
#define BUTTON_CELL_HEIGHT 60.0

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHight = DEFAULT_CELL_HEIGHT;
    return cellHight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectCellAtIndexPath:indexPath];
    NSDictionary *menuItemData = self.menuItems[indexPath.row];
    NSIndexPath *selectedCell = [self currentControllerIndexPath];
    [SlideNavigationController sharedInstance].avoidSwitchingToSameClassViewController = selectedCell.row == indexPath.row;
    [self showVcForMenuItemData:menuItemData];
}

- (void)showVcForMenuItemData:(NSDictionary*)menuItemData {
    UIViewController *rootVC;
    BSMenuItem menuItem = [menuItemData[kBSMenuItemType] integerValue];
    switch (menuItem) {
        case BSMenuItemSchedule: {
            BSSchedule *schedule = menuItemData[kBSMenuItemSchedule];
            rootVC = [[BSScheduleVC alloc] initWithSchedule:schedule];
            break;
        }
        case BSMenuItemFeedback:
            [self showMailScreen];
            break;
        default: {
            rootVC = [[[menuItemData objectForKey:kBSMenuItemClass] alloc] init];
            break;
        }
    }
    if (rootVC) {
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:rootVC withCompletion:nil];
    } else {
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
    }
}

//===============================================MAIL===========================================
#pragma mark - Mail
- (void)showMailScreen {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@"Bsuir Schedule app"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"devbudgged@gmail.com"]];
        [[SlideNavigationController sharedInstance] presentViewController:mailCont animated:YES completion:nil];
    }
}


// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [[SlideNavigationController sharedInstance] dismissViewControllerAnimated:YES completion:nil];
}


@end
