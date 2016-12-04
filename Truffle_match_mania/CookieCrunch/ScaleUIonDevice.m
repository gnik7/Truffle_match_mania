//
//  ScaleUIonDevice.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 02.06.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "ScaleUIonDevice.h"
#import "Settings.h"

@implementation ScaleUIonDevice

#pragma mark - Font
-(CGFloat) scaleFontForGameWindow
{
    CGFloat scale = 0;
    if (IS_IPHONE_4_AND_OLDER_IOS7)
    {
        scale=0.8;
    }
    else if (IS_IPHONE_5_IOS7)
    {
        scale = 0.85;
    }
    else if (IS_IPHONE_6_IOS7)
    {
        scale = 0.85;
    }
    else if (IS_IPHONE_6P_IOS7)
    {
        scale = 1.0;
    }
    else if (IS_IPAD_AIR || IS_IPAD3 || IS_IPAD4 || IS_IPAD_MINI_1G || IS_IPAD_MINI_2G)
    {
        scale = 2.0;
    }
    else if (IS_IPAD2 || [[Settings deviceModelName] isEqualToString:@"iPad Simulator"])
    {
        scale = 2.0;
    }
    
    return scale;
}

#pragma mark - First Map

-(NSArray*) scaleForFirstStartMap
{
    NSArray *arr ;
    if (IS_IPHONE_4_AND_OLDER_IOS7)
    {
        arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.16],
                                        [NSNumber numberWithFloat:0.14],
                                        [NSNumber numberWithFloat:0.455],
                                        [NSNumber numberWithFloat:0.225], nil];
    }
    else if (IS_IPHONE_5_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.16],
               [NSNumber numberWithFloat:0.18],
               [NSNumber numberWithFloat:0.455],
               [NSNumber numberWithFloat:0.225], nil];
    }
    else if (IS_IPHONE_6_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.16],
               [NSNumber numberWithFloat:0.18],
               [NSNumber numberWithFloat:0.455],
               [NSNumber numberWithFloat:0.225], nil];
    }
    else if (IS_IPHONE_6P_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.18],
               [NSNumber numberWithFloat:0.19],
               [NSNumber numberWithFloat:0.46],
               [NSNumber numberWithFloat:0.225], nil];
    }
    else if (IS_IPAD2 || [[Settings deviceModelName] isEqualToString:@"iPad Simulator"])
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.16],
               [NSNumber numberWithFloat:0.14],
               [NSNumber numberWithFloat:0.455],
               [NSNumber numberWithFloat:0.225], nil];
    }
    
    else if (IS_IPAD_AIR || IS_IPAD3 || IS_IPAD4 || IS_IPAD_MINI_1G || IS_IPAD_MINI_2G)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.16],
               [NSNumber numberWithFloat:0.14],
               [NSNumber numberWithFloat:0.456],
               [NSNumber numberWithFloat:0.225], nil];
    }
    
    return arr;
}

