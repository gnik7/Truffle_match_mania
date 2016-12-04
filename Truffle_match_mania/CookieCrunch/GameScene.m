//
//  GameScene.m
//  CookieCrunch
//
//  Created by Кирилл on 04.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

//этот отвечает за обнаружение свайпов

#import "GameScene.h"
#import "Character.h"
#import "Level.h"
#import "Swap.h"
#import "Settings.h"
#import "PlusOnePlusTwo.h"
#import "Aims.h"
#import "GameSceneUI.h"
#import "GameSceneWindow.h"
#import "Star.h"
#import "Bonus.h"
#import "MapScene.h"
#import "GameScene3.h"
#import "Booster.h"
#import "Chain.h"
#import "LeftMoves.h"
#import "GameSceneHelper.h"
#import "ProjectAnimationsAndActions.h"
#import "HelperGame.h"

//главное преимущество такого импорта: не нужно добавлять фреймворк в проект отдельно, Xcode добавит автоматически.
@import AVFoundation;

@interface GameScene ()

@property (strong, nonatomic) SKNode * tilesLayer;
@property (strong, nonatomic) SKNode * gameLayer;

//для свайпов
@property (assign, nonatomic)NSInteger swipeFromColumn;
@property (assign, nonatomic) NSInteger swipeFromRow;

@property (assign, nonatomic) CGFloat lastUpdateTime;
@property (assign, nonatomic) BOOL isNextTurn;
@property (strong, nonatomic) PlusOnePlusTwo * plusOneObject;
@property (assign, nonatomic) BOOL waitAnimationForSwipe;

//для подсветки
@property (strong, nonatomic) SKSpriteNode * selectionSprite;

//SOUND
@property (strong, nonatomic) SKAction * swapSound;
@property (strong, nonatomic) SKAction * invalidSwapSound;
@property (strong, nonatomic) SKAction * matchSound;
@property (strong, nonatomic) SKAction * fallingCharacterSound;
@property (strong, nonatomic) SKAction * addCharacterSound;
@property (strong, nonatomic) AVAudioPlayer * backgroundMusic;

//UI
@property (strong, nonatomic) SKCropNode * cropLayer;
@property (strong, nonatomic) SKNode * maskLayer;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *movesLabel;
@property (strong, nonatomic) SKLabelNode *blueLabel;
@property (strong, nonatomic) GameSceneWindow *window;
@property (assign, nonatomic) NSInteger lifes;
@property (assign, nonatomic) CGFloat scaleCharacter;
@property (assign, nonatomic) CGFloat scaleTile;
@property (assign, nonatomic) CGFloat scaleBlock;


//Helper
@property (assign, nonatomic) NSUInteger chainScore;
@property (assign, nonatomic) CGFloat scoreBarLevelIndex;
@property (assign, nonatomic) CGPoint scoreBarFromPointStart;
@property (strong, nonatomic) NSMutableArray * starSprites;
@property (strong, nonatomic) SKAction * starAnimation;

@property (assign, nonatomic) NSInteger leftMovesHelperCounter;
@property (strong, nonatomic) NSDictionary * allObjects;

@property (assign, nonatomic) CGPoint scoreBarGreenBegin;
@property (assign, nonatomic) CGPoint scoreBarYellowBegin;

//Booster
@property (assign, nonatomic) BOOL endGameStopBeginNexTurn;
@property (strong, nonatomic) SKSpriteNode * boosterbutton;

//Animation
@property (strong, nonatomic) NSMutableDictionary * animationCharacters;

@end

@implementation GameScene
{
    SKSpriteNode *buttonStart;
    BOOL _isLastStar;
    NSInteger _scoresDifferenceForBlock;
    NSArray * _aimSpritesPositions;
    ProjectAnimationsAndActions * _projectAnimationsAndActionsObject;
    Swap * _swapWithRepeatCharacers;
}

#pragma mark - Initialize

- (id)initWithSize:(CGSize)size withFile:(NSString *)file {
    if (self = [super initWithSize:size]) {
        _lastUpdateTime = 0.f;
//        центрирую картинку
        self.anchorPoint = CGPointMake(0.5, 0.5);
         NSLog(@"Gamescene  activeLevels - %d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"activeLevels"] intValue]);
        
        self.helpers = [[HelperGame alloc] init];
        self.arrayOfHelpers = [NSMutableArray array];
        NSLog(@"=====  %@", self.helpers.description);
        
        ScaleUIonDevice *scaleTile = [[ScaleUIonDevice alloc] init];
        NSArray *arrScale = [scaleTile scaleForTileGameScene];
        _scaleCharacter = [scaleTile scaleCharactersGameScene];
        _scaleTile = [[arrScale objectAtIndex:2]  floatValue];
        _scaleBlock = [scaleTile scaleBlockGameScene];
        
        _tileWidth = self.size.width * [[arrScale objectAtIndex:0] floatValue];
        _tileHeight = self.size.height * [[arrScale objectAtIndex:1] floatValue];
        
        _background = [SKSpriteNode spriteNodeWithImageNamed:@"background02"];
        _background.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        _background.zPosition = 1;
        [self addChild:_background];
        
        self.plusOneObject = [PlusOnePlusTwo new];
        self.level = [[Level alloc] initWithFile:file];
//        _endGameStopBeginNexTurn = NO;
        id block = ^(Swap * swap) {
//            self.view.userInteractionEnabled = NO;
            _waitAnimationForSwipe = NO;
            
            if ([self.level isPossibleSwap:swap]) {
                [self.level performSwap:swap];
                [self animateSwap:swap completion:^{
                    [self handleMatches:nil];
                }];
            } else {
                swap.characterA.isSwipeForBonus = NO;
                swap.characterB.isSwipeForBonus = NO;
                [self animateInvalidSwap:swap completion:^{
//                    self.view.userInteractionEnabled = YES;
                     _waitAnimationForSwipe = YES;
                }];
            }
        };
        
        self.swipeHandler = block;
//        добавляю пустые ноды, выступающие как слои
        self.gameLayer = [SKNode new];
        self.gameLayer.name = @"gameLayer";
        self.gameLayer.hidden = YES;
        self.gameLayer.zPosition = 2;
        [self addChild:self.gameLayer];
        
        CGPoint layerPosition = CGPointMake(-_tileWidth * self.level.NumColumns/2, -_tileHeight * self.level.NumRows/2);
        
//        добавляю клетки, предcтавляющие структуру борда, содержит спрайт ноды
        self.tilesLayer = [SKNode new];
        self.tilesLayer.position = layerPosition;
        self.tilesLayer.zPosition = 3;
        [self.gameLayer addChild:self.tilesLayer];
        
        self.charactersLayer = [SKNode new];
        self.charactersLayer.position = layerPosition;
        self.charactersLayer.zPosition = 6;
        [self.gameLayer addChild:self.charactersLayer];
        
       // [self addTiles:[self.level shuffle]]; Перенес в Shuffle чтобы 2 раза не вызывалась перемешка в level

        self.swipeFromColumn = self.swipeFromRow = NSNotFound;
        
//        для подсветки
        self.selectionSprite = [SKSpriteNode node];
        
//        загрузка предустановок звука
        [self preloadResources];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(helperLeftMoves)
                                                     name:KKLeftMovesEndsNotification object:nil];
//        self.activeLevels = [[[NSUserDefaults standardUserDefaults] objectForKey:@"activeLevels"] intValue];
        self.currentLevel = 2;
        
        //Добавляет все UI element на GameScene
        _sceneUI = [[GameSceneUI alloc] initWithSize:size withClass:self];
        _scoreBarLevelIndex = [self.sceneUI setScoreBarWithTarget:self.level.targetScore];
        _scoreBarFromPointStart = CGPointMake(self.sceneUI.scoreBarBackground.position.x - self.sceneUI.scoreBarBackground.size.width/2 + SCORE_BAR_BORDER_FIX_X_5_5S, 0);
        
        _scoreBarGreenBegin.x = POSITION_X * 0.6;
        _scoreBarYellowBegin.x = 0;
        _starSprites = [self.sceneUI setScoreBarWithStars:[self helpToDealWithScoreBar]];
        [self.sceneUI setBoosterBar];
//        [self setBoosters];
        _boosters = [NSMutableArray arrayWithArray:[Booster setBoostersWithBoosterSprites:self.sceneUI.boosterSprites gameScene:self]];
        [self.sceneUI setHornOfPLenty];
        
        _movesLabel = self.sceneUI.movesLabel;
        _leftMovesHelperCounter = -1;
        _scoresDifferenceForBlock = 0;
        
        _screenTouchEnable = YES; // Touch enable.  NO - need for window
        _waitAnimationForSwipe = YES; // Enable touch when animation active
        
        self.backgroundMusicIsEnabled = YES;
        self.volumeButtonISEnabled = YES;
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"Lifes"]];
        _lifes = TOTAL_LIFES - [arr count];
        
        self.windowShowNumber = 0;
        _forbidRestart = NO;

        [self beginGame];
        [self setTopBar];
        
        [self setLevelScoreLabels];
        [self setLifes];

        NSLog(@"Game Scene Loaded");
    }
    return self;
}

