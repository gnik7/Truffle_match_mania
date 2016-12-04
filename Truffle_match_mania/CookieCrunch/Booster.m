//
//  Booster.m
//  CookieCrunch
//
//  Created by Кирилл on 01.06.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "Booster.h"
#import "Character.h"
#import "Chain.h"
#import "Level.h"
#import "Aims.h"
#import "Settings.h"
#import "PlusOnePlusTwo.h"
#import "GameScene.h"
#import "GameSceneUI.h"
#import "ScaleUIonDevice.h"

@implementation Booster {
    PlusOnePlusTwo * _plusOneObject;
}

- (id)initBoosterWithType:(BoosterType)boosterType andSprite:(SKSpriteNode *)sprite withGameScene:(id)scene {
    if (self = [super init]) {
        _boosterType = boosterType;
        _sprite = sprite;
        [scene addChild:sprite];
    }
    return self;
}

- (NSMutableSet *)dealWithBooster:(Booster *)booster andCharacter:(Character *)character andLevel:(Level *)level withDelta:(NSInteger)delta {
    NSMutableSet * tempSet = [NSMutableSet new];
    Chain * tempChain = [Chain new];
    NSInteger boosterAmount = 0;
    
    switch (booster.boosterType) {
        case BoosterTypeKillOne: {
            if (booster.boosterAmount > 0) {
                NSLog(@"1 booster in progress");
                //            if (character.isBlocked) return nil; // booster can't remove block
                [tempChain addCharacter:character];
                tempChain.chainCreatedWith = ChainCreatedWithBooster;
                [tempSet addObject:tempChain];
                boosterAmount = [[[NSUserDefaults standardUserDefaults]
                                  valueForKey:[NSString stringWithFormat:@"%d_booster", BoosterTypeKillOne]] integerValue];
                boosterAmount--;
                booster.boosterAmount = boosterAmount;
                [[NSUserDefaults standardUserDefaults] setValue:@(boosterAmount)
                                                         forKey:[NSString stringWithFormat:@"%d_booster", BoosterTypeKillOne]];
            }
        }
        break;
        case BoosterTypeKillType: {
            if (booster.boosterAmount > 0) {
                NSLog(@"2 booster in progress");
                if (character.bonusType != BonusTypeNone)
                    break;
                tempSet = [[NSMutableSet alloc] initWithSet:[[level charactersWithOneTypeOfCharacter:character] firstObject]];
                boosterAmount = [[[NSUserDefaults standardUserDefaults]
                                  valueForKey:[NSString stringWithFormat:@"%d_booster", BoosterTypeKillType]] integerValue];
                boosterAmount--;
                booster.boosterAmount = boosterAmount;
                [[NSUserDefaults standardUserDefaults] setValue:@(boosterAmount)
                                                         forKey:[NSString stringWithFormat:@"%d_booster", BoosterTypeKillType]];
            }
        }
        break;
        case BoosterTypeKillRowOrColumn: {
            if (booster.boosterAmount > 0) {
                NSLog(@"3 booster in progress");
                tempSet = [[NSMutableSet alloc] initWithSet:[level getCharactersInOneColumnOrRowforBooster:character direction:delta]];
                boosterAmount = [[[NSUserDefaults standardUserDefaults]
                                  valueForKey:[NSString stringWithFormat:@"%d_booster", BoosterTypeKillRowOrColumn]] integerValue];
                boosterAmount--;
                booster.boosterAmount = boosterAmount;
                [[NSUserDefaults standardUserDefaults] setValue:@(boosterAmount)
                                                         forKey:[NSString stringWithFormat:@"%d_booster", BoosterTypeKillRowOrColumn]];
                tempChain.chainCreatedWith = ChainCreatedWithBooster;
            }
        }
        break;
        case BoosterTypeAddPlusOneToAim: {
            if (booster.boosterAmount > 0) {
                NSLog(@"4 booster in progress");
                if (character.bonusType != BonusTypeNone)
                    break;
                for (int i = 0; i < [[level.aimsObject getCharacterAimTypes] count]; i++) {
                    if (character.characterType == [[[level.aimsObject getCharacterAimTypes] objectAtIndex:i] integerValue]) {
                        NSSet * temp = [[level charactersWithOneTypeOfCharacter:character] firstObject];
                        _plusOneObject = [[level charactersWithOneTypeOfCharacter:character] lastObject];
                        [self dealWithFourthBooster:temp];
                        boosterAmount = [[[NSUserDefaults standardUserDefaults]
                                          valueForKey:[NSString stringWithFormat:@"%d_booster", BoosterTypeAddPlusOneToAim]] integerValue];
                        boosterAmount--;
                        booster.boosterAmount = boosterAmount;
                        [[NSUserDefaults standardUserDefaults] setValue:@(boosterAmount)
                                                                 forKey:[NSString stringWithFormat:@"%d_booster", BoosterTypeAddPlusOneToAim]];
                        booster.activated = NO;
                        tempSet = [[NSMutableSet alloc] initWithSet:temp];
                        NSNumber * number = [NSNumber numberWithInteger:1];
                        [tempSet addObject:number];
                        [self reDrawBoosterAmount:booster];
                    }
                }
            }
        }
        break;
        default: NSLog(@"ERROR WITH BOOSTER TYPE");
        break;
    }
    return tempSet;
}

