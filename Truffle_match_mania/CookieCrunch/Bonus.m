//
//  Bonus.m
//  CookieCrunch
//
//  Created by Кирилл on 28.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "Bonus.h"
#import "Character.h"
#import "Chain.h"
#import "Swap.h"
#import "ConvertLayers.h"
#import "Level.h"


@implementation Bonus {
    Character * _character;
}

- (id)initWithImageNamed:(NSString *)name withCharacterSettings:(Character *)character {
    if (self = [super initWithImageNamed:name]) {
        _character = character;
        self.position = character.sprite.position;
        self.zPosition = character.sprite.zPosition;
    }
    return self;
}

- (id)initWithCharacter:(Character *)character andScale:(CGFloat)scale withGameScane:(GameScene*)scene withHelpers:(HelperGame*) helper {
    if (self = [super init]) {
        switch (character.bonusType) {
            case 1: {
                self = [[Bonus alloc] initWithImageNamed:@"bonus-type-1" withCharacterSettings:character];
                self.name = @"bonusBoom";
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"helper4InRow"] integerValue] == 0 && scene.movesLeft > 0)
                {
                    CGSize tileSizeS = CGSizeMake(scene.tileWidth, scene.tileHeight);
                    CGPoint positionSprite = [ConvertLayers convertCLToGL:character.sprite.position tileSize:tileSizeS sceneSize:scene.size numColumns:scene.level.NumColumns numRows:scene.level.NumRows];
                    
                    [scene.myDelegate showHelperForFourInRow:scene withPosition:positionSprite withHelper:helper withCharacter:@"bonus-type-1" ];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:@"helper4InRow"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
                break;
            case 2: {
                self = [[Bonus alloc] initWithImageNamed:@"bonus-type-2" withCharacterSettings:character];
                self.name = @"bonusKillOneType";
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"helper5InRow"] integerValue] == 0 && scene.movesLeft > 0)
                {
                    CGSize tileSizeS = CGSizeMake(scene.tileWidth, scene.tileHeight);
                    CGPoint positionSprite = [ConvertLayers convertCLToGL:character.sprite.position tileSize:tileSizeS sceneSize:scene.size numColumns:scene.level.NumColumns numRows:scene.level.NumRows];
                    [scene.myDelegate showHelperForFiveInRow:scene withPosition:positionSprite withHelper:helper withCharacter:@"bonus-type-2"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:@"helper5InRow"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
                break;
            default:
                break;
        }
        self.size = CGSizeMake(self.size.width * scale, self.size.height * scale);
    }
    return self;
}

+(void) detectBonus:(NSSet *)set {
    if ([set count] > 0) {
        for (Chain * chain in set) {
            NSInteger anyCharacter = arc4random() % [chain.characters count];
            switch ([chain.characters count]) {
                case 4: {
                    for (Character * obj in chain.characters) {
                        if (obj.isSwipeForBonus) {
                            [obj setBonusType:BonusTypeBoom];
                            obj.isSwipeForBonus = NO;
                            obj.characterType = NEUTRAL_CHARACTER_TYPE;
                            return;
                        }
                    }
                    Character *character = [chain.characters objectAtIndex:anyCharacter]; // for accident chain, which have to create bonus
                    [character setBonusType:BonusTypeBoom];
                    character.characterType = NEUTRAL_CHARACTER_TYPE;
                }
                    break;
                case 5: {
                    for (Character * obj in chain.characters) {
                        if (obj.isSwipeForBonus) {
                            [obj setBonusType:BonusTypeKillAllType];
                            obj.isSwipeForBonus = NO;
                            obj.characterType = NEUTRAL_CHARACTER_TYPE;
                            return;
                        }
                    }
                    Character *character = [chain.characters objectAtIndex:anyCharacter]; // for accident chain, which have to create bonus
                    [character setBonusType:BonusTypeKillAllType];
                    character.characterType = NEUTRAL_CHARACTER_TYPE;
                }
                    break;
                default: {
                    for (Chain *chain in set) {
                        for (Character *character in chain.characters) {
                            character.isSwipeForBonus = NO;
                        }
                    }
                }
                    break;
            }
        }
    }
}

@end
