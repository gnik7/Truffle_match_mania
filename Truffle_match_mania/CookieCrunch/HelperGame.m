//
//  HelperGame.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 03.07.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "HelperGame.h"
#import "ScaleUIonDevice.h"
#import "Settings.h"
#import "GameSceneUI.h"

@implementation HelperGame

@dynamic position;

-(id) init
{
    self = [super init];
    if (self != nil)
    {
        self.background = nil;
        self.letter = nil;
        self.person = nil;
        self.element = nil;
        self.animation = nil;
    }
    return self;
}

-(void) initWithElements:(GameScene*)scene withMessage:(NSString*)message withPosition:(CGPoint)pos withElement:(NSString*)elementName  withAdditional:(NSString*)additional withPositionMessage:(CGPoint)posMess
{
    scene.screenTouchEnable = NO;
    self.background = nil;
    self.letter = nil;
    self.person = nil;
    self.element = nil;
    self.animation = nil;
    
    [self getTypeHelper:message];
 
    self.background = [SKSpriteNode spriteNodeWithImageNamed:@"tone"];
    self.background.anchorPoint = CGPointMake(0.5, 0.5);
    //self.background.name = @"background";
    self.background.name = @"helper1Move";
    self.background.size = CGSizeMake(scene.frame.size.width , scene.frame.size.height );
    //self.background.position = CGPointMake(scene.frame.size.width , 0);
    self.background.position = CGPointZero;
    self.background.zPosition = 329;
    self.background.alpha = 0.0;
    
    if ([message rangeOfString:@"helper1FirstMove"].location != NSNotFound)
    {
        [self bumbels4:scene];
    }
    
    self.person = [SKSpriteNode spriteNodeWithImageNamed:@"pers2"];
    self.person.name = @"person";
    self.person.anchorPoint = CGPointMake(1, 0);
    self.person.size = CGSizeMake(scene.frame.size.width * 0.5, scene.frame.size.width * 0.9);
    //self.person.position = CGPointMake(scene.frame.size.width * 0.5 , - scene.frame.size.height * 0.5);
    self.person.position = CGPointMake(scene.frame.size.width  , - scene.frame.size.height * 0.5);
    self.person.zPosition = 330;
    [self.background addChild:self.person];
    SKAction *movePersonBegin = [SKAction moveToX:scene.frame.size.width * 0.4 duration:0.5];
    movePersonBegin.timingMode = SKActionTimingEaseIn;
    SKAction *wait = [SKAction waitForDuration:0.1f];
    SKAction *movePersonEnd = [SKAction moveToX:scene.frame.size.width * 0.5 duration:0.1];
    movePersonEnd.timingMode = SKActionTimingEaseIn;
    SKAction *groupPerson = [SKAction sequence:@[movePersonBegin,wait, movePersonEnd]];
    
    self.letter = [SKSpriteNode spriteNodeWithImageNamed:message];
    self.letter.name = @"letter";
    self.letter.anchorPoint = CGPointMake(1, 0);
    self.letter.size = CGSizeMake(scene.frame.size.width * 0.55, scene.frame.size.width * 0.26);
    self.letter.position = CGPointMake(posMess.x + scene.frame.size.width * 1.4, posMess.y) ;
    self.letter.zPosition = 330;
    [self.background addChild:self.letter];
    SKAction *moveLetterBegin = [SKAction moveToX:posMess.x duration:0.3];
    moveLetterBegin.timingMode = SKActionTimingEaseIn;
    SKAction *moveLetterMiddle = [SKAction moveToX:posMess.x + scene.frame.size.width * 0.02 duration:0.1];
    SKAction *moveLetterEnd = [SKAction moveToX:posMess.x  duration:0.1];
    moveLetterEnd.timingMode = SKActionTimingEaseIn;
    SKAction *groupLetter = [SKAction sequence:@[moveLetterBegin,wait, moveLetterMiddle, moveLetterEnd]];
    
    ScaleUIonDevice *scaleTile = [[ScaleUIonDevice alloc] init];
    CGFloat scaleCharacter = [scaleTile scaleCharactersGameScene];

    if (elementName != nil)
    {
        if ([elementName rangeOfString:@"bonus-type"].location != NSNotFound)
        {
            SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Bonuses"];
            SKTexture * texture = [atlas textureNamed:elementName];
            self.element = [SKSpriteNode spriteNodeWithTexture:texture];
            self.element.size = CGSizeMake(self.element.size.width * scaleCharacter  , self.element.size.height * scaleCharacter );
        
            [self doAnimationForBonus:elementName];
        }
        else if ([elementName rangeOfString:@"booster"].location != NSNotFound)
        {
            SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Booster_available"];
            SKTexture * texture = [atlas textureNamed:elementName];
        self.element = [SKSpriteNode spriteNodeWithTexture:texture];
        self.element.size = CGSizeMake(self.element.size.width * scaleCharacter  , self.element.size.height * scaleCharacter );
        
        [self doAnimationForElementWithPosition];
    }

    else
    {
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Characters"];
        SKTexture * texture = [atlas textureNamed:elementName];
        self.element = [SKSpriteNode spriteNodeWithTexture:texture];
        CGFloat scaleSprite = [ScaleUIonDevice scaleForElementsInHelper];
        self.element.size = CGSizeMake(self.element.size.width * scaleCharacter *  scaleSprite, self.element.size.height * scaleCharacter * scaleSprite);
        [self doAnimationForElementWithPosition];
    }
    
        self.element.name = @"element";
        self.element.position = pos;
        self.element.zPosition = 330;
    
        [self.background addChild:self.element];
    }
    if (additional != nil)
    {
        SKSpriteNode *add = [SKSpriteNode spriteNodeWithImageNamed:additional];
        add.name = @"add_plus";
        add.size = CGSizeMake(self.element.size.width/2  , self.element.size.width / 2 );
        add.position = CGPointMake(0 + self.element.size.width/2 - self.element.size.width/4,
                                   0 + self.element.size.height/2 - self.element.size.height/3);
        add.zPosition = 331;
        [self.element addChild:add];
    }
    
    [scene addChild:self.background];

//    [self.background runAction:[SKAction fadeInWithDuration:1.0f] completion:^{
//       [self.element runAction:self.animation completion:^{
//           scene.view.paused = YES;
//           NSLog(@"PAUSED");
//       }];
//    }];
    
    
    // Анимация самого helper-a
    [self.background runAction:[SKAction fadeInWithDuration:1.0f] completion:^{
        [scene enumerateChildNodesWithName:@"gameLayer" usingBlock:^(SKNode *node, BOOL *stop) {
            node.paused = YES;
        }];
        [scene enumerateChildNodesWithName:@"scoreYellowLine" usingBlock:^(SKNode *node, BOOL *stop) {
            node.paused = YES;
        }];
        [self.person runAction:groupPerson completion:^{
            [self.letter runAction:groupLetter completion:^{
                if (elementName != nil)
                {
                    [self.element runAction:self.animation];
                }
                if ([message rangeOfString:@"helper1FirstMove"].location != NSNotFound)
                {
                    [self animationArrow:scene];
                }
            }];
        }];
    }];
}