#pragma mark - SKSceneDelegate

- (void)dealloc {
    NSLog(@"GameScene deallocated");
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:KKLeftMovesEndsNotification object:nil];
    
}

-(void) myDealloc
{
    NSLog(@"GameScene Mydeallocated");
    _level = nil;
    self.window = nil;
    self.sceneUI = nil;
    
    [self removeAllActions];
    [self removeAllChildren];
    _levelLabel = nil;
    _background = nil;
    _hoverLayer = nil;
    _projectAnimationsAndActionsObject = nil;
    self.helpers = nil;
    _starAnimation = nil;
    _starSprites = nil;
    for (int i = 1; i <= SCORE_BAR_STARS_AMOUNT; i++)
    {
         SKSpriteNode *tmp = (SKSpriteNode*)[self childNodeWithName:[NSString stringWithFormat:@"score-line-star%d", i]];
        [tmp removeFromParent];
        tmp = nil;
    }
    self.starAnimation = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KKLeftMovesEndsNotification object:nil];
    self.myDelegate = nil;
    [self.selectionSprite removeFromParent];
    self.selectionSprite = nil;
    [self.backgroundMusic stop];
    self.backgroundMusic = nil;
    _boosters = nil;
    _booster = nil;
    _aimSpritesPositions = nil;
}

- (void)update:(NSTimeInterval)currentTime {
    if (_isNextTurn) {                                                              // for hint animation, works after user makes a first turn:
        if (currentTime - _lastUpdateTime > TIME_TO_START_HINT_ANIMATION) {
            _swapWithRepeatCharacers = [[self.level possibleSwaps] anyObject];
            SKAction * repeatForA = [_animationCharacters valueForKey:_swapWithRepeatCharacers.characterA.sprite.name];
            SKAction * repeatForB = [_animationCharacters valueForKey:_swapWithRepeatCharacers.characterB.sprite.name];
            if (repeatForA != nil && repeatForB != nil && !self.level.endLevel) {
                [_swapWithRepeatCharacers.characterA.sprite runAction:
                 [SKAction repeatActionForever:repeatForA] withKey:@"repeat"];
                [_swapWithRepeatCharacers.characterB.sprite runAction:
                 [SKAction repeatActionForever:repeatForB] withKey:@"repeat"];
                _isNextTurn = NO;
            }
        }
    } else {
        _lastUpdateTime = currentTime;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"Lifes"]];
    NSInteger countArray = [arr count];
    if (countArray>0)
    {
        NSDate *now = [[NSDate alloc]init];
        NSInteger index = 0;
        for (NSDate *d in arr)
        {
            NSDate *date2 = d;
            NSComparisonResult result = [date2 compare:now];
            
            if(result==NSOrderedAscending)
            {
                NSLog(@"now is in the future");
                NSLog(@"i= %lu", (long)index);
                NSLog(@"===LIFES in  %@", arr);
                index++;
            }
            else if(result == NSOrderedDescending)
            {
                // NSLog(@"now is in the past");
            }
        }
        if (index>0)
        {
            [arr removeObjectAtIndex:index-1];
            NSLog(@"--------LIFES in  %@", arr);
            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"Lifes"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        _lifes = 5 - [arr count];
        [self setLifes];
    }
    arr = nil;
}

- (void) restartGame
{
    self.sceneUI.movesLabel.text = @"0";
    [self.charactersLayer removeAllChildren];
    [self.tilesLayer removeAllChildren];
    NSSet * newCharacters = [self.level shuffle];
    [self addSpritesForCharacters:newCharacters];
    [self.sceneUI revertUI];
    [self.sceneUI removeCheck];
    [self.level clearArraysForRestart];
    [self.sceneUI removeTarget:self.level.spritesName restart:YES];
    [self.sceneUI setScoreBarYellow:0.1 check:YES test:0.0];
    [self.sceneUI setTopBarTargets];
    [self.sceneUI removeScoreLine];
    [self.sceneUI setScoreBarWithTarget:self.level.targetScore];

    
    _scoreBarYellowBegin.x = 0;
//    _scoreBarFromPointStart = CGPointMake(self.sceneUI.scoreBarBackground.position.x - self.sceneUI.scoreBarBackground.size.width/2 + SCORE_BAR_BORDER_FIX_X_5_5S, 0);
    
    [self shuffle];
    for (NSInteger i=0; i< [self.level.aimsObject.getCurrentScore count]; i++)
    {
        [self.level.aimsObject addScoreToAim:[NSNumber numberWithInteger:0] atIndex:i];
    }
    [self animateScoreInChallengeBar:nil];
    self.score = 0;
    self.movesLeft = self.level.maximumMoves;
    _sceneUI.scoreLabel.text = @"0";
    self.sceneUI.movesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.level.maximumMoves];
    self.sceneUI.movesLabel.fontColor = FONT_COLOR_WHITE;
    _waitAnimationForSwipe = YES;
    self.level.endLevel = NO; // 13.07
    _leftMovesHelperCounter = -1; // 13.07
    
    _background = nil;
    _projectAnimationsAndActionsObject = nil;
    [self preloadResources];
    self.volumeButtonISEnabled = YES;
    self.backgroundMusicIsEnabled = YES;
}

#pragma mark - Custom methods from controller ()

- (void)beginGame {
    self.movesLeft = self.level.maximumMoves;
    self.score = 0;
    [self updateLabels];
    [self.level resetComboMultiplier];
    [self animateBeginGame];
    [self shuffle];
}

- (void)shuffle {
    [self removeAllCharactersSprites];
    NSSet * newCharacters = [self.level shuffle];
    [self addTiles:newCharacters];
    [self addSpritesForCharacters:newCharacters];
    _starSprites = [self.sceneUI setScoreBarWithStars:[self helpToDealWithScoreBar]];
}

