//
//  GameScene5.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 25.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "GameScene5.h"
#import "Booster.h"
#import "HelperGame.h"

@implementation GameScene5

- (id)initWithSize:(CGSize)size withFile:(NSString *)file {
    if (self = [super initWithSize:(CGSize)size withFile:(NSString *)file]) {
        
        //        центрирую картинку
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.background =[SKSpriteNode spriteNodeWithImageNamed:@"background05"];
        self.background.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        self.background.zPosition = 1;
        [self addChild:self.background];
        [super unlockBoostersWithLevel:self.currentLevel];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"helperFor_1_Booster"] integerValue] == 0) {
            CGPoint position = CGPointMake(-self.size.width * 0.31, -self.size.height/2.21);
            CGPoint posMessage = CGPointMake(self.frame.size.width * 0.05, -self.frame.size.height * 0.15);
            [self.helpers initWithElements:self withMessage:@"Booster1" withPosition:position withElement:@"1_booster" withAdditional:nil withPositionMessage:posMessage];
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"helperFor_1_Booster"];
            NSLog(@"==========");
        }
    }
    return self;
}

-(void)setLevelScoreLabels
{
    [super setLevelScoreLabels];
    [self.background removeFromParent];
    
    self.levelLabel.text = @"Level 5";
    self.currentLevel = 5;
}


@end