- (void)dealWithFourthBooster:(NSSet *)set {
    if ([set count] > 0) {
        for (Character * character in [[set anyObject] characters]) {
            if (character.aimCountOnSingleSprite == 1) {
                character.aimCountOnSingleSprite = 2;
            } else if(character.aimCountOnSingleSprite == 0) {
                character.aimCountOnSingleSprite = 1;
            }
            character.isChanged = YES;
            [_plusOneObject addCharacterWithNumberToMutableSet:character];
        }
    }
}

- (NSInteger)dealWithScoresWithAimTypes:(NSArray *)types andLevel:(Aims *)aims andBooster:(Booster *)booster andChains:(NSSet *)chains andCurreneScores:(NSInteger *)scores withLevel:(Level *)level {
    NSInteger counter = [types count];
    NSInteger scoreOfBoosterChain = 0, plusOneScores = 0, checker = 0;
    
    for (int j = 0; j < [[[chains anyObject] characters] count]; j++) {
        Character * character = [[[chains anyObject] characters] objectAtIndex:j];
        for (int i = 0; i < counter; i++) {
            if ([[types objectAtIndex:i] integerValue] == character.characterType)
                plusOneScores += [self helperForDealWithScoresWithIndex:i withAims:aims withLevel:level withCharacter:character checker:&checker];
            if (([[types objectAtIndex:i] integerValue] == BLOCK_TYPE) && character.isBlocked)
                plusOneScores += [self helperForDealWithScoresWithIndex:i withAims:aims withLevel:level withCharacter:character checker:&checker];
        }
    }
    scoreOfBoosterChain = SCORE_FOR_SINGLE_CHARACTER * ([[[chains anyObject] characters] count] + plusOneScores);
    
    *scores += scoreOfBoosterChain; // common scores come back via reference
    [self reDrawBoosterAmount:booster]; // decrease booster amount
    
    if (checker == counter) level.endLevel = YES; // if boosters action led to end game
  
    return scoreOfBoosterChain;
}

- (NSInteger)helperForDealWithScoresWithIndex:(NSInteger)index withAims:(Aims *)aims withLevel:(Level *)level withCharacter:(Character *)character checker:(NSInteger *)checker {
    NSInteger targetAimScore = [[[aims getTargetToLevel] objectAtIndex:index] integerValue];
    NSInteger currentAimscore = [[[aims getCurrentScore] objectAtIndex:index] integerValue];
    currentAimscore += character.aimCountOnSingleSprite + 1; // +1 cuz here is already one character
    
    if (currentAimscore >= targetAimScore)  { // for redraw aim sprite in score bar
        [level.spritesForRemove addObject: [character spriteName]]; // remove sprites if challenge is done
        *checker += 1;
    }
    
    NSNumber * score = [NSNumber numberWithInteger:currentAimscore];
    [aims addScoreToAim:score atIndex:index];
    return character.aimCountOnSingleSprite;
}