-(void) handleMatches:(NSSet *) chains {
    if (self.helpers.background == nil) {
        NSSet * actualChains = [NSSet new];
        NSArray * temp = [chains allObjects];
        NSMutableArray * tempForCheck = [NSMutableArray arrayWithArray:temp];
        if ([chains count] == 2) {                                                                  // 4 booster
            for (int i = 0; i < [tempForCheck count]; i++) {
                if ([[tempForCheck objectAtIndex:i] isKindOfClass:[NSNumber class]]) {
                    switch ([[tempForCheck objectAtIndex:i] integerValue]) {
                        case 1: {
                            [tempForCheck removeObject:[tempForCheck objectAtIndex:i]];
                            chains = [NSSet setWithArray:tempForCheck];
                            [self helpToanimateWithNewAndFallingColumns:[[chains anyObject] characters]];
                        }
                            break;
                        case 2: {
                            [tempForCheck removeObject:[tempForCheck objectAtIndex:i]];
                            actualChains = [NSSet setWithArray:tempForCheck];
                            [self.level calculateScores:actualChains];
                        }
                            break;
                        default:
                            break;
                    }
                }
            }
        } else if([chains count] == 1) {                                                            // 1,2,3 booster
    //        Chain *chain = [Chain new];
    //        chain.characters = [NSArray arrayWithArray:[self.level removeCharacters:chains]];
    //        actualChains = [NSSet setWithObject:chain];
            actualChains = [self.level removeCharacters:chains];
            actualChains = [actualChains setByAddingObjectsFromSet:chains];
            NSInteger temp = self.score;
            _chainScore = [_booster dealWithScoresWithAimTypes:[self.level.aimsObject getCharacterAimTypes]
                                                      andLevel:self.level.aimsObject
                                                    andBooster:_booster andChains:chains
                                              andCurreneScores:&temp
                                                     withLevel:self.level];
            self.score = temp;
        }
        else {
              actualChains = [[NSSet alloc] initWithSet:[self.level removeMatches]];
        }

        
        if ([actualChains count] > 0)
            [self animateScoreInChallengeBar:actualChains];
        [self.level checkTarget];
        
        if (([actualChains count] == 0) || actualChains == nil) {
            if (_leftMovesHelperCounter > 0 && self.score > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KKLeftMovesEndsNotification object:nil]; // NOTIFICATION
            } else if (_leftMovesHelperCounter == 0) {
                _leftMovesHelperCounter = -1;
                [self endingGame];
            } else {
                [self beginNextTurn];
            }
            return;
        }
        
        [self animateMatchedCharacters:actualChains completion:^{
            [self animateScoreBar];
            self.chainScore = 0;
            [self updateLabels];
            NSArray * fallingColumns = [self.level fillHoles];
            NSArray * newColumns = [self.level topUpCharacters];
            
            [self animateNewCharacters:newColumns andFallingCharacters:fallingColumns completion:^{
                self.booster.activated = NO;
                [self handleMatches:nil];
            }];
        }];
    }
}

-(void) beginNextTurn {
    [self.level resetComboMultiplier];
    [self.level detectPossibleSwaps];
  
    if ((self.level.possibleSwaps == nil) || ([self.level.possibleSwaps count] == 0))
    {
        [self.sceneUI setLabelForReshuffle1];
        
        [self.sceneUI.message1Reshuffle runAction:[self.sceneUI animationForReshuffle]  completion:^{
            [self.sceneUI setLabelForReshuffle2];
            [self.sceneUI.message2Reshuffle runAction:[self.sceneUI animationForReshuffle] completion:^{
                [self shuffle];
            }];
        }];
         // re-roll
    }
    
//    self.view.userInteractionEnabled = YES;
    _waitAnimationForSwipe = YES;
    if (self.movesFreeze )
    {
        [self decrementMoves];
        self.movesFreeze = NO;
    }
    _isNextTurn = YES;
}

-(NSInteger) countStarsInScoreBar
{
    NSInteger counter = 0;
    for (Star * star in _starSprites)
    {
        if (star.isActivated == YES)
        {
            counter++;
        }
    }
    return counter;
}

//для лэйблов
- (void)updateLabels {
    self.sceneUI.scoreLabel.text = [NSString stringWithFormat:@"%lu", (long)self.score];
    self.sceneUI.movesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.movesLeft];
}

- (void)decrementMoves {
    self.movesLeft--;
    if (self.movesLeft >= 1 && self.movesLeft <=5)
    {
        [self.sceneUI animateLeftMovesInDeadLine];
        _forbidRestart = YES;
    }
    else
    {
        self.sceneUI.movesLabel.fontColor = FONT_COLOR_WHITE;
    }
    [self updateLabels];
    
    if (self.level.endLevel) {
        if (self.movesLeft > 0)
        {
            self.level.currentMoves = self.movesLeft;
            _waitAnimationForSwipe = NO;                                // user can't move characters
//            _endGameStopBeginNexTurn = YES;
            if (self.score > 0) {
                _leftMovesHelperCounter = self.movesLeft;
                [self helperLeftMoves];
            } else {
                _leftMovesHelperCounter = -1;
            }
        }
        else if (self.movesLeft == 0)
        {
            [self endingGame];
        }
    } else if (self.movesLeft == 0 && !self.level.endLevel) {
        if ([self.arrayOfHelpers count] > 0 || self.helpers.background != nil)
        {
            self.windowShowNumber = HoverWindowGameMovesOut;
        }
        else
        {
            [self hoverWindow:HoverWindowGameMovesOut];
        }
    }
}

-(void) endingGame
{
    [self removeSoundAction];
    [self.backgroundMusic stop];
    self.backgroundMusic = nil;
    
    if ([self.arrayOfHelpers count] > 0 || self.helpers.background != nil)
    {
        self.windowShowNumber = HoverWindowGameCompleted;
    }
    else
    {
        [self hoverWindow:HoverWindowGameCompleted];
    }
}

#pragma mark - Conversion Routines

//колонну и ряд конвертим в точку
- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row {
    return CGPointMake(column * _tileWidth + _tileWidth/2, row * _tileHeight + _tileHeight/2);
}

//специально сделал NSInteger *, здесь колоны и ряды будут выходными параметрами. Метод может возвращать только одно значение, а мне нужно сразу 3! поэтому их я передаю и изменяю по ссылке!
- (BOOL)convertPoint:(CGPoint)point toColumn:(NSInteger *)column row:(NSInteger *)row {
    NSParameterAssert(column);
    NSParameterAssert(row);
    
    //    если валидная позиция в пределах слоя печений
    //    расчитывает отвечающие колону и ряд
    if (point.x >= 0 && point.x < self.level.NumColumns * _tileWidth && point.y >= 0 && point.y < self.level.NumRows * _tileHeight) {
        *column = point.x / _tileWidth;
        *row = point.y / _tileHeight;
        return YES;
    } else {
    //        invalid location
        *column = NSNotFound;
        *row = NSNotFound;
        return NO;
    }
}

#pragma mark - Game Setup

//метод создает затемнение за клеточками
- (void)addTiles:(NSSet *)characters {
    SKTextureAtlas * tilesAtlas = [SKTextureAtlas atlasNamed:@"Tiles"];

    for (NSInteger row = 0; row <= self.level.NumRows; row++) {
        for (NSInteger column = 0; column <= self.level.NumColumns; column++) {
            
            BOOL topLeft = (column > 0) && (row < self.level.NumRows) &&
            [self.level tileAtColumn:column - 1 row:row];
            
            BOOL bottomLeft = (column > 0) && (row > 0) &&
            [self.level tileAtColumn:column - 1 row:row - 1];
            
            BOOL topRight = (column < self.level.NumColumns) && (row < self.level.NumRows) &&
            [self.level tileAtColumn:column row:row];
            
            BOOL bottomRight = (column < self.level.NumColumns) && (row > 0) &&
            [self.level tileAtColumn:column row:row - 1];
            
//            клетки пронумерованы от 0 до 15, соотв. к битовым маскам, что создает совмещение этих четырех значений
            NSUInteger value = topLeft | topRight << 1 | bottomLeft << 2 | bottomRight << 3;
            
//            значение 0 (никаких клеток), 6 и 9 (две противоположные клетки) не рисуются
            if (value != 0 && value != 6 && value != 9) {
                SKTexture * texture = [tilesAtlas textureNamed:[NSString stringWithFormat:@"Tile_%lu", (long)value]];
                SKSpriteNode * tileNode = [SKSpriteNode spriteNodeWithTexture:texture];
                CGPoint point = [self pointForColumn:column row:row];
//                NSLog(@"x = %0.2f, y = %0.2f", point.x, point.y);
                point.x -= _tileWidth / 2;
                point.y -= _tileHeight / 2;
                tileNode.position = point;
                tileNode.size = CGSizeMake(tileNode.size.width * _scaleTile, tileNode.size.height * _scaleTile);
                tileNode.alpha = 0.5f;
                [self.tilesLayer addChild:tileNode];
            }
        }
    }
}

