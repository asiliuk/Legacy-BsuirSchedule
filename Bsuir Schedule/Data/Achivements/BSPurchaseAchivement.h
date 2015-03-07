//
//  BSPurchaseAchivement.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 08.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivementOnce.h"

@interface BSPurchaseAchivement : BSAchivementOnce
@property (strong, nonatomic, readonly) NSString *purchaseID;
- (instancetype)initWithName:(NSString*)name
                 description:(NSString*)description
                   imageName:(NSString*)imageName
               achivementKey:(NSString*)achivementKey
                  purchaseID:(NSString*)purchaseID;
@end