- (void)reDrawBoosterAmount:(Booster *)booster {
//    animation HERE could be
    NSArray *arrScale =[ScaleUIonDevice scaleForBottomBar];
    SKSpriteNode * amountSprite = [booster.sprite.children firstObject];
    if (amountSprite != nil) {
        NSInteger newAmount = booster.boosterAmount;
        CGPoint position = amountSprite.position;
        NSString * name = [NSString stringWithFormat:@"booster_amount_%ld", (long)newAmount];
        [booster.sprite removeAllChildren];
        SKSpriteNode * newAmountSprite = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"booster_amount_%ld", (long)newAmount]];
        newAmountSprite.name = name;
        newAmountSprite.size = CGSizeMake(newAmountSprite.size.width * [[arrScale objectAtIndex:2] floatValue] , newAmountSprite.size.width * [[arrScale objectAtIndex:2] floatValue]);
        newAmountSprite.position = position;
        [booster.sprite addChild:newAmountSprite];
    }
}

- (void)unlockBoosterWithCurrentLevel:(NSInteger)current andBoosters:(NSArray *)boosterArray andScene:(GameScene *)scene {
    if ([boosterArray count] > 0) {
        NSArray *arrScale = [ScaleUIonDevice scaleForBottomBar];
        SKTextureAtlas * boosterAtlas = [SKTextureAtlas atlasNamed:@"Booster_available"];
        for (int i = 1; i <= [boosterArray count]; i++) {
            Booster * booster = [boosterArray objectAtIndex:i-1];
            CGPoint position = booster.sprite.position;
            if (current >= BOOSTER_FIRST_ACTIVATE_ON_LEVEL && i == 1) {
                [booster.sprite removeFromParent];
                SKTexture * texture = [boosterAtlas textureNamed:[NSString stringWithFormat:@"%d_booster", i]];
                booster.sprite = [SKSpriteNode spriteNodeWithTexture:texture];
                booster.sprite.size = CGSizeMake(scene.frame.size.width * [[arrScale objectAtIndex:0] floatValue], scene.frame.size.width * [[arrScale objectAtIndex:0] floatValue]);
                booster.isAvailable = YES;
                [scene addChild:booster.sprite];
            }
            if (current >= BOOSTER_SECOND_ACTIVATE_ON_LEVEL && i == 2) {
                [booster.sprite removeFromParent];
                SKTexture * texture = [boosterAtlas textureNamed:[NSString stringWithFormat:@"%d_booster", i]];
                booster.sprite = [SKSpriteNode spriteNodeWithTexture:texture];
                booster.sprite.size = CGSizeMake(scene.frame.size.width * [[arrScale objectAtIndex:0] floatValue], scene.frame.size.width * [[arrScale objectAtIndex:0] floatValue]);
                booster.isAvailable = YES;
                [scene addChild:booster.sprite];
            }
            if (current >= BOOSTER_THIRD_ACTIVATE_ON_LEVEL && i == 3) {
                [booster.sprite removeFromParent];
                SKTexture * texture = [boosterAtlas textureNamed:[NSString stringWithFormat:@"%d_booster", i]];
                booster.sprite = [SKSpriteNode spriteNodeWithTexture:texture];
                booster.sprite.size = CGSizeMake(scene.frame.size.width * [[arrScale objectAtIndex:0] floatValue], scene.frame.size.width * [[arrScale objectAtIndex:0] floatValue]);
                booster.isAvailable = YES;
                [scene addChild:booster.sprite];
            }
            if (current >= BOOSTER_FOURTH_ACTIVATE_ON_LEVEL && i == 4) {
                [booster.sprite removeFromParent];
                SKTexture * texture = [boosterAtlas textureNamed:[NSString stringWithFormat:@"%d_booster", i]];
                booster.sprite = [SKSpriteNode spriteNodeWithTexture:texture];
                booster.sprite.size = CGSizeMake(scene.frame.size.width * [[arrScale objectAtIndex:0] floatValue], scene.frame.size.width * [[arrScale objectAtIndex:0] floatValue]);
                booster.isAvailable = YES;
                [scene addChild:booster.sprite];
            }
            if (booster.isAvailable) {
                SKSpriteNode * spriteWithAMount = [[scene.sceneUI.boosterAmountSprites valueForKey:
                                                    [NSString stringWithFormat:@"booster_amount_%lu", (unsigned long)booster.boosterAmount]] copy];
                [booster.sprite addChild:spriteWithAMount];
            }
            booster.sprite.name = [NSString stringWithFormat:@"%d_booster", i];
            booster.sprite.zPosition = 8;
            booster.sprite.position = position;
        }
    }
}

