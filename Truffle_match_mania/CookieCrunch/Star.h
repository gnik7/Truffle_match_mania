//
//  Star.h
//  CookieCrunch
//
//  Created by Кирилл on 28.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Star : SKSpriteNode

@property (assign, nonatomic) BOOL isActivated;
@property (strong, nonatomic) SKAction * animation;

@end
