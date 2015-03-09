//
//  BSAchivement.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 05.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivement.h"
#import "FXKeychain.h"

@implementation BSAchivement
@dynamic unlocked;

- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
                   imageName:(NSString *)imageName
               achivementKey:(NSString *)achivementKey {
    self = [super init];
    if (self) {
        _name = name;
        _achivementDescription = description;
        _imageName = imageName;
        _achivementKey = achivementKey;
    }
    return self;
}

static NSString * const contourPostfix = @"_contour";
- (UIImage*)image {
    NSString *imageName = self.imageName;
    if (!self.unlocked) {
        imageName = [imageName stringByAppendingString:contourPostfix];
    }
    return [UIImage imageNamed:imageName];
}
- (BOOL)trigger {
    return NO;
}
- (BOOL)unlocked {
    return NO;
}

@end
