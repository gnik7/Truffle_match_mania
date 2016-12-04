//
//  GameSceneWindow.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 25.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "GameSceneWindow.h"
#import "Settings.h"
#import "GameScene.h"

@implementation GameSceneWindow
{
    GameScene *selfName;
    ScaleUIonDevice *scale;
    SKTexture * _texture;
}

-(id)initWithSize:(CGSize)size withClass:(id)className
{
    if((self = [super initWithSize:size])){
        selfName = className;
        scale = [[ScaleUIonDevice alloc] init];
        
    }
    return self;
}
-(void) dealloc
{
     NSLog(@"Window  is deallocated");
}


-(void) hoverWindow:(HoverWindow)window
{
    _hoverLayer = [SKNode new];
    _hoverLayer.position = CGPointMake(-POSITION_X/2, -POSITION_Y/2);
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"tone"];
    background.position = CGPointMake(POSITION_OF_BACKGROUND_X, POSITION_OF_BACKGROUND_Y);
    background.size = CGSizeMake( self.frame.size.width , self.frame.size.height);
    background.zPosition = 121;
    background.alpha = 0;
    [_hoverLayer addChild:background];
    
    SKTextureAtlas * windowAtlas = [SKTextureAtlas atlasNamed:@"Window"];
    
    SKSpriteNode *formaImage;
    NSString *nameForma = @"";
    CGSize sizeBg ;
    switch (window) {
        case HoverWindowPause:
        {
            nameForma = @"bg_settings";
            sizeBg = CGSizeMake(self.frame.size.width *0.8 , self.frame.size.width * 0.8);
        }
            break;
        case HoverWindowGameCompleted:
        {
            nameForma = @"bg_complite";
            sizeBg = CGSizeMake(self.frame.size.width *0.95 *[[[ScaleUIonDevice scaleWindows] objectAtIndex:1] floatValue] , self.frame.size.height * 0.68 * [[[ScaleUIonDevice scaleWindows] objectAtIndex:0] floatValue]);
        }
            break;
        case HoverWindowGameMovesOut:
        {
            nameForma = @"bg_ofMoves";
            sizeBg = CGSizeMake(self.frame.size.width *0.8*[[[ScaleUIonDevice scaleWindows] objectAtIndex:3] floatValue] , self.frame.size.height * 0.75 * [[[ScaleUIonDevice scaleWindows] objectAtIndex:4] floatValue]);
        }
            break;
            
        default:
            break;
    }
    
    _texture = [windowAtlas textureNamed:nameForma];
    formaImage = [SKSpriteNode spriteNodeWithTexture:_texture];
    formaImage.name = @"formaImage";
    formaImage.position = CGPointMake(POSITION_OF_BACKGROUND_X, POSITION_OF_BACKGROUND_Y);
    formaImage.size = sizeBg;
    formaImage.zPosition = 122;
    [_hoverLayer addChild:formaImage];
    
   
    
    //Label Your score
    SKLabelNode *yourScoreLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
    yourScoreLabel.fontSize = FONT_SIZE_WINDOW_FORM * [scale scaleFontForGameWindow];
    yourScoreLabel.fontColor = FONT_COLOR_GREEN;
    yourScoreLabel.position = CGPointMake(formaImage.position.x , formaImage.position.y + formaImage.size.height * 0.11);
    yourScoreLabel.zPosition = 122;
    [_hoverLayer addChild:yourScoreLabel];
    
    
    switch (window) {
        case HoverWindowPause:
        {
            [self setOnOffBackgroundSound:self.backgroundMusicIsEnabled];
            [self setOnOffVolume:self.volumeButtonISEnabled];
//            [self setVolume:@"sound"];
//            [self setBackgroundSound:@"music"];

            if (_currentLevel !=1)
            {
                if (!selfName.forbidRestart)
                {
                    _texture = [windowAtlas textureNamed:@"again1"];
                    _retryButton = [SKSpriteNode spriteNodeWithTexture:_texture];
                    _retryButton.name = @"restartButton";
                    _retryButton.position = CGPointMake(formaImage.position.x -formaImage.position.x*0.3 , formaImage.position.y - formaImage.size.height * 0.08);
                    _retryButton.size = CGSizeMake(formaImage.size.width *0.2 , formaImage.size.height * 0.2);
                    _retryButton.zPosition = 122;
                    [_hoverLayer addChild:_retryButton];
                }
            }
            _texture = [windowAtlas textureNamed:@"home1"];
            _goToMapButton = [SKSpriteNode spriteNodeWithTexture:_texture];
            _goToMapButton.name = @"giveUpButton";
            _goToMapButton.position = CGPointMake(formaImage.position.x + formaImage.position.x*0.3 , formaImage.position.y - formaImage.size.height * 0.08);
            _goToMapButton.size = CGSizeMake(formaImage.size.width *0.2 , formaImage.size.height * 0.2);
            _goToMapButton.zPosition = 122;
            [_hoverLayer addChild:_goToMapButton];
            
            _texture = [windowAtlas textureNamed:@"quit1"];
            _continueButton = [SKSpriteNode spriteNodeWithTexture:_texture];
            _continueButton.name = @"continueButton";
            _continueButton.position = CGPointMake(formaImage.position.x , formaImage.position.y - formaImage.size.height * 0.35);
            _continueButton.size = CGSizeMake(formaImage.size.width *0.8 , formaImage.size.height * 0.2);
            _continueButton.zPosition = 122;
            [_hoverLayer addChild:_continueButton];
        }
            break;
            
        case HoverWindowGameMovesOut:
        {
            //Button Restart
            _texture = [windowAtlas textureNamed:@"button_restart_out1"];
            _retryButton = [SKSpriteNode spriteNodeWithTexture:_texture];
            _retryButton.name = @"retryButton";
            _retryButton.position = CGPointMake(formaImage.position.x , formaImage.position.y - formaImage.size.height * 0.4);
            _retryButton.size = CGSizeMake(formaImage.size.width *0.6 , formaImage.size.width * 0.17);
            _retryButton.zPosition = 122;
            [_hoverLayer addChild:_retryButton];
            
            //Button Close
            _texture = [windowAtlas textureNamed:@"button_close1"];
            _closeButton = [SKSpriteNode spriteNodeWithTexture:_texture];
            _closeButton.name = @"closeButton";
            _closeButton.position = CGPointMake(formaImage.position.x + formaImage.size.width * 0.402 , formaImage.position.y + formaImage.size.height * 0.35);
            _closeButton.size = CGSizeMake(formaImage.size.width *0.08 , formaImage.size.width * 0.08);
            _closeButton.zPosition = 122;
            //[_hoverLayer addChild:_closeButton];

        }
            break;
        case HoverWindowGameCompleted:
        {
            //Label LEVEL
            _levelLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];

            _levelLabel.fontSize = FONT_SIZE_WINDOW_FORM * [[[ScaleUIonDevice scaleWindows] objectAtIndex:2] floatValue];
          
            _levelLabel.fontColor = FONT_COLOR_WHITE;
            _levelLabel.position = CGPointMake(formaImage.position.x , formaImage.position.y + formaImage.size.height * 0.38);
            _levelLabel.zPosition = 123;
            _levelLabel.text = @"1 Level";
            [_hoverLayer addChild:_levelLabel];
            
            //Label Score
            _scoreLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
            
            _scoreLabel.fontSize = FONT_SIZE_WINDOW_FORM_LEVEL * [scale scaleFontForGameWindow];
           
            _scoreLabel.fontColor = FONT_COLOR_GREEN;
            _scoreLabel.position = CGPointMake(formaImage.position.x , formaImage.position.y - formaImage.size.height * 0.1);
            _scoreLabel.zPosition = 123;
            [_hoverLayer addChild:_scoreLabel];
            _scoreLabel.text = @"Score: 3000";
            
            //Share Button
            _texture = [windowAtlas textureNamed:@"button_shared1"];
            _shareButton = [SKSpriteNode spriteNodeWithTexture:_texture];
            _shareButton.name = @"shareButton";
            _shareButton.position = CGPointMake(formaImage.position.x , formaImage.position.y - formaImage.size.height * 0.4);
            _shareButton.size = CGSizeMake(formaImage.size.width *0.6 , formaImage.size.width * 0.15);
            _shareButton.zPosition = 122;
            [_hoverLayer addChild:_shareButton];
            
            //Close Button
            _texture = [windowAtlas textureNamed:@"button_close1"];
            _closeButton = [SKSpriteNode spriteNodeWithTexture:_texture];
            _closeButton.name = @"closeButton";
            _closeButton.position = CGPointMake(formaImage.position.x + formaImage.size.width * 0.402 , formaImage.position.y + formaImage.size.height * 0.35);
            _closeButton.size = CGSizeMake(formaImage.size.width *0.08 , formaImage.size.width * 0.08);
            _closeButton.zPosition = 122;
            //[_hoverLayer addChild:_closeButton];
            
            CGPoint positionNextLevel ;
            if(_currentLevel != 1)
            {
                //Restart Button
                _texture = [windowAtlas textureNamed:@"button_restart1"];
                _restartButton = [SKSpriteNode spriteNodeWithTexture:_texture];
                _restartButton.name = @"retryButton";
                _restartButton.position = CGPointMake(formaImage.position.x - formaImage.position.x * 0.4 , formaImage.position.y - formaImage.size.height * 0.22);
                _restartButton.size = CGSizeMake(formaImage.size.width *0.38 , formaImage.size.width * 0.17);
                _restartButton.zPosition = 122;
                [_hoverLayer addChild:_restartButton];
                positionNextLevel = CGPointMake(formaImage.position.x + formaImage.position.x * 0.4 , formaImage.position.y - formaImage.size.height * 0.22);
            }
            else
            {
                positionNextLevel = CGPointMake(formaImage.position.x, formaImage.position.y - formaImage.size.height * 0.22);
            }
            
            if (_currentLevel != ENDLEVEL)
            {
                //Forward Button
                _texture = [windowAtlas textureNamed:@"button_nextlevel1"];
                _forwardButton = [SKSpriteNode spriteNodeWithTexture:_texture];
                _forwardButton.name = @"forwardButton";
                _forwardButton.position = positionNextLevel;
                _forwardButton.size = CGSizeMake(formaImage.size.width *0.38 , formaImage.size.width * 0.17);
                _forwardButton.zPosition = 122;
                [_hoverLayer addChild:_forwardButton];
            }
            else
            {
                _restartButton.position = CGPointMake(formaImage.position.x, formaImage.position.y - formaImage.size.height * 0.22);
            }
            

        }
            break;
            
        default:
            break;
    }


    [selfName addChild: _hoverLayer];
    [background runAction:[SKAction fadeInWithDuration:1.0f] completion:^{
        //Stars
        if (window == HoverWindowGameCompleted)
        {
            [self animationStars:formaImage];
        }
    }];

    
}


