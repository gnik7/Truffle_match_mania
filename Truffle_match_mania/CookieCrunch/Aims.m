//
//  Aims.m
//  CookieCrunch
//
//  Created by Кирилл on 15.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "Aims.h"

@implementation Aims {
    NSMutableArray * _characterAimTypes;
    NSMutableArray *_levelTypes;
    NSMutableArray *_targetScoreAims;
    NSMutableArray *_currentScore;
    NSMutableArray *_anchorArray;
}

- (void)addCharacterTypeToAim:(NSNumber *)characterType {
    if (_characterAimTypes == nil) {
        _characterAimTypes = [NSMutableArray new];
    }
    [_characterAimTypes addObject:characterType];
}

- (NSMutableArray *)getCharacterAimTypes {
    return _characterAimTypes;
}


-(NSMutableArray *)getCharactersToLevel
{
    return  _levelTypes;
}


- (void)addCharactersToLevel:(NSNumber *)type
{
    if (_levelTypes == nil) {
        _levelTypes = [NSMutableArray new];
    }
    [_levelTypes addObject:type];
}

-(NSMutableArray *)getTargetToLevel
{
    return _targetScoreAims;
}

- (void)addTargetScoreToAim:(NSNumber *)score
{
    if(_targetScoreAims == nil)
    {
        _targetScoreAims = [NSMutableArray new];
    }
    [_targetScoreAims addObject:score];
}

-(NSMutableArray *)getCurrentScore
{
    return _currentScore;
}

-(void) initArrayOfScore
{
    if(_currentScore == nil)
    {
        NSInteger count=0;
        for(NSMutableArray *arr in _targetScoreAims)
        {
            if ( arr != 0 ) {
                count++;
            }
        }
        _currentScore = [NSMutableArray arrayWithCapacity:count];
        NSNumber *number = [NSNumber numberWithInteger:0];
        for(NSInteger i=0; i< count; i++)
        {
            [_currentScore insertObject:number atIndex:i];
        }
    }
}

- (void)addScoreToAim:(NSNumber *)score atIndex:(NSUInteger)index
{
    [_currentScore removeObjectAtIndex:index];
    [_currentScore insertObject:score atIndex:index];
}


-(NSArray*) aimsForAnchor
{
    NSInteger capacity = [[self.getTargetToLevel objectAtIndex:1] integerValue];
    _anchorArray = [NSMutableArray arrayWithCapacity:capacity];
    NSInteger counter = 0;
    NSInteger tmp = 0;
    
    while (counter < capacity)
    {
        if (counter %2 == 0)
        {
            tmp= arc4random()%2 + 3; //row=7
            [_anchorArray addObject: [NSNumber numberWithInteger:tmp]];
            counter++;
        }
        else
        {
            tmp = arc4random()%4 + 2; //row=6
            if(tmp != [[_anchorArray objectAtIndex:counter-1] integerValue])
            {
                [_anchorArray addObject: [NSNumber numberWithInteger:tmp]];
                counter++;
            }
        } 
    }

    return _anchorArray;
}

@end
