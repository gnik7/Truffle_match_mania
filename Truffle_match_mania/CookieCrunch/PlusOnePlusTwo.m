//
//  PlusOnePlusTwo.m
//  CookieCrunch
//
//  Created by Кирилл on 15.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "PlusOnePlusTwo.h"
#import "Character.h"
#import "ScaleUIonDevice.h"
#import "HelperGame.h"
#import "ConvertLayers.h"
#import "Level.h"

@class Helpers;

@implementation PlusOnePlusTwo

- (void)addCharacterWithNumberToMutableSet:(Character *)character {
    
    if (self.charactersWithNumbers == nil)
        self.charactersWithNumbers = [NSMutableSet new];
    
    [self.charactersWithNumbers addObject:character];
}

- (NSMutableSet*)getCharactersWithNumbers {
    return self.charactersWithNumbers;
}

+ (void)addSpriteWithArray:(NSArray *)array withGameScane:(GameScene*)scene withHelpers:(HelperGame*) helper {
    SKTextureAtlas * plusOneAtlas = [SKTextureAtlas atlasNamed:@"PlusOne"];
    for (Character * character in array) {
        if (character.isChanged == YES) {
            SKSpriteNode * sprite = [SKSpriteNode new];
            
            if (character.aimCountOnSingleSprite == 1) {
                [character.sprite removeAllChildren];
                SKTexture * texture = [plusOneAtlas textureNamed:@"plus_one"];
                sprite = [SKSpriteNode spriteNodeWithTexture:texture];
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"helperPlusOne" ] intValue] == 0 && scene.movesLeft > 0)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:@"helperPlusOne"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    CGSize tileSizeS = CGSizeMake(scene.tileWidth, scene.tileHeight);
                    CGPoint positionSprite = [ConvertLayers convertCLToGL:character.sprite.position tileSize:tileSizeS sceneSize:scene.size numColumns:scene.level.NumColumns numRows:scene.level.NumRows];
                    
                    [scene.myDelegate showHelperForPlusOne:scene withPosition:positionSprite withHelper:helper withCharacter:(NSString*)[character spriteName]];
                }
            } else if (character.aimCountOnSingleSprite == 2) {
                [character.sprite removeAllChildren];
                SKTexture * texture = [plusOneAtlas textureNamed:@"plus_two"];
                sprite = [SKSpriteNode spriteNodeWithTexture:texture];
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"helperPlusTwo"] intValue] == 0 && scene.movesLeft > 0)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:@"helperPlusTwo"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    CGSize tileSizeS = CGSizeMake(scene.tileWidth, scene.tileHeight);
                    CGPoint positionSprite = [ConvertLayers convertCLToGL:character.sprite.position tileSize:tileSizeS sceneSize:scene.size numColumns:scene.level.NumColumns numRows:scene.level.NumRows];
                    
                    [scene.myDelegate showHelperForPlusTwo:scene withPosition:positionSprite withHelper:helper withCharacter:(NSString*)[character spriteName]];
                }
            } else {
                NSLog(@"ERROR");
            }

            sprite.name = [NSString stringWithFormat:@"%@_aim", character.sprite.name];
            sprite.position = CGPointMake(0 + character.sprite.size.width/2 - sprite.size.width/4,
                                          0 + character.sprite.size.height/2 - sprite.size.height/3);
            
            sprite.xScale = [ScaleUIonDevice scalePlusOne];
            sprite.yScale = [ScaleUIonDevice scalePlusOne];
            sprite.zPosition = 1;
            [character.sprite addChild:sprite];
            
            
            
        }
    }
}

@end
