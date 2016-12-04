//
//  KKLevel.h
//  CookieCrunch
//
//  Created by Кирилл on 04.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@class Aims;
@class PlusOnePlusTwo;
@class Character;
@class Tile;
@class Swap;
@class Chain;
@class GameScene;

@interface Level : NSObject

@property (assign, nonatomic) NSUInteger targetScore;
@property (assign, nonatomic) NSUInteger maximumMoves;
@property (assign, nonatomic) NSUInteger currentMoves;
//для возможных движений, заранее в этот массив попадут возможные ходы, и уже из них буду смотреть давать ли возможность пользователю делать ход. Также его можно использовать для подсказок юзеру.
@property (strong, nonatomic) NSMutableSet * possibleSwaps;

@property (assign, nonatomic) NSUInteger NumColumns;
@property (assign, nonatomic) NSUInteger NumRows;

@property (strong, nonatomic) Aims * aimsObject;
@property (assign, nonatomic) BOOL endLevel;
@property (strong, nonatomic) NSMutableArray * sprites; //for check
@property (strong, nonatomic) NSMutableArray * spritesForRemove;
@property (strong, nonatomic) NSMutableArray * spritesName; //names sprites in targets

@property (strong, nonatomic) PlusOnePlusTwo * plusOneObject;

@property (strong, nonatomic) NSMutableArray * leftMovesCharactersPositions;

- (NSSet *)shuffle;
- (Character *)characterAtColumn:(NSInteger)column row:(NSInteger)row;

- (id)initWithFile:(NSString *)fileName;
- (Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;
- (void)performSwap:(Swap *)swap;
- (BOOL)isPossibleSwap:(Swap *)swap;

- (NSSet *)removeMatches;

- (NSArray *)fillHoles;

- (NSArray *)topUpCharacters;

- (void)detectPossibleSwaps;

- (void)resetComboMultiplier;
- (void)checkTarget;
//- (NSSet *)removeCharacters:(NSSet *)chains;
- (NSMutableSet *) removeCharacters:(NSSet *) setOfChains;
- (NSMutableSet *) removeCharactersForBoosters:(NSSet *) setOfChains;
- (NSArray *)charactersWithOneTypeOfCharacter:(Character *)character;
- (void)clearArraysForRestart;
- (NSMutableSet *)getCharactersInOneColumnOrRowforBooster:(Character *)character direction:(NSInteger)direction;
- (Chain *)bonusHelperToDetectChains:(NSArray *)characters;
//- (Chain *) bonusHelperToDetectChains:(Character *)bombCharacter;
//- (void) bonusHelperToDetectSwaps:(Swap *)swap;
- (NSSet *)bonusBoomCalculateRangeWithCharacter:(Character *)character;
- (NSDictionary *)dealWithLeftMovesWithObject:(GameScene *)object;
- (void)calculateScores:(NSSet *)chains;

@end