#pragma mark - HighlightButton

-(void) highlightButon:(SKSpriteNode *)button withBlock:(void(^)()) myblock
{
    __block SKSpriteNode * but = button;
    __block CGPoint pos = but.position;
    __block CGSize size = but.size;

    SKAction *wait = [SKAction waitForDuration:0.25f];
    SKAction *scaleUp =[SKAction scaleTo:1.1 duration:0.2];
    SKAction *scaleDown = [SKAction scaleTo:0.9 duration:0.2];
    SKAction *sequence = [SKAction sequence:@[scaleUp, scaleDown]];
    SKAction *repeat =[SKAction repeatAction:sequence count:3];
   
    SKAction *newSprite = [SKAction runBlock:^{
        [but removeFromParent];
        NSArray *arr = [but.texture.description componentsSeparatedByString:@"'"];
        NSMutableString *name = [NSMutableString stringWithString:[arr objectAtIndex:1]];
        [name deleteCharactersInRange:NSMakeRange([name length]-5, 5)];
        SKTextureAtlas * windowAtlas = [SKTextureAtlas atlasNamed:@"Window"];
        _texture = [windowAtlas textureNamed:[NSString stringWithFormat:@"%@2", name]];
        but = [SKSpriteNode spriteNodeWithTexture:_texture];
        but.size= size;
        but.position = pos;
        but.zPosition = 130;
        
        [_hoverLayer addChild:but];
    }];

    [but runAction:newSprite completion:^{
        [but runAction:repeat completion:^{
            [but runAction:wait completion:^{
                myblock();
            }];

        }];
    }];
}