#pragma mark - Map
// [  button   cursor  size ]  [pos y cursor]
-(NSArray*) scaleForMapElements
{
    NSArray *arr ;
    if (IS_IPHONE_4_AND_OLDER_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.7],
               [NSNumber numberWithFloat:0.05], nil];
    }
    else if (IS_IPHONE_5_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.7],
               [NSNumber numberWithFloat:0.045], nil];
    }
    else if (IS_IPHONE_6_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.8],
               [NSNumber numberWithFloat:0.044], nil];
    }
    else if (IS_IPHONE_6P_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.9],
               [NSNumber numberWithFloat:0.043], nil];
    }
    else if (IS_IPAD2 || [[Settings deviceModelName] isEqualToString:@"iPad Simulator"])
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:1.5],
               [NSNumber numberWithFloat:0.07], nil];
    }
    
    else if (IS_IPAD_AIR || IS_IPAD3 || IS_IPAD4 || IS_IPAD_MINI_1G || IS_IPAD_MINI_2G)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:1.6],
               [NSNumber numberWithFloat:0.058], nil];
    }
    
    return arr;
}
#pragma mark - TopBar
//  0[Moves/Lifes] 1[Level/Score]  2[Label on target 0/12 ]  3[Target] 4[Blue Line] 5[ Lebel target Score 0/12 pos Y]
-(NSArray*) scaleForTopBar
{
    NSArray *arr ;
    if (IS_IPHONE_4_AND_OLDER_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.7],
               [NSNumber numberWithFloat:8],
               [NSNumber numberWithFloat:9],
               [NSNumber numberWithFloat:0.9],
               [NSNumber numberWithFloat:0.8],
               [NSNumber numberWithFloat:0.35],nil];
    }
    else if (IS_IPHONE_5_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.7],
               [NSNumber numberWithFloat:9],
               [NSNumber numberWithFloat:12],
               [NSNumber numberWithFloat:1.0],
               [NSNumber numberWithFloat:1.0],
               [NSNumber numberWithFloat:0.3],nil];
    }
    else if (IS_IPHONE_6_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.8],
               [NSNumber numberWithFloat:10],
               [NSNumber numberWithFloat:15],
               [NSNumber numberWithFloat:1.0],
               [NSNumber numberWithFloat:1.0],
               [NSNumber numberWithFloat:0.32],nil];
    }
    else if (IS_IPHONE_6P_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.9],
               [NSNumber numberWithFloat:12],
               [NSNumber numberWithFloat:17],
               [NSNumber numberWithFloat:1.05],
               [NSNumber numberWithFloat:1.05],
               [NSNumber numberWithFloat:0.29],nil];
    }
    else if (IS_IPAD2 || [[Settings deviceModelName] isEqualToString:@"iPad Simulator"])
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:1.4],
               [NSNumber numberWithFloat:19],
               [NSNumber numberWithFloat:22],
               [NSNumber numberWithFloat:0.85],
               [NSNumber numberWithFloat:0.8],
               [NSNumber numberWithFloat:0.27],nil];
    }
    
    else if (IS_IPAD_AIR || IS_IPAD3 || IS_IPAD4 || IS_IPAD_MINI_1G || IS_IPAD_MINI_2G)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:1.4],
               [NSNumber numberWithFloat:19],
               [NSNumber numberWithFloat:22],
               [NSNumber numberWithFloat:0.85],
               [NSNumber numberWithFloat:0.8],
               [NSNumber numberWithFloat:0.28],nil];
    }
    return arr;
}

#pragma mark - Tiles Characters
//  0[Width] 1[Height] 2[Tile size]
-(NSArray*) scaleForTileGameScene
{
    NSArray *arr ;
    if (IS_IPHONE_4_AND_OLDER_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.114454],
               [NSNumber numberWithFloat:0.076349],
               [NSNumber numberWithFloat:1.05],nil];
    }
    else if (IS_IPHONE_5_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.11449],
               [NSNumber numberWithFloat:0.06452],
               [NSNumber numberWithFloat:1.05],nil];
    }
    else if (IS_IPHONE_6_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.11527],
               [NSNumber numberWithFloat:0.06502],
               [NSNumber numberWithFloat:1.24],nil];
    }
    else if (IS_IPHONE_6P_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.104566],
               [NSNumber numberWithFloat:0.0587],
               [NSNumber numberWithFloat:1.24],nil];
    }
    else if (IS_IPAD2 || [[Settings deviceModelName] isEqualToString:@"iPad Simulator"])
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.0827],
               [NSNumber numberWithFloat:0.0625],
               [NSNumber numberWithFloat:1.6],nil];
    }
    
    else if (IS_IPAD_AIR || IS_IPAD3 || IS_IPAD4 || IS_IPAD_MINI_1G || IS_IPAD_MINI_2G)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.0732],
               [NSNumber numberWithFloat:0.0548],
               [NSNumber numberWithFloat:1.61],nil];
    }
    return arr;
}

-(CGFloat) scaleCharactersGameScene
{
    CGFloat scale = 0;
    if (IS_IPHONE_4_AND_OLDER_IOS7)
    {
        scale=0.9;
    }
    else if (IS_IPHONE_5_IOS7)
    {
        scale = 1.0;
    }
    else if (IS_IPHONE_6_IOS7)
    {
        scale = 1.1;
    }
    else if (IS_IPHONE_6P_IOS7)
    {
        scale = 1.2;
    }
    else if (IS_IPAD_AIR || IS_IPAD3 || IS_IPAD4 || IS_IPAD_MINI_1G || IS_IPAD_MINI_2G)
    {
        scale = 1.5;
    }
    else if (IS_IPAD2 || [[Settings deviceModelName] isEqualToString:@"iPad Simulator"])
    {
        scale = 1.5;
    }
    
    return scale;
}

-(CGFloat) scaleBlockGameScene
{
    CGFloat scale = 0;
    if (IS_IPHONE_4_AND_OLDER_IOS7)
    {
        scale=0.8;
    }
    else if (IS_IPHONE_5_IOS7)
    {
        scale = 0.8;
    }
    else if (IS_IPHONE_6_IOS7)
    {
        scale = 1.0;
    }
    else if (IS_IPHONE_6P_IOS7)
    {
        scale = 1.0;
    }
    else if (IS_IPAD_AIR || IS_IPAD3 || IS_IPAD4 || IS_IPAD_MINI_1G || IS_IPAD_MINI_2G)
    {
        scale = 1.35;
    }
    else if (IS_IPAD2 || [[Settings deviceModelName] isEqualToString:@"iPad Simulator"])
    {
        scale = 1.5;
    }
    
    return scale;
}

