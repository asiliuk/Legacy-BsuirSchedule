//
//  UIViewController+Presentation.m
//  futchi demo
//
//  Created by Anton Siliuk on 04.03.15.
//  Copyright (c) 2015 SOFTEQ Development. All rights reserved.
//

#import "UIViewController+Presentation.h"
#import "BSConstants.h"

@implementation UIViewController (Presentation)

- (void)presentVCInCurrentContext:(UIViewController*)vc animated:(BOOL)animated {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    } else {
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [self presentViewController:vc animated:animated completion:nil];
}

@end
