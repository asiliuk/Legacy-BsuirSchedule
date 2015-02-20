//
//  BSLecturer+Thumbnail.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 18.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSLecturer+Thumbnail.h"
#import "NSString+Transiterate.h"
#import "NSUserDefaults+Share.h"
#import "BSConstants.h"

static NSString * const kNoavatar = @"noavatar";

@implementation BSLecturer (Thumbnail)
- (UIImage*)thumbnail {
    UIImage *thumbnail;
    if (![[NSUserDefaults sharedDefaults] boolForKey:kEasterEggMode]) {
        NSString *thumbName = [NSString stringWithFormat:@"%@_%@_%@.jpg", self.lastName, self.firstName, self.middleName];
        thumbnail = [UIImage imageNamed:[thumbName toLatinWithDictionary]];
        if (!thumbnail) {
            thumbnail = [UIImage imageNamed:kNoavatar];
        }
    } else {
        thumbnail = [UIImage imageNamed:@"my_face.jpg"];
    }
    return thumbnail;
}
@end
