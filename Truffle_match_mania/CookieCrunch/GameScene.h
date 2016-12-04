//
//  GameScene.h
//  CookieCrunch
//

//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//


#import <SpriteKit/SpriteKit.h>

@class Swap; // обратная связь
@class Level;
@class Booster;
@class HelperGame;
@class GameSceneUI;

@protocol NGHelperDelegete;

@interface GameScene : SKScene

@property (strong, nonatomic) id <NGHelperDelegete> myDelegate;

//Helpers
@property (assign, nonatomic) BOOL movesFreeze;
@property(assign, nonatomic)  BOOL screenTouchEnable;
@property (assign, nonatomic) NSUInteger movesLeft;
@property (assign, nonatomic) NSUInteger activeLevels;
@property (assign, nonatomic) NSUInteger currentLevel;
@property (strong, nonatomic) Level * level;
@property (assign, nonatomic) CGFloat tileWidth;
@property (assign, nonatomic) CGFloat tileHeight;
@property (assign, nonatomic) BOOL backgroundMusicIsEnabled;
@property (assign, nonatomic) BOOL volumeButtonISEnabled;
@property (strong, nonatomic) HelperGame *helpers;
@property (strong, nonatomic) NSMutableArray *arrayOfHelpers;
@property (assign, nonatomic) NSInteger windowShowNumber;
@property (assign, nonatomic) BOOL forbidRestart;


//Sprites
@property (strong, nonatomic) SKNode * charactersLayer;
@property (strong, nonatomic) SKSpriteNode * background;
@property (strong, nonatomic) SKNode *hoverLayer;
@property (strong, nonatomic) SKSpriteNode *image;
@property (nonatomic) SKLabelNode * levelLabel;
@property (copy, nonatomic) void (^buttonsBlock)();

//блок для обратной связи свайпа
@property (copy, nonatomic) void (^swipeHandler)(Swap * swap);
@property (assign, nonatomic) NSUInteger score;
@property (strong, nonatomic) Booster * booster;
@property (strong, nonatomic) NSMutableArray * boosters;
@property(strong, nonatomic) GameSceneUI * sceneUI;

- (id)initWithSize:(CGSize)size withFile:(NSString *)file;
-(void)setLevelScoreLabels;
- (void)decrementMoves;
- (void)addSpritesForCharacters:(NSSet *)characters;
//- (void)addTiles;
- (void)animateSwap:(Swap *)swap completion:(dispatch_block_t)completion;
- (void)animateInvalidSwap:(Swap *)swap completion:(dispatch_block_t)completion;
- (void)animateMatchedCharacters:(NSSet *)chains completion:(dispatch_block_t)completion;
- (void)animateGameOver;
- (void)animateBeginGame;
- (void)animateNewCharacters:(NSArray *)newColumns andFallingCharacters:(NSArray *)fallingColumns completion:(dispatch_block_t)completion;
- (void)removeAllCharactersSprites;
- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row;
- (void)unlockBoostersWithLevel:(NSInteger)currenteLevel;

-(void) removeSoundAction;
-(void) myDealloc;
@end

@protocol NGHelperDelegete

@required
-(void) showHelperForFourInRow:(GameScene*) scene withPosition:(CGPoint)position withHelper:(HelperGame*)helper withCharacter:(NSString*)spriteName;

-(void) showHelperForFiveInRow:(GameScene*) scene withPosition:(CGPoint)position withHelper:(HelperGame*)helper withCharacter:(NSString*)spriteName;

-(void) showHelperForBooster:(GameScene*) scene withNumber:(NSInteger)number withHelper:(HelperGame*)helper;

-(void) showHelperForPlusOne:(GameScene*) scene withPosition:(CGPoint)position withHelper:(HelperGame*)helper withCharacter:(NSString*)spriteName;

-(void) showHelperForPlusTwo:(GameScene*) scene withPosition:(CGPoint)position withHelper:(HelperGame*)helper withCharacter:(NSString*)spriteName;
//-(void) showHelperFirstMove:(GameScene*) scene;

@end
