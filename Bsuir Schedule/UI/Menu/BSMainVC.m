//
//  BSMainVC.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 28.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSMainVC.h"
#import "BSMenuVC.h"

#import "BSScheduleVC.h"
#import "BSSettingsVC.h"

#import "BSDataManager.h"
@interface BSMainVC ()

@end

@implementation BSMainVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    /*******************************
     *     Initializing menus
     *******************************/
    self.leftMenu = [[BSMenuVC alloc] init];
    /*******************************
     *     End Initializing menus
     *******************************/
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Overriding methods
- (void)configureLeftMenuButton:(UIButton *)button
{
    // Creating a custom bar button for right menu
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"menu_burger"] forState:UIControlStateNormal];
}

- (CGFloat)leftMenuWidth {
    return 270.0f;
}

- (NSIndexPath *)initialIndexPathForLeftMenu {
    NSInteger row = 0;
    NSArray *menuItems = [(BSMenuVC*)self.leftMenu menuItems];
    for (NSDictionary *menuItem in menuItems) {
        NSInteger menuItemType = [menuItem[kBSMenuItemType] integerValue];
        if (menuItemType == BSMenuItemSchedule || menuItemType == BSMenuItemSettings) {
            row = [menuItems indexOfObject:menuItem];
            break;
        }
    }
    return [NSIndexPath indexPathForRow:row inSection:0];
}

- (void)configureSlideLayer:(CALayer *)layer {
    
}

@end
