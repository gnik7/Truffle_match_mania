//
//  GameScene2.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 14.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "GameScene3.h"
#import "GameSceneUI.h"
#import "Booster.h"

@implementation GameScene3

- (id)initWithSize:(CGSize)size withFile:(NSString *)file {
    if (self = [super initWithSize:(CGSize)size withFile:(NSString *)file]) {
        
        //        центрирую картинку
        self.anchorPoint = CGPointMake(0.5, 0.5);
        [self.background removeFromParent];
        self.background =[SKSpriteNode spriteNodeWithImageNamed:@"background03"];
        self.background.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        self.background.zPosition = 1;
        [self addChild:self.background];
        [super unlockBoostersWithLevel:self.currentLevel];
    }
    return self;
}

-(void)setLevelScoreLabels
{
    [super setLevelScoreLabels];
    
    self.levelLabel.text = @"Level 3";
    self.currentLevel = 3;
}

@end