- (void)addSpritesForCharacters:(NSSet *)characters {
    SKTextureAtlas * charactersAtlas = [SKTextureAtlas atlasNamed:@"Characters"];
    for (Character * character in characters) {
        SKTexture * texture = [charactersAtlas textureNamed:[NSString stringWithFormat:@"%@", [character spriteName]]];
        SKSpriteNode * sprite = [SKSpriteNode spriteNodeWithTexture:texture];
        sprite.name = [character spriteName];
        sprite.size = CGSizeMake(sprite.size.width * _scaleCharacter , sprite.size.height * _scaleCharacter);
        sprite.position = [self pointForColumn:character.column row:character.row];
        [self.charactersLayer addChild:sprite];
        character.sprite = sprite;
        
        if (character.isBlocked) {
            SKSpriteNode * blockSprite = [SKSpriteNode spriteNodeWithImageNamed:@"box"];
            blockSprite.size = CGSizeMake(blockSprite.size.width * _scaleBlock,  blockSprite.size.height * _scaleBlock);
//            blockSprite.name = @"block";
            [character.sprite addChild:blockSprite];
        }
        
        character.sprite.alpha = 0;
        character.sprite.xScale = character.sprite.yScale = 0;
        
        [character.sprite runAction:[SKAction sequence:@[
                                                      [SKAction waitForDuration:0.25 withRange:0.5],
                                                      [SKAction group:@[
                                                                        [SKAction fadeInWithDuration:0.25],
                                                                        [SKAction scaleTo:1.0 duration:0.25]]]]]];
    }
}

- (void)removeAllCharactersSprites {
    [self.charactersLayer removeAllChildren];
}

#pragma mark - Highlight (Selection Indicator)

- (void)showSelectionIndicatorForCharacter:(Character*)character {
    if (self.selectionSprite.parent != nil) {
        [self.selectionSprite removeFromParent];
    }
//    [self animateCharacter:character.sprite animateOneTime:YES];
}

//обратный подсветке метод
- (void)hideSelectionIndicator {
    [self.selectionSprite runAction:[SKAction sequence:@[
                                                         [SKAction fadeOutWithDuration:0.3],
                                                         [SKAction removeFromParent]]]];
}

#pragma mark - Animations

-(void) animateScoreBar {
    CGFloat moveAmount = _chainScore / _scoreBarLevelIndex;
    CGFloat toYellowX = 0;
    CGFloat sum = _scoreBarYellowBegin.x + moveAmount;
    if (sum <= (self.sceneUI.scoreBarBackground.size.width - SCORE_BAR_BORDER_FIX_X_5_5S)) {
        toYellowX = _scoreBarYellowBegin.x + moveAmount;
        CGFloat needScale = [[[ScaleUIonDevice scaleForScoreLine] objectAtIndex:0] floatValue] * toYellowX/self.sceneUI.scoreBarBackground.size.width;
        [self.sceneUI setScoreBarYellow:needScale check:YES test:toYellowX];
         _scoreBarYellowBegin.x = toYellowX;
    }
    else
    {
        if (self.sceneUI.firstTimeEndScoreLine)
        {
            CGFloat needScale = [[[ScaleUIonDevice scaleForScoreLine] objectAtIndex:0] floatValue] * 1;
            [self.sceneUI setScoreBarYellow:needScale check:YES test:self.sceneUI.scoreBarBackground.size.width];
            _scoreBarYellowBegin.x = sum;
            self.sceneUI.firstTimeEndScoreLine = NO;
        }
        else
        {
            [self.sceneUI setScoreBarYellow:0 check:NO test:0.0];
            _scoreBarYellowBegin.x = sum;
        }
    }
    
    CGFloat forStars = (_scoreBarYellowBegin.x - self.sceneUI.scoreBarBackground.size.width);
    
    for (Star * star in _starSprites) {
        if (star.position.x <= forStars && star.isActivated == NO) {
            [star runAction:star.animation];
            star.isActivated = YES;
        }
    }
}

- (void)animateSwap:(Swap *)swap completion:(dispatch_block_t)completion {
    swap.characterA.sprite.zPosition = 50;
    swap.characterB.sprite.zPosition = 40;
    
    const NSTimeInterval Duration = 0.3;
    
    SKAction * moveA = [SKAction moveTo:swap.characterB.sprite.position duration:Duration];
    moveA.timingMode = SKActionTimingEaseOut;
    [swap.characterA.sprite runAction:[SKAction sequence:@[moveA, [SKAction runBlock:completion]]]];
    
    SKAction * moveB = [SKAction moveTo:swap.characterA.sprite.position duration:Duration];
    moveA.timingMode = SKActionTimingEaseOut;
    [swap.characterB.sprite runAction:moveB];
    
//    sound
    [self runAction:self.swapSound];
}

- (void)animateInvalidSwap:(Swap *)swap completion:(dispatch_block_t)completion {
    swap.characterA.sprite.zPosition = 50;
    swap.characterB.sprite.zPosition = 40;
    
    const NSTimeInterval Duration = 0.2f;
    
    SKAction * moveA = [SKAction moveTo:swap.characterB.sprite.position duration:Duration];
    moveA.timingMode = SKActionTimingEaseOut;
    
    SKAction * moveB = [SKAction moveTo:swap.characterA.sprite.position duration:Duration];
    moveB.timingMode = SKActionTimingEaseOut;
    
    [swap.characterA.sprite runAction:[SKAction sequence:@[moveA, moveB, [SKAction runBlock:completion]]]];
    [swap.characterB.sprite runAction:[SKAction sequence:@[moveB, moveA]]];
    
    [self runAction:self.invalidSwapSound];
}

- (void)animateMatchedCharacters:(NSSet *)chains completion:(dispatch_block_t)completion {
    for (Chain * chain in chains) {
        self.score += chain.score;
        _chainScore += chain.score;
        chain.score = _chainScore;
        [self animateScoreForChain:chain];
        for (Character * character in chain.characters) {
            if (character.sprite != nil) {
                if (character.isBlocked && chain.chainCreatedWith != ChainCreatedWithBooster) {   // remove only block
                    [character.sprite removeAllChildren];
                    character.isBlocked = NO;
                    continue;
                }                                                                                   // else - remove sprite with block
                
                character.isBlocked = NO;
                character.aimCountOnSingleSprite = 0;
                SKAction * scaleAction = [SKAction scaleTo:0.1 duration:0.3];
                scaleAction.timingMode = SKActionTimingEaseOut;
                SKEmitterNode * emitter;
                if (character.characterType < 7) {
                    emitter = [SKEmitterNode nodeWithFileNamed:[NSString stringWithFormat:@"Magic_%d.sks", character.characterType]];
                } else {
                    emitter = [SKEmitterNode nodeWithFileNamed:@"Magic_0.sks"];
                }
                
                emitter.zPosition = 70;
                SKAction * wait = [SKAction waitForDuration:0.35f];

                emitter.position = [self pointForColumn:character.column row:character.row];
                [self.charactersLayer addChild:emitter];
                
                SKAction * removeEmitter = [SKAction runBlock:^{
                    [emitter removeFromParent];
                }];
                if (character.bonusType != BonusTypeNone && !character.bonusActivated) {
                    Bonus * bonus = [[Bonus alloc] initWithCharacter:character andScale:_scaleCharacter withGameScane:self withHelpers:_helpers];
                    [self.charactersLayer addChild:bonus];
                    [character.sprite runAction:[SKAction sequence:@[scaleAction, wait, removeEmitter, [SKAction removeFromParent]]]];
                    character.sprite = bonus;
                    character.bonusActivated = YES;
                } else {
                    [character.sprite runAction:[SKAction sequence:@[scaleAction, wait, removeEmitter, [SKAction removeFromParent]]]];
                    character.sprite = nil;
                }
            } else {
                NSLog(@"character.sprite = nil!!!");
            }
        }
    }
    [self runAction:self.matchSound];
    [self runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:0.3],
                                         [SKAction runBlock:completion]]]];
}

