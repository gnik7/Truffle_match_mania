//
//  MapScene.m
//  CookieCrunch
//
//  Created by Nikita Gil' on 12.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "MapScene.h"
#import "FirstLevelScene.h"
#import "GameScene.h"
#import "GameScene3.h"
#import "GameScene4.h"
#import "GameScene5.h"
#import "GameScene6.h"
#import "GameScene7.h"
#import "GameScene8.h"
#import "GameScene9.h"
#import "GameScene10.h"
#import "GameScene11.h"
#import "GameScene12.h"
#import "GameScene13.h"
#import "GameScene14.h"
#import "GameScene15.h"
#import "GameScene16.h"
#import "GameScene17.h"
#import "GameScene18.h"
#import "Settings.h"
#import "GameSceneHelper.h"
#import "ScaleUIonDevice.h"

static const float BG_VELOCITY = 1.0;

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}
static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

@implementation MapScene
{
    SKSpriteNode *firstLaunchButton;
    NSNumber *firstLaunch;
    NSNumber *activeLevels;
    NSMutableDictionary *dictionaryPositions;

    NSMutableArray *backgrounds;
    CGPoint beginPosition;
    CGPoint endPosition;
    BOOL stopScrollBackground;
    SKNode *bgLayer;
    CGFloat heigth;
    SKSpriteNode *background1;
    SKSpriteNode *background2;
    NSInteger lifeCount;
    SKLabelNode *lifeLabel;
    GameSceneHelper *helper;

}

#pragma mark - Init

-(id)initWithSize:(CGSize)size
{
    if((self = [super initWithSize:size])) {
        self.anchorPoint = CGPointMake(0,0);
        firstLaunch = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"];
        helper = [[GameSceneHelper alloc] init];
        
        //нужно реализовать логику при подсчете очков
        activeLevels = [[NSUserDefaults standardUserDefaults] objectForKey:@"activeLevels"];
        if ([firstLaunch intValue] == 0)
        {
            [self firstLaunchNodes];
            
//            activeLevels = [NSNumber numberWithInteger:2]; /// change to1
//            [[NSUserDefaults standardUserDefaults] setObject:activeLevels forKey:@"activeLevels"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"helper4InRow"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"helper5InRow"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        else
        {
            bgLayer = [SKNode node];
            [self setBackground];
            [self positionOfButtons];
            [self setButtons];
            [self setCursor];
            [self addChild:bgLayer];
            
        }
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"Lifes"]];
        lifeCount = [arr count];
    }
    return self;
}

-(void) dealloc
{
    NSLog(@" MAP deallocated");
    helper = nil;
    bgLayer = nil;
}


#pragma mark - Update

- (void)update:(NSTimeInterval)currentTime {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"Lifes"]];
    NSInteger countArray = [arr count];
    if (countArray > 0)
    {
        NSDate *now = [[NSDate alloc]init];
        NSInteger index = 0;
        NSTimeInterval secondsBetween = [(NSDate*)[arr objectAtIndex:0] timeIntervalSinceDate:now];
        for (NSDate *d in arr)
        {
            NSDate *date2 = d;
            NSComparisonResult result = [date2 compare:now];
            
            if(result==NSOrderedAscending)
            {
                NSLog(@"now is in the future");
                NSLog(@"i= %lu", (long)index);
                NSLog(@"===LIFES in  %@", arr);
                index++;
            }
            else if(result == NSOrderedDescending)
            {
                // NSLog(@"now is in the past");
            }
            
        }
        if (index>0)
        {
            [arr removeObjectAtIndex:index-1];
            NSLog(@"--------LIFES in  %@", arr);
            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"Lifes"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        if (countArray == 5)
        {
            //вызов метода для вызова лейба оповещения
            [lifeLabel removeFromParent];
            NSInteger timeMin = secondsBetween/60;
            [self setLabelForLifes:timeMin];
        }
        if (countArray < 5)
        {
            //вызов метода для вызова лейба оповещения
            [lifeLabel removeFromParent];
            lifeLabel= nil;
        }
    }
    else if (countArray == 0)
    {
        if (lifeLabel != nil)
        {
            [lifeLabel removeFromParent];
            lifeLabel= nil;
        }
    }
    lifeCount = [arr count];
    arr = nil;
}


