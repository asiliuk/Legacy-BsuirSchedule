//
//  BSAchivementsVC.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 06.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivementsVC.h"
#import "BSAchivementManager.h"

#import "BSAchivementCell.h"
#import "BSSocialAchivementCell.h"
#import "BSPurchaseAchivementCell.h"

#import "BSAchivement.h"
#import "BSSocialAchivement.h"
#import "BSPurchaseAchivement.h"

#import "BSConstants.h"
#import "BSUtils.h"

#import <Parse/Parse.h>
#import "UIViewController+Achivements.h"

@import Twitter;
@import MessageUI;

@interface BSAchivementsVC () <SKPaymentTransactionObserver, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate,
BSSocialAchivementCellDelegate, BSPurchaseAchivementCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *achivements;
@property (strong, nonatomic) UIView *loadindicatorView;
@end

@implementation BSAchivementsVC

- (instancetype)init {
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LZD(@"L_Achivements");
    
    self.achivements = [[BSAchivementManager sharedInstance] achivements];
    
    [self.navigationController.view addSubview:self.loadindicatorView];
    self.loadindicatorView.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSAchivementCell class]) bundle:nil]
         forCellReuseIdentifier:kAchivementCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSSocialAchivementCell class]) bundle:nil]
         forCellReuseIdentifier:kSocialAchivementCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSPurchaseAchivementCell class]) bundle:nil]
         forCellReuseIdentifier:kPurchaseAchivementCellID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(achivementUnlocked) name:kAchivementUnlocked object:nil];
    
    [self registerPurchasesLogic];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LZD(@"L_Restore")
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(restorePurchases)];
}

- (void)achivementUnlocked {
    [self.tableView reloadData];
}

//===============================================PURCHASES===========================================
#pragma mark - TransactionsDeleagte
- (void)registerPurchasesLogic {
    [PFPurchase addObserverForProduct:kSupporterAchivementID block:^(SKPaymentTransaction *transaction) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [self triggerAchivementWithType:BSAchivementTypeSupporter];
        } else if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            [[BSAchivementManager sharedInstance] triggerAchivementWithType:BSAchivementTypeSupporter];
        }
    }];
    [PFPurchase addObserverForProduct:kSuperSupporterAchivementID block:^(SKPaymentTransaction *transaction) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
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
    [BSUtils showAlertWithTitle:LZD(@"L_PurchaseRestore") message:LZD(@"L_PurchaseRestoreSuccess") inVC:self];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    [self hideLoadingView];
    [BSUtils showAlertWithTitle:LZD(@"L_Error") message:[LZD(@"L_PurchaseRestoreError") stringByAppendingString:error.localizedDescription] inVC:self];
    
}

//===============================================TABLE VIEW===========================================
#pragma mark - TableView

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.achivements count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSAchivementCell *cell;
    BSAchivement *achivement = [self.achivements objectAtIndex:indexPath.row];
    if ([achivement isKindOfClass:[BSSocialAchivement class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kSocialAchivementCellID forIndexPath:indexPath];
        [(BSSocialAchivementCell*)cell setDelegate:self];
    } else if ([achivement isKindOfClass:[BSPurchaseAchivement class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kPurchaseAchivementCellID forIndexPath:indexPath];
        [(BSPurchaseAchivementCell*)cell setDelegate:self];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kAchivementCellID forIndexPath:indexPath];
    }
    [cell setupWithAchivement:achivement];
    return cell;
}
static CGFloat const achivementCellHeight = 140.0f;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return achivementCellHeight;
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

//===============================================PURCHASE CELL DELEGATE===========================================
#pragma mark - Purchase Cell delegate

- (void)purchaseAchivementCellBuyPressed:(BSPurchaseAchivementCell *)cell {
    [self showLoadingView];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BSPurchaseAchivement *achivement = [self.achivements objectAtIndex:indexPath.row];
    __weak typeof(self) weakself = self;
    [PFPurchase buyProduct:achivement.purchaseID block:^(NSError *error) {
        [weakself hideLoadingView];
    }];
}

//===============================================SOCIAL CELL DELEGATE===========================================
#pragma mark - Social Cell delegate

- (void)socialAchivementCellDidPressEmail:(BSSocialAchivementCell *)cell {
    [self showLoadingView];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BSAchivement *achivement = [self.achivements objectAtIndex:indexPath.row];
    [self showMailScreenForAchivement:achivement];
}
- (void)socialAchivementCellDidPressFacebook:(BSSocialAchivementCell *)cell {
    [self showLoadingView];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BSAchivement *achivement = [self.achivements objectAtIndex:indexPath.row];
    [self showShareScreenWithType:SLServiceTypeFacebook forAchivement:achivement];
}
- (void)socialAchivementCellDidPressTwitter:(BSSocialAchivementCell *)cell {
    [self showLoadingView];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BSAchivement *achivement = [self.achivements objectAtIndex:indexPath.row];
    [self showShareScreenWithType:SLServiceTypeTwitter forAchivement:achivement];
}
//===============================================SOCIAL===========================================
#pragma mark - Social

- (void)showShareScreenWithType:(NSString*)type forAchivement:(BSAchivement*)achivement {
    if ([SLComposeViewController isAvailableForServiceType:type]) {
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:type];
        __weak typeof(self) weakself = self;
        vc.completionHandler = ^(SLComposeViewControllerResult result) {
            [weakself hideLoadingView];
            if (result == SLComposeViewControllerResultDone) {
                [weakself dismissViewControllerAnimated:YES completion:^{
                    [weakself triggerAchivementWithType:BSAchivementTypeSocial];
                }];
            }
        };
        UIImage *appIcon = [UIImage imageNamed:@"bsuir_icon.jpg"];

        [vc addImage:appIcon];
        [vc setInitialText:[(BSSocialAchivement*)achivement shareText]];
        [vc addURL:[NSURL URLWithString:kAppURL]];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        [BSUtils showAlertWithTitle:LZD(@"L_Error") message:LZD(@"L_NoAvailable") inVC:self];
    }
}


//===============================================MAIL===========================================
#pragma mark - Mail
- (void)showMailScreenForAchivement:(BSAchivement*)achivement {
    UIViewController *rootVC = self;
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@"Bsuir Schedule"];
        NSString *message = [NSString stringWithFormat:@"%@ %@",[(BSSocialAchivement*)achivement shareText], kAppURL];
        [mailCont setMessageBody:message isHTML:NO];
        [rootVC presentViewController:mailCont animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        }];
    } else {
        [BSUtils showAlertWithTitle:LZD(@"L_Error") message:LZD(@"L_NoAvailable") inVC:rootVC];
    }
}


// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self hideLoadingView];
    __weak typeof(self) weakself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSent) {
            [weakself triggerAchivementWithType:BSAchivementTypeSocial];
        }
    }];
}


@end