- (void)animateNewCharacters:(NSArray *)newColumns andFallingCharacters:(NSArray *)fallingColumns completion:(dispatch_block_t)completion {
    NSInteger count = [newColumns count];
    NSMutableArray * mergeArray = [NSMutableArray arrayWithArray:newColumns];
    [mergeArray addObjectsFromArray:fallingColumns];
    
    __block NSTimeInterval longestDuration = 0;
    
    NSInteger startRow = 0;
    NSInteger newColumnsAmount = count;
    //
    SKTextureAtlas * charactersAtlas = [SKTextureAtlas atlasNamed:@"Characters"];
    for (Character * character in mergeArray) {
        
        if (newColumnsAmount > 0) {
            startRow = character.row + 1;
            newColumnsAmount--;
        }
        
        CGFloat delay = 0.1;
        CGPoint newPosition = [self pointForColumn:character.column row:character.row];
        CGFloat duration = ((character.sprite.position.y - newPosition.y) / _tileHeight) * 0.1f;
        
        if (character.sprite == nil && startRow != 0) { // for new characters
            SKTexture * texture = [charactersAtlas textureNamed:[NSString stringWithFormat:@"%@", [character spriteName]]];
            SKSpriteNode * sprite = [SKSpriteNode spriteNodeWithTexture:texture];
            sprite.name = [character spriteName];
            sprite.position = [self pointForColumn:character.column row:startRow];
            sprite.size = CGSizeMake(sprite.size.width * _scaleCharacter , sprite.size.height * _scaleCharacter);
            [self.charactersLayer addChild:sprite];
            character.sprite = sprite;
            character.sprite.alpha = 0;
            delay = 0.1f + 0.05f * (count--);
            duration = (startRow - character.row) * 0.01 + delay;
        }
        
        //            4 Расчет какая анимация самая длинная.
        longestDuration = MAX(longestDuration, duration + delay);
        //            5 создание анимации с учетом задержки, движения и звука.
        SKAction * moveAction = [SKAction moveTo:newPosition duration:duration];
        moveAction.timingMode = SKActionTimingEaseOut;
        
        [character.sprite runAction:[SKAction sequence:@[
                                                      [SKAction waitForDuration:delay],
                                                      [SKAction group:@[[SKAction fadeInWithDuration:1.f], moveAction/*, self.fallingCookieSound*/]]]]];
    }
    [self helpToanimateWithNewAndFallingColumns:nil];
    [self runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:longestDuration],
                                         [SKAction runBlock:completion]]]];
}

- (void)animateScoreForChain:(Chain *)chain {
//    средняя точка цепи
    Character * firstCharacter = [chain.characters firstObject];
    Character * lastCharacter = [chain.characters lastObject];
    CGPoint centerPosition = CGPointMake((firstCharacter.sprite.position.x + lastCharacter.sprite.position.x)/2,
                                       (firstCharacter.sprite.position.y + lastCharacter.sprite.position.y)/2 - 8);
    
//    добавить лэйбл для очков, который медленно всплывает над цепью
    SKLabelNode * scoreLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
    scoreLabel.fontSize = 16;
    scoreLabel.text = [NSString stringWithFormat:@"%lu", (long)chain.score];
    scoreLabel.position = centerPosition;
    scoreLabel.zPosition = 20;
    [self.charactersLayer addChild:scoreLabel];
    
    SKAction * moveAction = [SKAction moveBy:CGVectorMake(0, 3) duration:0.7f];
//    timingMode - тип прохождения анимации, SKActionTimingEaseOut - медленно вначале, быстро в средине и медленно в конце.
    moveAction.timingMode = SKActionTimingEaseOut;
    [scoreLabel runAction:[SKAction sequence:@[moveAction, [SKAction removeFromParent]]]];
}

//весь gameLayer анимировано уходит за экран
- (void)animateGameOver {
    SKAction * action = [SKAction moveBy:CGVectorMake(0, -self.size.height) duration:0.3f];
    action.timingMode = SKActionTimingEaseIn;
    [self.gameLayer runAction:action];
}

//весь gameLayer анимировано выходит из-за экрана
- (void)animateBeginGame {
    self.gameLayer.hidden = NO;
    
    self.gameLayer.position = CGPointMake(0, self.size.height);
    SKAction * action = [SKAction moveBy:CGVectorMake(0, -self.size.height) duration:0.3f];
    action.timingMode = SKActionTimingEaseOut;
    [self.gameLayer runAction:action];
}

- (void) animateScoreInChallengeBar:(NSSet*)chains {
    Character *currentCharacter = [[Character alloc] init];
    NSArray * arrayTargetToLevel = [NSArray arrayWithArray: [self.level.aimsObject getTargetToLevel]];
    NSArray * arrayOfAims = [NSArray arrayWithArray:[self.level.aimsObject getCharacterAimTypes]];
    
    for (NSInteger i = 0; i < [arrayTargetToLevel count]; i++) {
        NSInteger tmp = [[arrayTargetToLevel objectAtIndex:i] integerValue];
        if (tmp != (long)0) {
            currentCharacter.characterType = [[[self.level.aimsObject getCharactersToLevel] objectAtIndex:i] integerValue];
            NSString *spriteName;
            if ([[arrayOfAims objectAtIndex:i] integerValue] == BLOCK_TYPE)
                spriteName = @"blockLabel";
            else                                                                    //if not a block
                spriteName = [NSString stringWithFormat:@"%@Label", [currentCharacter spriteName]];
            
            SKLabelNode * oldLabel = [(SKLabelNode*)[self childNodeWithName:spriteName] copy];
            SKLabelNode * label = (SKLabelNode*)[self childNodeWithName:spriteName];
            // aim characters already checked
            if (label == nil) {
                NSLog(@"aim characters already checked SO CONTINUE");
                continue;
            }
            [label removeFromParent];
            label = nil;
            label = oldLabel;
            oldLabel = nil;
//            label.text = [NSString stringWithFormat:@"%@/%@", [[self.level.aimsObject getCurrentScore] objectAtIndex:i],
//                                                            [[self.level.aimsObject getTargetToLevel] objectAtIndex:i]];
            [self addChild:label];
            
            for (Chain * chain in chains) { // cycle for only one iterate (if single chain)
                if (chain.chainCreatedWith == ChainCreatedWithBooster) {                            // Booster
                    [_projectAnimationsAndActionsObject animateFlyingScoreToAimBarWithChain:chain withLabelsPosition:_aimSpritesPositions
                                                                             withAimTypePos:i
                                                                                      label:label];
                    continue;
                }
                if (chain.chainCreatedWith == ChainCreatedWithBonus) {                              // Bonus
                    [_projectAnimationsAndActionsObject animateFlyingScoreToAimBarWithChain:chain withLabelsPosition:_aimSpritesPositions
                                                                                withAimTypePos:i
                                                                                      label:label];
                    continue;
                }
                NSUInteger currentType = [[chain.characters objectAtIndex:0] characterType];
                NSUInteger currentInArray = [[arrayOfAims objectAtIndex:i] integerValue];
                if (currentInArray == currentType) {                                                // Type
                    [_projectAnimationsAndActionsObject animateFlyingScoreToAimBarWithChain:chain withLabelsPosition:_aimSpritesPositions
                                                                             withAimTypePos:i
                                                                                      label:label];
                }
                if ([[arrayOfAims objectAtIndex:i] integerValue] == BLOCK_TYPE) {                   // Block
                    if (_scoresDifferenceForBlock < [[[self.level.aimsObject getCurrentScore] objectAtIndex:i] integerValue]) {
                        _scoresDifferenceForBlock = [[[self.level.aimsObject getCurrentScore] objectAtIndex:i] integerValue];
                        [_projectAnimationsAndActionsObject animateFlyingScoreToAimBarWithChain:chain withLabelsPosition:_aimSpritesPositions
                                                                                 withAimTypePos:i
                                                                                          label:label];
                    }
                }
            }
        }
    }
    
    if ([self.level.spritesForRemove count] > 0)
        [self.sceneUI removeTarget:self.level.spritesForRemove restart:NO]; // почистить этот массив если цель выполнена!
}

