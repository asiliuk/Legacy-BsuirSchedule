//
//  BMWMenuVC.m
//  BMW club
//
//  Created by Anton Siliuk on 11.12.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSMenuVC.h"
#import "BSMenuCell.h"
#import "BSScheduleVC.h"
#import "BSTutorialVC.h"
#import "BSSettingsVC.h"
#import "BSAchivementsVC.h"
#import "BSDataManager.h"

#import "BSConstants.h"
@import MessageUI;

NSString * const kBSMenuItemType = @"kBSMenuItemType";

NSString * const kBSMenuItemTitle = @"kBSMenuItemTitle";
NSString * const kBSMenuItemImage = @"kBSMenuItemImage";
NSString * const kBSMenuItemClass = @"kBSMenuItemClass";

NSString * const kBSMenuItemSchedule = @"kBSMenuItemSchedule";

NSString * const kBSMenuCell = @"kBSMenuCell";



@interface BSMenuVC () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, AMSlideMenuDelegate>
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
                                             selector:@selector(schedulesUpdate)
                                                 name:kSchedulesGetUpdated
                                               object:nil];
    self.mainVC.slideMenuDelegate = self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addFixView {
    
    if (!self.fixView) {
        self.fixView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        self.fixView.backgroundColor = [UIColor darkGrayColor];
        [self.mainVC.view insertSubview:self.fixView aboveSubview:self.view];
    }
}

- (void)removeFixView {
    [self.fixView removeFromSuperview];
    self.fixView = nil;
}

//===============================================INDEX METHODS===========================================
#pragma mark - Index methods
- (NSIndexPath*)indexPathForGroupNumber:(NSString*)groupNumber {
    NSIndexPath *indexPath;
    for (NSDictionary* menuItemData in self.menuItems) {
        if ([menuItemData[kBSMenuItemType] isEqual:@(BSMenuItemSchedule)]) {
            if (!groupNumber || [[[menuItemData[kBSMenuItemSchedule] group] groupNumber] isEqual:groupNumber]) {
                indexPath = [NSIndexPath indexPathForRow:[self.menuItems indexOfObject:menuItemData] inSection:0];
                break;
            }
        }
    }
    return indexPath;
}
- (NSIndexPath*)settingsIndexPath {
    NSIndexPath *indexPath;
    for (NSDictionary* menuItemData in self.menuItems) {
        if ([menuItemData[kBSMenuItemType] isEqual:@(BSMenuItemSettings)]) {
            indexPath = [NSIndexPath indexPathForRow:[self.menuItems indexOfObject:menuItemData] inSection:0];
            break;
        }
    }
    return indexPath;
}
- (void)openVCAtIndexPath:(NSIndexPath*)indexPath {
    [self showVcForMenuItemData:self.menuItems[indexPath.row]];
}
//===============================================SLIDE MENU DELEGATE===========================================
#pragma mark - Slide menu delegate

- (void)leftMenuWillClose {
    [self removeFixView];
}

- (void)leftMenuDidClose {
    [self selectCellAtIndexPath:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMenuDidClose object:self];
}

- (void)leftMenuDidOpen {
    [self addFixView];
    
    NSIndexPath *currVCIndexPath = [self currentControllerIndexPath];
    if (currVCIndexPath) {
        [self selectCellAtIndexPath:currVCIndexPath];
    }
}

- (NSIndexPath*)currentControllerIndexPath {
    NSIndexPath *currentControllerIndexPath;
    UIViewController *currentController = self.mainVC.currentActiveNVC.topViewController;
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

    itemData = @{kBSMenuItemType: @(BSMenuItemAchivements),
                 kBSMenuItemTitle: NSLocalizedString(@"L_Achivements", @"menu item title"),
                 kBSMenuItemImage: [UIImage imageNamed:@"menu_achivements"],
                 kBSMenuItemClass: [BSAchivementsVC class]};
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
    
    itemData = @{kBSMenuItemType: @(BSMenuItemFeedback),
                 kBSMenuItemTitle: NSLocalizedString(@"L_Feedback", @"menu item title"),
                 kBSMenuItemImage: [UIImage imageNamed:@"menu_feedback"]};
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
    [menuCell.cellLabel setText:title];
    [menuCell.iconIV setImage:menuItemData[kBSMenuItemImage]];


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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEFAULT_CELL_HEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectCellAtIndexPath:indexPath];
    NSDictionary *menuItemData = self.menuItems[indexPath.row];
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
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
        [self openContentNavigationController:nvc];
    } else {
        [self.mainVC closeLeftMenuAnimated:YES];
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
        [self presentViewController:mailCont animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
}


// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