#pragma mark - Boosters
//  0[Boosters] 1[Horn] 2[amount]
+(NSArray*) scaleForBottomBar
{
    NSArray *arr ;
    if (IS_IPHONE_4_AND_OLDER_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.12],
               [NSNumber numberWithFloat:0.16],
               [NSNumber numberWithFloat:0.7],nil];
    }
    else if (IS_IPHONE_5_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.13],
               [NSNumber numberWithFloat:0.195],
               [NSNumber numberWithFloat:0.7],nil];
    }
    else if (IS_IPHONE_6_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.14],
               [NSNumber numberWithFloat:0.195],
               [NSNumber numberWithFloat:0.85],nil];
    }
    else if (IS_IPHONE_6P_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.15],
               [NSNumber numberWithFloat:0.195],
               [NSNumber numberWithFloat:1.0],nil];
    }
    else if (IS_IPAD2 || [[Settings deviceModelName] isEqualToString:@"iPad Simulator"])
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.11],
               [NSNumber numberWithFloat:0.14],
               [NSNumber numberWithFloat:1.4],nil];
    }
    
    else if (IS_IPAD_AIR || IS_IPAD3 || IS_IPAD4 || IS_IPAD_MINI_1G || IS_IPAD_MINI_2G)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.11],
               [NSNumber numberWithFloat:0.14],
               [NSNumber numberWithFloat:1.4],nil];
    }
    return arr;
}

#pragma mark - PlusOneScale

+ (CGFloat)scalePlusOne {
    CGFloat scale = 0;
    if (IS_IPHONE_4_AND_OLDER_IOS7)
    {
        scale = 0.7;
    }
    else if (IS_IPHONE_5_IOS7)
    {
        scale = 0.8;
    }
    else if (IS_IPHONE_6_IOS7)
    {
        scale = 1;
    }
    else if (IS_IPHONE_6P_IOS7)
    {
        scale = 1.3;
    }
    else if (IS_IPAD2 || [[Settings deviceModelName] isEqualToString:@"iPad Simulator"])
    {
        scale = 1.6;
    }
    
    else if (IS_IPAD_AIR || IS_IPAD3 || IS_IPAD4 || IS_IPAD_MINI_1G || IS_IPAD_MINI_2G)
    {
        scale = 1.5;
    }
    return scale;
}

#pragma mark - FirstHelper
//  0[Bumble Position x ] 1[Bumble Position y] 2[Width Bumble] 3[ Height Bumble] 4[Width Arrow] 5[ Height Arrow]
-(NSArray*) scaleForFirsGameScene
{
    NSArray *arr ;
    if (IS_IPHONE_4_AND_OLDER_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.05],
               [NSNumber numberWithFloat:0.08],
               [NSNumber numberWithFloat:0.37],
               [NSNumber numberWithFloat:0.27],
               [NSNumber numberWithFloat:0.07],
               [NSNumber numberWithFloat:0.064],nil];
    }
    else if (IS_IPHONE_5_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.06],
               [NSNumber numberWithFloat:0.06],
               [NSNumber numberWithFloat:0.37],
               [NSNumber numberWithFloat:0.27],
               [NSNumber numberWithFloat:0.07],
               [NSNumber numberWithFloat:0.059],nil];
    }
    else if (IS_IPHONE_6_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.055],
               [NSNumber numberWithFloat:0.065],
               [NSNumber numberWithFloat:0.37],
               [NSNumber numberWithFloat:0.26],
               [NSNumber numberWithFloat:0.07],
               [NSNumber numberWithFloat:0.059],nil];
    }
    else if (IS_IPHONE_6P_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.05],
               [NSNumber numberWithFloat:0.06],
               [NSNumber numberWithFloat:0.35],
               [NSNumber numberWithFloat:0.22],
               [NSNumber numberWithFloat:0.06],
               [NSNumber numberWithFloat:0.059],nil];
    }
    else if (IS_IPAD2 || [[Settings deviceModelName] isEqualToString:@"iPad Simulator"])
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.04],
               [NSNumber numberWithFloat:0.06],
               [NSNumber numberWithFloat:0.27],
               [NSNumber numberWithFloat:0.19],
               [NSNumber numberWithFloat:0.05],
               [NSNumber numberWithFloat:0.06],nil];
    }
    
    else if (IS_IPAD_AIR || IS_IPAD3 || IS_IPAD4 || IS_IPAD_MINI_1G || IS_IPAD_MINI_2G)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:0.035],
               [NSNumber numberWithFloat:0.06],
               [NSNumber numberWithFloat:0.23],
               [NSNumber numberWithFloat:0.17],
               [NSNumber numberWithFloat:0.05],
               [NSNumber numberWithFloat:0.06],nil];
    }
    return arr;
}

