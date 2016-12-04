//
//  Cookie.h
//  CookieCrunch
//
//  Created by Кирилл on 04.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

typedef enum {
    BonusTypeNone = 0,
    BonusTypeBoom,
    BonusTypeKillAllType
} BonusType;

//импорт модуля
@import SpriteKit;

static const NSUInteger NumCharacterTypes = NUM_CHARACTER_TYPES;

@interface Character : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger characterType;
@property (strong, nonatomic) SKSpriteNode * sprite;
@property (strong, nonatomic) SKSpriteNode * tile;
@property (assign, nonatomic) NSUInteger aimCountOnSingleSprite;
@property (assign, nonatomic) BOOL isChanged;                               // for +1, +2
@property (assign, nonatomic) BonusType bonusType;
@property (assign, nonatomic) BOOL bonusActivated;
@property (assign, nonatomic) BOOL isBlocked;
@property (assign, nonatomic) BOOL isSwipeForBonus;

- (NSString *)spriteName;
- (NSArray *)spriteNames;
//- (NSString *)highlightedSpriteName;

@end
