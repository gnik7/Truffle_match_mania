//
//  GameSceneUI.h
//  CookieCrunch
//
//  Created by Nikita Gil' on 25.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameSceneUI : SKScene

@property (strong, nonatomic) SKLabelNode *message1Reshuffle;
@property (strong, nonatomic) SKLabelNode *message2Reshuffle;
@property (strong, nonatomic) SKLabelNode *levelLabel;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *movesLabel;
@property (strong, nonatomic) SKLabelNode *lifeLabel;
@property (strong, nonatomic) SKSpriteNode *pauseButton;
@property (strong, nonatomic) SKSpriteNode * scoreBarBackground;  //green line
@property (strong, nonatomic) SKSpriteNode * hornOfPlenty;
@property (strong, nonatomic) SKSpriteNode * scoreYellowLine;
@property(assign, nonatomic) BOOL firstTimeEndScoreLine;

@property (strong, nonatomic) NSMutableArray *getTargetToLevel;
@property (strong, nonatomic) NSMutableArray *getCharactersToLevel;
@property (strong, nonatomic) NSMutableArray *getAimsToLevel;

@property (strong, nonatomic) NSMutableDictionary * boosterSprites;
@property (strong, nonatomic) NSMutableDictionary * boosterAmountSprites;


- (id)initWithSize:(CGSize)size withClass:(id)className;
- (CGFloat)setScoreBarWithTarget:(NSUInteger)targetScore;
- (NSMutableArray*)setScoreBarWithStars:(NSArray *)stars;
- (void)revertUI;
- (NSArray *) setTopBar;
-(void) checkTarget:(NSString*)nameSprite toX:(CGFloat)positionX toY:(CGFloat)positionY;
-(void) removeTarget:(NSMutableArray *) array restart:(BOOL)flag;
-(void) removeCheck;
-(NSMutableArray *) setTopBarTargets;
-(void) animateLeftMovesInDeadLine;
- (void)setBoosterBar;
- (void)setHornOfPLenty;
-(void) drawPauseButton:(NSString *)fileName;
- (void) removeScoreLine;
-(void)setScoreBarYellow:(CGFloat)scaleY check:(BOOL)doScale test:(CGFloat)toYellowX;
-(SKAction*) animationForReshuffle;
-(void)setLabelForReshuffle1;
-(void)setLabelForReshuffle2;

@end