+(NSMutableArray*) setBoostersWithBoosterSprites:(NSMutableDictionary *)boosterSprites gameScene:(GameScene *)scene {
    NSMutableArray *boosters = [NSMutableArray new];
    
    for (int i = 1; i <= BOOSTER_AMOUNT ; i++) {
        Booster * booster;
        switch (i) {
            case BoosterTypeKillOne: {
                booster = [[self alloc] initBoosterWithType:i
                                                            andSprite:[boosterSprites
                                                                       valueForKey:[NSString stringWithFormat:@"%d_booster_unavailable", i]]
                                                        withGameScene:scene];
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%d_booster", i]] integerValue] == 0) {
                    [[NSUserDefaults standardUserDefaults] setValue:@(BOOSTER_FIRST_BOOSTER_AMOUNT)
                                                             forKey:[NSString stringWithFormat:@"%d_booster", i]];
                }
                booster.boosterAmount = [[[NSUserDefaults standardUserDefaults]
                                          valueForKey:[NSString stringWithFormat:@"%d_booster", i]] integerValue];
            }
                break;
            case BoosterTypeKillType: {
                booster = [[self alloc] initBoosterWithType:i
                                                            andSprite:[boosterSprites
                                                                       valueForKey:[NSString stringWithFormat:@"%d_booster_unavailable", i]]
                                                        withGameScene:scene];
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%d_booster", i]] integerValue] == 0) {
                    [[NSUserDefaults standardUserDefaults] setValue:@(BOOSTER_SECOND_BOOSTER_AMOUNT)
                                                             forKey:[NSString stringWithFormat:@"%d_booster", i]];
                }
                booster.boosterAmount = [[[NSUserDefaults standardUserDefaults]
                                          valueForKey:[NSString stringWithFormat:@"%d_booster", i]] integerValue];
            }
                break;
            case BoosterTypeKillRowOrColumn: {
                booster = [[self alloc] initBoosterWithType:i
                                                            andSprite:[boosterSprites
                                                                            valueForKey:[NSString stringWithFormat:@"%d_booster_unavailable", i]]
                                                        withGameScene:scene];
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%d_booster", i]] integerValue] == 0) {
                    [[NSUserDefaults standardUserDefaults] setValue:@(BOOSTER_THIRD_BOOSTER_AMOUNT)
                                                             forKey:[NSString stringWithFormat:@"%d_booster", i]];
                }
                booster.boosterAmount = [[[NSUserDefaults standardUserDefaults]
                                          valueForKey:[NSString stringWithFormat:@"%d_booster", i]] integerValue];
            }
                break;
            case BoosterTypeAddPlusOneToAim: {
                booster = [[self alloc] initBoosterWithType:i andSprite:[boosterSprites
                                                                            valueForKey:[NSString stringWithFormat:@"%d_booster_unavailable", i]]
                                                        withGameScene:scene];
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%d_booster", i]] integerValue] == 0) {
                    [[NSUserDefaults standardUserDefaults] setValue:@(BOOSTER_FOURTH_BOOSTER_AMOUNT)
                                                             forKey:[NSString stringWithFormat:@"%d_booster", i]];
                }
                booster.boosterAmount = [[[NSUserDefaults standardUserDefaults]
                                          valueForKey:[NSString stringWithFormat:@"%d_booster", i]] integerValue];
            }
                break;
            default: NSLog(@"ERROR in BOOSTER SETUP");
                break;
        }
        booster.activated = NO;
        booster.isAvailable = NO;
        [boosters addObject:booster];
    }
    return boosters;
}

-(void) animationBoosterButton:(NSInteger)type
{
    NSLog(@"%d",type);
    NSString *atlasName =@"hammer";
    switch (type) {
        case 1:
            atlasName =@"";
            break;
        case 2:
            atlasName =@"";
            break;
        case 3:
            atlasName =@"hammer";
            break;
        case 4:
            atlasName =@"";
            break;
        default:
            break;
    }
    
    SKTextureAtlas * atlas = [SKTextureAtlas atlasNamed:[NSString stringWithFormat:@"%@", atlasName]];
    NSMutableArray * mutableArray = [NSMutableArray new];
    for (int i = 1; i <= [atlas.textureNames count]/3; i++) {
        SKTexture * texture = [atlas textureNamed:[NSString stringWithFormat:@"hammer_anim1%d", i]];
        [mutableArray addObject:texture];
    }
    SKAction * animation = [SKAction animateWithTextures:mutableArray timePerFrame:0.1];
    self.animationPressButon = [SKAction repeatActionForever:animation ];
}

@end
