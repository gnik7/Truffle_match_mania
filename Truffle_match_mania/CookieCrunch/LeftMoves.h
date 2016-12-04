//
//  LeftMoves.h
//  CookieCrunch
//
//  Created by Кирилл on 17.06.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LeftMoves : SKNode

+ (void)drawTrajectoryFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)point withObject:(id)object completion:(dispatch_block_t)completion;
- (void)setEmitterOnPoint:(CGPoint)location withObject:(SKNode *)object;

@end
