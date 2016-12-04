//
//  GameScene5.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 25.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "GameScene14.h"
#import "HelperGame.h"

@implementation GameScene14

- (id)initWithSize:(CGSize)size withFile:(NSString *)file {
    if (self = [super initWithSize:(CGSize)size withFile:(NSString *)file]) {
        
        //        центрирую картинку
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.background =[SKSpriteNode spriteNodeWithImageNamed:@"background01"];
        [super unlockBoostersWithLevel:self.currentLevel];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"helperFor_4_Booster"] integerValue] == 0) {
            CGPoint position = CGPointMake(self.size.width * 0.15, -self.size.height/2.21);
            CGPoint posMessage = CGPointMake(self.frame.size.width * 0.05, -self.frame.size.height * 0.15);
            [self.helpers initWithElements:self withMessage:@"Booster4" withPosition:position withElement:@"4_booster" withAdditional:nil withPositionMessage:posMessage];
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"helperFor_4_Booster"];
        }

    }
    return self;
}

-(void)setLevelScoreLabels
{
    [super setLevelScoreLabels];
    
    self.levelLabel.text = @"Level 14";
    self.currentLevel = 14;
}


@end