#pragma mark - SetElemens

-(void) positionOfButtons
{
    dictionaryPositions = [NSMutableDictionary dictionaryWithCapacity:LEVELS_IN_GAME];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.46],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.225], nil]
                           forKey:@"1"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.27],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.235], nil]
                           forKey:@"2"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.18],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.28], nil]
                           forKey:@"3"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.37],
                                   [NSNumber numberWithFloat:POSITION_Y *0.323], nil]
                           forKey:@"4"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.54],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.35], nil]
                           forKey:@"5"];
    
    
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.45],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.41], nil]
                           forKey:@"6"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.69],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.43], nil]
                           forKey:@"7"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.5],
                                   [NSNumber numberWithFloat:POSITION_Y *0.5], nil]
                           forKey:@"8"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.69],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.535], nil]
                           forKey:@"9"];
    
    
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.4],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.56], nil]
                           forKey:@"10"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.4],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.63], nil]
                           forKey:@"11"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.69],
                                   [NSNumber numberWithFloat:POSITION_Y *0.6], nil]
                           forKey:@"12"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.84],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.65], nil]
                           forKey:@"13"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.77],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.71], nil]
                           forKey:@"14"];
    
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.6],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.71], nil]
                           forKey:@"15"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.4],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.71], nil]
                           forKey:@"16"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.28],
                                   [NSNumber numberWithFloat:POSITION_Y *0.77], nil]
                           forKey:@"17"];
    [dictionaryPositions setValue:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:POSITION_X * 0.26],
                                   [NSNumber numberWithFloat:POSITION_Y * 0.84], nil]
                           forKey:@"18"];
}

-(void)firstLaunchNodes
{
    SKTextureAtlas * atlasFirstNode = [SKTextureAtlas atlasNamed:@"MapMain"];
    SKTexture * textureBut = [atlasFirstNode textureNamed:@"FirstLaunchBackground"];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:textureBut];
    background.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    background.zPosition = 1;
    [self addChild:background];
    
    ScaleUIonDevice *scale = [[ScaleUIonDevice alloc] init];
    NSArray *arrScale = [scale scaleForFirstStartMap];
    
    firstLaunchButton = [SKSpriteNode spriteNodeWithImageNamed:@"FirstLaunchButton"];
    firstLaunchButton.name = @"firstLaunchButton";
    firstLaunchButton.anchorPoint = CGPointMake( 0.5, 0.5);

    firstLaunchButton.position = CGPointMake(POSITION_X *[[arrScale objectAtIndex:2] floatValue] ,  POSITION_Y *[[arrScale objectAtIndex:3] floatValue]);
    firstLaunchButton.size = CGSizeMake(self.frame.size.width * [[arrScale objectAtIndex:0] floatValue], self.frame.size.width * [[arrScale objectAtIndex:1] floatValue]);
    firstLaunchButton.zPosition = 2;
    [self addChild:firstLaunchButton];
    scale = nil;
    
    SKSpriteNode *person = [SKSpriteNode spriteNodeWithImageNamed:@"pers2"];
    person.anchorPoint = CGPointMake(1, 0);
    person.size = CGSizeMake(self.frame.size.width * 0.5, self.frame.size.width * 0.9);
    person.position = CGPointMake(self.frame.size.width * 1, self.frame.size.height * 0);
    person.zPosition = 3;
    [self addChild:person];
    
    SKSpriteNode *letter = [SKSpriteNode spriteNodeWithImageNamed:@"helperMap"];
    letter.anchorPoint = CGPointMake(0, 0);
    letter.size = CGSizeMake(self.frame.size.width * 0.5, self.frame.size.width * 0.4);
    letter.position = CGPointMake(self.frame.size.width * 0.05, self.frame.size.height * 0.38);
    letter.zPosition = 3;
    [self addChild:letter];
}

