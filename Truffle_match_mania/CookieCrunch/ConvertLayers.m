//
//  ConvertLayers.m
//  CookieCrunch
//
//  Created by Кирилл on 03.07.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "ConvertLayers.h"

@implementation ConvertLayers

+ (CGPoint)convertGLToCL:(CGPoint)originalPoint tileSize:(CGSize)tileSize sceneSize:(CGSize)sceneSize
              numColumns:(NSInteger)numColumns numRows:(NSInteger)numRows { // относительно characterLayer
//    CL - charactersLayer, GL - gameLayer, ZP - zero point
    CGFloat artificialCLWidth = tileSize.width * numColumns;
    CGFloat artificialCLHeight = tileSize.height * numRows;
    
    CGFloat GLLeftSideX = (0 - sceneSize.width/2);
    CGFloat GLRightSideX = (0 + sceneSize.width/2);
    CGFloat GLTopY = (0 + sceneSize.height/2);
    CGFloat GLBottomY = (0 - sceneSize.height/2);
    //  zero point for charactersLayer: (0, 0) for gameLayer, CLZPToGL - for charactersLayer
    CGPoint CLZPToGL = CGPointMake(artificialCLWidth/2, artificialCLHeight/2);
    
    CGPoint result;
    if ((originalPoint.x < 0 && originalPoint.x > GLLeftSideX) && (originalPoint.y > 0 && originalPoint.y < GLTopY)) {                // leftTopSquare
        CGFloat xForGLFromZP = (originalPoint.x * -1);
        CGFloat yForGLFromZP = originalPoint.y;
        result = CGPointMake(CLZPToGL.x - xForGLFromZP, CLZPToGL.y + yForGLFromZP);
    } else if ((originalPoint.x > 0 && originalPoint.x < GLRightSideX) && (originalPoint.y > 0 && originalPoint.y < GLTopY)) {        // rightTopSquare
        CGFloat xForGLFromZP = originalPoint.x;
        CGFloat yForGLFromZP = originalPoint.y;
        result = CGPointMake(CLZPToGL.x + xForGLFromZP, CLZPToGL.y + yForGLFromZP);
    } else if ((originalPoint.x < 0 && originalPoint.x > GLLeftSideX) && (originalPoint.y < 0 && originalPoint.y > GLBottomY)) {      // leftBottomSquare
        CGFloat xForGLFromZP = (originalPoint.x * -1);
        CGFloat yForGLFromZP = (originalPoint.y * -1);
        result = CGPointMake(CLZPToGL.x - xForGLFromZP, CLZPToGL.y - yForGLFromZP);
    } else if ((originalPoint.x > 0 && originalPoint.x < GLRightSideX) && (originalPoint.y < 0 && originalPoint.y > GLBottomY)) {     // rightBottomSquare
        CGFloat xForGLFromZP = originalPoint.x;
        CGFloat yForGLFromZP = (originalPoint.y * -1);
        result = CGPointMake(CLZPToGL.x + xForGLFromZP, CLZPToGL.y - yForGLFromZP);
    }
    return result;
}

+ (CGPoint)convertCLToGL:(CGPoint)originalPoint tileSize:(CGSize)tileSize sceneSize:(CGSize)sceneSize
              numColumns:(NSInteger)numColumns numRows:(NSInteger)numRows { // относительно characterLayer
//    CL - charactersLayer, GL - gameLayer, ZP - zero point
    CGFloat artificialCLWidth = tileSize.width * numColumns;
    CGFloat artificialCLHeight = tileSize.height * numRows;

//  zero point for charactersLayer: (0, 0) for gameLayer, CLZPToGL - for charactersLayer
    CGPoint CLZPToGL = CGPointMake(artificialCLWidth/2, artificialCLHeight/2);
    
    CGPoint result;
    if ((originalPoint.x > 0 && originalPoint.x < CLZPToGL.x) &&
        (originalPoint.y > CLZPToGL.y && originalPoint.y < artificialCLHeight)) {               // leftTopSquare
        result = CGPointMake(0 + (originalPoint.x - CLZPToGL.x), 0 + (originalPoint.y - CLZPToGL.y));
    } else if ((originalPoint.x > CLZPToGL.x && originalPoint.x < artificialCLWidth) &&
               (originalPoint.y > CLZPToGL.y && originalPoint.y < artificialCLHeight)) {        // rightTopSquare
        result = CGPointMake(0 + (originalPoint.x - CLZPToGL.x), 0 + (originalPoint.y - CLZPToGL.y));
    } else if ((originalPoint.x > 0 && originalPoint.x < CLZPToGL.x) &&
               (originalPoint.y > 0 && originalPoint.y < CLZPToGL.y)) {                         // leftBottomSquare
        result = CGPointMake(0 + (originalPoint.x - CLZPToGL.x), 0 + (originalPoint.y - CLZPToGL.y));
    } else if ((originalPoint.x > CLZPToGL.x && originalPoint.x < artificialCLWidth) &&
               (originalPoint.y > 0 && originalPoint.y < CLZPToGL.y)) {                         // rightBottomSquare
        result = CGPointMake(0 + (originalPoint.x - CLZPToGL.x), 0 + (originalPoint.y - CLZPToGL.y));
    }
    return result;
}

@end
