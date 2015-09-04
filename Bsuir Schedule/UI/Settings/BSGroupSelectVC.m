//
//  BSGroupSelectVC.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSGroupSelectVC.h"

#import "BSScheduleParser.h"
#import "BSUtils.h"
#import "BSConstants.h"

@interface BSGroupSelectVC () <UITableViewDelegate, UITableViewDataSource, BSScheduleAddVCDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) UIView *loadindicatorView;
@end

@implementation BSGroupSelectVC

- (instancetype)init {
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.navigationController.view addSubview:self.loadindicatorView];

    self.title = LZD(@"L_AvailableGroups");
    [self showLoadingView];
    [BSScheduleParser allGroupsWithSuccess:^(NSArray *groups) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingView];
            NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:kGroupName ascending:YES];
            self.groups = [groups sortedArrayUsingDescriptors:@[sort]];
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingView];
            [BSUtils showAlertWithTitle:LZD(@"L_Error") message:error.localizedDescription inVC:self];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (UIView*)loadindicatorView {
    if (!_loadindicatorView) {
        _loadindicatorView = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
        _loadindicatorView.backgroundColor = [UIColor blackColor];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center = CGPointMake(_loadindicatorView.bounds.size.width / 2.0, _loadindicatorView.bounds.size.height / 2.0);
        [_loadindicatorView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        _loadindicatorView.hidden = YES;
    }
    return _loadindicatorView;
}

//===============================================TABLE VIEW===========================================
#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.groups count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:17];
    NSDictionary *groupData = [self.groups objectAtIndex:indexPath.row];
    cell.textLabel.text = groupData[kGroupName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *groupData = [self.groups objectAtIndex:indexPath.row];
    
    BSScheduleAddVC *scheduleAddVC = [[BSScheduleAddVC alloc] initWithGroupName:groupData[kGroupName] delehate:self];
    [self.navigationController pushViewController:scheduleAddVC animated:YES];
}

//===============================================DELEGATE===========================================
#pragma mark - Delegate

- (void)scheduleAddVC:(BSScheduleAddVC *)scheduleAddVC saveGroupWithGroupNumber:(NSString *)groupNumber subgroupNumber:(NSInteger)subgroupNumber {
    [self.delegate scheduleAddVC:scheduleAddVC saveGroupWithGroupNumber:groupNumber subgroupNumber:subgroupNumber];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
