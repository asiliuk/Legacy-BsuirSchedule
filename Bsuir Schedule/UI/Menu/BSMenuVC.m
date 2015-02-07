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

#import "BSConstants.h"

static NSString * const BayernkraftUrlString = @"http://www.bayernkraft.by";

static NSString * const kBMWMenuItemTitle = @"kBMWMenuItemTitle";
static NSString * const kBMWMenuItemImage = @"kBMWMenuItemImage";
static NSString * const kBMWMenuItemBadgeCount = @"kBMWMenuItemBadgeCount";
static NSString * const kBMWMenuItemClass = @"kBMWMenuItemClass";

static NSString * const kBMWMenuCell = @"kBMWMenuCell";

typedef NS_ENUM(NSInteger, BSMenuItem) {
    BSMenuItemFeedback       = 1,
    BSMenuItemSettings       = 2,
};

@interface BSMenuVC () <UITableViewDataSource, UITableViewDelegate>

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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSMenuCell class]) bundle:nil] forCellReuseIdentifier:kBMWMenuCell];

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
        if ([NSStringFromClass([currentController class]) isEqual:NSStringFromClass(itemData[kBMWMenuItemClass])]) {
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
    self.menuItems = @[@(BSMenuItemFeedback), @(BSMenuItemSettings)];
    NSMutableDictionary *itemsData = [NSMutableDictionary dictionary];
    NSDictionary *itemData;
    

    
    itemData = @{kBMWMenuItemTitle: NSLocalizedString(@"L_Feedback", @"menu item title"),
                 kBMWMenuItemImage: [UIImage imageNamed:@"tools"]};
    itemsData[@(BSMenuItemFeedback)] = itemData;
    
    itemData = @{kBMWMenuItemTitle: NSLocalizedString(@"L_Settings", @"menu item title"),
                 kBMWMenuItemImage: [UIImage imageNamed:@"tools"]};
    itemsData[@(BSMenuItemSettings)] = itemData;
    
    self.menuItemsData = itemsData;
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
    
    BSMenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:kBMWMenuCell forIndexPath:indexPath];
    
    [menuCell.titleLabel setText:menuItemData[kBMWMenuItemTitle]];
    [menuCell.iconIV setImage:menuItemData[kBMWMenuItemImage]];


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
        case BSMenuItemSettings:
        {
            NSDictionary *itemData = self.menuItemsData[@(menuItem)];
            rootVC = [[[itemData objectForKey:kBMWMenuItemClass] alloc] init];
            break;
        }
        default:
            //            rootVC = [[BMWActionsVC alloc] init];
            break;
    }
    if (rootVC) {
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:rootVC withCompletion:nil];
    } else {
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
    }
}


@end