-(void) doAnimationForElementWithPosition
{
    SKAction *scaleUp = [SKAction scaleTo:1.5  duration:0.5f];
    scaleUp.timingMode = SKActionTimingEaseOut;
    SKAction *scaleDown = [SKAction scaleTo:0.9  duration:0.5f];
    scaleDown.timingMode = SKActionTimingEaseOut;
    self.animation = [SKAction repeatActionForever:[SKAction sequence:@[scaleUp, scaleDown]]];
}

-(void) doAnimationForBonus:(NSString*)elementName
{
    NSString *name = @"";
    if ([elementName rangeOfString:@"bonus-type-1"].location != NSNotFound)
    {
        name = @"bomba";
    }
    else if ([elementName rangeOfString:@"bonus-type-2"].location != NSNotFound)
    {
        name = @"rose";
    }
    
    SKTextureAtlas * atlas = [SKTextureAtlas atlasNamed:[NSString stringWithFormat:@"%@", name]];
    NSMutableArray * mutableArray = [NSMutableArray new];
    for (int i = 1; i <= [atlas.textureNames count]/3; i++) {
        SKTexture * texture = [atlas textureNamed:[NSString stringWithFormat:@"%d%@", i, name]];
        [mutableArray addObject:texture];
    }
    SKAction * animation = [SKAction animateWithTextures:mutableArray timePerFrame:0.1];
    self.animation = [SKAction repeatActionForever:animation ];
}

