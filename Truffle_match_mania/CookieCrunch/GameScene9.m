//
//  GameScene5.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 25.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "GameScene9.h"

@implementation GameScene9

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
    
    self.levelLabel.text = @"Level 9";
    self.currentLevel = 9;
}


@end
