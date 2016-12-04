//
//  GameSceneUI.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 25.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "GameSceneUI.h"
#import "Settings.h"
#import "Star.h"
#import "Character.h"
#import "Level.h"
#import "GameScene.h"
#import "ScaleUIonDevice.h"

@implementation GameSceneUI {
    id _className;
    NSInteger _counterForCheck;
    SKTextureAtlas * _atlas;
    ScaleUIonDevice *scaleUI;
    CGFloat _lastEffectPosX;
}

-(id)initWithSize:(CGSize)size withClass:(id)className
{
    if((self = [super initWithSize:size])){
        _className = className;
        [self setLevelScoreLabel];
        _counterForCheck = 0;
        scaleUI = [[ScaleUIonDevice alloc] init];
        _firstTimeEndScoreLine = YES;
    }
    return self;
}

-(void) dealloc
{
    NSLog(@"UI is deallocated");
}

-(void)setLevelScoreLabel
{
    ScaleUIonDevice *scaleUI2 = [[ScaleUIonDevice alloc] init];
    NSArray *arrScale =[scaleUI2 scaleForTopBar];
    //Label with target Score
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
    _scoreLabel.fontSize = [arrScale[1] floatValue];
    _scoreLabel.fontColor = FONT_COLOR_GREEN;
    _scoreLabel.position = CGPointMake(POSITION_X * 0.36, POSITION_Y * 0.367);
    _scoreLabel.zPosition = 10;
    _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [_className addChild:_scoreLabel];
    
    
    //Label Level
    _levelLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
    _levelLabel.fontSize = [arrScale[1] floatValue];
    _levelLabel.fontColor = FONT_COLOR_GREEN;
    _levelLabel.position = CGPointMake(-POSITION_X * 0.36, POSITION_Y * 0.367);
    _levelLabel.zPosition = 10;
    [_className addChild:_levelLabel];
    
}

- (CGFloat)setScoreBarWithTarget:(NSUInteger)targetScore {
    _atlas = [SKTextureAtlas atlasNamed:@"ScoreBar"];
//    SKTexture * texture = [_atlas textureNamed:@"score-line-background"];
//    _scoreBarBackground = [SKSpriteNode spriteNodeWithTexture:texture];
//    _scoreBarBackground.zPosition = 11;
//    _scoreBarBackground.size = CGSizeMake(POSITION_X / 1.65, POSITION_Y * 0.02);
//    _scoreBarBackground.position = CGPointMake(0, POSITION_Y * 0.375);
//    [_className addChild:_scoreBarBackground];

//    texture = [_atlas textureNamed:@"score-bar-blue"];
//    SKSpriteNode * blueLine = [SKSpriteNode spriteNodeWithTexture:texture];
//    blueLine.zPosition = 12;
//    blueLine.position = CGPointMake(0, POSITION_Y * 0.375);
//    blueLine.size = CGSizeMake(_scoreBarBackground.size.width - SCORE_BAR_BORDER_FIX_X_5_5S, blueLine.size.height);
//    [_className addChild:blueLine];
//    CGFloat scoreBarLevelIndex = targetScore / _scoreBarBackground.size.width;
//
//    texture = [_atlas textureNamed:@"score-line-red-start"];
//    SKSpriteNode * redStart = [SKSpriteNode spriteNodeWithTexture:texture];
//    redStart.zPosition = 20;
//    redStart.position = CGPointMake(-_scoreBarBackground.size.width/2 + SCORE_BAR_BORDER_FIX_X_5_5S, POSITION_Y * 0.375);
//    [_className addChild:redStart];
    
    
    SKTexture * texture = [_atlas textureNamed:@"score-bar-green"];
    _scoreBarBackground = [SKSpriteNode spriteNodeWithTexture:texture];
    _scoreBarBackground.anchorPoint = CGPointMake(1, 0.5);
    _scoreBarBackground.zPosition = 11;
    _scoreBarBackground.size = CGSizeMake(POSITION_X / 1.65, POSITION_Y * 0.02);
    _scoreBarBackground.position = CGPointMake(POSITION_X * 0.3, POSITION_Y * 0.375);
    [_className addChild:_scoreBarBackground];
    
    SKTexture * texture2 = [_atlas textureNamed:@"score-line"];
    _scoreYellowLine = [SKSpriteNode spriteNodeWithTexture:texture2];
    _scoreYellowLine.name = @"scoreYellowLine";
    _scoreYellowLine.zPosition = 11;
    _scoreYellowLine.anchorPoint = CGPointMake(0, 0.5);
    _scoreYellowLine.size = CGSizeMake(1, POSITION_Y * 0.02);
    _scoreYellowLine.position = CGPointMake(-POSITION_X * 0.3 , POSITION_Y * 0.375);
    [_className addChild:_scoreYellowLine];
    
    
    CGFloat scoreBarLevelIndex = targetScore / _scoreBarBackground.size.width;
    
    return scoreBarLevelIndex;
}

