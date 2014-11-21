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
    NSString *thumbName = [NSString stringWithFormat:@"%@_%@_%@.jpg", self.lastName, self.firstName, self.middleName];
    return [UIImage imageNamed:[thumbName toLatinWithDictionary]];
}
@end
