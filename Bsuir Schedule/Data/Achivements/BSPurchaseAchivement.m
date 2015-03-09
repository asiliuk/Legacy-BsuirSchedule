//
//  BSPurchaseAchivement.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 08.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSPurchaseAchivement.h"

@implementation BSPurchaseAchivement

- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
                   imageName:(NSString *)imageName
               achivementKey:(NSString *)achivementKey
                   purchaseID:(NSString *)purchaseID
{
    self = [super initWithName:name description:description imageName:imageName achivementKey:achivementKey];
    if (self) {
        _purchaseID = purchaseID;
    }
    return self;
}
@end