#pragma mark - First Helper

-(void) bumbels4:(GameScene*) scene
{
    ScaleUIonDevice *scaleUI = [[ScaleUIonDevice alloc] init];
    NSArray *arrScale = [scaleUI scaleForFirsGameScene];
    SKSpriteNode *bumbels = [SKSpriteNode spriteNodeWithImageNamed:@"jelly_helper1"];
    bumbels.name = @"bumbels";
    bumbels.anchorPoint = CGPointMake(0.5, 0.5);
    bumbels.size = CGSizeMake(scene.frame.size.width* [[arrScale objectAtIndex:2] floatValue], scene.frame.size.width * [[arrScale objectAtIndex:3] floatValue] );
    bumbels.position = CGPointMake(scene.frame.size.width * [[arrScale objectAtIndex:0] floatValue], scene.frame.size.height * [[arrScale objectAtIndex:1] floatValue]);
    bumbels.zPosition = 330;
    [self.background addChild:bumbels];
}

- (void) animationArrow:(GameScene*) scene
{
    ScaleUIonDevice *scaleUI = [[ScaleUIonDevice alloc] init];
    NSArray *arrScale = [scaleUI scaleForFirsGameScene];
    
    SKSpriteNode *arrow1 = [[SKSpriteNode alloc] initWithImageNamed:@"pointer1"];
    arrow1.name = @"arrow1";
    arrow1.size = CGSizeMake(scene.frame.size.width* [[arrScale objectAtIndex:4]floatValue], scene.frame.size.height * [[arrScale objectAtIndex:5]floatValue] );
    arrow1.position = CGPointMake(scene.frame.size.width * 0.03, scene.frame.size.height * 0.04);
    arrow1.zPosition = 333;
    [self.background addChild:arrow1];
    
    CGPoint destinationForward = CGPointMake(scene.frame.size.width * 0.03, scene.frame.size.height * 0.08);
    CGPoint destinationBack = CGPointMake(scene.frame.size.width * 0.03, scene.frame.size.height * 0.04);
    
    SKAction *moveDown = [SKAction moveToY:destinationForward.y  duration:0.5f];
    SKAction *moveUp = [SKAction moveToY:destinationBack.y  duration:0.5f];
    SKAction *sequenceArrow1 = [SKAction sequence:@[ moveDown, moveUp]];
    
    SKSpriteNode *arrow2 = [[SKSpriteNode alloc] initWithImageNamed:@"pointer2"];
    arrow2.name = @"arrow2";
    arrow2.size = CGSizeMake(scene.frame.size.width* [[arrScale objectAtIndex:4]floatValue], scene.frame.size.height * [[arrScale objectAtIndex:5]floatValue] );
    arrow2.position = CGPointMake(scene.frame.size.width * 0.07, scene.frame.size.height * 0.08);
    arrow2.zPosition = 333;
    [self.background  addChild:arrow2];
    
    CGPoint destinationForward2 = CGPointMake(scene.frame.size.width * 0.07, scene.frame.size.height * 0.08);
    CGPoint destinationBack2 = CGPointMake(scene.frame.size.width * 0.07, scene.frame.size.height * 0.04);
    
    SKAction *moveDown2 = [SKAction moveToY:destinationForward2.y  duration:0.5f];
    SKAction *moveUp2 = [SKAction moveToY:destinationBack2.y  duration:0.5f];
    SKAction *sequenceArrow2 = [SKAction sequence:@[moveUp2, moveDown2]];
    
    [arrow1 runAction:[SKAction repeatActionForever:sequenceArrow1]];
    [arrow2 runAction:[SKAction repeatActionForever:sequenceArrow2]];
}

#pragma mark - First Helper

-(void) getTypeHelper:(NSString*)message
{
    if ([message rangeOfString:@"bonus-type"].location != NSNotFound)
    {
        _startHandleMathes = YES;
    }
    else if ([message rangeOfString:@"helper_plus"].location != NSNotFound)
    {
        _startHandleMathes = YES;
    }
    else if ([message rangeOfString:@"Booster"].location != NSNotFound)
    {
        _startHandleMathes = NO;
    }
    else
    {
        _startHandleMathes = NO;
    }
}


@end
