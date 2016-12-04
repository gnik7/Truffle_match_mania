//
//  KKChain.h
//  CookieCrunch
//
//  Created by Кирилл on 05.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

//класс для нахождения цепей, которые создаются автоматически

#import <Foundation/Foundation.h>

@class Character;

typedef NS_ENUM(NSUInteger, ChainType) {
    ChainTypeHorizontal,
    ChainTypeVertical,
};

typedef NS_ENUM(NSUInteger, ChainCreatedWith) {
    ChainCreatedWithOriginal,
    ChainCreatedWithBooster,
    ChainCreatedWithBonus,
};

@interface Chain : NSObject <NSCopying>

@property (strong, nonatomic) NSArray * characters;
@property (assign, nonatomic) ChainType chainType;
@property (assign, nonatomic) NSUInteger score;
@property (assign, nonatomic) ChainCreatedWith chainCreatedWith;

- (void)addCharacter:(Character *)character;
- (BOOL)removeCharacter:(Character *)character;
- (id)copyWithZone:(NSZone *)zone;

@end
