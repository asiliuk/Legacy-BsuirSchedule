//
//  BSSettingsVC.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 20.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSSettingsVC.h"
#import "BSDataManager.h"
#import "BSConstants.h"

@interface BSSettingsVC ()
@property (strong, nonatomic) IBOutlet UIView *centerView;
@property (strong, nonatomic) IBOutlet UIView *blackBack;
@property (strong, nonatomic) IBOutlet UITextField *groupNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *subgroupNumberTF;

@property (nonatomic) BOOL dataChanged;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@end

@implementation BSSettingsVC

- (instancetype)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        self.dataChanged = NO;
    }
    return self;
}

#define BORDER_WIDTH 2.0
#define CORNER_RADIUS 5.0
- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupNumberTF.layer.borderWidth = BORDER_WIDTH;
    self.groupNumberTF.layer.cornerRadius = CORNER_RADIUS;
    self.groupNumberTF.layer.borderColor = BS_LIGHT_BLUE.CGColor;
    
    self.subgroupNumberTF.layer.borderWidth = BORDER_WIDTH;
    self.subgroupNumberTF.layer.cornerRadius = BORDER_WIDTH;
    self.subgroupNumberTF.layer.borderColor = BS_LIGHT_BLUE.CGColor;
    
    [self.groupNumberTF setText:[[NSUserDefaults standardUserDefaults] objectForKey:kUserGroup]];
    [self.subgroupNumberTF setText:[[NSUserDefaults standardUserDefaults] objectForKey:kUserSubgroup]];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showCenterView];
}


#define ANIMATION_DURATION_SHOW 0.4

- (void)showCenterView {
    self.centerView.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    CGRect centerViewFrame = self.centerView.frame;
    centerViewFrame.origin.y = CGRectGetMaxY(self.view.frame);
    self.centerView.frame = centerViewFrame;
    self.blackBack.alpha = 0.0;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:ANIMATION_DURATION_SHOW delay:0.0 usingSpringWithDamping:1.2 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        typeof(weakSelf) self = weakSelf;
        self.blackBack.alpha = 0.5;
        self.centerView.center = self.view.center;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissWithChanges:(BOOL)changes {
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;

    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[self.centerView] mode:UIPushBehaviorModeInstantaneous];
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.centerView]];
    UIDynamicItemBehavior *di = [[UIDynamicItemBehavior alloc] initWithItems:@[self.centerView]];
    di.action =  ^{
        typeof(weakSelf) self = weakSelf;
        if (CGRectGetMinY(self.centerView.frame) >= CGRectGetMaxY(self.view.bounds)) {
            [self.delegate settingsScreen:self dismissWithChanges:changes];
            [self dismissViewControllerAnimated:NO completion:nil];
        } else {
            self.blackBack.alpha = 1 - CGRectGetMidY(self.centerView.frame) / CGRectGetHeight(self.view.frame);
        }
    };

    [push setAngle:((changes) ? 0 : M_PI) magnitude:30.0];
    gravity.magnitude = 10.0;
    [di addAngularVelocity:((changes) ? 1 : -1)*5 forItem:self.centerView];

    [self.animator addBehavior:di];
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:push];

}

- (void)shakeView:(UIView*)view amplitude:(CGPoint)amplitude {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.07];
    [animation setRepeatCount:3];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([view center].x - amplitude.x, [view center].y - amplitude.y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([view center].x + amplitude.x, [view center].y + amplitude.y)]];
    [[view layer] addAnimation:animation forKey:@"position"];
    
    CABasicAnimation *colorAnimation = [CABasicAnimation
                                        animationWithKeyPath:@"backgroundColor"];
    colorAnimation.duration = 0.3;
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
    colorAnimation.fromValue = (id)[UIColor whiteColor].CGColor;
    colorAnimation.toValue = (id)BS_LIGHT_BLUE.CGColor;
    colorAnimation.autoreverses = YES;
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [[view layer] addAnimation:colorAnimation forKey:@"backgroundColor"];
}

//===============================================ACTIONS===========================================
#pragma mark - Actions

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.subgroupNumberTF) {
        [theTextField resignFirstResponder];
    } else if (theTextField == self.groupNumberTF) {
        [self.subgroupNumberTF becomeFirstResponder];
    }
    return YES;
}

- (IBAction)dismissPressed:(id)sender {
    [self dismissWithChanges:NO];
}
- (IBAction)okPressed:(id)sender {
    if ([self.groupNumberTF.text isEqual:@""]) {
        [self shakeView:self.groupNumberTF amplitude:CGPointMake(10, 0)];
    } else if ([self.subgroupNumberTF.text isEqual:@""]) {
        [self shakeView:self.subgroupNumberTF amplitude:CGPointMake(10, 0)];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.groupNumberTF.text forKey:kUserGroup];
        [[NSUserDefaults standardUserDefaults] setObject:self.subgroupNumberTF.text forKey:kUserSubgroup];
        [self dismissWithChanges:self.dataChanged];
    }
}

- (IBAction)editingChanged:(id)sender {
    self.dataChanged = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


//===============================================KEYBOARD===========================================
#pragma mark - Keyboard
#define OFFSET 30.0

- (void)keyboardWillShow:(NSNotification*)notification {
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardAnimationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect intersection = CGRectIntersection(self.centerView.frame, keyboardFrame);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        typeof(weakSelf) self = weakSelf;
        CGRect centerViewFrame = self.centerView.frame;
        centerViewFrame.origin.y -= (intersection.size.height + OFFSET);
        self.centerView.frame = centerViewFrame;
    }];
    
}
- (void)keyboardWillHide:(NSNotification*)notification {
    CGFloat keyboardAnimationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        weakSelf.centerView.center = self.view.center;
    }];
}

@end
