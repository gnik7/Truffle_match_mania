//
//  Tile.m
//  CookieCrunch
//
//  Created by Кирилл on 04.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "Tile.h"

@implementation Tile

- (id)initWithBlock {
    if (self = [super init]) {
        _withBlock = YES;
    }
    return self;
}

@end
