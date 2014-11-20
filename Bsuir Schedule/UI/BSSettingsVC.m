//
//  BSSettingsVC.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 20.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSSettingsVC.h"
#import "BSDataManager.h"
#import "BSColors.h"

@interface BSSettingsVC ()
@property (strong, nonatomic) IBOutlet UIView *centerView;
@property (strong, nonatomic) IBOutlet UIView *blackBack;
@property (strong, nonatomic) IBOutlet UITextField *groupNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *subgroupNumberTF;

@end

@implementation BSSettingsVC

- (instancetype)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

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
#define ANIMATION_DURATION_HIDE 1.2

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
    [UIView animateWithDuration:ANIMATION_DURATION_HIDE delay:0.0 usingSpringWithDamping:1.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        typeof(weakSelf) self = weakSelf;
        CGAffineTransform rotate = CGAffineTransformMakeRotation(((changes) ? 1 : -1)*M_PI/3.0);
        CGFloat moveX = ((changes) ? 1 : -1)*self.centerView.frame.size.height;
        CGFloat moveY = CGRectGetMaxY(self.view.frame) + self.centerView.frame.size.width/2.0 - self.centerView.frame.origin.y;
        CGAffineTransform move = CGAffineTransformMakeTranslation(moveX, moveY);
        self.centerView.transform = CGAffineTransformConcat(rotate, move);
        self.blackBack.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
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
        [self dismissWithChanges:YES];
    }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
