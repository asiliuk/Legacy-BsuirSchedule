//
//  UIViewController+Presentation.h
//  futchi demo
//
//  Created by Anton Siliuk on 04.03.15.
//  Copyright (c) 2015 SOFTEQ Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Presentation)
- (void)presentVCInCurrentContext:(UIViewController*)vc animated:(BOOL)animated;
@end