+(CGFloat) scaleForElementsInHelper
{
    CGFloat scale = 0;
    if (IS_IPHONE_4_AND_OLDER_IOS7)
    {
        scale = 0.9;
    }
    else if (IS_IPHONE_5_IOS7)
    {
        scale = 0.9;
    }
    else if (IS_IPHONE_6_IOS7)
    {
        scale = 0.9;
    }
    else if (IS_IPHONE_6P_IOS7)
    {
        scale = 0.9;
    }
    else if (IS_IPAD_AIR || IS_IPAD3 || IS_IPAD4 || IS_IPAD_MINI_1G || IS_IPAD_MINI_2G)
    {
        scale = 0.9;
    }
    else if (IS_IPAD2 || [[Settings deviceModelName] isEqualToString:@"iPad Simulator"])
    {
        scale = 0.9;
    }
    
    return scale;
}


#pragma mark - ScoreLine
// [Line length]  [size stars]
+(NSArray*) scaleForScoreLine
{
    NSArray *arr ;
    if (IS_IPHONE_4_AND_OLDER_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:180],
               [NSNumber numberWithFloat:0.9],nil];
    }
    else if (IS_IPHONE_5_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:190],
               [NSNumber numberWithFloat:1.0],nil];
    }
    else if (IS_IPHONE_6_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:220],
               [NSNumber numberWithFloat:1.1],nil];
    }
    else if (IS_IPHONE_6P_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:250],
               [NSNumber numberWithFloat:1.2],nil];
    }
    else if (IS_IPAD2 || [[Settings deviceModelName] isEqualToString:@"iPad Simulator"])
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:450],
               [NSNumber numberWithFloat:1.7],nil];
    }
    
    else if (IS_IPAD_AIR || IS_IPAD3 || IS_IPAD4 || IS_IPAD_MINI_1G || IS_IPAD_MINI_2G)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:450],
               [NSNumber numberWithFloat:1.7],
               nil];
    }
    return arr;
}

#pragma mark - Window
// 0[Window Complite Height]  1[Window Complite width]  2[LEvel Font Height] 3[Window OutOfMoves Height]  4[Window OutOfMoves width]
+(NSArray*) scaleWindows
{
    NSArray *arr ;
    if (IS_IPHONE_4_AND_OLDER_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:1.1],
               [NSNumber numberWithFloat:0.9],
               [NSNumber numberWithFloat:0.75],
               [NSNumber numberWithFloat:1.0],
               [NSNumber numberWithFloat:0.9],
              nil];
    }
    else if (IS_IPHONE_5_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:1.0],
               [NSNumber numberWithFloat:0.93],
               [NSNumber numberWithFloat:0.8],
               [NSNumber numberWithFloat:1.1],
               [NSNumber numberWithFloat:0.9],
               nil];
    }
    else if (IS_IPHONE_6_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:1.0],
               [NSNumber numberWithFloat:1.0],
               [NSNumber numberWithFloat:1.0],
               [NSNumber numberWithFloat:1.1],
               [NSNumber numberWithFloat:0.9],
               nil];
    }
    else if (IS_IPHONE_6P_IOS7)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:1.0],
               [NSNumber numberWithFloat:1.0],
               [NSNumber numberWithFloat:1.0],
               [NSNumber numberWithFloat:1.0],
               [NSNumber numberWithFloat:0.9],
               nil];
    }
    else if (IS_IPAD2 || [[Settings deviceModelName] isEqualToString:@"iPad Simulator"])
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:1.1],
               [NSNumber numberWithFloat:0.9],
               [NSNumber numberWithFloat:1.6],
               [NSNumber numberWithFloat:0.83],
               [NSNumber numberWithFloat:0.9],
               nil];
    }
    
    else if (IS_IPAD_AIR || IS_IPAD3 || IS_IPAD4 || IS_IPAD_MINI_1G || IS_IPAD_MINI_2G)
    {
        arr = [NSArray arrayWithObjects:
               [NSNumber numberWithFloat:1.05],
               [NSNumber numberWithFloat:0.9],
               [NSNumber numberWithFloat:1.6],
               [NSNumber numberWithFloat:0.8],
               [NSNumber numberWithFloat:0.9],
               nil];
    }
    return arr;
}


@end
