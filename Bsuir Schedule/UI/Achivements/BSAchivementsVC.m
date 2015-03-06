//
//  BSAchivementsVC.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 06.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivementsVC.h"
#import "BSAchivementsDnDS.h"
#import "BSAchivementManager.h"
#import "BSAchivementCell.h"

#import "BSConstants.h"
#import "BSUtils.h"

#import <Parse/Parse.h>
#import "UIViewController+Achivements.h"

@interface BSAchivementsVC () <SKPaymentTransactionObserver>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BSAchivementsDnDS *achivementsDnDS;
@property (strong, nonatomic) UIView *loadindicatorView;
@end

@implementation BSAchivementsVC

- (instancetype)init {
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LZD(@"L_Achivements");
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSAchivementCell class]) bundle:nil] forCellReuseIdentifier:kAchivementCellID];
    self.achivementsDnDS = [[BSAchivementsDnDS alloc] initWithAchivements:[[BSAchivementManager sharedInstance] achivements]];
    self.tableView.delegate = self.achivementsDnDS;
    self.tableView.dataSource = self.achivementsDnDS;
    [self registerPurchasesLogic];
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

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
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
    }
    return _loadindicatorView;
}


@end