- (NSMutableArray*)setScoreBarWithStars:(NSArray *)stars {
    NSMutableArray * starsSprites = [NSMutableArray new];
    for (NSValue * starPos in stars) {
        Star * star = [[Star alloc] initWithImageNamed:@"score-line-star1"];
        star.name = @"star";
        star.zPosition = 14;
        star.position = [starPos CGPointValue];
        star.size = CGSizeMake(star.size.width * [[[ScaleUIonDevice scaleForScoreLine] objectAtIndex:1] floatValue], star.size.height * [[[ScaleUIonDevice scaleForScoreLine] objectAtIndex:1] floatValue]);
        [_scoreBarBackground addChild:star];
        [starsSprites addObject:star];
        star = nil;
    }
    return starsSprites;
}

-(void)setScoreBarYellow:(CGFloat)scaleX check:(BOOL)doScale test:(CGFloat)toYellowX
{
    if (doScale)
    {
        SKAction *move = [SKAction scaleXTo:scaleX duration:1.0f];
        
        _scoreYellowLine.position = CGPointMake(-POSITION_X * 0.3 -2 , POSITION_Y * 0.375);
        CGFloat yellowLineBoardX = _scoreYellowLine.position.x + scaleX;
        if (_lastEffectPosX == 0) _lastEffectPosX = _scoreYellowLine.position.x;
        SKEmitterNode * scoreBarEffect = [SKEmitterNode nodeWithFileNamed:@"ScoreBarEffect.sks"];
        scoreBarEffect.position = CGPointMake(_lastEffectPosX, _scoreYellowLine.position.y);
        _lastEffectPosX = yellowLineBoardX;
        scoreBarEffect.zPosition = 20;
        [_className addChild:scoreBarEffect];
        SKAction * moveEffect = [SKAction moveTo:CGPointMake(yellowLineBoardX, POSITION_Y * 0.375) duration:1.0f];
        SKAction * effectSequence = [SKAction sequence:@[moveEffect, [SKAction removeFromParent]]];
        [_scoreYellowLine runAction:move];
        [scoreBarEffect runAction:effectSequence];
    }
    else
    {
         _scoreYellowLine.size = CGSizeMake(POSITION_X / 1.65, POSITION_Y * 0.02);
         _scoreYellowLine.position = CGPointMake(-POSITION_X * 0.3 -2 , POSITION_Y * 0.375);
    }
}

- (void) removeScoreLine
{
    [_scoreYellowLine removeFromParent];
    [_scoreBarBackground removeFromParent];
    _scoreBarBackground = nil;
    _scoreYellowLine = nil;
}