#pragma mark - Animation Helper

- (void)helpToanimateWithNewAndFallingColumns:(NSArray *)array {
    if ([array count] > 0) {
        [PlusOnePlusTwo addSpriteWithArray:array withGameScane:self withHelpers:self.helpers];
    } else {
        [self.level.plusOneObject.charactersWithNumbers enumerateObjectsUsingBlock:^(Character * character, BOOL *stop) {
            if (character.isChanged == NO) {
                character.aimCountOnSingleSprite = 0;
                [self.level.plusOneObject.charactersWithNumbers removeObject:character];
            }
        }];
        
        NSArray * newArray = [self.level.plusOneObject.charactersWithNumbers allObjects];
        [PlusOnePlusTwo addSpriteWithArray:newArray withGameScane:self withHelpers:self.helpers];
    }
}

- (NSArray *)helpToDealWithScoreBar {
    CGPoint scoreBarFirstStarPos = CGPointMake(-self.sceneUI.scoreBarBackground.size.width +
                                       SCORE_BAR_BORDER_FIX_X_5_5S + self.sceneUI.scoreBarBackground.size.width/10, 0);
    CGPoint scoreBarSecondStarPos = CGPointMake(-self.sceneUI.scoreBarBackground.size.width/2 +
                                                SCORE_BAR_BORDER_FIX_X_5_5S , 0);
    CGPoint scoreBarThirdStarPos = CGPointMake( -self.sceneUI.scoreBarBackground.size.width/10 - SCORE_BAR_BORDER_FIX_X_5_5S , 0);
    NSArray * resultArray = [NSArray arrayWithObjects:
                             [NSValue valueWithCGPoint:scoreBarFirstStarPos],
                             [NSValue valueWithCGPoint:scoreBarSecondStarPos],
                             [NSValue valueWithCGPoint:scoreBarThirdStarPos], nil];
    return resultArray;
}

#pragma mark - Resources

-(void) loadBackgroundMusic
{
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"Mining by Moonlight" withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic play];
}

-(void) loadSoundAction
{
        self.swapSound = [SKAction playSoundFileNamed:@"Chomp.wav" waitForCompletion:NO];
        self.invalidSwapSound = [SKAction playSoundFileNamed:@"Error.wav" waitForCompletion:NO];
        self.matchSound = [SKAction playSoundFileNamed:@"Ka-Ching.wav" waitForCompletion:NO];
        self.fallingCharacterSound = [SKAction playSoundFileNamed:@"Scrape.wav" waitForCompletion:NO];
        self.addCharacterSound = [SKAction playSoundFileNamed:@"Drip.wav" waitForCompletion:NO];
}

//чтоб не пересоздавать SKAction каждый раз когда нужно проиграть звук, лучше его загрузить один раз и переиспользовать их
- (void)preloadResources {
//    [self loadSoundAction];
//    [self loadBackgroundMusic];
  
    _projectAnimationsAndActionsObject = [[ProjectAnimationsAndActions alloc] initWithGameScene:self];
    _animationCharacters = [_projectAnimationsAndActionsObject getCharactersAnimation];
    [_projectAnimationsAndActionsObject characterAnimationRelease];
//    animation
    
    NSMutableArray * stars = [NSMutableArray new];
    for (int i = 1; i <= SCORE_BAR_STARS_AMOUNT; i++) {
        SKSpriteNode * starAnimate = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"score-line-star%d", i]];
        [stars addObject:starAnimate];
        starAnimate.name = [NSString stringWithFormat:@"score-line-star%d", i];
    }
    _starAnimation = [SKAction animateWithTextures:stars timePerFrame:0.2];
}

-(void) removeSoundAction
{
    self.swapSound =  nil;
    self.invalidSwapSound = nil;
    self.matchSound = nil;
    self.fallingCharacterSound = nil;
    self.addCharacterSound = nil;
}

#pragma mark - Boosters

- (void)boosterActivateWithPoint:(CGPoint)location {
//  initialize boosters:
    for (int i = 1; i <= BOOSTER_AMOUNT; i++) {
        SKSpriteNode * boosterButton = (SKSpriteNode*)[self childNodeWithName:[NSString stringWithFormat:@"%d_booster", i]];
        if ([boosterButton containsPoint:location] && !_booster.activated) {
            switch (i) {
                case 1:
                {
                    _booster = [_boosters objectAtIndex:BoosterTypeKillOne-1];
                }
                    break;
                case 2:
                    _booster = [_boosters objectAtIndex:BoosterTypeKillType-1];
                    break;
                case 3:
                {
                    _booster = [_boosters objectAtIndex:BoosterTypeKillRowOrColumn-1];
                    [_booster animationBoosterButton:3];
                    _boosterbutton = (SKSpriteNode*)[self childNodeWithName:@"3_booster"];
                    NSLog(@"==== %@ ",_boosterbutton.description);
                    [_boosterbutton runAction:_booster.animationPressButon withKey:@"BoosterAnimation"];
                }
                    break;
                case 4:
                    _booster = [_boosters objectAtIndex:BoosterTypeAddPlusOneToAim-1];
                    break;
                default: NSLog(@"ERROR in boosterActivateWithPoint");
                    break;
            }
            _booster.activated = YES;
        }
    }
}

#pragma mark - LeftMoves

