//
//  FirstLevelScene.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 12.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "FirstLevelScene.h"
#import "Character.h"
#import "Level.h"
#import "Swap.h"
#import "ScaleUIonDevice.h"
#import "HelperGame.h"

@import AVFoundation;

@interface FirstLevelScene()

@property (strong, nonatomic) SKNode * coverLayer;

@end

@implementation FirstLevelScene
{
    BOOL flag;
    CGFloat x, y, y2;
    NSInteger steps;
}

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size withFile:@"Level_1"]) {
        
      //        центрирую картинку
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        SKSpriteNode * background = [SKSpriteNode spriteNodeWithImageNamed:@"background01"];
        background.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        background.zPosition = 1;
        [self addChild:background];
        
//        [self.background removeFromParent];
//        self.background = [SKSpriteNode spriteNodeWithImageNamed:@"background01"];
//        self.background.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
//        self.background.zPosition = 1;
//        [self addChild:self.background];

        self.coverLayer = [SKNode node];
        self.coverLayer.hidden = NO;

        self.coverLayer.position = CGPointMake(-self.frame.size.width/2, -self.frame.size.height/2);
        self.coverLayer.zPosition = 15;
        [self addChild:self.coverLayer];
       
        flag = NO;
        steps = self.level.maximumMoves;
        
      if([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"] intValue] == 0)
      {
          CGPoint positionMassege = CGPointMake(self.frame.size.width * 0.05, self.frame.size.height * 0.2);
          [self.helpers initWithElements:self withMessage:@"helper1FirstMove" withPosition:CGPointZero withElement:nil withAdditional:nil withPositionMessage:positionMassege];

          flag = YES;
      }
        
        [super unlockBoostersWithLevel:self.currentLevel];
    }
    return self;
}

- (void)dealloc {

    NSLog(@"FIRST LEVEL deallocated");
   
}

-(void) myDealloc
{
    NSLog(@"FIRST LEVEL mydeallocated");
    [super myDealloc];
    [self removeAllChildren];
}

-(void)setLevelScoreLabels
{
    [super setLevelScoreLabels];
    self.levelLabel.text = @"1 Level";
    self.currentLevel = 1;
}

- (void)decrementMoves
{
    [super decrementMoves];
    if (steps- self.movesLeft == 1 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"] intValue] == 0)
    {
        CGPoint positionMassege = CGPointMake(self.frame.size.width * 0.05, self.frame.size.height * 0);
        [self.helpers initWithElements:self withMessage:@"helper_next_move" withPosition:CGPointZero withElement:nil withAdditional:nil withPositionMessage:positionMassege];
    }
}

////колонну и ряд конвертим в точку
- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row {
    return [super pointForColumn:column row:row];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touchNew = [touches anyObject];
    CGPoint location = [touchNew locationInNode:self];
    
    if(self.score == 0  && [[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"] intValue] == 0)
    {
        if(flag)
        {
            [super touchesBegan:touches withEvent:event];

            flag = NO;
        }
                NSLog(@" x = %f   y = %f  ", location.x, location.y);
        if ( (location.x > 7 && location.x < 58) && (location.y > 3 && location.y < 115) )
        {
            [super touchesBegan:touches withEvent:event];
        }
    }
    else if((steps - self.movesLeft) == 1  && [[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"] intValue] == 0)
    {
        [super touchesBegan:touches withEvent:event];

        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"activeLevels"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    else
    {
         [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.score == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"] intValue] == 0)
    {
        UITouch * touchNew = [touches anyObject];
        CGPoint location = [touchNew locationInNode:self];
    
        if ( (location.x > 7 && location.x < 58) && (location.y > 3 && location.y < 115) )
        {
            [super touchesMoved:touches withEvent:event];
        }
    }
    else
    {
        [super touchesMoved:touches withEvent:event];
    }
}


@end