#pragma mark - Music & Volume

-(void) setBackgroundSound:(NSString*)spriteName
{
    SKTextureAtlas * atlas = [SKTextureAtlas atlasNamed:@"Window"];
    _texture = [atlas textureNamed:spriteName];
    _backgroundMusicButton = [SKSpriteNode spriteNodeWithTexture:_texture];
    SKSpriteNode *formaTMP = (SKSpriteNode*)[_hoverLayer childNodeWithName:@"formaImage"];
    _backgroundMusicButton.zPosition = 122;
    _backgroundMusicButton.size = CGSizeMake(formaTMP.size.width *0.2 , formaTMP.size.height * 0.2);
    _backgroundMusicButton.position = CGPointMake( formaTMP.position.x + formaTMP.position.x*0.3 , formaTMP.position.y + formaTMP.size.height * 0.2);

    [_hoverLayer addChild:_backgroundMusicButton];
}

#pragma mark - Sound

-(void) setVolume:(NSString*)spriteName
{
    SKTextureAtlas * atlas = [SKTextureAtlas atlasNamed:@"Window"];
    _texture = [atlas textureNamed:spriteName];
    _volumeButton = [SKSpriteNode spriteNodeWithTexture:_texture];
    SKSpriteNode *formaTMP = (SKSpriteNode*)[_hoverLayer childNodeWithName:@"formaImage"];
    _volumeButton.zPosition = 122;
    _volumeButton.size = CGSizeMake(formaTMP.size.width *0.2 , formaTMP.size.height * 0.2);
    _volumeButton.position = CGPointMake( formaTMP.position.x - formaTMP.position.x*0.3 , formaTMP.position.y + formaTMP.size.height * 0.2 );

    [_hoverLayer addChild:_volumeButton];
}


