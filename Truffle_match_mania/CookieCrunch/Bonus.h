//
//  Bonus.h
//  CookieCrunch
//
//  Created by Кирилл on 28.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "HelperGame.h"

@class Character;
@class Chain;
@class Swap;

@interface Bonus : SKSpriteNode

@property (strong, nonatomic) SKAction * animation;

- (id)initWithImageNamed:(NSString *)name withCharacterSettings:(Character *)character;
- (id)initWithCharacter:(Character *)character andScale:(CGFloat)scale withGameScane:(GameScene*)scene withHelpers:(HelperGame*) helper;
+ (void)detectBonus:(NSSet *)set;

@end
