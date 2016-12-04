//
//  HelperGame.h
//  CookieCrunch
//
//  Created by Nikita Gil' on 03.07.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "GameScene.h"

@interface HelperGame : SKSpriteNode

@property (strong, nonatomic) SKSpriteNode * background;
@property (strong, nonatomic) SKSpriteNode * letter;
@property (strong, nonatomic) SKSpriteNode * person;
@property (strong, nonatomic) SKSpriteNode * element;
@property (strong, nonatomic) SKAction * animation;

@property (strong, nonatomic) NSString * message;
@property (nonatomic) CGPoint position;
@property (strong, nonatomic) NSString * elementName;
@property (strong, nonatomic) NSString * additional;
@property (nonatomic) CGPoint positionMessage;
@property (assign, nonatomic) BOOL startHandleMathes;


-(void) initWithElements:(GameScene*)scene withMessage:(NSString*)message withPosition:(CGPoint)pos withElement:(NSString*)elementName  withAdditional:(NSString*)additional withPositionMessage:(CGPoint)posMess;


@end
