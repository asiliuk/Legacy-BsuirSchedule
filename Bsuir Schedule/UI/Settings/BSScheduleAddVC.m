//
//  BSScheduleAddVC.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 12.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSScheduleAddVC.h"
#import "BSConstants.h"
@interface BSScheduleAddVC ()
@property (weak, nonatomic) IBOutlet UITextField *groupNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *subgroupTF;

@end

@implementation BSScheduleAddVC

- (instancetype)init {
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LZD(@"L_AddGroup");
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                      target:self
                                                                                      action:@selector(save)];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        addBarButtonItem.tintColor = [UIColor whiteColor];
    } else {
        addBarButtonItem.tintColor = BS_BLUE;
    }
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    [self customizeSlideNavigationController:self.navigationController];
}

- (void)customizeSlideNavigationController:(UINavigationController*)slideNavController {
    
    slideNavController.navigationBar.barStyle = UIBarStyleBlack;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [slideNavController.navigationBar setBarTintColor:BS_BLUE];
    } else {
        slideNavController.navigationBar.tintColor = BS_BLUE;
    }
    UIFont *titleFont = [UIFont fontWithName:@"OpenSans" size:20.0f];
    [slideNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                               NSFontAttributeName: titleFont}];
}

- (void)save {
    NSString *groupNumber = self.groupNumberTF.text;
    NSString* subgroup = self.subgroupTF.text;
    if (groupNumber && ![groupNumber isEqual:@""]) {
        if (subgroup && ![subgroup isEqual:@""]) {
            [self.delegate scheduleAddVC:self saveGroupWithGroupNumber:groupNumber subgroupNumber:[subgroup integerValue]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self shakeView:self.subgroupTF amplitude:CGPointMake(10.0, 0)];
        }
    } else {
        [self shakeView:self.groupNumberTF amplitude:CGPointMake(10.0, 0)];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
