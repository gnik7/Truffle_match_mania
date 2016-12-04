//
//  ScaleUIonDevice.h
//  CookieCrunch
//
//  Created by Nikita Gil' on 02.06.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScaleUIonDevice : SKScene

-(CGFloat) scaleFontForGameWindow;
-(NSArray*) scaleForFirstStartMap;
-(NSArray*) scaleForMapElements;
-(NSArray*) scaleForTopBar;
-(NSArray*) scaleForTileGameScene;
-(CGFloat) scaleCharactersGameScene;
-(CGFloat) scaleBlockGameScene;
+(NSArray*) scaleForBottomBar;
-(NSArray*) scaleForFirsGameScene;
+ (CGFloat)scalePlusOne;
+(NSArray*) scaleForScoreLine;
+(CGFloat) scaleForElementsInHelper;
+(NSArray*) scaleWindows;


@end
