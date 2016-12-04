//
//  ConvertLayers.h
//  CookieCrunch
//
//  Created by Кирилл on 03.07.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ConvertLayers : NSObject

+ (CGPoint)convertGLToCL:(CGPoint)originalPoint tileSize:(CGSize)tileSize sceneSize:(CGSize)sceneSize
              numColumns:(NSInteger)numColumns numRows:(NSInteger)numRows;
+ (CGPoint)convertCLToGL:(CGPoint)originalPoint tileSize:(CGSize)tileSize sceneSize:(CGSize)sceneSize
              numColumns:(NSInteger)numColumns numRows:(NSInteger)numRows;

@end