-(void)setBackground
{
    
//    for(NSInteger i = 0; i < NUMBER_OF_MAPS; i++)
//    {
        background1 = [SKSpriteNode spriteNodeWithImageNamed:@"GameMap0"];
        background1.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        background1.position = CGPointMake( 0, 0);
        background1.anchorPoint = CGPointZero;
        background1.name = @"background1";
        background1.zPosition = 1;
        //heigth = background.size.height;
        [bgLayer addChild:background1];
        [backgrounds addObject:background1];
    
    background2 = [SKSpriteNode spriteNodeWithImageNamed:@"GameMap1"];
    background2.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    background2.position = CGPointMake( 0, background1.size.height );
    background2.anchorPoint = CGPointZero;
    background2.name = @"background2";
    background2.zPosition = 1;
    //heigth = background.size.height;
    [bgLayer addChild:background2];
    [backgrounds addObject:background2];
//    }
}

-(void) setFirstButton
{
    ScaleUIonDevice *scaleUI = [[ScaleUIonDevice alloc] init];
    NSArray *arrScale = [scaleUI scaleForMapElements];
    
    SKTextureAtlas * atlas = [SKTextureAtlas atlasNamed:@"Map"];
    SKTexture * texture = [atlas textureNamed:@"lvl_1"];
    SKSpriteNode *button = [SKSpriteNode spriteNodeWithTexture:texture];
    button.name = [NSString stringWithFormat:@"button%d", 1];
    button.size = CGSizeMake(button.size.width * [arrScale[0] floatValue],  button.size.height * [arrScale[0] floatValue] );
    NSArray *tmp = [NSArray arrayWithArray: [dictionaryPositions valueForKey:[NSString stringWithFormat:@"%d", 1]]];
    CGFloat posx = [[tmp objectAtIndex:0] floatValue];
    CGFloat posy =[[tmp objectAtIndex:1] floatValue];
    button.position = CGPointMake(posx, posy);
    button.zPosition = 5;
    [bgLayer addChild:button];
}

-(void) setButtons
{
    ScaleUIonDevice *scaleUI = [[ScaleUIonDevice alloc] init];
    NSArray *arrScale = [scaleUI scaleForMapElements];
    
    [self setFirstButton];
    SKTextureAtlas * atlas = [SKTextureAtlas atlasNamed:@"Map"];
    for (NSUInteger i = 2; i <= LEVELS_IN_GAME; i++)
    {
        SKSpriteNode *button;
        if ( i < [activeLevels intValue])
        {
            SKTexture * texture = [atlas textureNamed:[NSString stringWithFormat:@"lvl_%lu", (unsigned long)i ]];
            button = [SKSpriteNode spriteNodeWithTexture:texture];
        }
        else if ( i == [activeLevels intValue])
        {
            SKTexture * texture = [atlas textureNamed:[NSString stringWithFormat:@"cur_%lu", (unsigned long)i ]];
            button = [SKSpriteNode spriteNodeWithTexture:texture];
        }
        else
        {
            SKTexture * texture = [atlas textureNamed:@"lock"];
            button = [SKSpriteNode spriteNodeWithTexture:texture];
        }
        
        button.name = [NSString stringWithFormat:@"button%lu", (unsigned long)i];
        button.size = CGSizeMake(button.size.width * [arrScale[0] floatValue],  button.size.height * [arrScale[0] floatValue] );
        NSArray *tmp = [NSArray arrayWithArray: [dictionaryPositions valueForKey:[NSString stringWithFormat:@"%lu", (unsigned long)i]]];
        CGFloat posx = [[tmp objectAtIndex:0] floatValue];
        CGFloat posy =[[tmp objectAtIndex:1] floatValue];
        button.position = CGPointMake(posx, posy);
        button.zPosition = 5;
        [bgLayer addChild:button];
    }
}

