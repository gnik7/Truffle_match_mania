//
//  Aims.h
//  CookieCrunch
//
//  Created by Кирилл on 15.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Aims : NSObject

@property(nonatomic, assign) NSUInteger additionalScore;

- (NSMutableArray *)getCharacterAimTypes;
- (void)addCharacterTypeToAim:(NSNumber *)characterType;

// типы Characters которые будут в сетке
-(NSMutableArray *)getCharactersToLevel;
- (void)addCharactersToLevel:(NSNumber *)type;

//для целей в верху chalenge on level
-(NSMutableArray *)getTargetToLevel;
- (void)addTargetScoreToAim:(NSNumber *)score;

// хранит текущее значние счета по каждой цели
-(NSMutableArray *)getCurrentScore;
- (void)addScoreToAim:(NSNumber *)score atIndex:(NSUInteger)index;
-(void) initArrayOfScore;

//для создания именно 2х якорей
-(NSArray*) aimsForAnchor;

@end
