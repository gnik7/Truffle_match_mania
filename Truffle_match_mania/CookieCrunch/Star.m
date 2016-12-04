//
//  Star.m
//  CookieCrunch
//
//  Created by Кирилл on 28.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "Star.h"
#import "Settings.h"
#import "ScaleUIonDevice.h"

@implementation Star {
    NSString * _name;
}

- (id)initWithImageNamed:(NSString *)name {
    if (self = [super initWithImageNamed:name]) {
        self.isActivated = NO;
        NSArray * newName = [name componentsSeparatedByString:@"1"];
        [self makeAnimationWithName:[newName firstObject]];
        newName = nil;
    }
    return self;
}

- (void)makeAnimationWithName:(NSString *)name {
    NSMutableArray * stars = [NSMutableArray new];
    SKAction * scaleToHalf = [SKAction scaleTo:0.5 duration:0.2];
    SKAction * scaleToNormal = [SKAction scaleTo:1 duration:0.2];
    for (int i = 1; i <= SCORE_BAR_STARS_AMOUNT; i++) {
        NSString * textureName = [NSString stringWithFormat:@"%@%d", name, i];
        SKSpriteNode * texture = [SKSpriteNode spriteNodeWithImageNamed:textureName];
        texture.size = CGSizeMake(texture.size.width *[[[ScaleUIonDevice scaleForScoreLine] objectAtIndex:1] floatValue], texture.size.height *[[[ScaleUIonDevice scaleForScoreLine] objectAtIndex:1] floatValue]);
        [stars addObject:texture];
    }
    SKAction * addSecondSprite = [SKAction runBlock:^{
        [self removeAllChildren];
        [self addChild:[stars objectAtIndex:1]];
    }];
    SKAction * addThirdSprite = [SKAction runBlock:^{
        [[stars objectAtIndex:1] removeFromParent];
        [self addChild:[stars objectAtIndex:2]];
    }];
    self.animation = [SKAction sequence:@[scaleToHalf, addSecondSprite, scaleToNormal, addThirdSprite]];
    stars = nil;
    name = nil;
}

@end
