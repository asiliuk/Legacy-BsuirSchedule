//
//  BSUtils.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 12.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSUtils.h"

@implementation BSUtils

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message inVC:(UIViewController*)vc {
    
    NSString *okButtonTitle = NSLocalizedString(@"L_Ok", nil);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                         message:message
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertVC addAction:okAction];
        [vc presentViewController:alertVC animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:okButtonTitle otherButtonTitles: nil];
        [alert show];
    }
}
@end
