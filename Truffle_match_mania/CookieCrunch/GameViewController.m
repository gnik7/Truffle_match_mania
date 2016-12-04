//
//  GameViewController.m
//  CookieCrunch
//
//  Created by Кирилл on 04.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "GameViewController.h"
//#import "GameScene.h"
#import "StartScene.h"
#import "Level.h"
#import "Settings.h"

@import AVFoundation;

@interface GameViewController ()

@property (strong, nonatomic) Level * level;
@property (assign, nonatomic) NSUInteger movesLeft;
@property (assign, nonatomic) NSUInteger score;
@property (strong, nonatomic) AVAudioPlayer * backgroundMusic;



@end


@implementation GameViewController


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTwitter:) name:NGTwitterNotification object:nil];
    
    NSLog(@"viewWillLayoutSubviews");
    
    SKView * skView = (SKView*)self.view;
    if (!skView.scene) {
        skView.multipleTouchEnabled = NO;
//        skView.showsFPS = YES;
//        skView.showsNodeCount = YES;
        
//        self.scene = [GameScene sceneWithSize:skView.bounds.size];
//        self.scene = [[GameScene alloc] initWithSize:skView.bounds.size withFile:@"Level_0"];

       StartScene *scene = [StartScene sceneWithSize:skView.bounds.size];
        
        NSLog(@"screen: width = %0.2f, height = %0.2f", [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);

        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [skView presentScene:scene];

    }
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NGTwitterNotification object:nil];
}

#pragma mark - Custom methods ()


#pragma mark Twitter

- (void)sendTwitter:(NSNotification *)notification {
    NSArray *arrayString = [NSArray arrayWithArray:[(NSString*)notification.object componentsSeparatedByString:@"_"]];
    NSLog(@"%@", arrayString);
    //Initial object
    SLComposeViewController *tweetContent;
    tweetContent = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    //Set text of message
    [tweetContent setInitialText:[NSString stringWithFormat:@"Wow, I scored %@ points on %@ in the Game: Truffle_match_mania!", [arrayString objectAtIndex:0],  [arrayString objectAtIndex:1]]];
    //See message to send
    [self presentViewController:tweetContent animated:YES completion:nil];
}

@end
