//
//  BSAchivement.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 05.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BSAchivement : NSObject
@property (readonly, nonatomic) NSString *achivementKey;
@property (readonly, nonatomic) NSString *imageName;

@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *achivementDescription;

@property (readonly, nonatomic) BOOL unlocked;

- (instancetype)initWithName:(NSString*)name
                 description:(NSString*)description
                   imageName:(NSString*)imageName
               achivementKey:(NSString*)achivementKey;

- (UIImage*)image;
- (BOOL)trigger;
- (BOOL)unlocked;
@end
