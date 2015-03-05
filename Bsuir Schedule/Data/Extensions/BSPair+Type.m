//
//  BSPair+Type.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 19.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSPair+Type.h"

@implementation BSPair (Type)
- (NSString*)pairTypeName {
    NSString *pairTypeName;
    PairType pairType = (PairType)[self.pairType integerValue];
    switch (pairType) {
        case BSPairTypeLaboratory:
            pairTypeName = @"ЛР";
            break;
        case BSPairTypeLecture:
            pairTypeName = @"ЛК";
            break;
        case BSPairTypePractical:
            pairTypeName = @"ПЗ";
            break;
        default:
            pairTypeName = @"Неизвестно";
            break;
    }
    return pairTypeName;
}

+ (PairType)pairTypeWithName:(NSString *)pairTypeName
{
    PairType pairType = BSPairTypeUnknown;
    if ([pairTypeName isEqualToString:@"ЛК"]) {
        pairType = BSPairTypeLecture;
    } else if ([pairTypeName isEqualToString:@"ПЗ"]) {
        pairType = BSPairTypePractical;
    } else if ([pairTypeName isEqualToString:@"ЛР"]) {
        pairType = BSPairTypeLaboratory;
    }
    return pairType;
}

- (void)setPairTypeWithName:(NSString *)pairTypeName {
    self.pairType = @([BSPair pairTypeWithName:pairTypeName]);
}
@end
