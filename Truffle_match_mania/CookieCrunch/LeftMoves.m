//
//  LeftMoves.m
//  CookieCrunch
//
//  Created by Кирилл on 17.06.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "LeftMoves.h"
#import "GameScene.h"

@implementation LeftMoves

+(void) drawTrajectoryFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)point withObject:(id)object completion:(dispatch_block_t)completion {
    CGFloat angle = atanf((point.y - fromPoint.y)/(point.x - fromPoint.x));
    SKAction * rotation = [SKAction rotateByAngle:angle duration:0.1];
    SKEmitterNode * fireFly = [SKEmitterNode nodeWithFileNamed:@"HornOfPlentyFires.sks"];
    fireFly.position = CGPointMake(fromPoint.x, fromPoint.y);
    fireFly.zPosition = 80;
    [object addChild:fireFly];
    SKAction * moveTo = [SKAction moveTo:point duration:0.75];
    [fireFly runAction:[SKAction sequence:@[[SKAction group:@[rotation, moveTo]], [SKAction removeFromParent]]] completion:completion];
}

-(void) setEmitterOnPoint:(CGPoint)location withObject:(SKNode *)object {
    __block SKEmitterNode * emitter = [SKEmitterNode nodeWithFileNamed:@"Spark.sks"];
    emitter.name = @"spark";
    emitter.position = location;
    [object addChild:emitter];
    SKAction * wait = [SKAction waitForDuration:1.0];
    SKAction * sequence = [SKAction sequence:@[wait, [SKAction runBlock:^{
        [emitter removeFromParent];
        emitter = nil;
    }]]];
    [emitter runAction:sequence];
}

@end
