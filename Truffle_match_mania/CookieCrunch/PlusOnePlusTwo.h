///
//  PlusOnePlusTwo.h
//  CookieCrunch
//
//  Created by Кирилл on 15.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScene.h"

@class Character;
@class HelperGame;

@interface PlusOnePlusTwo : NSObject

@property (strong, nonatomic) NSMutableSet * charactersWithNumbers;

- (void)addCharacterWithNumberToMutableSet:(Character *)character;
- (NSMutableSet*)getCharactersWithNumbers;
+ (void)addSpriteWithArray:(NSArray *)array withGameScane:(GameScene*)scene withHelpers:(HelperGame*) helper;

@end
