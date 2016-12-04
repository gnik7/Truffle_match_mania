//
//  Settings.h
//  CookieCrunch
//
//  Created by Nikita Gil' on 13.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef CookieCrunch_Settings_h
#define CookieCrunch_Settings_h

//1. GLOBAL

#define ARRAY_DIMENSION                 15
#define LEVELS_IN_GAME                  18
#define POSITION_X                      self.frame.size.width
#define POSITION_Y                      self.frame.size.height
#define FONT_NAME                       @"Vogue Cyr Bold"
#define TIME_LIFE                       3 * 60
#define TOTAL_LIFES                     5
#define TIME_TO_START_HINT_ANIMATION    8
#define ENDLEVEL                        18
#define NEUTRAL_CHARACTER_TYPE          30
#define HARDNESLEVEL                    4


//1.1 Sizes

#pragma mark - Sizes

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_IPAD2 (IS_IPAD && (([[Settings deviceModelName] isEqualToString:@"iPad 2(WiFi)"]) || ([[Settings deviceModelName] isEqualToString:@"iPad 2(GSM)"]) || ([[Settings deviceModelName] isEqualToString:@"iPad 2(CDMA)"]) || ([[Settings deviceModelName] isEqualToString:@"iPad 2(WiFi Rev A)"])))
#define IS_IPAD_AIR (IS_IPAD && (([[Settings deviceModelName] isEqualToString:@"iPad Air(WiFi)"]) || ([[Settings deviceModelName] isEqualToString:@"iPad Air(GSM)"]) || ([[Settings deviceModelName] isEqualToString:@"iPad Air(GSM+CDMA)"])))
#define IS_IPAD_MINI_1G (IS_IPAD && (([[Settings deviceModelName] isEqualToString:@"iPad Mini 1G (WiFi)"]) || ([[Settings deviceModelName] isEqualToString:@"iPad Mini 1G (GSM)"]) || ([[Settings deviceModelName] isEqualToString:@"iPad Mini 1G (GSM+CDMA)"])))
#define IS_IPAD3 (IS_IPAD && (([[Settings deviceModelName] isEqualToString:@"iPad 3(WiFi)"]) || ([[Settings deviceModelName] isEqualToString:@"iPad 3(GSM+CDMA)"]) || ([[Settings deviceModelName] isEqualToString:@"iPad 3(GSM)"])))
#define IS_IPAD4 (IS_IPAD && (([[Settings deviceModelName] isEqualToString:@"iPad 4(WiFi)"]) || ([[Settings deviceModelName] isEqualToString:@"iPad 4(GSM+CDMA)"]) || ([[Settings deviceModelName] isEqualToString:@"iPad 4(GSM)"])))
#define IS_IPAD_MINI_2G (IS_IPAD && (([[Settings deviceModelName] isEqualToString:@"iPad Mini 2G (WiFi)"]) || ([[Settings deviceModelName] isEqualToString:@"iPad Mini 2G (GSM)"]) || ([[Settings deviceModelName] isEqualToString:@"iPad Mini 2G (GSM+CDMA)"])))

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_AND_OLDER_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0f)
#define IS_IPHONE_5_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6P_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)

//2. START

//Positions
#define POSITION_OF_BUTTON_START_X          self.frame.size.width / 2
#define POSITION_OF_BUTTON_START_Y          self.frame.size.height / 8
#define SIZE_OF_BUTTON_START                self.frame.size.width / 3

//3. MAP

#define NUMBER_OF_MAPS                      2

//4. GAMESCENE

//4.1 Position

#define POSITION_OF_BACKGROUND_X            self.frame.size.width / 2
#define POSITION_OF_BACKGROUND_Y            self.frame.size.height / 2

#define NUM_CHARACTER_TYPES                                  6

//5. LEVEL

