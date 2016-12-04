//
//  ProjectAnimationsAndActions.h
//  CookieCrunch
//
//  Created by Кирилл on 01.07.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Chain;
@class Aims;
@class GameScene;

@interface ProjectAnimationsAndActions : SKNode

- (NSMutableDictionary *)getCharactersAnimation;
- (void)animateFlyingScoreToAimBarWithChain:(Chain *)chain withLabelsPosition:(NSArray *)positions withAimTypePos:(NSInteger)aimTypePos
                                      label:(SKLabelNode *)label;
- (id)initWithGameScene:(GameScene *)gameScene;
-(void) characterAnimationRelease;
@end
