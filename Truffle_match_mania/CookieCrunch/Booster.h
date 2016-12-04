//
//  Booster.h
//  CookieCrunch
//
//  Created by Кирилл on 01.06.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    BoosterTypeKillOne = 1,
    BoosterTypeKillType,
    BoosterTypeKillRowOrColumn,
    BoosterTypeAddPlusOneToAim
} BoosterType;

@class Character;
@class Level;
@class Aims;
@class GameScene;

@interface Booster : SKNode

@property (assign, nonatomic) BOOL activated;
@property (assign, nonatomic) BOOL isAvailable;
@property (assign, nonatomic) BoosterType boosterType;
@property (assign, nonatomic) NSUInteger boosterAmount;
@property (strong, nonatomic) SKSpriteNode * sprite;
@property (strong, nonatomic) SKAction * animationPressButon;

- (id)initBoosterWithType:(BoosterType)boosterType andSprite:(SKSpriteNode *)sprite withGameScene:(id)scene;
- (NSMutableSet *)dealWithBooster:(Booster*)booster andCharacter:(Character *)character andLevel:(Level *)level withDelta:(NSInteger)delta;
//- (NSSet *)dealWithFourthBooster:(Booster *)booster objects:(NSMutableArray *)aimObjects aimTypes:(NSArray *)types;
- (NSInteger)dealWithScoresWithAimTypes:(NSArray *)types andLevel:(Aims *)aims
                        andBooster:(Booster *)booster
                         andChains:(NSSet *)chains
                       andCurreneScores:(NSInteger*)scores
                              withLevel:(Level *)level;
- (void)unlockBoosterWithCurrentLevel:(NSInteger)current andBoosters:(NSArray *)boosterArray andScene:(id)scene;
+(NSMutableArray*) setBoostersWithBoosterSprites:(NSMutableDictionary*)boosterSprites gameScene:(GameScene*)scene;
-(void) animationBoosterButton:(NSInteger)type;

@end
