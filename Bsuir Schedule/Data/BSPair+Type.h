//
//  BSPair+Type.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 19.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSPair.h"

typedef enum {
    BSPairTypePractical,
    BSPairTypeLaboratory,
    BSPairTypeLecture,
    BSPairTypeUnknown
}PairType;

@interface BSPair (Type)
- (NSString*)pairTypeName;
+ (PairType)pairTypeWithName:(NSString *)pairTypeName;
- (void)setPairTypeWithName:(NSString*)pairTypeName;
@end
