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

@interface BSSettingsVC ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSUserDefaults *sharedDefaults;
@end

@implementation BSSettingsVC

- (instancetype)init
{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

#define BORDER_WIDTH 2.0
#define CORNER_RADIUS 5.0
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedDefaults = [NSUserDefaults sharedDefaults];
//    [self.groupNumberTF setText:[sharedDefaults objectForKey:kUserGroup]];
//    [self.subgroupNumberTF setText:[sharedDefaults objectForKey:kUserSubgroup]];
}


@end
