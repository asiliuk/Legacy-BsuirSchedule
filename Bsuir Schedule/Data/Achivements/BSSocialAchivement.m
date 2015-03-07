//
//  BSSocialAchivement.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 06.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSSocialAchivement.h"

@implementation BSSocialAchivement
- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
                   imageName:(NSString *)imageName
               achivementKey:(NSString *)achivementKey
                   shareText:(NSString *)shareText
{
    self = [super initWithName:name description:description imageName:imageName achivementKey:achivementKey];
    if (self) {
        _shareText = shareText;
    }
    return self;
}

@end