- (void)helperLeftMoves {
    if (_leftMovesHelperCounter > 0) {
        __block NSDictionary * allObjects = [self.level dealWithLeftMovesWithObject:self];
        CGPoint toPoint = [[allObjects valueForKey:@"point"] CGPointValue];
        CGPoint fromPoint = [[allObjects valueForKey:@"hornPos"] CGPointValue];// horn of plenty position
        [self.charactersLayer enumerateChildNodesWithName:@"hornOfPlentyLine" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
        [LeftMoves drawTrajectoryFromPoint:fromPoint
                                   toPoint:toPoint
                                withObject:self.charactersLayer completion:^{
                                    Character * character = [allObjects valueForKey:@"character"]; // center character, like bomb
                                    allObjects = nil;
                                    NSSet * set = [self.level bonusBoomCalculateRangeWithCharacter:character];
                                    Chain * chain = [set anyObject];
                                    chain.chainCreatedWith = ChainCreatedWithBonus;
                                    [chain addCharacter:character];
                                    set = [set setByAddingObject:[NSNumber numberWithInteger:2]];
                                    _leftMovesHelperCounter--;
                                    self.movesLeft--;
                                    [self handleMatches:set];
                                }];
    }
}

#pragma mark - Touches

-(void) functionalButtons:(CGPoint)location
{
    SKSpriteNode *pauseButton = (SKSpriteNode*)[self childNodeWithName:@"pauseButton"];
    if ([pauseButton containsPoint:location])
    {
        [self hoverWindow:HoverWindowPause];
        _screenTouchEnable = NO;
    }
}

-(void) windowsButtons:(CGPoint)location
{
    SKSpriteNode *continueButton = (SKSpriteNode*)[_window.hoverLayer childNodeWithName:@"continueButton"];
    SKSpriteNode *retryButton = (SKSpriteNode*)[_window.hoverLayer childNodeWithName:@"retryButton"];
    SKSpriteNode *forwardButton = (SKSpriteNode*)[_window.hoverLayer childNodeWithName:@"forwardButton"];
    SKSpriteNode *shareButton = (SKSpriteNode*)[_window.hoverLayer childNodeWithName:@"shareButton"];
    SKSpriteNode *giveUpButton = (SKSpriteNode*)[_window.hoverLayer childNodeWithName:@"giveUpButton"];
    SKSpriteNode *closeButton = (SKSpriteNode*)[_window.hoverLayer childNodeWithName:@"closeButton"];
    SKSpriteNode *restartButton = (SKSpriteNode*)[_window.hoverLayer childNodeWithName:@"restartButton"];
    
    self.buttonsBlock = nil;
    if ([continueButton containsPoint:location])
    {
        id block = ^(){
        [_window.hoverLayer removeFromParent];
        self.window = nil;
        _screenTouchEnable = YES;
        };
        self.buttonsBlock = block;
        [self.window highlightButon:continueButton withBlock:self.buttonsBlock];
        [self.sceneUI drawPauseButton:@"pause_button_1"];
    }
    if ([restartButton containsPoint:location])
    {
        if (_lifes > 0)
        {
            id block = ^(){
                _screenTouchEnable = YES;
                [_window.hoverLayer removeFromParent];
                self.window = nil;
                [self restartGame];
            };
            self.buttonsBlock = block;
        }
        else
        {
            id block = ^(){
                [_window.hoverLayer removeFromParent];
                self.window = nil;
                _screenTouchEnable = YES;
                SKView *skView = (SKView *)self.view;
                SKTransition *reveal = [SKTransition flipVerticalWithDuration:0.5];
                SKScene *map = [[MapScene alloc] initWithSize:skView.bounds.size];
                [self.view presentScene:map transition:reveal];
                [self myDealloc];
            };
            self.buttonsBlock = block;
        }
        [self.window highlightButon:restartButton withBlock:self.buttonsBlock];
        [self.sceneUI drawPauseButton:@"pause_button_1"];
    }
    if ([retryButton containsPoint:location])
    {
        if (_lifes > 0)
        {
            id block = ^(){
                _screenTouchEnable = YES;
                [_window.hoverLayer removeFromParent];
                self.window = nil;
                [self restartGame];
            };
            self.buttonsBlock = block;
        }
        else
        {
            id block = ^(){
                [_window.hoverLayer removeFromParent];
                self.window = nil;
                _screenTouchEnable = YES;
                SKView *skView = (SKView *)self.view;
                SKTransition *reveal = [SKTransition flipVerticalWithDuration:0.5];
                SKScene *map = [[MapScene alloc] initWithSize:skView.bounds.size];
                [self.view presentScene:map transition:reveal];
                [self myDealloc];
            };
            self.buttonsBlock = block;
        }
        [self.window highlightButon:retryButton withBlock:self.buttonsBlock];
        [self.sceneUI drawPauseButton:@"pause_button_1"];
    }
    if ([forwardButton containsPoint:location])
    {
        id block = ^(){
            [_window.hoverLayer removeFromParent];
            self.window = nil;
            _screenTouchEnable = YES;
            SKView *skView = (SKView *)self.view;
            SKTransition *reveal = [SKTransition flipVerticalWithDuration:0.5];
            SKScene *map = [[MapScene alloc] initWithSize:skView.bounds.size];
            [self.view presentScene:map transition:reveal];
            [self myDealloc];
        };
        self.buttonsBlock = block;
        [self.window highlightButon:forwardButton withBlock:self.buttonsBlock];
    }
    if ([shareButton containsPoint:location])
    {
        id block = ^(){
        NSString *scoreLevel = [NSString stringWithFormat:@"%@_%@", self.sceneUI.scoreLabel.text, self.sceneUI.levelLabel.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:NGTwitterNotification object:scoreLevel];
        };
        self.buttonsBlock = block;
        [self.window highlightButon:shareButton withBlock:self.buttonsBlock];
    }
    if ([giveUpButton containsPoint:location])
    {
        id block = ^(){
        [_window.hoverLayer removeFromParent];
        self.window = nil;
        _screenTouchEnable = YES;
        SKView *skView = (SKView *)self.view;
        SKTransition *reveal = [SKTransition flipVerticalWithDuration:0.5];
        SKScene *map = [[MapScene alloc] initWithSize:skView.bounds.size];
        [self.view presentScene:map transition:reveal];
        [self myDealloc];
        };
        self.buttonsBlock = block;
       [self.window highlightButon:giveUpButton withBlock:self.buttonsBlock];
    }
    if ([closeButton containsPoint:location])
    {
        id block = ^(){
        [_window.hoverLayer removeFromParent];
        _window = nil;
        _screenTouchEnable = YES;
        SKView *skView = (SKView *)self.view;
        SKTransition *reveal = [SKTransition flipVerticalWithDuration:0.5];
        SKScene *map = [[MapScene alloc] initWithSize:skView.bounds.size];
        [self.view presentScene:map transition:reveal];
        [self myDealloc];
        };
        self.buttonsBlock = block;
        [self.window highlightButon:closeButton withBlock:self.buttonsBlock];
        [self.sceneUI drawPauseButton:@"pause_button_1"];
    }
    
    if ([self.window.backgroundMusicButton containsPoint:location])
    {
        if (self.window.backgroundMusicIsEnabled)
        {
            [self.backgroundMusic stop];
            self.window.backgroundMusicIsEnabled = NO;
            self.backgroundMusicIsEnabled = NO;
            [self.window setOnOffBackgroundSound:NO];
        }
        else
        {
            [self.backgroundMusic play];
            self.window.backgroundMusicIsEnabled = YES;
            self.backgroundMusicIsEnabled = YES;
            [self.window setOnOffBackgroundSound:YES];
        }
    }
    if ([self.window.volumeButton containsPoint:location])
    {
        if (self.window.volumeButtonISEnabled)
        {
            [self removeSoundAction];
            self.window.volumeButtonISEnabled = NO;
            self.volumeButtonISEnabled = NO;
            [self.window setOnOffVolume:NO];
        }
        else
        {
            [self loadSoundAction];
            self.window.volumeButtonISEnabled = YES;
            self.volumeButtonISEnabled = YES;
            [self.window setOnOffVolume:YES];
        }
    }

}

-(void) helpersButtons:(CGPoint)location
{
    if ([self containsPoint:location])
    {
        [self.helpers.background removeFromParent];
        [self.helpers.letter removeFromParent];
        [self.helpers.person removeFromParent];
        [self.helpers.element removeFromParent];
        
        BOOL startHandleMathes = self.helpers.startHandleMathes;
        self.helpers = nil;
        self.helpers = [[HelperGame alloc] init];
        _screenTouchEnable = YES;
        
        if ([self.arrayOfHelpers count] == 0  )
        {
            [self enumerateChildNodesWithName:@"gameLayer" usingBlock:^(SKNode *node, BOOL *stop) {
                node.paused = NO;
            }];
            [self enumerateChildNodesWithName:@"scoreYellowLine" usingBlock:^(SKNode *node, BOOL *stop) {
                node.paused = NO;
            }];
            
            if (startHandleMathes)
            {
                [self handleMatches:nil];
                NSLog(@"====handleMatches=====");
            }
            
            if (self.windowShowNumber != 0)
            {
                [self hoverWindow:(int)self.windowShowNumber];
            }
        }
        
        if ([self.arrayOfHelpers count] > 0)
        {
            self.helpers = (HelperGame*)[self.arrayOfHelpers lastObject];
            [self.helpers initWithElements:self withMessage:self.helpers.message withPosition:self.helpers.position withElement:self.helpers.elementName withAdditional:self.helpers.additional withPositionMessage:self.helpers.positionMessage];
            [self.arrayOfHelpers removeLastObject];
        }
        
    }}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_screenTouchEnable) {
        UITouch * touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self.charactersLayer];
        
