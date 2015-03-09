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
@property (strong, nonatomic) NSString *initialGroupNumber;
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

- (void)showVCForGroupNumber:(NSString *)groupNumber {
    self.initialGroupNumber = groupNumber;
    NSIndexPath *groupIndexPath = [(BSMenuVC*)self.leftMenu indexPathForGroupNumber:groupNumber];
    [(BSMenuVC*)self.leftMenu openVCAtIndexPath:groupIndexPath];
}

- (NSIndexPath *)initialIndexPathForLeftMenu {
    NSIndexPath *initialIndexPath = [(BSMenuVC*)self.leftMenu indexPathForGroupNumber:self.initialGroupNumber];
    if (!initialIndexPath) {
        initialIndexPath = [(BSMenuVC*)self.leftMenu settingsIndexPath];
    }
    return initialIndexPath;
}

- (void) configureSlideLayer:(CALayer *)layer
{
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.4;
    layer.shadowRadius = 20.0;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.masksToBounds = NO;
    layer.shadowPath =[UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
}

@end