-(void) setCursor
{
    ScaleUIonDevice *scaleUI = [[ScaleUIonDevice alloc] init];
    NSArray *arrScale = [scaleUI scaleForMapElements];

    NSInteger lastLevel = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LastLevel"] integerValue];
    
    if ([activeLevels integerValue] == lastLevel)
    {
        SKSpriteNode *cursor = [SKSpriteNode spriteNodeWithImageNamed:@"cursor"];
        NSArray *tmp = [NSArray arrayWithArray: [dictionaryPositions valueForKey:[NSString stringWithFormat:@"%lu", (unsigned long)lastLevel]]];
        CGFloat posx = [[tmp objectAtIndex:0] floatValue];
        CGFloat posy =[[tmp objectAtIndex:1] floatValue] + POSITION_Y*[arrScale[1] floatValue];
        cursor.position = CGPointMake(posx, posy);
        cursor.size = CGSizeMake(cursor.size.width * [arrScale[0] floatValue],  cursor.size.height * [arrScale[0] floatValue] );
        cursor.zPosition = 6;
        [bgLayer addChild:cursor];
    }
    else if ([activeLevels integerValue] > lastLevel)
    {
        [self animateCursorMove:lastLevel];
    }
}

-(void) animateCursorMove:(NSInteger)lastLevel
{
    ScaleUIonDevice *scaleUI = [[ScaleUIonDevice alloc] init];
    NSArray *arrScale = [scaleUI scaleForMapElements];
    
    SKSpriteNode *cursor = [SKSpriteNode spriteNodeWithImageNamed:@"cursor"];
    
    NSArray *fromPointAr = [NSArray arrayWithArray: [dictionaryPositions valueForKey:[NSString stringWithFormat:@"%lu", (unsigned long)lastLevel]]];
    CGFloat posx = [[fromPointAr objectAtIndex:0] floatValue];
    CGFloat posy =[[fromPointAr objectAtIndex:1] floatValue] + POSITION_Y*[arrScale[1] floatValue];
    cursor.position = CGPointMake(posx, posy);
    cursor.size = CGSizeMake(cursor.size.width * [arrScale[0] floatValue],  cursor.size.height * [arrScale[0] floatValue] );
    cursor.zPosition = 6;
    [self addChild:cursor];
    
    NSArray *toPointAr = [NSArray arrayWithArray: [dictionaryPositions valueForKey:[NSString stringWithFormat:@"%lu", (unsigned long)[activeLevels integerValue]]]];
    
    CGPoint fromPoint = CGPointMake(posx, posy);
    CGPoint toPoint = CGPointMake( [[toPointAr objectAtIndex:0] floatValue], [[toPointAr objectAtIndex:1] floatValue] + POSITION_Y*[arrScale[1] floatValue]);
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, fromPoint.x, fromPoint.y);
    
    if (lastLevel == 5)
    {
        CGPoint pointMiddle = CGPointMake(POSITION_X * 0.63, POSITION_Y * 0.45);
        CGPathAddLineToPoint(pathToDraw, NULL, pointMiddle.x , pointMiddle.y);
    }
    else if (lastLevel == 8 || lastLevel == 9)
    {
        CGPoint pointMiddle = CGPointMake(POSITION_X * 0.515, POSITION_Y * 0.603);
        CGPathAddLineToPoint(pathToDraw, NULL, pointMiddle.x , pointMiddle.y);
    }
    
    CGPathAddLineToPoint(pathToDraw, NULL,toPoint.x , toPoint.y);
    
    SKShapeNode *invicibleLine =[SKShapeNode node];
    invicibleLine.path = pathToDraw;
    invicibleLine.lineWidth = 5;
    invicibleLine.zPosition = 10;
    [invicibleLine setStrokeColor:[UIColor colorWithRed:26/255.f green:230/255.f blue:77/255.f alpha:0 ]];
    [self addChild:invicibleLine];
    
    SKAction *followLine = [SKAction followPath:pathToDraw asOffset:NO orientToPath:NO duration:3.0f];
    [cursor runAction:followLine completion:^{
        if (lifeCount < 5)
        {
            NSString *className = @"GameScene";
            if ([activeLevels integerValue] != 2)
            {
                className = [NSString stringWithFormat:@"GameScene%d", [activeLevels integerValue]];;
            }
  
            SKView * skView = (SKView *)self.view;
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:1.5];
            
            NSString * file = [NSString stringWithFormat:@"Level_%d", [activeLevels integerValue]];
            GameScene *level = [[NSClassFromString(className) alloc] initWithSize:skView.bounds.size withFile:file];
            [self.view presentScene:level transition:reveal];
            level.myDelegate = helper;
            level = nil;
        }
    }];
    CGPathRelease(pathToDraw);
    
    [[NSUserDefaults standardUserDefaults] setObject:activeLevels forKey:@"LastLevel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void) setLabelForLifes:(NSInteger)time
{
    lifeLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
    lifeLabel.fontSize = 10;
    lifeLabel.fontColor = FONT_COLOR_RED;
    lifeLabel.position = CGPointMake(POSITION_X * 0.5, POSITION_Y * 0.05);
    lifeLabel.zPosition = 15;
    lifeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    if (time >= 1)
    {
         lifeLabel.text = [NSString stringWithFormat:@"You need to wait about %ld min. You life has ended.", (long)time ];
    }
    else
    {
         lifeLabel.text = @"You need to wait less 1 min. You life has ended.";
    }
    [self addChild:lifeLabel];
}

#pragma mark - Touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKView * skView = (SKView *)self.view;
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    
    if ([firstLaunch intValue] == 0)
    {
        for (UITouch *touch in touches)
        {
            CGPoint location = [touch locationInNode:self];
            if ([firstLaunchButton containsPoint:location])
            {
                FirstLevelScene *level = [[FirstLevelScene alloc] initWithSize:skView.bounds.size];
                [self.view presentScene:level transition:reveal];
                level.myDelegate = helper;
                level = nil;
            }
        }
    }
    else
    {
        // For scroll screen
        for (UITouch *touch in touches)
        {
            CGPoint location = [touch locationInNode:bgLayer];
//            beginPosition = location;
            SKView * skView = (SKView *)self.view;
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            
            SKSpriteNode *button1 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button1"];
            SKSpriteNode *button2 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button2"];
            SKSpriteNode *button3 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button3"];
            SKSpriteNode *button4 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button4"];
            SKSpriteNode *button5 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button5"];
            SKSpriteNode *button6 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button6"];
            SKSpriteNode *button7 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button7"];
            SKSpriteNode *button8 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button8"];
            SKSpriteNode *button9 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button9"];
            SKSpriteNode *button10 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button10"];
            SKSpriteNode *button11 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button11"];
            SKSpriteNode *button12 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button12"];
            SKSpriteNode *button13 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button13"];
            SKSpriteNode *button14 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button14"];
            SKSpriteNode *button15 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button15"];
            SKSpriteNode *button16 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button16"];
            SKSpriteNode *button17 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button17"];
            SKSpriteNode *button18 = (SKSpriteNode*)[bgLayer childNodeWithName:@"button18"];
            
            //GameScene *object = [[NSClassFromString(@"GameScene3") alloc] init];
            if (lifeCount < 5)
            {
                if ([button1 containsPoint:location] && [activeLevels intValue] == 1 )
                {
                    NSLog(@" Button 1 pressed");
                    NSLog(@" %d" , [activeLevels intValue]);
                    
                    FirstLevelScene *level = [[FirstLevelScene alloc] initWithSize:skView.bounds.size];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button2 containsPoint:location] && [activeLevels intValue] >= 2)
                {
                    NSString * file = @"Level_2";
                    GameScene *level = [[GameScene alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button3 containsPoint:location] && [activeLevels intValue] >= 3)
                {
                    NSString * file = @"Level_3";
                    GameScene3 *level = [[GameScene3 alloc]  initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button4 containsPoint:location] && [activeLevels intValue] >= 4)
                {
                    NSString * file = @"Level_4";
                    GameScene4 *level = [[GameScene4 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button5 containsPoint:location] && [activeLevels intValue] >= 5)
                {
                    NSString * file = @"Level_5";
                    GameScene5 *level = [[GameScene5 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button6 containsPoint:location] && [activeLevels intValue] >= 6)
                {
                    NSString * file = @"Level_6";
                    GameScene6 *level = [[GameScene6 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button7 containsPoint:location] && [activeLevels intValue] >= 7)
                {
                    NSString * file = @"Level_7";
                    GameScene7 *level = [[GameScene7 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button8 containsPoint:location] && [activeLevels intValue] >= 8)
                {
                    NSString * file = @"Level_8";
                    GameScene8 *level = [[GameScene8 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button9 containsPoint:location] && [activeLevels intValue] >= 9)
                {
                    NSString * file = @"Level_9";
                    GameScene9 *level = [[GameScene9 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button10 containsPoint:location] && [activeLevels intValue] >= 10)
                {
                    NSString * file = @"Level_10";
                    GameScene10 *level = [[GameScene10 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button11 containsPoint:location] && [activeLevels intValue] >= 11)
                {
                    NSString * file = @"Level_11";
                    GameScene11 *level = [[GameScene11 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button12 containsPoint:location] && [activeLevels intValue] >= 12)
                {
                    NSString * file = @"Level_12";
                    GameScene12 *level = [[GameScene12 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button13 containsPoint:location] && [activeLevels intValue] >= 13)
                {
                    NSString * file = @"Level_13";
                    GameScene13 *level = [[GameScene13 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button14 containsPoint:location] && [activeLevels intValue] >= 14)
                {
                    NSString * file = @"Level_14";
                    GameScene14 *level = [[GameScene14 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button15 containsPoint:location] && [activeLevels intValue] >= 15)
                {
                    NSString * file = @"Level_15";
                    GameScene15 *level = [[GameScene15 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button16 containsPoint:location] && [activeLevels intValue] >= 16)
                {
                    NSString * file = @"Level_16";
                    GameScene16 *level = [[GameScene16 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button17 containsPoint:location] && [activeLevels intValue] >= 17)
                {
                    NSString * file = @"Level_17";
                    GameScene17 *level = [[GameScene17 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
                else if ([button18 containsPoint:location] && [activeLevels intValue] >= 18)
                {
                    NSString * file = @"Level_18";
                    GameScene18 *level = [[GameScene18 alloc] initWithSize:skView.bounds.size withFile:file];
                    [self.view presentScene:level transition:reveal];
                    level.myDelegate = helper;
                    level = nil;
                }
            }
            
            skView = nil;
            
            button1 = nil;
            button2 = nil;
            button3 = nil;
            button4 = nil;
            button5 = nil;
            button6 = nil;
            button7 = nil;
            button8 = nil;
            button9 = nil;
            button10 = nil;
            button11 = nil;
            button12 = nil;
            button13 = nil;
            button14 = nil;
            button15 = nil;
            button16 = nil;
            button17 = nil;
            button18 = nil;

        }
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];

    endPosition = touchLocation;
//    NSLog(@"Touch end X= %.2f Y= %.2f", endPosition.x, endPosition.y );
//    [self moveBackground];
//    [self moveMapLevels];

}


#pragma mark - MoveBackground

-(void) moveBackground
{
//    SKSpriteNode * bg = (SKSpriteNode *)[self childNodeWithName:@"background"];
    CGFloat delta = endPosition.y - beginPosition.y;
    CGPoint velocity = CGPointMake( 0 , BG_VELOCITY);
    CGPoint amtToMove = CGPointMultiplyScalar(velocity, delta);

//    bgLayer.position = CGPointAdd(bgLayer.position, amtToMove);
    NSLog(@"   bgLayer.position.y= %0.2f",  bgLayer.position.y);
    
    background1.position = CGPointAdd(background1.position, amtToMove);
    background2.position = CGPointAdd(background2.position, amtToMove);
    
    if(background1.position.y <= - background1.size.height)
    {
        background2.position = CGPointMake(0 , 0);
    }
    
    if(background1.position.y == 0)
    {
        background1.position = CGPointMake(0 , 0);
    }
}

-(void) moveMapLevels
{
    CGFloat backgroundDelta =endPosition.y - beginPosition.y;
    CGPoint bgVelocity = CGPointMake( 0 , BG_VELOCITY);
    CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity, backgroundDelta);
    
    for (NSUInteger i = 1; i <= LEVELS_IN_GAME; i++)
    {
        NSString *name = [NSString stringWithFormat:@"button%lu", (unsigned long)i];
    [bgLayer enumerateChildNodesWithName:name usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode * bt = (SKSpriteNode *)node;
        bt.position = CGPointAdd(bt.position, amtToMove);
    }];
    }
    [bgLayer enumerateChildNodesWithName:@"LevelNumber" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode * number = (SKSpriteNode *)node;
        number.position = CGPointAdd(number.position, amtToMove);
    }];
}



@end
