//
//  BSAchivementVC.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 05.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivementUnlockedVC.h"
#import "UIView+Screenshot.h"
#import "BSConstants.h"

@interface BSAchivementUnlockedVC ()
@property (weak, nonatomic) IBOutlet UIImageView *achivementImage;
@property (weak, nonatomic) IBOutlet UILabel *achivementNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *achivementUnlockedLabel;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (weak, nonatomic) IBOutlet UIImageView *backIV;
@property (weak, nonatomic) IBOutlet UIView *centerView;

@property (strong, nonatomic) BSAchivement *achivement;
@end

@implementation BSAchivementUnlockedVC

- (instancetype)initWithAchivement:(BSAchivement*)achivement {
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.achivement = achivement;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.achivementImage setImage:[self.achivement image]];
    [self.achivementNameLabel setText:self.achivement.name];
    
    self.centerView.layer.masksToBounds = NO;
    self.centerView.layer.cornerRadius = 5.0;
    
    self.okBtn.layer.masksToBounds = NO;
    self.okBtn.layer.cornerRadius = 5.0;
    
    [self.achivementUnlockedLabel setText:LZD(@"L_AchivementUnlocked")];
    [self.okBtn setTitle:LZD(@"L_Ok") forState:UIControlStateNormal];
    [self.okBtn setTitle:LZD(@"L_Ok") forState:UIControlStateNormal | UIControlStateHighlighted];
    
}


#define DEFAULT_ANIMATION_DURATION 0.4


- (void)viewDidAppear:(BOOL)animated {
    
    self.backIV.image = [[[UIApplication sharedApplication] keyWindow] bluredScreenshot];
    self.backIV.alpha = 0.0;
    [self replaceCenterConstraintOnView:self.centerView withConstant:-self.view.bounds.size.height/2.0];

    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
        typeof(weakself) self = weakself;
        [self.view layoutIfNeeded];
        self.backIV.alpha = 1.0;
    }];
    [super viewDidAppear:animated];
}

- (void)replaceCenterConstraintOnView:(UIView *)view withConstant:(float)constant
{
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((constraint.secondItem == view) && (constraint.secondAttribute == NSLayoutAttributeCenterY)) {
            constraint.constant = constant;
        }
    }];
}



- (IBAction)dismiss:(id)sender {
    [self replaceCenterConstraintOnView:self.centerView withConstant:self.centerView.bounds.size.height / 2.0];
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
        typeof(weakself) self = weakself;
        [self.view layoutIfNeeded];
        self.backIV.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakself dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
