//
//  StartScene.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 12.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "StartScene.h"
#import "MapScene.h"
#import "Settings.h"

@implementation StartScene
{
    SKSpriteNode *buttonStart;
}

#pragma mark - Init

-(id)initWithSize:(CGSize)size
{
    if((self = [super initWithSize:size])) {
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"startscreen"];
        background.position = CGPointMake(POSITION_OF_BACKGROUND_X, POSITION_OF_BACKGROUND_Y);
        background.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        background.zPosition = 1;
        [self addChild:background];
        [self setButtonStart];
        [self setAnimation];
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"] intValue] == 0)
        {
            // Create lifes
            NSMutableArray *array = [NSMutableArray array];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"Lifes"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"LIFE  %@", array);
            
            //Create LastLevel
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"LastLevel"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        /*   For TEst Font
        SKLabelNode *_levelLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
        //Set different font size to another device

            _levelLabel.fontSize = 60;

        _levelLabel.fontColor = FONT_COLOR_BLUE;
        _levelLabel.text = @"Test Text";
        _levelLabel.position = CGPointMake(POSITION_X * 0.36, POSITION_Y * 0.37  );
        _levelLabel.zPosition = 100;
        //Add node to scene
        [self addChild:_levelLabel];
       */

        //для отладки движения по карте
//
//        [[NSUserDefaults standardUserDefaults] setObject:@18 forKey:@"activeLevels"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [[NSUserDefaults standardUserDefaults] setObject:@15 forKey:@"LastLevel"];
//        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    return self;
}
-(void) dealloc
{
    NSLog(@" Start deallocated");
}

-(void) setButtonStart
{
    buttonStart = [SKSpriteNode spriteNodeWithImageNamed:@"play1"];
    buttonStart.size = CGSizeMake(SIZE_OF_BUTTON_START, SIZE_OF_BUTTON_START);
    buttonStart.position = CGPointMake(POSITION_OF_BUTTON_START_X, POSITION_OF_BUTTON_START_Y);
    buttonStart.zPosition = 5;
    buttonStart.xScale = 0;
    buttonStart.yScale = 0;
    [self addChild:buttonStart];
}

-(void) setAnimation
{
    SKAction *wait =[SKAction waitForDuration:0.9f];
    SKAction *appear = [SKAction scaleTo:1.0 duration:0.5f];
    appear.timingMode = SKActionTimingEaseOut;
//    CGPoint up = CGPointMake(POSITION_OF_BUTTON_START_X + 10, POSITION_OF_BUTTON_START_Y + 10);
//    SKAction *moveUp = [SKAction moveTo:up duration:0.2f];
//    CGPoint down = CGPointMake(POSITION_OF_BUTTON_START_X - 10, POSITION_OF_BUTTON_START_Y - 10);
//    SKAction *moveDown = [SKAction moveTo:down duration:0.2f];
//    CGPoint middle = CGPointMake(POSITION_OF_BUTTON_START_X , POSITION_OF_BUTTON_START_Y);
//    SKAction *moveMiddle = [SKAction moveTo:middle duration:0.2f];
    SKAction *scaleUp = [SKAction scaleBy:1.1f duration:0.2];
    SKAction *scaleDown = [scaleUp reversedAction];
    
    SKAction *scaleNorm = [SKAction scaleBy:1.0f duration:0.2];
    SKAction *groupWiggle = [SKAction repeatActionForever:[SKAction sequence:@[/*moveUp,*/ scaleUp, /*moveDown,*/ scaleDown, /*moveMiddle,*/ scaleNorm]]];
    SKAction *groupAll = [SKAction sequence:@[wait, appear,groupWiggle]];
    [buttonStart runAction:groupAll];
}


#pragma mark - Touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if ([buttonStart containsPoint:location]) {
            CGPoint pos = buttonStart.position;
            CGSize size = buttonStart.size;
            SKAction *wait = [SKAction waitForDuration:0.25f];
            
            SKAction *newSprite = [SKAction runBlock:^{
                [buttonStart removeFromParent];
                NSArray *arr = [buttonStart.texture.description componentsSeparatedByString:@"'"];
                NSMutableString *name = [NSMutableString stringWithString:[arr objectAtIndex:1]];
                [name deleteCharactersInRange:NSMakeRange([name length]-1, 1)];
                buttonStart = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@2", name]];
                buttonStart.size= size;
                buttonStart.position = pos;
                buttonStart.zPosition = 130;
                [self addChild:buttonStart];
            }];
            
            [buttonStart runAction:newSprite completion:^{
                [buttonStart runAction:wait completion:^{
                    SKView * skView = (SKView *)self.view;
                    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
                    SKScene *level = [[MapScene alloc] initWithSize:skView.bounds.size];
                    
                    [self.view presentScene:level transition:reveal];
                    NSLog(@"%@",  self.name);
                }];
            }];
  
        }
    }
    
   
}

#pragma mark - Update

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
