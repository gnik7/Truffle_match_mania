//
//  ProjectAnimationsAndActions.m
//  CookieCrunch
//
//  Created by Кирилл on 01.07.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "ProjectAnimationsAndActions.h"
#import "Character.h"
#import "Settings.h"
#import "Chain.h"
#import "Aims.h"
#import "GameScene.h"
#import "ConvertLayers.h"
#import "Level.h"

@implementation ProjectAnimationsAndActions {
    NSMutableDictionary * _animatedCharacters;
    GameScene * _gameScene;
    __block NSInteger _commonScoreAmountForLabel;
}

- (id)initWithSpriteNode:(SKSpriteNode *)sprite {
    if (self = [super init]) {
        
    }
    return self;
}

- (id)initWithGameScene:(GameScene *)gameScene {
    if (self = [super init]) {
//        [self preloadResourcesWithMatch:@"*blue.png"];
        _gameScene = gameScene;
        [self texturesForAnimtaion];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:@"testNotification" object:nil];
    }
    return self;
}

- (void)test:(NSNotification *)notification {
    [_gameScene runAction:[SKAction runBlock:[notification object]]];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"testNotification" object:nil];
    _gameScene = nil;//?
}

//- (NSArray *)preloadResourcesWithMatch:(NSString *)match {
//    NSString * bundleRoot = [[NSBundle mainBundle] bundlePath];
//    NSFileManager * fm = [NSFileManager defaultManager];
//    NSArray * dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
//    NSPredicate * fltr = [NSPredicate predicateWithFormat:@"SELF like %@", match];
//    NSArray * filteredArray = [dirContents filteredArrayUsingPredicate:fltr];
//    if ([filteredArray count] > 0) {
//        return filteredArray;
//    } else {
//        return nil;
//    }
//}

#pragma mark - Animations

- (NSMutableDictionary *)texturesForAnimtaion {
    Character * character = [Character new];
    _animatedCharacters = [NSMutableDictionary new];
    for (int i = 0; i < [[character spriteNames] count]; i++) {
        NSString * spriteName = [[character spriteNames] objectAtIndex:i];
        SKTextureAtlas * atlas = [SKTextureAtlas atlasNamed:[NSString stringWithFormat:@"%@", spriteName]];
        NSMutableArray * mutableArray = [NSMutableArray new];
        for (int i = 1; i <= [atlas.textureNames count]/3; i++) {
            SKTexture * texture = [atlas textureNamed:[NSString stringWithFormat:@"%d%@", i, spriteName]];
            [mutableArray addObject:texture];
        }
        SKAction * animation = [SKAction animateWithTextures:mutableArray timePerFrame:0.1];
        [_animatedCharacters setValue:animation forKey:[NSString stringWithFormat:@"%@", spriteName]];
        mutableArray = nil;
    }
    return _animatedCharacters;
}

