//
//  KKChain.m
//  CookieCrunch
//
//  Created by Кирилл on 05.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "Chain.h"
#import "Character.h"

@implementation Chain {
    NSMutableArray * _characters;
}

- (void)addCharacter:(Character *)character {
    if (self.chainCreatedWith == ChainCreatedWithOriginal) {
        if (character != nil) {
            if (_characters == nil) {
                _characters = [NSMutableArray array];
            }
            [_characters addObject:character];
        }
    } else if (character != nil && character.characterType != ANCHOR_TYPE && !character.isBlocked) {
        if (_characters == nil) {
            _characters = [NSMutableArray array];
        }
        [_characters addObject:character];
    } else if (self.chainCreatedWith == ChainCreatedWithBooster) {
        if (_characters == nil) {
            _characters = [NSMutableArray array];
        }
        [_characters addObject:character];
    }
}

- (BOOL)removeCharacter:(Character *)character {
    if ([_characters count] > 0) {
        [_characters removeObject:character];
        return YES;
    }
    return NO;
}

//метод возвращает массив, а должен - изменяющийся массив. Это трюк чтоб пользователи не меняли массив.
- (NSArray *)characters {
    return _characters;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"type:%ld characters:%@", (long)self.chainType, self.characters];
}

-(id)copyWithZone:(NSZone *)zone
{
    Chain * another = [[self class] allocWithZone:zone];
    another.characters = self.characters;
    another.chainType = self.chainType;
    another.score = self.score;
    
    return another;
}

@end
