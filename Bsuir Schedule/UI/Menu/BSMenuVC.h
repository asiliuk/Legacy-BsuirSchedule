//
//  BMWMenuVC.h
//  BMW club
//
//  Created by Anton Siliuk on 11.12.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSlideMenuLeftTableViewController.h"
#import "AMSlideMenuMainViewController.h"

typedef NS_ENUM(NSInteger, BSMenuItem) {
    BSMenuItemFeedback       = 1,
    BSMenuItemSettings       = 2,
    BSMenuItemInfo           = 3,
    BSMenuItemSchedule       = 4,
    
};

extern NSString * const kBSMenuItemType;
extern NSString * const kBSMenuItemTitle;
extern NSString * const kBSMenuItemImage;
extern NSString * const kBSMenuItemBadgeCount;
extern NSString * const kBSMenuItemClass;
extern NSString * const kBSMenuItemSchedule;
extern NSString * const kBSMenuCell;

@interface BSMenuVC : AMSlideMenuLeftTableViewController
@property (strong, nonatomic) NSArray *menuItems;

- (NSIndexPath*)indexPathForGroupNumber:(NSString*)groupNumber;
- (NSIndexPath*)settingsIndexPath;
- (void)openVCAtIndexPath:(NSIndexPath*)indexPath;
@end
