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

#import "BSConstants.h"
@import MessageUI;

static NSString * const kBSMenuItemTitle = @"kBSMenuItemTitle";
static NSString * const kBSMenuItemImage = @"kBSMenuItemImage";
static NSString * const kBSMenuItemBadgeCount = @"kBSMenuItemBadgeCount";
static NSString * const kBSMenuItemClass = @"kBSMenuItemClass";

static NSString * const kBSMenuCell = @"kBSMenuCell";

typedef NS_ENUM(NSInteger, BSMenuItem) {
    BSMenuItemFeedback       = 1,
    BSMenuItemSettings       = 2,
    BSMenuItemInfo           = 3,
    BSMenuItemSchedule       = 4,

};

@interface BSMenuVC () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) NSDictionary *menuItemsData;
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
}

//===============================================SLIDE MENU DELEGATE===========================================
#pragma mark - Slide menu delegate


- (void)leftMenuDidOpen {
    UIViewController *currentController = [SlideNavigationController sharedInstance].topViewController;
    [self.tableView reloadData];
    for (NSNumber *itemNumber in self.menuItems) {
        NSDictionary *itemData = self.menuItemsData[itemNumber];
        if ([NSStringFromClass([currentController class]) isEqual:NSStringFromClass(itemData[kBSMenuItemClass])]) {
            NSInteger itemIndex = [self.menuItems indexOfObject:itemNumber];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:itemIndex inSection:0];
            [self selectCellAtIndexPath:indexPath];
            break;
        }
    }
}

//===============================================DATA===========================================
#pragma mark - Data

- (void)updateMenuItems{
    self.menuItems = @[@(BSMenuItemSchedule), @(BSMenuItemSettings), @(BSMenuItemInfo),@(BSMenuItemFeedback)];
    NSMutableDictionary *itemsData = [NSMutableDictionary dictionary];
    NSDictionary *itemData;
    
    itemData = @{kBSMenuItemTitle: NSLocalizedString(@"L_Schedule", @"menu item title"),
                 kBSMenuItemImage: [UIImage imageNamed:@"menu_schedule"],
                 kBSMenuItemClass: [BSScheduleVC class]};
    itemsData[@(BSMenuItemSchedule)] = itemData;
    
    itemData = @{kBSMenuItemTitle: NSLocalizedString(@"L_Feedback", @"menu item title"),
                 kBSMenuItemImage: [UIImage imageNamed:@"menu_feedback"]};
    itemsData[@(BSMenuItemFeedback)] = itemData;
    
    itemData = @{kBSMenuItemTitle: NSLocalizedString(@"L_Settings", @"menu item title"),
                 kBSMenuItemImage: [UIImage imageNamed:@"menu_settings"],
                 kBSMenuItemClass: [BSSettingsVC class]};
    itemsData[@(BSMenuItemSettings)] = itemData;
    
    itemData = @{kBSMenuItemTitle: NSLocalizedString(@"L_Info", @"menu item title"),
                 kBSMenuItemImage: [UIImage imageNamed:@"menu_info"],
                 kBSMenuItemClass: [BSTutorialVC class]};
    itemsData[@(BSMenuItemInfo)] = itemData;
    
    self.menuItemsData = itemsData;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftMenuDidOpen) name:SlideNavigationControllerDidOpen object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)currentUserChanged {
    [self updateMenuItems];
    [self.tableView reloadData];
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
    NSNumber *menuItem = [self.menuItems objectAtIndex:indexPath.row];
    NSDictionary *menuItemData = [self.menuItemsData objectForKey:menuItem];
    
    BSMenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:kBSMenuCell forIndexPath:indexPath];
    
    [menuCell.titleLabel setText:menuItemData[kBSMenuItemTitle]];
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
    BSMenuItem menuItem = [self.menuItems[indexPath.row] intValue];
    [self showVcForMenuItem:menuItem];
}

- (void)showVcForMenuItem:(BSMenuItem)menuItem {
    UIViewController *rootVC;
    
    switch (menuItem) {
        case BSMenuItemFeedback:
            [self showMailScreen];
            break;
        default: {
            NSDictionary *itemData = self.menuItemsData[@(menuItem)];
            rootVC = [[[itemData objectForKey:kBSMenuItemClass] alloc] init];
            break;
        }
    }
    if (rootVC) {
        [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:rootVC withCompletion:nil];
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