- (void) animateFlyingScoreToAimBarWithChain:(Chain *) chain withLabelsPosition:(NSArray *) positions withAimTypePos:(NSInteger) aimTypePos
                                      label:(SKLabelNode *) label {
    NSInteger aimType = [[[_gameScene.level.aimsObject getCharacterAimTypes] objectAtIndex:aimTypePos] integerValue];
    CGFloat startAfter = 0.0f;
    SKSpriteNode * cloudLayer;
    NSInteger chainSize = [[chain characters] count];
    for (int i = 0; i < chainSize; i++) {
//        NSLog(@"start cycle = %d", i);
        Character * currentCharacter = [[chain characters] objectAtIndex:i];
        if (aimType == currentCharacter.characterType && currentCharacter.bonusType == BonusTypeNone) {
            NSInteger amountForSingleCharacter = ++currentCharacter.aimCountOnSingleSprite; // +1 character and it additional count
//            NSLog(@">>aimtype = %ld", (long)aimType);
//            NSLog(@">>amountForSingleCharacter = %ld", (long)amountForSingleCharacter);
            cloudLayer = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]
                                                                     size:currentCharacter.sprite.size];
            cloudLayer.zPosition = 20;
            cloudLayer.position = CGPointMake(currentCharacter.sprite.position.x, currentCharacter.sprite.position.y);
            SKEmitterNode * cloudEmitter = [SKEmitterNode nodeWithFileNamed:@"Cloud.sks"];
            cloudEmitter.position = CGPointMake(0, 0 - cloudLayer.size.height/2);
            [cloudLayer addChild:cloudEmitter];
            SKLabelNode * scores = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%ld", (long)amountForSingleCharacter]];
            scores.fontColor = [UIColor colorWithRed: 0.9941 green: 0.7432 blue: 0.0 alpha: 1.0];
            scores.fontSize = 14;
            scores.fontName = FONT_NAME;
            scores.position = CGPointMake(0, 0 + cloudLayer.size.height/3);
            [cloudLayer addChild:scores];
            [_gameScene.charactersLayer addChild:cloudLayer];
            CGSize tileSize = CGSizeMake(_gameScene.tileWidth, _gameScene.tileHeight);
            CGPoint currentAimSpritePos = [ConvertLayers convertGLToCL:[[positions objectAtIndex:aimTypePos] CGPointValue] tileSize:tileSize
                                                             sceneSize:_gameScene.scene.size numColumns:_gameScene.level.NumColumns
                                                               numRows:_gameScene.level.NumRows];
            SKAction * moveCloud = [SKAction moveTo:currentAimSpritePos duration:1];
            
            startAfter += (float)chainSize/100.f;
            
            SKAction * waitInSequence = [SKAction waitForDuration:startAfter];
            SKAction * remove = [SKAction removeFromParent];
            moveCloud.timingMode = SKActionTimingEaseOut;
            
//            NSLog(@"current score = %@, target = %@", [[_gameScene.level.aimsObject getCurrentScore] objectAtIndex:aimTypePos],
//                  [[_gameScene.level.aimsObject getTargetToLevel] objectAtIndex:aimTypePos]);
            
//            NSLog(@"_commonScoreAmountForLabel BEFORE = %0.2ld", (long)_commonScoreAmountForLabel);
            
            
            SKAction * block = [SKAction runBlock:^{
                [self scaleForAnimateInScoreBar:label];
                label.text = [NSString stringWithFormat:@"%@/%@", [[_gameScene.level.aimsObject getCurrentScore] objectAtIndex:aimTypePos],
                              [[_gameScene.level.aimsObject getTargetToLevel] objectAtIndex:aimTypePos]];
//                _commonScoreAmountForLabel += amountForSingleCharacter;
//                NSLog(@"_commonScoreAmountForLabel in BLOCK = %0.2ld", (long)_commonScoreAmountForLabel);
//                label.text = [NSString stringWithFormat:@"%ld/%@", (long)_commonScoreAmountForLabel,
//                                                            [[_gameScene.level.aimsObject getTargetToLevel] objectAtIndex:aimTypePos]];
            }];
            
            SKAction * sequenceForCloud = [SKAction sequence:@[waitInSequence, moveCloud, remove]];
            CGFloat waitForScale = startAfter + 0.8f;
            SKAction * waitInScale = [SKAction waitForDuration:waitForScale];
            SKAction * sequenceForScale = [SKAction sequence:@[waitInScale, block]];
//            SKAction * group = [SKAction group:@[sequenceForCloud, sequenceForScale]];
            [_gameScene runAction:sequenceForScale];
            [cloudLayer runAction:sequenceForCloud];
        }
    }
//    NSLog(@"end of method");
//    _commonScoreAmountForLabel = [[[_gameScene.level.aimsObject getCurrentScore] objectAtIndex:aimTypePos] integerValue];
}

- (void) scaleForAnimateInScoreBar:(SKLabelNode *) label {
    SKAction *scaleUp = [SKAction scaleTo:2.f duration:0.3f];
    scaleUp.timingMode = SKActionTimingEaseOut;
    SKAction *scaleDown = [SKAction scaleTo:1.0f duration:0.1f];
    SKAction *scaleSequence = [SKAction sequence:@[scaleUp, scaleDown]];
    //FIXME: проблема с label, есть, но не воспринимает действие
    [label runAction:scaleSequence];
}

#pragma mark - Getters

- (NSMutableDictionary *) getCharactersAnimation {
    return _animatedCharacters;
}

//Setter

-(void) characterAnimationRelease
{
    _animatedCharacters = nil;
}

#pragma mark - Actions

@end
