//
//  Cookie.m
//  CookieCrunch
//
//  Created by Кирилл on 04.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "Character.h"

@implementation Character

- (NSString *)spriteName {
    static NSString * const spriteNames[] = {
        //blue - 1 type, green - 2 type...
        @"blue",
        @"green",
        @"pink",
        @"purple",
        @"red",
        @"yellow",
        @"anchor",
    };
    
    return spriteNames[self.characterType - 1];
}

- (NSArray *)spriteNames {
    NSArray * spriteNameArray = @[@"blue", @"green", @"pink", @"purple", @"red", @"yellow"];
    return spriteNameArray;
}

- (void)setBonusType:(BonusType)bonusType {
    _bonusType = bonusType;
}

- (BonusType)getBonusType {
    return _bonusType;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"type:%ld square:(%ld, %ld)",
            (long)self.characterType,
            (long)self.column,
            (long)self.row];
}

@end
