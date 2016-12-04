//
//  GameScene16.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 25.06.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "GameScene16.h"
#import "GameSceneUI.h"
#import "Booster.h"

@implementation GameScene16

- (id)initWithSize:(CGSize)size withFile:(NSString *)file {
    if (self = [super initWithSize:(CGSize)size withFile:(NSString *)file]) {
        
        //        центрирую картинку
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.background =[SKSpriteNode spriteNodeWithImageNamed:@"background01"];
        [super unlockBoostersWithLevel:self.currentLevel];
    }
    return self;
}

-(void)setLevelScoreLabels
{
    [super setLevelScoreLabels];
    
    self.levelLabel.text = @"Level 16";
    self.currentLevel = 16;
}

@end