-(void) setOnOffBackgroundSound:(BOOL)sound
{
    if (sound)
    {
        if(_backgroundMusicButton!= nil)
        {
            [_backgroundMusicButton removeFromParent];
            _backgroundMusicButton = nil;
        }
        [self setBackgroundSound:@"music"];
    }
    else
    {
        if(_backgroundMusicButton!= nil)
        {
            [_backgroundMusicButton removeFromParent];
            _backgroundMusicButton = nil;
        }
        [self setBackgroundSound:@"VolumeOff"];
    }
    
}

-(void) setOnOffVolume:(BOOL)volume
{
    if (volume)
    {
        if (_volumeButton!= nil)
        {
            [_volumeButton removeFromParent];
            _volumeButton = nil;
        }
        [self setVolume:@"sound"];
    }
    else
    {
        if (_volumeButton!= nil)
        {
            [_volumeButton removeFromParent];
            _volumeButton = nil;
        }
        [self setVolume:@"SoundOff"];
    }
}

#pragma mark - Stars Animation

-(void) animationStars:(SKSpriteNode*)formaImage
{
    NSArray *positionXStars = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat: formaImage.position.x - formaImage.position.x*0.52],
                               [NSNumber numberWithFloat: formaImage.position.x + formaImage.position.x*0.52],
                               [NSNumber numberWithFloat: formaImage.position.x],
                               nil];
    NSArray *positionYStars = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat: formaImage.position.y + formaImage.size.height * 0.07],
                               [NSNumber numberWithFloat: formaImage.position.y + formaImage.size.height * 0.07],
                               [NSNumber numberWithFloat: formaImage.position.y + formaImage.size.height * 0.11],
                               nil];
    NSMutableArray *arrStars = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *arrStarsAnimation = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *arrStarsAnimationScale = [NSMutableArray array];
    for (NSInteger i= 0; i < 3; i++)
    {
        NSString *fileName= @"";
        SKSpriteNode *stars;
        NSLog(@"STARS %d",  self.stars);
        CGPoint posStars = CGPointZero;
        if (i < self.stars)
        {
            fileName = [NSString stringWithFormat:@"star%lu", (long)i+1];
            posStars = CGPointMake( [[positionXStars objectAtIndex:i] floatValue] - formaImage.size.width * 1.1,[[positionYStars objectAtIndex:i] floatValue]);
        }
        else
        {
            fileName = [NSString stringWithFormat: @"star_unavalible%lu", (long)i+1];
            posStars = CGPointMake( [[positionXStars objectAtIndex:i] floatValue] + formaImage.size.width * 1.1,[[positionYStars objectAtIndex:i] floatValue]);
        }
        SKTextureAtlas * windowAtlas = [SKTextureAtlas atlasNamed:@"Window"];
        _texture = [windowAtlas textureNamed:fileName];
        stars = [SKSpriteNode spriteNodeWithTexture:_texture];
        stars.zPosition = 122;
        stars.position = posStars;
        
        if (i == 0)
        {
            stars.size = CGSizeMake(formaImage.size.width *0.32 , formaImage.size.width * 0.32);
        }
        else if (i == 1)
        {
            stars.size = CGSizeMake(formaImage.size.width *0.32 , formaImage.size.width * 0.32);
        }
        else if (i == 2)
        {
            stars.size = CGSizeMake(formaImage.size.width *0.42 , formaImage.size.width * 0.42);
        }
        
        [_hoverLayer addChild:stars];
        SKAction *moveStar = [SKAction moveToX:[[positionXStars objectAtIndex:i] floatValue] duration:0.2];
        moveStar.timingMode = SKActionTimingEaseIn;
        
        if (i < self.stars)
        {
            SKAction *scaleUp = [SKAction scaleTo:1.1 duration:0.2];
            SKAction *scaleDown = [SKAction scaleTo:0.9 duration:0.2];
            SKAction *sequence = [SKAction repeatActionForever:[SKAction sequence:@[scaleUp, scaleDown]]];
            [arrStarsAnimationScale addObject:sequence];
        }
  
        [arrStarsAnimation addObject:moveStar];
        [arrStars addObject:stars];
    }

    [[arrStars objectAtIndex:0] runAction:[arrStarsAnimation objectAtIndex:0] completion:^{
        [[arrStars objectAtIndex:1] runAction:[arrStarsAnimation objectAtIndex:1] completion:^{
            [[arrStars objectAtIndex:2] runAction:[arrStarsAnimation objectAtIndex:2] completion:^{
                for (NSInteger i= 0; i < [arrStarsAnimationScale count]; i++) {
                    [[arrStars objectAtIndex:i] runAction:[arrStarsAnimationScale objectAtIndex:i]];
                }
            }];
        }];
    }];

}



@end