- (void)revertUI {
    if ([_scoreBarBackground.children count] > 0) {
        [_scoreBarBackground enumerateChildNodesWithName:@"redLine" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
        [_scoreBarBackground enumerateChildNodesWithName:@"star" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
        _lastEffectPosX = 0;
    }
}

-(NSArray *)setTopBar
{
    NSArray *arrScale = [scaleUI scaleForTopBar];
    SKSpriteNode *topBarLayer = [SKSpriteNode spriteNodeWithImageNamed:@"top_board"];
    topBarLayer.zPosition = 8;
    topBarLayer.size = CGSizeMake(self.frame.size.width, self.frame.size.height *0.2);
    topBarLayer.anchorPoint = CGPointMake(0, 1);
    topBarLayer.position = CGPointMake(-self.frame.size.width/2, self.frame.size.height/2);
    [_className addChild:topBarLayer];
    
    //Label with current Moves
    _movesLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
    _movesLabel.fontSize = FONT_SIZE_SCORE_GAME_SCENE * [arrScale[0] floatValue];
    _movesLabel.fontColor = FONT_COLOR_WHITE;
    _movesLabel.position = CGPointMake( -POSITION_X* 0.395 , POSITION_Y * 0.46 );
    _movesLabel.zPosition = 10;
    _movesLabel.text = @"0";
    [_className addChild:_movesLabel];
    
    //Label with  LIFE
    _lifeLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
    _lifeLabel.fontSize = FONT_SIZE_SCORE_GAME_SCENE * [arrScale[0] floatValue];
    _lifeLabel.fontColor = FONT_COLOR_WHITE;
    _lifeLabel.position = CGPointMake( POSITION_X* 0.39 , POSITION_Y * 0.46 );
    _lifeLabel.zPosition = 10;
    _lifeLabel.text = @"0";
    [_className addChild:_lifeLabel];
    
    NSArray * aimSpritesPositions = [self setTopBarTargets];
    [self setBottomBar];
    [self drawPauseButton:@"pause_button_1"];
    return aimSpritesPositions;
}

#pragma mark - Bottom

-(void) setBottomBar
{
    SKSpriteNode *bottomBarLayer = [SKSpriteNode spriteNodeWithImageNamed:@"layer_boosters"];
    bottomBarLayer.anchorPoint = CGPointMake(0.5, 0);
    bottomBarLayer.zPosition = 3;
    bottomBarLayer.size = CGSizeMake(self.frame.size.width *1.02, self.frame.size.height *0.135);
    //bottomBarLayer.anchorPoint = CGPointMake(0, 1);
    bottomBarLayer.position = CGPointMake( 0 , -self.frame.size.height/2);
    [_className addChild:bottomBarLayer];

}

-(void) drawPauseButton:(NSString *)fileName
{
    [_pauseButton removeFromParent];
    SKTextureAtlas * atlas = [SKTextureAtlas atlasNamed:@"Window"];
    SKTexture * texture = [atlas textureNamed:fileName];
    _pauseButton = [SKSpriteNode spriteNodeWithTexture:texture];
    _pauseButton.name = @"pauseButton";
    _pauseButton.zPosition = 8;
    _pauseButton.size = CGSizeMake(self.frame.size.width * 0.12, self.frame.size.width * 0.12);
    _pauseButton.anchorPoint = CGPointMake(0.5, 0.5);
    _pauseButton.position = CGPointMake( -POSITION_X * 0.39  , -POSITION_Y * 0.34 );
    [_className addChild:_pauseButton];
}


#pragma mark - Boosters

- (void)setBoosterBar {
    NSArray *arrScale = [ScaleUIonDevice scaleForBottomBar];
    _boosterSprites = [NSMutableDictionary new];
    _atlas = [SKTextureAtlas atlasNamed:@"Booster_unavailable"];
    SKSpriteNode * tempSprite;
    for (int i = 1; i <= BOOSTER_AMOUNT; i++) {
        SKTexture * texture = [_atlas textureNamed:[NSString stringWithFormat:@"%d_booster_unavailable", i]];
        SKSpriteNode * boosterSprite = [SKSpriteNode spriteNodeWithTexture:texture];
        tempSprite = boosterSprite;
        boosterSprite.name = [NSString stringWithFormat:@"%d_booster", i];
        boosterSprite.zPosition = 8;
        boosterSprite.anchorPoint = CGPointMake(0.5, 0.5);
        boosterSprite.size = CGSizeMake( self.frame.size.width * [[arrScale objectAtIndex:0] floatValue] , self.frame.size.width * [[arrScale objectAtIndex:0] floatValue]);
        switch (i) {
            case 1:
                boosterSprite.position = CGPointMake(-POSITION_X * 0.31, -POSITION_Y/2.21);
                break;
            case 2:
                boosterSprite.position = CGPointMake(-POSITION_X * 0.15, -POSITION_Y/2.21);
                break;
            case 3:
                boosterSprite.position = CGPointMake(POSITION_X * 0, -POSITION_Y/2.21);
                break;
            case 4:
                boosterSprite.position = CGPointMake(POSITION_X * 0.15, -POSITION_Y/2.21);
                break;
            default: NSLog(@"ERROR BOOSTER POSITION");
                break;
        }
        [_boosterSprites setValue:boosterSprite forKey:[NSString stringWithFormat:@"%d_booster_unavailable", i]];
    }
    
    [self setBoosterAmountWithSpriteSize:tempSprite.size];
}

- (void)setBoosterAmountWithSpriteSize:(CGSize)size {
    NSArray *arrScale =[ScaleUIonDevice scaleForBottomBar];
    _boosterAmountSprites = [NSMutableDictionary new];
    SKTextureAtlas *atlasAmount = [SKTextureAtlas atlasNamed:@"Booster_amount"];
    for (int i = 1; i <= BOOSTER_SINGLE_AMOUNT; i++) {
        SKTexture * texture = [atlasAmount textureNamed:[NSString stringWithFormat:@"booster_amount_%d", i]];
        SKSpriteNode * boosterAmountSprite = [SKSpriteNode spriteNodeWithTexture:texture];
        boosterAmountSprite.name = [NSString stringWithFormat:@"booster_amount_%d", i];
        boosterAmountSprite.size = CGSizeMake(boosterAmountSprite.size.width * [[arrScale objectAtIndex:2] floatValue] , boosterAmountSprite.size.width * [[arrScale objectAtIndex:2] floatValue]);
        boosterAmountSprite.position = CGPointMake(size.width/2 - boosterAmountSprite.size.width/2, size.height/2 - boosterAmountSprite.size.height/2);
        [_boosterAmountSprites setValue:boosterAmountSprite forKey:[NSString stringWithFormat:@"booster_amount_%d", i]];
    }
}

#pragma mark - LeftMoves

- (void)setHornOfPLenty {
    NSArray *arrScale = [ScaleUIonDevice scaleForBottomBar];
    _hornOfPlenty = [SKSpriteNode spriteNodeWithImageNamed:@"horn_of_plenty"];
    _hornOfPlenty.name = @"hornOfPlenty";
    _hornOfPlenty.position = CGPointMake(POSITION_X/HORN_OF_PLENTY_X_DELTA, -POSITION_Y/HORN_OF_PLENTY_Y_DELTA);
    _hornOfPlenty.size = CGSizeMake(self.frame.size.width * [[arrScale objectAtIndex:1] floatValue], self.frame.size.width * [[arrScale objectAtIndex:1] floatValue] );
    _hornOfPlenty.zPosition = 9;
    [_className addChild:_hornOfPlenty]; // gamescene
}

#pragma mark - TopBar Targets

-(NSArray *)setTopBarTargets
{
    //
    /*  Block for Target Sprite, Blue Line, Score/Target */
    //
    NSArray *arrScale =[scaleUI scaleForTopBar];
    NSMutableArray * spritesPositions = [NSMutableArray new];
    //позиции и размеры Sprite
    NSArray *positionX_SpriteTarget = [NSArray arrayWithObjects:
                                       [NSNumber numberWithFloat:(-POSITION_X * 0.2)] ,
                                       [NSNumber numberWithFloat:(-POSITION_X * 0.07)],
                                       [NSNumber numberWithFloat:(POSITION_X * 0.07)],
                                       [NSNumber numberWithFloat:(POSITION_X * 0.2)],
                                       nil];
    CGFloat positionY_SpriteTarget = POSITION_Y * 0.46;
    CGSize sizeCaracters = CGSizeMake(self.frame.size.width * 0.12 * [[arrScale objectAtIndex:3] floatValue], self.frame.size.width * 0.12 * [[arrScale objectAtIndex:3] floatValue]);
    
    // Size of Blue Line for Characters
    CGSize sizeBlueLine = CGSizeMake(self.frame.size.width* 0.11 * [[arrScale objectAtIndex:4] floatValue], self.frame.size.width * 0.05 * [[arrScale objectAtIndex:4] floatValue]);
    
    //Position of Score / Target  Labels
    CGFloat positionYofLabel = positionY_SpriteTarget - sizeCaracters.height/2 - sizeBlueLine.height * [[arrScale objectAtIndex:5] floatValue];
    
    _atlas = [SKTextureAtlas atlasNamed:@"CharactersBig"];
    
    Character *currentCharacter = [[Character alloc] init];
//    NSArray * arrayTargetToLevel = [NSArray arrayWithArray:  _getTargetToLevel];
//    for (NSInteger i = 0; i < [arrayTargetToLevel count]; i++)
    for (NSInteger i = 0; i < [_getAimsToLevel count]; i++) {
//        NSInteger tmp = [[arrayTargetToLevel objectAtIndex:i] integerValue];
//        if(tmp != (long)0)
//        {
        //определение имени Sprite
        currentCharacter.characterType = [[_getCharactersToLevel objectAtIndex:i] integerValue];
        NSString *spriteName = [currentCharacter spriteName];
        SKSpriteNode *spriteCharacter;
        
        if ([[_getAimsToLevel objectAtIndex:i] integerValue] == BLOCK_TYPE) {   // block
            spriteCharacter = [SKSpriteNode spriteNodeWithImageNamed:@"box"];
            spriteName = @"block";
        } else {                                                                // other sprites (characters)
            //отрисовка Sprite
            SKTexture * texture = [_atlas textureNamed:spriteName];
            spriteCharacter = [SKSpriteNode spriteNodeWithTexture:texture];
        }
        spriteCharacter.name = [NSString stringWithFormat: @"%@ScoreBar", spriteName];
        spriteCharacter.zPosition = 9;
        spriteCharacter.size = sizeCaracters;
        spriteCharacter.anchorPoint = CGPointMake(0.5 , 0.5);
        spriteCharacter.position = CGPointMake([[positionX_SpriteTarget objectAtIndex:i] floatValue] ,  positionY_SpriteTarget);
        NSValue * posValue = [NSValue valueWithCGPoint:spriteCharacter.position];
        [spritesPositions addObject:posValue];
        [_className addChild:spriteCharacter];
        
        //Adding Blue Line for Characters
        SKSpriteNode *blueLine = [SKSpriteNode spriteNodeWithImageNamed:@"number_jelly"];
        blueLine.name = [NSString stringWithFormat:@"%@BlueLine", spriteName];
        blueLine.zPosition = 10;
        blueLine.size = sizeBlueLine;
        spriteCharacter.anchorPoint = CGPointMake(0.5 , 0.5);
        blueLine.position = CGPointMake( [[positionX_SpriteTarget  objectAtIndex:i] floatValue] , positionY_SpriteTarget - spriteCharacter.size.height/2);
        [_className addChild:blueLine];
        
        
        //   Score / Target  Labels
        SKLabelNode *targetScoreLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
        targetScoreLabel.name = [NSString stringWithFormat:@"%@Label", spriteName];

        //targetScoreLabel.fontSize = FONT_SIZE_TARGETS_IN_TOP_BAR * [[arrScale objectAtIndex:2] floatValue];
        targetScoreLabel.fontSize = [[arrScale objectAtIndex:2] floatValue];
        targetScoreLabel.fontColor = FONT_COLOR_WHITE;
        targetScoreLabel.position = CGPointMake([[positionX_SpriteTarget objectAtIndex:i] floatValue], positionYofLabel);
        targetScoreLabel.zPosition = 11;
        targetScoreLabel.text = [NSString stringWithFormat:@"%d/%@", 0, [ _getTargetToLevel objectAtIndex:i]];
        [_className addChild:targetScoreLabel];
//        }
    }
    return spritesPositions;
}

-(void) removeTarget:(NSMutableArray *) array restart:(BOOL)flag
{
    if ([array count]>0)
    {
        for (NSString *sprite in array)
        {
            SKLabelNode *label = (SKLabelNode*)[_className childNodeWithName:[NSString stringWithFormat:@"%@Label", sprite]];
            SKSpriteNode *blueLine = (SKSpriteNode*)[_className childNodeWithName:[NSString stringWithFormat:@"%@BlueLine", sprite]];
            SKSpriteNode *spriteNode = (SKSpriteNode*)[_className childNodeWithName:[NSString stringWithFormat:@"%@ScoreBar", sprite]];
            if (label != nil && blueLine != nil && spriteNode != nil)
            {
                [label removeFromParent];
                [blueLine removeFromParent];
                CGFloat posX = spriteNode.position.x;
                CGFloat posY = spriteNode.position.y;
                [spriteNode removeFromParent];
                
                if (!flag)
                {
                  [self checkTarget:sprite toX:posX toY:posY];
                }
                
                label = nil;
                blueLine = nil;
                spriteNode = nil;
            }
        }
        array = nil;
    }
}

-(void) checkTarget:(NSString*)nameSprite toX:(CGFloat)positionX toY:(CGFloat)positionY
{
    _counterForCheck++;
    SKTextureAtlas * atlas = [SKTextureAtlas atlasNamed:@"CharactersChecked"];
    SKTexture * texture = [atlas textureNamed:[NSString stringWithFormat: @"%@_checked", nameSprite]];
    SKSpriteNode *spriteCheck = [SKSpriteNode spriteNodeWithTexture:texture];
    spriteCheck.name = [NSString stringWithFormat:@"checkSprite%lu", (long)_counterForCheck];
    spriteCheck.zPosition = 9;
    spriteCheck.anchorPoint = CGPointMake(0.5 , 0.5);
    spriteCheck.position = CGPointMake(positionX ,  positionY);
    if ([nameSprite isEqualToString:@"anchor"])
        spriteCheck.size = CGSizeMake(self.frame.size.width * 0.10, self.frame.size.width * 0.10);
    else
        spriteCheck.size = CGSizeMake(self.frame.size.width * 0.12, self.frame.size.width * 0.12);
    
    [_className addChild:spriteCheck];
}

-(void) removeCheck
{
    for (NSInteger i= 1; i <= _counterForCheck; i++)
    {
        SKSpriteNode *check = (SKSpriteNode*)[_className childNodeWithName:[NSString stringWithFormat: @"checkSprite%lu",(long)i]];
        if(check != nil)
        {
            [check removeFromParent];
            check = nil;
        }
    }
    _counterForCheck = 0;
}

-(void) animateLeftMovesInDeadLine
{
    self.movesLabel.fontColor = FONT_COLOR_RED;
    SKAction *scaleUp = [SKAction scaleTo:1.4f duration:0.5f];
    scaleUp.timingMode = SKActionTimingEaseOut;
    SKAction *scaleDown = [SKAction scaleTo:1.0f duration:0.2f];
    SKAction *sequence = [SKAction sequence:@[scaleUp,scaleDown]];
    [self.movesLabel runAction:sequence];
}


#pragma mark - Refaffle Animation

-(void)setLabelForReshuffle1
{
    _message1Reshuffle = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
    _message1Reshuffle.fontSize = 40 * [[[ScaleUIonDevice scaleWindows] objectAtIndex:2] floatValue];
    _message1Reshuffle.fontColor = FONT_COLOR_RESHUFFLE;
    _message1Reshuffle.position = CGPointZero;
    _message1Reshuffle.zPosition = 300;
    _message1Reshuffle.text = @"There is no swipe.";
    [_className addChild:_message1Reshuffle];
}

-(void)setLabelForReshuffle2
{
    _message2Reshuffle = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
    _message2Reshuffle.fontSize = 50 * [[[ScaleUIonDevice scaleWindows] objectAtIndex:2] floatValue];
    _message2Reshuffle.fontColor = FONT_COLOR_RESHUFFLE;
    _message2Reshuffle.position = CGPointZero;
    _message2Reshuffle.zPosition = 300;
    _message2Reshuffle.text = @"Reshuffle";
    [_className addChild:_message2Reshuffle];
}

-(SKAction*) animationForReshuffle
{
    SKAction *wait = [SKAction waitForDuration:1.5];
    SKAction *fadeIn = [SKAction fadeOutWithDuration:1.5];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[wait, fadeIn, remove]];
    return sequence;
}

@end