#define LEFT_SIDE                           _characters[character.column-1][character.row]
#define RIGHT_SIDE                          _characters[character.column+1][character.row]
#define TOP_SIDE                            _characters[character.column][character.row+1]
#define BOTTOM_SIDE                         _characters[character.column][character.row-1]
#define LEFT_TOP_CORNER_SIDE                _characters[character.column-1][character.row+1]
#define LEFT_BOTTOM_CORNER_SIDE             _characters[character.column-1][character.row-1]
#define RIGHT_TOP_CORNER_SIDE               _characters[character.column+1][character.row+1]
#define RIGHT_BOTTOM_CORNER_SIDE            _characters[character.column+1][character.row-1]

//6. SCORE BAR

#define SCORE_BAR_BORDER_FIX_X_5_5S         5
#define SCORE_BAR_STARS_AMOUNT              3

//7. SCORES

#define SCORE_FOR_SINGLE_CHAIN              60
#define SCORE_FOR_SINGLE_CHARACTER          20

//8. BOOSTERS

#define BOOSTER_AMOUNT                      4
#define BOOSTER_SINGLE_AMOUNT               5
#define BOOSTER_FIRST_BOOSTER_AMOUNT        5
#define BOOSTER_FIRST_ACTIVATE_ON_LEVEL     1
#define BOOSTER_SECOND_BOOSTER_AMOUNT       5
#define BOOSTER_SECOND_ACTIVATE_ON_LEVEL    1
#define BOOSTER_THIRD_BOOSTER_AMOUNT        5
#define BOOSTER_THIRD_ACTIVATE_ON_LEVEL     1
#define BOOSTER_FOURTH_BOOSTER_AMOUNT       5
#define BOOSTER_FOURTH_ACTIVATE_ON_LEVEL    1

//10. HORN OF PLENTY

#define HORN_OF_PLENTY_X_DELTA              3.05
#define HORN_OF_PLENTY_Y_DELTA              2.27

//11. ANCHOR

#define ANCHOR_TYPE                         7

//12. Block/Cage

#define BLOCK_TYPE                          12

#pragma mark - Notifications

extern NSString * const KKLeftMovesEndsNotification;
extern NSString * const NGTwitterNotification;

#pragma mark - Fonts

//Font Size

#define FONT_SIZE_SCORE_GAME_SCENE          25
#define FONT_SIZE_LEVEL_MAP_SCENE           25
#define FONT_SIZE_MOVES_SMALL               8
#define FONT_SIZE_TARGETS_IN_TOP_BAR        13
#define FONT_SIZE_CURRENT_SCORE_IN_TOP_BAR  10
#define FONT_SIZE_WINDOW_FORM               40
#define FONT_SIZE_WINDOW_FORM_SCORE         30
#define FONT_SIZE_WINDOW_FORM_LEVEL         30
#define FONT_SIZE_WINDOW_FORM_EXTRAMOVES    25

//Color
#define FONT_COLOR_SCORE [UIColor colorWithRed:(204/255.0) green:(193/255.0) blue:(140/255.0) alpha:1]
#define FONT_COLOR_LEVEL_ON_MAP [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1]
#define FONT_COLOR_WHITE [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1]
#define FONT_COLOR_BLUE [UIColor colorWithRed:(0/255.0) green:(109/255.0) blue:(185/255.0) alpha:1]
#define FONT_COLOR_RED [UIColor colorWithRed:(251/255.0) green:(136/255.0) blue:(0/255.0) alpha:1]
#define FONT_COLOR_GREEN [UIColor colorWithRed:(4/255.0) green:(61/255.0) blue:(0/255.0) alpha:1]
#define FONT_COLOR_STROKE_UNDER_RED [UIColor colorWithRed:(31/255.0) green:(91/255.0) blue:(3/255.0) alpha:1]
#define FONT_COLOR_RESHUFFLE [UIColor colorWithRed:(238 /255.0) green:(238 /255.0) blue:(0/255.0) alpha:1]

typedef enum {
    HoverWindowPause = 1,
    HoverWindowGameMovesOut,
    HoverWindowGameCompleted
} HoverWindow;

typedef enum {
    HelperTypePlus = 1,
    HelperTypeBonus,
    HelperTypeBooster,
    HelperTypeFirstLevel
} HelperType;

#endif

@interface Settings : NSObject

+ (NSString*)deviceModelName;

@end
