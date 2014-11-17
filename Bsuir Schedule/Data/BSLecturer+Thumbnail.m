//
//  BSLecturer+Thumbnail.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 18.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSLecturer+Thumbnail.h"
#import "NSString+Transiterate.h"

@implementation BSLecturer (Thumbnail)
- (UIImage*)thumbnail {
    NSString *thumbName = [NSString stringWithFormat:@"%@_%@_%@", self.lastName, self.firstName, self.middleName];
    NSLog(@"%@", [thumbName toLatinWithDictionary]); // outputs "russkij âzyk"
    return [UIImage imageNamed:[thumbName toLatinWithDictionary]];
}
@end
