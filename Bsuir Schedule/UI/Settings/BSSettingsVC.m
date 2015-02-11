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
#import "BSGroupAddVC.h"
#import "AppDelegate.h"

@interface BSSettingsVC () <UITableViewDataSource,  UITableViewDelegate, BSGroupAddVCDelegate>
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
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                      target:self
                                                                                      action:@selector(addGroup)];
    addBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
//    [self.groupNumberTF setText:[sharedDefaults objectForKey:kUserGroup]];
//    [self.subgroupNumberTF setText:[sharedDefaults objectForKey:kUserSubgroup]];
}
- (void)addGroup {
    BSGroupAddVC *groupAddVC = [[BSGroupAddVC alloc] init];
    groupAddVC.delegate = self;
    AppDelegate *delegate =  [UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController:groupAddVC animated:NO completion:nil];

}

//===============================================GROUP ADD DELEGATE===========================================
#pragma mark - Group add delegate

- (void)groupAddingScreen:(BSGroupAddVC *)groupAddVC dismissWithGroupNumber:(NSString *)group andSubgroup:(NSString *)subgroup {
    
}

//===============================================TABLE VIEW===========================================
#pragma mark - Table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu;
{
    return YES;
}


@end
