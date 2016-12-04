//
//  GameSceneWindow.h
//  CookieCrunch
//
//  Created by Nikita Gil' on 25.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Settings.h"
#import "ScaleUIonDevice.h"

@interface GameSceneWindow : SKScene

@property(strong, nonatomic) SKNode *hoverLayer;

@property(strong, nonatomic) SKSpriteNode *continueButton;
@property(strong, nonatomic) SKSpriteNode *retryButton;
@property(strong, nonatomic) SKSpriteNode *keepPlayingButton;
@property(strong, nonatomic) SKSpriteNode *giveUpButton;
@property(strong, nonatomic) SKSpriteNode *shareButton;
@property(strong, nonatomic) SKSpriteNode *restartButton;
@property(strong, nonatomic) SKSpriteNode *forwardButton;
@property(strong, nonatomic) SKSpriteNode *closeButton;
@property(strong, nonatomic) SKSpriteNode *goToMapButton;

@property(strong, nonatomic) SKLabelNode *scoreLabel;
@property(strong, nonatomic) SKLabelNode *keepPlayingLabel;
@property(strong, nonatomic) SKLabelNode *levelLabel;

@property(strong, nonatomic) NSMutableArray *targetsToLevel;
@property(assign, nonatomic) NSInteger stars;
@property(assign, nonatomic) NSInteger currentLevel;
@property (strong, nonatomic) SKSpriteNode *backgroundMusicButton;
@property (strong, nonatomic) SKSpriteNode *volumeButton;

@property (assign, nonatomic) BOOL backgroundMusicIsEnabled;
@property (assign, nonatomic) BOOL volumeButtonISEnabled;


-(id)initWithSize:(CGSize)size withClass:(id)className;
-(void) hoverWindow:(HoverWindow)window;
-(void) highlightButon:(SKSpriteNode *)button withBlock:(void(^)()) block;
-(void) setOnOffBackgroundSound:(BOOL)sound;
-(void) setOnOffVolume:(BOOL)volume;

@end
