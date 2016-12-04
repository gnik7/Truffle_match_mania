//
//  GameSceneHelper.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 02.06.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "GameSceneHelper.h"
#import "ScaleUIonDevice.h"
#import "HelperGame.h"
#import "Settings.h"

@implementation GameSceneHelper

-(void) showHelperForFourInRow:(GameScene*)scene withPosition:(CGPoint)position withHelper:(HelperGame*)helper withCharacter:(NSString*)spriteName;
{
    CGPoint posMessage = CGPointMake(scene.frame.size.width * 0.05, scene.frame.size.height * 0.25);
    if (helper.background == nil)
    {
        [helper initWithElements:scene withMessage:@"bonus-type_Bomb" withPosition:position withElement:spriteName withAdditional:nil withPositionMessage: posMessage];
    }
    else
    {
        HelperGame *newHelper = [[HelperGame alloc] init];
        newHelper.message = @"bonus-type_Bomb";
        newHelper.position = position;
        newHelper.elementName = spriteName;
        newHelper.additional = nil;
        newHelper.positionMessage = posMessage;
        [scene.arrayOfHelpers addObject:newHelper];
    }
}

-(void) showHelperForFiveInRow:(GameScene*)scene withPosition:(CGPoint)position withHelper:(HelperGame*)helper withCharacter:(NSString*)spriteName;
{
    CGPoint posMessage = CGPointMake(scene.frame.size.width * 0.05, scene.frame.size.height * 0.25);
    if (helper.background == nil)
    {
        helper.message =@"bonus-type_Rose";
        [helper initWithElements:scene withMessage:@"bonus-type_Rose" withPosition:position withElement:spriteName withAdditional:nil withPositionMessage:posMessage];
    }
    else
    {
        HelperGame *newHelper = [[HelperGame alloc] init];
        newHelper.message = @"bonus-type_Rose";
        newHelper.position = position;
        newHelper.elementName = spriteName;
        newHelper.additional = nil;
        newHelper.positionMessage = posMessage;
        [scene.arrayOfHelpers addObject:newHelper];
    }
}

-(void) showHelperForPlusOne:(GameScene*) scene withPosition:(CGPoint)position withHelper:(HelperGame*)helper withCharacter:(NSString*)spriteName
{
    CGPoint posMessage = CGPointMake(scene.frame.size.width * 0.05, scene.frame.size.height * 0.25);
    if (helper.background == nil)
    {
        [helper initWithElements:scene withMessage:@"helper_plus1" withPosition:position withElement:spriteName withAdditional:@"plus_one"  withPositionMessage:posMessage];
    }
    else
    {
        HelperGame *newHelper = [[HelperGame alloc] init];
        newHelper.message = @"helper_plus1";
        newHelper.position = position;
        newHelper.elementName = spriteName;
        newHelper.additional = @"plus_one";
        newHelper.positionMessage = posMessage;
        [scene.arrayOfHelpers addObject:newHelper];
    }
}

-(void) showHelperForPlusTwo:(GameScene*) scene withPosition:(CGPoint)position withHelper:(HelperGame*)helper withCharacter:(NSString*)spriteName
{
    CGPoint posMessage = CGPointMake(scene.frame.size.width * 0.05, scene.frame.size.height * 0.25);
    if (helper.background == nil)
    {
        helper.message =@"helper_plus2";
        [helper initWithElements:scene withMessage:@"helper_plus2" withPosition:position withElement:spriteName withAdditional:@"plus_two" withPositionMessage:posMessage];
    }
    else
    {
        HelperGame *newHelper = [[HelperGame alloc] init];
        newHelper.message = @"helper_plus2";
        newHelper.position = position;
        newHelper.elementName = spriteName;
        newHelper.additional = @"plus_two";
        newHelper.positionMessage = posMessage;
        [scene.arrayOfHelpers addObject:newHelper];
    }
}

-(void) showHelperForBooster:(GameScene*) scene withNumber:(NSInteger)number withHelper:(HelperGame *)helper
{
    CGPoint position = CGPointZero;
    switch (number) {
        case 1:
            position = CGPointMake(-scene.size.width * 0.31, -scene.size.height/2.21);
            break;
        case 2:
            position = CGPointMake(-scene.size.width * 0.15, -scene.size.height/2.21);
            break;
        case 3:
            position = CGPointMake(scene.size.width * 0, -scene.size.height/2.21);
            break;
        case 4:
            position = CGPointMake(scene.size.width * 0.15, -scene.size.height/2.21);
            break;
        default:
            break;
    }
    NSString *message = [NSString stringWithFormat:@"Booster%lu", (long)number];
    NSString *spriteName = [NSString stringWithFormat:@"%lu_booster", (long)number];
    CGPoint posMessage = CGPointMake(scene.frame.size.width * 0.05, -scene.frame.size.height * 0.15);
    if (helper.background == nil)
    {
        [helper initWithElements:scene withMessage:message withPosition:position withElement:spriteName withAdditional:nil withPositionMessage:posMessage];
    }
    else
    {
        HelperGame *newHelper = [[HelperGame alloc] init];
        newHelper.message = message;
        newHelper.position = position;
        newHelper.elementName = spriteName;
        newHelper.additional = nil;
        newHelper.positionMessage = posMessage;
        [scene.arrayOfHelpers addObject:newHelper];
    }
}


@end
