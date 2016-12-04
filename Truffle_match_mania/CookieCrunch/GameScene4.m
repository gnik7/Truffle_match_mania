//
//  GameScene4.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 25.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "GameScene4.h"
#import "Booster.h"

@implementation GameScene4

- (id)initWithSize:(CGSize)size withFile:(NSString *)file {
    if (self = [super initWithSize:(CGSize)size withFile:(NSString *)file]) {
        
        //        центрирую картинку
        self.anchorPoint = CGPointMake(0.5, 0.5);
        [self.background removeFromParent];
        self.background =[SKSpriteNode spriteNodeWithImageNamed:@"background04"];
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
    
    self.levelLabel.text = @"Level 4";
    self.currentLevel = 4;
}

@end