//        kills repeat action on hint sprites
        if (_swapWithRepeatCharacers.characterA.sprite != nil && _swapWithRepeatCharacers.characterB.sprite != nil) {
            [_swapWithRepeatCharacers.characterA.sprite removeActionForKey:@"repeat"];
            [_swapWithRepeatCharacers.characterB.sprite removeActionForKey:@"repeat"];
            _swapWithRepeatCharacers = nil;
        }
        
        if(_waitAnimationForSwipe) {
            NSInteger column, row;
            _isNextTurn = NO;
        
            if ([self convertPoint:location toColumn:&column row:&row]) {
                Character * character = [self.level characterAtColumn:column row:row];
                [character.sprite runAction:[_animationCharacters valueForKey:character.sprite.name]]; // animation
//                NSLog(@"Column= %lu  Row = %lu", (long)column, (long)row);
                [[self.level.aimsObject getCharacterAimTypes] count];
                if (character != nil) {
                    [self showSelectionIndicatorForCharacter:character];
//                booster make action:
                    if (_booster.activated && _booster.boosterAmount > 0 &&
                        _booster.boosterType != BoosterTypeKillRowOrColumn && _booster.isAvailable) { // 1, 2, 4 booster
//                        additional check for 4 booster
                        NSSet * set = [_booster dealWithBooster:_booster andCharacter:character andLevel:self.level withDelta:0];
                        if ([set count] > 0) [self handleMatches:set];
                        return;
                    } else {                                                                            // 3 booster
                        self.swipeFromColumn = column;
                        self.swipeFromRow = row;
                    }
                }
            } else {
                _booster.activated = NO;
            }
        }
        
        CGPoint newLocation = [touch locationInNode:self];
        [self boosterActivateWithPoint:newLocation];
        [self functionalButtons:newLocation];
    }
    else {
        for (UITouch *touch in touches) {
            CGPoint locationButtons = [touch locationInNode:_window.hoverLayer];
            [self windowsButtons:locationButtons];
            if (self.helpers.background != nil)
            {
                CGPoint locationHelper = [touch locationInNode:self.helpers];
                [self helpersButtons:locationHelper];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_screenTouchEnable) {
        if (self.swipeFromColumn == NSNotFound) return;
        self.movesFreeze = YES; // для активации decrementMoves
        UITouch * touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self.charactersLayer];
        
        NSInteger column, row;
        
        if ([self convertPoint:location toColumn:&column row:&row]) {
            NSInteger horzDelta = 0, verDelta = 0;
            if (column < self.swipeFromColumn) {
                horzDelta = -1;
            } else if (column > self.swipeFromColumn) {
                horzDelta = 1;
            } else if (row < self.swipeFromRow) {
                verDelta = -1;
            } else if (row > self.swipeFromRow) {
                verDelta = 1;
            }
            if (horzDelta != 0 || verDelta != 0) {
                [self trySwapHorizontal:horzDelta vertical:verDelta];
                [self hideSelectionIndicator];
                self.swipeFromColumn = NSNotFound;
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_screenTouchEnable)
    {
        if (self.selectionSprite.parent != nil && self.swipeFromColumn != NSNotFound) {
        [self hideSelectionIndicator];
        }
        self.swipeFromColumn = self.swipeFromRow = NSNotFound;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)trySwapHorizontal:(NSInteger)horzDelta vertical:(NSInteger)vertDelta {
//    calculate which column and row affected by user
    NSInteger toColumn = self.swipeFromColumn + horzDelta;
    NSInteger toRow = self.swipeFromRow + vertDelta;
//    external swipes ignore
    if (toColumn < 0 || toColumn >= self.level.NumColumns) return;
    if (toRow < 0 || toRow >= self.level.NumRows) return;
    
//    check - if character at this position
    Character * toCharacter = [self.level characterAtColumn:toColumn row:toRow];
    
//    action
    Character * fromCharacter = [self.level characterAtColumn:self.swipeFromColumn row:self.swipeFromRow];
    
    if (toCharacter == nil || fromCharacter == nil) return;
    //if ([toCharacter.spriteName isEqualToString:@"anchor"] || [fromCharacter.spriteName isEqualToString:@"anchor"]) return;
    if (toCharacter.isBlocked || fromCharacter.isBlocked) return;
    
    if (self.swipeHandler != nil) {
        Swap * swap = [Swap new];
        swap.characterA = fromCharacter;
        swap.characterB = toCharacter;
        fromCharacter.isSwipeForBonus = YES;
        toCharacter.isSwipeForBonus = YES;
        
//        if ((fromCharacter.bonusType != BonusTypeNone) || (toCharacter.bonusType != BonusTypeNone)) {
            NSArray * characters = @[fromCharacter, toCharacter];
            [self.level bonusHelperToDetectChains:characters];
//            [self.level bonusHelperToDetectChains:nil withSwapCharacters:swap];
//        [self.level bonusHelperToDetectSwaps:swap];
//        }
        
//        call the block
        self.swipeHandler(swap);
        
        if (_booster.activated && _booster.isAvailable) {
            [self handleMatches:[_booster dealWithBooster:_booster andCharacter:fromCharacter andLevel:self.level withDelta:horzDelta]];
        }
    }
}

#pragma mark - Set Elements

-(void)setTopBar
{
    self.sceneUI.getCharactersToLevel = [self.level.aimsObject getCharactersToLevel];
    self.sceneUI.getTargetToLevel = [self.level.aimsObject getTargetToLevel];
    self.sceneUI.getAimsToLevel = [self.level.aimsObject getCharacterAimTypes];
    _aimSpritesPositions = [self.sceneUI setTopBar];
    self.sceneUI.movesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.level.maximumMoves];
}

-(void)setLevelScoreLabels
{
    self.sceneUI.scoreLabel.text = @"0";
    _levelLabel = self.sceneUI.levelLabel;
    self.sceneUI.levelLabel.text = @"Level 2";
}

-(void) setLifes
{
    self.sceneUI.lifeLabel.text = [NSString stringWithFormat:@"%ld", (long)_lifes ];
}

- (void)unlockBoostersWithLevel:(NSInteger)currenteLevel {
    Booster * booster = [Booster new];
    [booster unlockBoosterWithCurrentLevel:currenteLevel andBoosters:self.boosters andScene:self];
}

#pragma mark - Window

-(void) hoverWindow:(HoverWindow)window
{
    //Добавляет все Functional Windows  на GameScene
    _window = [[GameSceneWindow alloc] initWithSize:self.frame.size withClass:self];
    self.screenTouchEnable = NO;
    
    switch (window) {
        case HoverWindowPause:
        {
            _window.backgroundMusicIsEnabled = self.backgroundMusicIsEnabled;
            _window.volumeButtonISEnabled = self.volumeButtonISEnabled;
            self.window.currentLevel = self.currentLevel;
            [self.sceneUI drawPauseButton:@"pause_button_2"];
            [self.window hoverWindow:window];
            _window.scoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.score];
        }
        break;
        case HoverWindowGameMovesOut:
        {
            _window.targetsToLevel = [NSMutableArray arrayWithArray:self.level.sprites];
            [self.window hoverWindow:window];

            NSDate *now= [[NSDate alloc] init];
            NSDate *end = [now dateByAddingTimeInterval:TIME_LIFE];
            NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"Lifes"]];
            [array addObject:end];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"Lifes"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _lifes--;
        }
        break;
        case HoverWindowGameCompleted:
        {
            self.level.endLevel = NO;
            self.activeLevels = [[[NSUserDefaults standardUserDefaults] objectForKey:@"activeLevels"] intValue];
            if (self.currentLevel == self.activeLevels && self.currentLevel != ENDLEVEL)
            {
                self.activeLevels += 1;
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:self.activeLevels] forKey:@"activeLevels"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            self.window.stars = [self countStarsInScoreBar];
            self.window.currentLevel = self.currentLevel;
            [self.window hoverWindow:window];
            self.window.levelLabel.text = [NSString stringWithFormat:@"%lu level", (unsigned long)_currentLevel];
            self.window.scoreLabel.text = [NSString stringWithFormat:@"Score:%lu", (unsigned long)self.score];
        }
        break;
        default:
        break;
    }
}

@end
