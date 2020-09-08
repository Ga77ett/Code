//
//  KBLProductCardModel.m
//  Korablik
//
//  Created by Kirill Shalankin on 08/09/2017.
//  Copyright © 2017 Kirill Shalankin. All rights reserved.
//

#import "KBLProductCardModel.h"

@implementation KBLProductCardModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _videoURLs = [@[] mutableCopy];
    }
    return self;
}

@end
