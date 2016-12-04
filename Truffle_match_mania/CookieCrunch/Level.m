//
//  KKLevel.m
//  CookieCrunch
//
//  Created by Кирилл on 04.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "Level.h"
#import "Aims.h"
#import "PlusOnePlusTwo.h"
#import "Bonus.h"
#import "Character.h"
#import "Tile.h"
#import "Swap.h"
#import "Chain.h"
#import "LeftMoves.h"
#import "GameScene.h"
#import "GameSceneUI.h"

@interface Level ()
@property (assign, nonatomic) NSUInteger comboMultiplier;
@property (assign, nonatomic) NSUInteger charactersOnBoard;
@end

@implementation Level {

    Character * _characters[ARRAY_DIMENSION][ARRAY_DIMENSION];
//    _tiles - массив покаывает какие клетки пустые, а какие нет. Если клетка nil - она не может содержать печенье.
    Tile * _tiles[ARRAY_DIMENSION][ARRAY_DIMENSION];

    NSUInteger typeOfSpriteArray[6][6]; //только для 1 уровня
//    NSInteger _tempCharactersStorageWithAdditionalAmount;
    NSMutableDictionary * _characterAdditionalAmount;
    NSInteger movesBonus;
    Bonus * _bonusObject;
    NSInteger currentLevel;
}

@synthesize NumColumns;
@synthesize NumRows;

#pragma mark - Initialize

- (id)initWithFile:(NSString *)fileName {
    self = [super init];
    if (self != nil) {
        NSDictionary * dictionary = [self loadJSON:fileName];
        self.aimsObject = [Aims new];
        _plusOneObject = [PlusOnePlusTwo new];
        
        self.NumColumns = [dictionary[@"Columns"] unsignedIntegerValue];
        self.NumRows = [dictionary[@"Rows"] unsignedIntegerValue];
        
        [dictionary[@"aims"] enumerateObjectsUsingBlock:^(NSNumber * aimType, NSUInteger row, BOOL *stop) {
            [self.aimsObject addCharacterTypeToAim:aimType];
        }];
        [dictionary[@"levelAims"] enumerateObjectsUsingBlock:^(NSNumber * levelTypes, NSUInteger row, BOOL *stop) {
            [self.aimsObject addCharactersToLevel:levelTypes];
        }];
        [dictionary[@"targetAims"] enumerateObjectsUsingBlock:^(NSNumber * aimTarget, NSUInteger row, BOOL *stop) {
            [self.aimsObject addTargetScoreToAim:aimTarget];
        }];
        
        [self.aimsObject initArrayOfScore];
        
        [dictionary[@"tiles"] enumerateObjectsUsingBlock:^(NSArray * array, NSUInteger row, BOOL *stop) {
        [array enumerateObjectsUsingBlock:^(NSNumber *  value, NSUInteger column, BOOL *stop) {
                
                NSInteger tileRow = NumRows - row - 1; // новый ряд, создаю обратный порядок. Потому что посчитанный первый ряд здесь, будет последним в таблице, тк начало таблицы идет из коорд (0,0).
                
                if (([value integerValue] == 1 || [value integerValue] == 12) &&
                    [[[NSUserDefaults standardUserDefaults] objectForKey:@"activeLevels"] intValue] > 1) {
                    switch ([value integerValue]) {
                        case 1:
                            _tiles[column][tileRow] = [Tile new];
                            break;
                        case 12:
                            _tiles[column][tileRow] = [[Tile alloc] initWithBlock];
                            break;
                        default:
                            break;
                    }
                }
                else if ([value integerValue] != 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"activeLevels"] intValue] <= 1){
                    //first launch
                    _tiles[column][tileRow] = [Tile new];
                    typeOfSpriteArray[column][tileRow] = [value integerValue];
                }
            }];
        }];
        
        _bonusObject = [Bonus new];
        
//        для лэйблов
        self.targetScore = [dictionary[@"targetScore"] unsignedIntegerValue];
        self.maximumMoves = [dictionary[@"moves"] unsignedIntegerValue];
        
        self.endLevel = NO;
        self.spritesForRemove = [NSMutableArray array];
        self.spritesName = [NSMutableArray array];
        Character *character = [[Character alloc] init];
        for (NSInteger i=0; i< [self.aimsObject.getCharacterAimTypes count]; i++) {
            character.characterType = [[self.aimsObject.getCharacterAimTypes objectAtIndex: i]integerValue];
            NSString *name;
            if (character.characterType == BLOCK_TYPE) {
                name = @"block";
            } else {
                name = character.spriteName;
            }
            [self.spritesName addObject:name];
        }
        character=nil;
        NSString *path = [[fileName lastPathComponent] stringByDeletingPathExtension];
        NSArray *splite = [path componentsSeparatedByString:@"_"];
        currentLevel = [[splite objectAtIndex:1] integerValue];
        _charactersOnBoard = [_aimsObject.getCharactersToLevel count];
        
        NSLog(@"CurrentLevel %ld", (long)currentLevel);
    }
    return self;
}

- (void)dealloc {
    NSLog(@"Level is deallocated");
}

- (NSDictionary *)loadJSON:(NSString * )fileName {
    NSString * path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    
    if (path == nil) {
        NSLog(@"Could not find level file: %@", fileName);
        return nil;
    }
    
    NSError * error;
    //    данные из json
    NSData * data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    
    if (data == nil) {
        NSLog(@"Could not load level file: %@, error: %@", fileName, error);
        return nil;
    }
    //    данные в словарь
    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Level file '%@' is not valid JSON: %@", fileName, error);
        return nil;
    }
    
    return dictionary;
}

#pragma mark - Game Setup

- (NSSet *)shuffle {
    NSSet * set;
        do {
            set = [self createInitialCharacters];
            [self detectPossibleSwaps];
        } while ([self.possibleSwaps count] == 0);
        
        return set;
}

- (NSSet *)createInitialCharacters { // IMPROVE
    NSMutableSet * set = [NSMutableSet new];
    NSArray *anchorArray = [NSArray arrayWithArray:[self.aimsObject aimsForAnchor]];
    NSInteger column7 = 0;
    NSInteger column6 = 0;
    if ( [anchorArray count] > 0)
    {
        column7 = [[anchorArray objectAtIndex:0] integerValue];
        column6 = [[anchorArray objectAtIndex:1] integerValue];
    }
    BOOL levelsWithAnchor = NO;
    if ([_aimsObject.getCharactersToLevel containsObject:@7])
    {
        levelsWithAnchor = YES;
    }
   
    NSInteger lastCharacter = 6;
    NSInteger activeLevel = [[[NSUserDefaults standardUserDefaults] objectForKey:@"activeLevels"] intValue];
    for (NSInteger row = 0; row < NumRows; row++) {
        //NSMutableArray *columnArray = [[NSMutableArray alloc] initWithArray:[_tiles objectAtIndex:row]];
        for (NSInteger column = 0; column < NumColumns; column++) {
            if (_tiles[column][row] != nil) {
                NSUInteger characterType;
                if(activeLevel > 1) {
                    NSUInteger counter = [[self.aimsObject getCharactersToLevel] count];
                    do {
                        if(levelsWithAnchor)
                        {
                            if (row == 6 && column6 == column)
                            {
                                characterType = [[[self.aimsObject getCharactersToLevel] objectAtIndex:1] integerValue];
                            }
                            else if (row == 7 && column7 == column)
                            {
                                characterType = [[[self.aimsObject getCharactersToLevel] objectAtIndex:1] integerValue];
                            }
                            else
                            {
                                NSUInteger numberType = arc4random_uniform((uint32_t)counter);
                                characterType = [[[self.aimsObject getCharactersToLevel] objectAtIndex:numberType] integerValue];
                            }
                        }
                        else
                        {
                            //characterType = arc4random_uniform(NumCharacterTypes) +1;
                            NSUInteger numberType = arc4random_uniform((uint32_t)counter);
                            characterType = [[[self.aimsObject getCharactersToLevel] objectAtIndex:numberType] integerValue];
                        }
                    } while ( [self conditionCreateInitialCharacters:characterType Column:column Row:row Exception1:column7 Exception2:column6 LastCharacter:lastCharacter LastColumn:0 forFallDown:NO]);
                }
                else if (activeLevel <= 1) {
                    characterType = typeOfSpriteArray[column][row];
                }
                
                lastCharacter = characterType;
                Character * character = [self createCharacterAtColumn:column row:row withType:characterType];
                character.bonusType = 0;
                [set addObject:character];
                
                if (_tiles[column][row].withBlock) {
                    character.isBlocked = YES;
                }
            }
        }
    }
    return set;
}

-(BOOL) conditionCreateInitialCharacters:(NSInteger)characterType Column:(NSInteger)column Row:(NSInteger)row Exception1:(NSInteger)column7 Exception2:(NSInteger)column6 LastCharacter:(NSInteger)lastCharacterType LastColumn:(NSInteger)lastCol  forFallDown:(BOOL)flag
{
    if(_charactersOnBoard > HARDNESLEVEL)
    {
        if (row == 6 && column == column6)
        {
            return NO;
        }
        else if (row == 7 && column == column7)
        {
            return NO;
        }
        else if (characterType == 7)
        {
            return YES;
        }
        else if (characterType == lastCharacterType && column == lastCol)
        {
            return YES;
        }
        else if ((column >= 2 &&
              _characters[column - 1][row].characterType == characterType &&
              _characters[column - 2][row].characterType == characterType )
              ||(column >= 1 &&
                 _characters[column - 1][row].characterType == characterType )
              || (row >= 2 &&
                  _characters[column][row - 1].characterType == characterType &&
                  _characters[column][row - 2].characterType == characterType)
              || (row >= 1 && _characters[column][row - 1].characterType == characterType)
              
              ||( column < NumColumns &&
                 _characters[column + 1][row].characterType == characterType /*&&
                 _characters[column + 2][row].characterType == characterType*/)
              ||( column < NumColumns &&
                 _characters[column + 1][row].characterType == characterType))

        {
            return YES;
        }
        else
        {
            return NO;
        }
//    } else {                                                    // TEST удалить
//        if (characterType == lastCharacterType)
//        {
//            return YES;
//        }
//        else if (row == 6 && column == column6)
//        {
//            return NO;
//        }
//        else if (row == 7 && column == column7)
//        {
//            return NO;
//        }
//        else if (characterType == 7)
//        {
//            return YES;
//        }
    }
    else
    {
        if (row == 6 && column == column6)
        {
            if (characterType == 7 && flag)
                return YES;
            else
                return NO;
        }
        else if (row == 7 && column == column7)
        {
            return NO;
        }
        else if (characterType == 7)
        {
            return YES;
        }
        
        else if (characterType == lastCharacterType && column == lastCol)
        {
            return YES;
        }
        else if ((column >= 2 &&
                  _characters[column - 1][row].characterType == characterType &&
                  _characters[column - 2][row].characterType == characterType)
                 || (row >= 2 &&
                     _characters[column][row - 1].characterType == characterType &&
                     _characters[column][row - 2].characterType == characterType))
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

- (Character *)createCharacterAtColumn:(NSInteger)column row:(NSInteger)row withType:(NSUInteger)characterType {
    Character * character = [Character new];
    character.characterType = characterType;
    character.column = column;
    character.row = row;
    _characters[column][row] = character;
    return character;
}

- (void)resetComboMultiplier {
    self.comboMultiplier = 1;
}

#pragma mark - Detecting Swaps

- (BOOL)hasChainAtColumn:(NSInteger)column row:(NSInteger)row {
    NSUInteger characterType = _characters[column][row].characterType;
    
    NSUInteger horzLength = 1;

    for (NSInteger i = column - 1; i >= 0 && (_characters[i][row].characterType == characterType); i--, horzLength++);
    
    for (NSInteger i = column + 1; i < NumColumns && (_characters[i][row].characterType == characterType); i++, horzLength++);
    
    if (horzLength >= 3) return YES;
    
    NSUInteger vertLength = 1;
    
    for (NSInteger i = row - 1; i >= 0 && (_characters[column][i].characterType == characterType); i--, vertLength++);
    
    for (NSInteger i = row +1; i < NumRows && (_characters[column][i].characterType == characterType); i++, vertLength++);
    
    return  (vertLength >= 3);
}

- (void)detectPossibleSwaps {
    NSMutableSet * set = [NSMutableSet set];
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            Character * character = _characters[column][row];
            if (character != nil) {
//                if character is located on the right side of the current and swap leads to chain - than adds them to array
                if (column < NumColumns - 1) {
//                    whether there is a character in this place, if there is not a tile - there is no a character
                    Character * other = _characters[column + 1][row];
                    if (other != nil) {
//                        свап
                        _characters[column][row] = other;
                        _characters[column + 1][row] = character;
                        
//                        if some character is part of a chain
                        if ([self hasChainAtColumn:column row:row] || [self hasChainAtColumn:column + 1 row:row]) {
                            Swap * swap = [Swap new];
                            swap.characterA = character;
                            swap.characterB = other;
                            [set addObject:swap];
                        }
//                        swap
                        _characters[column][row] = character;
                        _characters[column + 1][row] = other;
                    }
                }
                
                if (row < NumRows - 1) {
                    Character * other = _characters[column][row + 1];
                    if (other != nil) {
//                        swap
                        _characters[column][row] = other;
                        _characters[column][row + 1] = character;
                        
                        if ([self hasChainAtColumn:column row:row] || [self hasChainAtColumn:column row:row + 1]) {
                            Swap * swap = [Swap new];
                            swap.characterA = character;
                            swap.characterB = other;
                            [set addObject:swap];
                        }
                        
                        _characters[column][row] = character;
                        _characters[column][row + 1] = other;
                    }
                }
            } 
        }
    }
    self.possibleSwaps = set;
//    NSLog(@"SET SWAPS = %@", set);
}

#pragma mark - Swapping

- (void)performSwap:(Swap *)swap {
    NSInteger columnA = swap.characterA.column;
    NSInteger rowA = swap.characterA.row;
    NSInteger columnB = swap.characterB.column;
    NSInteger rowB = swap.characterB.row;
    
    _characters[columnA][rowA] = swap.characterB;
    swap.characterB.column = columnA;
    swap.characterB.row = rowA;
    
    _characters[columnB][rowB] = swap.characterA;
    swap.characterA.column = columnB;
    swap.characterA.row = rowB;
}

#pragma mark - Detecting Matches

//search for horiz matches
- (NSSet *)detectHorizontalMatches {
    NSMutableSet * set = [NSMutableSet set];
    BOOL levelsWithAnchor = NO;
    if ([_aimsObject.getCharactersToLevel containsObject:@7])
    {
        levelsWithAnchor = YES;
    }
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns - 2;) {
            if (_characters[column][row] != nil) {
                NSUInteger matchType = _characters[column][row].characterType;
                
//                condition: (_characters[column][row].bonusActivated) prevents bomb to activate near chain
                if ((_characters[column][row].bonusType != BonusTypeNone) && (_characters[column][row].bonusActivated)) {
                    Chain * bonusChain = [self bonusHelperToDetectChains:nil];
//                    Chain * bonusChain = [self bonusHelperToDetectChains:_characters[column][row]];
                    if ([bonusChain.characters count] > 0) [set addObject:bonusChain];
                }
                
                if (_characters[column + 1][row].characterType == matchType &&
                     _characters[column + 2][row].characterType == matchType) {

                    Chain * chain = [Chain new];
                    chain.chainType = ChainTypeHorizontal;
                    do {
                        [chain addCharacter:_characters[column][row]];
                        column++;
                    } while (column < NumColumns && _characters[column][row].characterType == matchType);
                    
                    [set addObject:chain];
                    continue;
                }
                
                //For anchor
                if(_characters[column][row].characterType == 7 &&
                   (row == 0  || (_tiles[column][row - 1] == nil  && row >= 1))
                   )
                {
                    Chain * chain = [Chain new];
                    chain.chainType = ChainTypeHorizontal;
                    [chain addCharacter:_characters[column][row]];
                    [set addObject:chain];
                }
            }
            column++;
        }
    }
    return set;
}

//search for vert mathces
- (NSSet *)detectVerticalMatches {
    NSMutableSet * set = [NSMutableSet set];
    
    for (NSInteger column = 0; column < NumColumns; column++) {
        for (NSInteger row = 0; row < NumRows - 2; ) {
            if (_characters[column][row] != nil) {
                NSUInteger matchType = _characters[column][row].characterType;
                
//                condition: (_characters[column][row].bonusActivated) prevents bomb to activate near chain
                if ((_characters[column][row].bonusType != BonusTypeNone) && (_characters[column][row].bonusActivated)) {
                    Chain * bonusChain = [self bonusHelperToDetectChains:nil];
//                    Chain * bonusChain = [self bonusHelperToDetectChains:_characters[column][row]];
                    if ([bonusChain.characters count] > 0) [set addObject:bonusChain];
                }
                
                if (_characters[column][row + 1].characterType == matchType
                    && _characters[column][row + 2].characterType == matchType) {
                    
                    Chain * chain = [Chain new];
                    chain.chainType = ChainTypeVertical;
                    do {
                        [chain addCharacter:_characters[column][row]];
                        row++;
                    } while (row < NumRows && _characters[column][row].characterType == matchType);

                    [set addObject:chain];
                    continue;
                }
            }
            row++;
        }
    }
    return set;
}

- (NSSet *)removeMatches {
    
    NSSet * horizontalChains = [self detectHorizontalMatches];
    NSSet * verticalChains = [self detectVerticalMatches];
    
    if(_charactersOnBoard > HARDNESLEVEL)
    {
        [Bonus detectBonus:horizontalChains];
        [Bonus detectBonus:verticalChains];
    }
    
    NSSet * tempSet = [horizontalChains setByAddingObjectsFromSet:verticalChains];
    
    tempSet = [self helperForDublicateCharacterInChain:tempSet];
    
    NSSet * setWithKilledCharacters = [self removeCharacters:tempSet];
//    NSMutableArray *bonusCharactersToAct = [self removeCharacters:tempSet];
    
//    if ([bonusCharactersToAct count] > 0) {
//        NSSet *setWithKilledCharacters = [self workWithBonuses:bonusCharactersToAct];
//        bonusCharactersToAct = nil;
        if ([setWithKilledCharacters count] > 0) {
            tempSet = [NSSet setWithSet:[tempSet setByAddingObjectsFromSet:setWithKilledCharacters]];
        }
//    }
    
    tempSet = [self helperForDublicateCharacterInChain:tempSet];
    [self calculateScores:tempSet];
    
    if ([tempSet count] > 0) [self hasNearAimObject:tempSet];
    
    return tempSet;
}

- (NSSet *) workWithBonuses:(NSArray *) bonusCharactersToAct characterType:(NSInteger) characterType {
    NSSet *killedCharacters = [NSSet new];
    for (int i = 0; i < [bonusCharactersToAct count]; i++) {
        switch ([[bonusCharactersToAct objectAtIndex:i] bonusType]) {
            case 1: {
//                killedCharacters = [NSSet setWithSet:[killedCharacters setByAddingObjectsFromSet:
//                [self bonusBoomCalculateRangeWithCharacter:[bonusCharactersToAct objectAtIndex:i]]]];
                killedCharacters = [self bonusBoomCalculateRangeWithCharacter:[bonusCharactersToAct objectAtIndex:i]];
            }
            break;
            case 2: {
                Character *starBonusCharacter = [bonusCharactersToAct objectAtIndex:i];
                starBonusCharacter.characterType = characterType;
                killedCharacters = [self bonusKillAllTypeCalculateAffectedCharacters:[bonusCharactersToAct objectAtIndex:i]];
            }
            break;
            default:
            break;
        }
    }
    return killedCharacters;
}

//clears sprites place in set from c-array
- (NSSet *) removeCharacters:(NSSet *) setOfChains {
    NSMutableArray *bonusCharacters = [NSMutableArray new];
    Chain *killedCharactersChain = [Chain new];
    NSInteger characterType = NEUTRAL_CHARACTER_TYPE;
    
    for (Chain * chain in setOfChains) {
        for (int i = 0; i <  [chain.characters count]; i++) {
            Character *character = [chain.characters objectAtIndex:i];
            
            if (character.isBlocked && chain.chainCreatedWith != ChainCreatedWithBooster)
                continue;
            
            [self helperForCheckCharacterInAims:character];
            
            if (character.bonusType != BonusTypeNone) {
                if (character.bonusActivated) {
                    [bonusCharacters addObject:character];      // if bonus activated and in chain to remove
                } else {
                    continue;                                   // if bonus just created
                }
            } else {
                characterType = character.characterType;        // for star-bonus
            }
            
            [killedCharactersChain addCharacter:_characters[character.column][character.row]];
            _characters[character.column][character.row] = nil;
        }
    }
    
    NSSet *killedCharactersSet;
    
    if ([killedCharactersChain.characters count] > 0) {         // adding to set
        killedCharactersSet = [NSSet setWithObject:killedCharactersChain];
    }
    
    if ([bonusCharacters count] > 0) { // if in chain was bonus
        killedCharactersSet = [killedCharactersSet setByAddingObjectsFromSet:[self workWithBonuses:bonusCharacters
                                                                                     characterType:characterType]];
    }
    
    return killedCharactersSet;
}

#pragma mark - Methods()

-(void) helperCalculateScores:(NSInteger)position withAdditionalAmount:(NSInteger)amount {
    NSInteger sum = [[[self.aimsObject getCurrentScore] objectAtIndex:position] integerValue];
    if (amount != 0) {                              // additional +1 or +2 in chain calculates here
        [self.aimsObject addScoreToAim:[NSNumber numberWithInteger:sum += amount] atIndex:position];
    } else {                                        // another characters
        [self.aimsObject addScoreToAim:[NSNumber numberWithInteger:++sum] atIndex:position];
    }
}

-(void) calculateScores:(NSSet *)chains {
    for (Chain * chain in chains) {
        for (Character * character in chain.characters) {
            for (int i = 0; i < [[self.aimsObject getCharacterAimTypes] count]; i++) {                      // aims
                NSInteger aimType = [[[self.aimsObject getCharacterAimTypes] objectAtIndex:i] integerValue];
                if (character.bonusActivated) {
                    continue;
                }
                if (character.characterType == aimType && !character.isBlocked) {                           // aim type
                    [self helperCalculateScores:i withAdditionalAmount:0];
                    if ([_characterAdditionalAmount valueForKey:[NSString stringWithFormat:@"type_%ld", (long)aimType]]) {   // additional aim
                        NSString * key = [NSString stringWithFormat:@"type_%ld", (long)aimType];
                        [self helperCalculateScores:i withAdditionalAmount:[[_characterAdditionalAmount valueForKey:key] integerValue]];
//                        NSLog(@"withAdditionalAmount = %d", [[_characterAdditionalAmount valueForKey:key] integerValue]);
                        [self putAmountToAimDictionaryWithCharacter:character clear:YES];
                    }
                }
                if (character.isBlocked && aimType == BLOCK_TYPE) {                                         // block
                    [self helperCalculateScores:i withAdditionalAmount:0];
                }
            }
            if (character.isBlocked) continue;
            NSInteger counter = 1;
            counter += character.aimCountOnSingleSprite;
            chain.score += counter * SCORE_FOR_SINGLE_CHARACTER;
        }
        
        if (!self.endLevel) {                           //Kyrylo, 14.07
            chain.score *= self.comboMultiplier;
            self.comboMultiplier++;
        }
        
//        replace sprite from challenge board with done-sprite:
        NSInteger counter = 0;
        Character * character = [[Character alloc] init];
        for (NSInteger i = 0; i < [[self.aimsObject getCharacterAimTypes] count]; i++)
        {
            if([[[self.aimsObject getCurrentScore] objectAtIndex:i] integerValue] >= [[[self.aimsObject getTargetToLevel] objectAtIndex:i] integerValue])
            {
                character.characterType = [[self.aimsObject.getCharacterAimTypes objectAtIndex:i] integerValue];
                NSString * spriteName;
                if (character.characterType == BLOCK_TYPE) {
                    spriteName = @"block";
                } else {
                    spriteName = [character spriteName];
                }
                [self.spritesForRemove addObject: spriteName];
                counter++;
            }
        }
        if (counter == [[self.aimsObject getCharacterAimTypes] count]) {
            self.endLevel = YES;
        }
    }
}

- (void) checkTarget
{
    _sprites = nil;
    _sprites = [NSMutableArray array];
    Character * character = [[Character alloc] init];
    for (NSInteger i = 0; i < [self.aimsObject.getTargetToLevel count]; i++)
    {
        if ([[[self.aimsObject getTargetToLevel] objectAtIndex:i] integerValue] != 0 &&
            [[[self.aimsObject getCurrentScore] objectAtIndex:i] integerValue] < [[[self.aimsObject getTargetToLevel] objectAtIndex:i] integerValue])
        {
            character.characterType = [[self.aimsObject.getCharacterAimTypes objectAtIndex:i] integerValue];
            NSString * spriteName = [character spriteName];
            [_sprites addObject:spriteName];
        }
    }
}

#pragma mark - Bonuses

- (Chain *)bonusHelperToDetectChains:(NSArray *)characters {
    Chain * chain = [Chain new];
    NSArray * array;
    Swap * swap = [Swap new];

    for (int column = 0; column < NumColumns; column++) {
        for (int row = 0; row < NumRows; row++) {
            if (_characters[column][row].bonusType != BonusTypeNone) {
                NSInteger oldColumn = column;
                NSInteger oldRow = row;
                if ([characters count] > 0) {                                   // call from tryswap
                    swap.characterA = [characters objectAtIndex:0];
                    swap.characterB = [characters objectAtIndex:1];
                    _characters[swap.characterA.column][swap.characterA.row] = swap.characterB;
                    _characters[swap.characterB.column][swap.characterB.row] = swap.characterA;
                    if (swap.characterA.bonusType != BonusTypeNone) {
                        column = (int)swap.characterB.column;
                        row = (int)swap.characterB.row;
                    } else {
                        swap.characterB.isSwipeForBonus = NO;
                    }

                    if (swap.characterB.bonusType != BonusTypeNone) {
                        column = (int)swap.characterA.column;
                        row = (int)swap.characterA.row;
                    } else {
                        swap.characterA.isSwipeForBonus = NO;
                    }
                }

                NSInteger chainCount = [chain.characters count];

//                rows
                if (row < NumRows - 2 && _characters[column][row+1].characterType == _characters[column][row+2].characterType) {
                    array = [NSArray arrayWithObjects:_characters[column][row+1], _characters[column][row+2], _characters[column][row], nil];
                    [self addToBonusChain:chain array:array];
                }
                if (row != 0 && row < NumRows - 1 && _characters[column][row-1].characterType == _characters[column][row+1].characterType) {
                    array = [NSArray arrayWithObjects:_characters[column][row-1], _characters[column][row+1], _characters[column][row], nil];
                    [self addToBonusChain:chain array:array];
                }
                if (row > 1 && _characters[column][row-2].characterType == _characters[column][row-1].characterType) {
                    array = [NSArray arrayWithObjects:_characters[column][row-2], _characters[column][row-1], _characters[column][row], nil];
                    [self addToBonusChain:chain array:array];
                }
//                cols
                if (column < NumColumns - 2 && _characters[column+1][row].characterType == _characters[column+2][row].characterType) {
                    array = [NSArray arrayWithObjects:_characters[column+1][row], _characters[column+2][row], _characters[column][row], nil];
                    [self addToBonusChain:chain array:array];
                }
                if (column != 0 && column < NumColumns - 1 && _characters[column+1][row].characterType == _characters[column-1][row].characterType) {
                    array = [NSArray arrayWithObjects:_characters[column+1][row], _characters[column-1][row], _characters[column][row], nil];
                    [self addToBonusChain:chain array:array];
                }
                if (column > 1 && _characters[column-1][row].characterType == _characters[column-2][row].characterType) {
                    array = [NSArray arrayWithObjects:_characters[column-1][row], _characters[column-2][row], _characters[column][row], nil];
                    [self addToBonusChain:chain array:array];
                }

                if ([characters count] > 0) {                               // call from tryswap
                    if (chainCount != [chain.characters count]) {           // for possible swaps
                        [self.possibleSwaps addObject:swap];
                    }
                    _characters[swap.characterA.column][swap.characterA.row] = swap.characterA;
                    _characters[swap.characterB.column][swap.characterB.row] = swap.characterB;
                    column = (int)oldColumn;
                    row = (int)oldRow;
                }
            }
        }
    }

    return chain; // for detectVertical and Horizontal matches
}

//- (void) bonusHelperToDetectSwaps:(Swap *) swap {
//    for (int column = 0; column < NumColumns; column++) {
//        for (int row = 0; row < NumRows; row++) {
//            if (_characters[column][row].bonusType != BonusTypeNone) {
//                NSInteger oldColumn = column;
//                NSInteger oldRow = row;
//                _characters[swap.characterA.column][swap.characterA.row] = swap.characterB;
//                _characters[swap.characterB.column][swap.characterB.row] = swap.characterA;
//                if (swap.characterA.bonusType != BonusTypeNone) {
//                    column = (int)swap.characterB.column;
//                    row = (int)swap.characterB.row;
//                }
//                else {
//                    swap.characterB.isSwipeForBonus = NO;
//                }
//
//                if (swap.characterB.bonusType != BonusTypeNone) {
//                    column = (int)swap.characterA.column;
//                    row = (int)swap.characterA.row;
//                }
//                else {
//                    swap.characterA.isSwipeForBonus = NO;
//                }
//                
//                Chain *chain = [self bonusHelperToDetectChains:_characters[column][row]];
//                
//                if ([chain.characters count] > 0) {
//                    [self.possibleSwaps addObject:swap]; // adding additional swap to swaps array
//                }
//                _characters[swap.characterA.column][swap.characterA.row] = swap.characterA;
//                _characters[swap.characterB.column][swap.characterB.row] = swap.characterB;
//                column = (int)oldColumn;
//                row = (int)oldRow;
//            }
//        }
//    }
//}

//- (Chain *) bonusHelperToDetectChains:(Character *) bombCharacter {
//    Chain * chain = [Chain new];
//    NSArray * array;
//    NSInteger row = bombCharacter.row;
//    NSInteger column = bombCharacter.column;
//
////                rows
//    if (row < NumRows - 2 && _characters[column][row+1].characterType == _characters[column][row+2].characterType) {
//        array = [NSArray arrayWithObjects:_characters[column][row+1], _characters[column][row+2], _characters[column][row], nil];
//        [self addToBonusChain:chain array:array];
//    }
//    if (row != 0 && row < NumRows - 1 && _characters[column][row-1].characterType == _characters[column][row+1].characterType) {
//        array = [NSArray arrayWithObjects:_characters[column][row-1], _characters[column][row+1], _characters[column][row], nil];
//        [self addToBonusChain:chain array:array];
//    }
//    if (row > 1 && _characters[column][row-2].characterType == _characters[column][row-1].characterType) {
//        array = [NSArray arrayWithObjects:_characters[column][row-2], _characters[column][row-1], _characters[column][row], nil];
//        [self addToBonusChain:chain array:array];
//    }
////                cols
//    if (column < NumColumns - 2 && _characters[column+1][row].characterType == _characters[column+2][row].characterType) {
//        array = [NSArray arrayWithObjects:_characters[column+1][row], _characters[column+2][row], _characters[column][row], nil];
//        [self addToBonusChain:chain array:array];
//    }
//    if (column != 0 && column < NumColumns - 1 && _characters[column+1][row].characterType == _characters[column-1][row].characterType) {
//        array = [NSArray arrayWithObjects:_characters[column+1][row], _characters[column-1][row], _characters[column][row], nil];
//        [self addToBonusChain:chain array:array];
//    }
//    if (column > 1 && _characters[column-1][row].characterType == _characters[column-2][row].characterType) {
//        array = [NSArray arrayWithObjects:_characters[column-1][row], _characters[column-2][row], _characters[column][row], nil];
//        [self addToBonusChain:chain array:array];
//    }
//
//    return chain;
//}

- (void)addToBonusChain:(Chain *)chain array:(NSArray *) array {
    for (int i = 0; i < [array count]; i++) [chain addCharacter:[array objectAtIndex:i]];
}

- (NSSet *)bonusBoomCalculateRangeWithCharacter:(Character *)character {
    if (character != nil) {
        Chain * chain = [Chain new];
        chain.chainCreatedWith = ChainCreatedWithBonus;
        
        if (character.column != 0) {
            [chain addCharacter:LEFT_SIDE];
            [self helperForCheckCharacterInAims:LEFT_SIDE];
            [chain addCharacter:LEFT_TOP_CORNER_SIDE];
            [self helperForCheckCharacterInAims:LEFT_TOP_CORNER_SIDE];
        }
        [chain addCharacter:TOP_SIDE];
        [self helperForCheckCharacterInAims:TOP_SIDE];
        [chain addCharacter:RIGHT_TOP_CORNER_SIDE];
        [self helperForCheckCharacterInAims:RIGHT_TOP_CORNER_SIDE];
        [chain addCharacter:RIGHT_SIDE];
        [self helperForCheckCharacterInAims:RIGHT_SIDE];
        if (character.row != 0) {
            [chain addCharacter:BOTTOM_SIDE];
            [self helperForCheckCharacterInAims:BOTTOM_SIDE];
            [chain addCharacter:RIGHT_BOTTOM_CORNER_SIDE];
            [self helperForCheckCharacterInAims:RIGHT_BOTTOM_CORNER_SIDE];
        }
        if ((character.column != 0 && character.row != 0)) {
            [chain addCharacter:LEFT_BOTTOM_CORNER_SIDE];
            [self helperForCheckCharacterInAims:LEFT_BOTTOM_CORNER_SIDE];
        }
        
        //    NSLog(@"chain.characters = %@", chain.characters);
        
        for (int i = 0; i < [chain.characters count]; i++) {
            Character * tempCharacter = [chain.characters objectAtIndex:i];
            //        if (tempCharacter.characterType == ANCHOR_TYPE || tempCharacter.isBlocked) {
            //            NSMutableArray * temp = [NSMutableArray arrayWithArray:chain.characters];
            //            [temp removeObject:tempCharacter];
            //            chain.characters = [NSArray arrayWithArray:temp];
            //        } else {
            _characters[tempCharacter.column][tempCharacter.row] = nil;
            //            testCounter++;
            //        }
        }
        
        NSSet * resultSet = [NSSet setWithObject:chain];
        //    _characters[character.column][character.row] = nil;
        
        for (Character * character in chain.characters) {
            if (character.bonusType != BonusTypeNone && !character.bonusActivated) {
                character.bonusActivated = YES;
                resultSet = [resultSet setByAddingObjectsFromSet:[self bonusBoomCalculateRangeWithCharacter:character]];
            }
        }
        
        return resultSet;
    }
    return nil;
}

- (NSSet *) bonusKillAllTypeCalculateAffectedCharacters:(Character *) character {
    NSSet * resultSet = [NSSet new];
    if (character != nil) {
        Chain * chain = [Chain new];
        NSInteger characterType = character.characterType;
        
        for (int column = 0; column < NumColumns; column++) {
            for (int row = 0; row < NumRows; row++) {
                if (_characters[column][row] != nil && _characters[column][row].characterType == characterType &&
                    _characters[column][row].bonusType == BonusTypeNone) {
                    if (_characters[column][row].isBlocked) continue;
                    
                    [chain addCharacter:_characters[column][row]];
                    if (_characters[column][row].aimCountOnSingleSprite != 0) {
                        [self putAmountToAimDictionaryWithCharacter:_characters[column][row] clear:NO];
                    }
                    _characters[column][row] = nil;
                }
            }
        }
        resultSet = [NSSet setWithObjects:chain, nil];
    }
    
    return resultSet;
}

#pragma mark - Boosters

- (NSArray *)charactersWithOneTypeOfCharacter:(Character *)character {
    Chain * chain = [Chain new];
    
    for (int columns = 0; columns < NumColumns; columns++) {
        for (int rows = 0; rows < NumRows; rows++) {
                if (character.characterType == _characters[columns][rows].characterType && !character.isBlocked)
                    [chain addCharacter:_characters[columns][rows]];
        }
    }
    chain.chainCreatedWith = ChainCreatedWithBooster;
    NSSet * set = [[NSSet alloc] initWithObjects:chain, nil];
    NSArray * array = [NSArray arrayWithObjects:set, _plusOneObject, nil];
    return array;
}

- (NSMutableSet *)getCharactersInOneColumnOrRowforBooster:(Character *)character direction:(NSInteger)direction{
    NSMutableSet * set = [NSMutableSet new];
    Chain * tempChain = [Chain new];
    NSInteger startColumn = character.column;
    NSInteger startRow = character.row;
    if (character != nil) {
        if (direction == 0) {
            // vertical
            for (int row = 0; row < NumRows; row++) {
                if (_characters[startColumn][row] != nil) {
                    [tempChain addCharacter:_characters[startColumn][row]];
                }
            }
        } else {
            // horizont
            for (int column = 0; column < NumColumns; column++) {
                if (_characters[column][startRow] != nil) {
                    [tempChain addCharacter:_characters[column][startRow]];
                }
            }
        }
        tempChain.chainCreatedWith = ChainCreatedWithBooster;
        [set addObject:tempChain];
    }
    
    return set;
}

#pragma mark - Detecting Holes

- (NSArray *)fillHoles {
    NSMutableArray * columns = [NSMutableArray array];
    
    for (NSInteger column = 0; column < NumColumns; column++) {
        for (NSInteger row = 0; row < NumRows; row++) {
            if (_tiles[column][row] != nil && _characters[column][row] == nil) {
//                looking above the hole. The hole could be not only for one square up
                for (NSInteger lookup = row + 1; lookup < NumRows; lookup++) {
                    Character * character = _characters[column][lookup];
                    if (character != nil) {
//                        if found another character - move it to the hole
                        _characters[column][lookup] = nil;
                        _characters[column][row] = character;
                        character.row = row;
                        [columns addObject:character];
//                        if already found character - break
                        break;
                    }
                }
            }
        }
    }
    return columns;
}

- (NSArray *)topUpCharacters {
    NSMutableArray * columns = [NSMutableArray new];
    
    NSUInteger characterType = 97;
    NSUInteger lastColumn = 97;
    
    for (NSInteger column = 0; column < NumColumns; column++) {
//        this cycle ends when _cookies[column][row] not nil
        for (NSInteger row = NumRows - 1; row >= 0 && _characters[column][row] == nil; row--) {
            
//            empty squares to ignore
            if (_tiles[column][row] != nil) {
//                new character type created randomly
                NSUInteger counter = [[self.aimsObject getCharactersToLevel] count];
                NSUInteger newCharacterType;
                do {
                    NSUInteger numberType = arc4random_uniform((uint32_t)counter);
                    newCharacterType = [[[self.aimsObject getCharactersToLevel] objectAtIndex:numberType] integerValue];

                    //NSLog(@"newCharacterType = %lu", (unsigned long)newCharacterType);
//                    if (newCharacterType == 7) {
//                        continue;
//                    }

                } while (
                         [self conditionCreateInitialCharacters:newCharacterType Column:column Row:row Exception1:0 Exception2:0 LastCharacter:characterType LastColumn:lastColumn forFallDown:YES]
                         );
                characterType = newCharacterType;
                lastColumn = column;

                Character * character = [self createCharacterAtColumn:column row:row withType:characterType];
                [columns addObject:character];
            }
        }
    }
    
//    NSLog(@"topUpCharacters: testCounter = %d", testCounter);

    //для теста усложнения игры - потом удалить
//     NSLog(@"+++++++++");
//     NSLog(@"%@", columns);
//    NSLog(@"============");
//    for (NSInteger column = 0; column < NumColumns; column++) {
//        //        this cycle ends when _cookies[column][row] not nil
//        for (NSInteger row = 0; row < NumRows; row++) {
//            NSLog(@"%@", _characters[column][row]);
//        }
//    }

    return columns; // возвращает массив, в котором только колонный имеющие дыры. Обьекты печений здесь отсортированы сверху вниз, важно для анимации.
}

#pragma mark - Querying the Level

- (Character *)characterAtColumn:(NSInteger)column row:(NSInteger)row {
//    condition, if not, here will be a log. Necessary check if c-array is using.
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    
    return _characters[column][row];
}

- (BOOL)isPossibleSwap:(Swap *)swap {
    return [self.possibleSwaps containsObject:swap];
}

// пустое место или нет на позиции печенья, проверка
- (Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    
    return _tiles[column][row];
}

#pragma mark - +1 +2

// проверяет есть ли рядом целевые спрайты
- (void)hasNearAimObject:(NSSet *)set {
    NSArray * characterTypesWithAim = [self.aimsObject getCharacterAimTypes];
    
    for (Character * acceptCharacter in _plusOneObject.charactersWithNumbers) {
        acceptCharacter.isChanged = NO;
    }
    
    for (Chain * chain in set) {
        for (Character * character in chain.characters) {
            if (character != nil) {
//                есть типы целевых спрайтов, прохожусь по ним и сравниваю их с текущим спрайтoм
                for (int i = 0; i < [characterTypesWithAim count]; i++) {
                    NSInteger chType = [characterTypesWithAim[i] integerValue];
                    
                    if (chType == ANCHOR_TYPE) continue;

                    if (LEFT_SIDE != nil && character.column != 0 && LEFT_SIDE.characterType == chType) {
                        [self incrementCharacter:LEFT_SIDE];
                    }
                    if (LEFT_TOP_CORNER_SIDE != nil && character.column != 0 && LEFT_TOP_CORNER_SIDE.characterType == chType) {
                        [self incrementCharacter:LEFT_TOP_CORNER_SIDE];
                    }
                    if (TOP_SIDE != nil && TOP_SIDE.characterType == chType) {
                        [self incrementCharacter:TOP_SIDE];
                    }
                    if (RIGHT_TOP_CORNER_SIDE != nil && RIGHT_TOP_CORNER_SIDE.characterType == chType) {
                        [self incrementCharacter:RIGHT_TOP_CORNER_SIDE];
                    }
                    if (RIGHT_SIDE != nil && RIGHT_SIDE.characterType == chType) {
                        [self incrementCharacter:RIGHT_SIDE];
                    }
                    if (RIGHT_BOTTOM_CORNER_SIDE != nil && character.row != 0 && RIGHT_BOTTOM_CORNER_SIDE.characterType == chType) {
                        [self incrementCharacter:RIGHT_BOTTOM_CORNER_SIDE];
                    }
                    if (BOTTOM_SIDE != nil && character.row != 0 && BOTTOM_SIDE.characterType == chType) {
                        [self incrementCharacter:BOTTOM_SIDE];
                    }
                    if (LEFT_BOTTOM_CORNER_SIDE != nil && character.column != 0 && character.row != 0 &&
                        LEFT_BOTTOM_CORNER_SIDE.characterType == chType) {
                        [self incrementCharacter:LEFT_BOTTOM_CORNER_SIDE];
                    }
                }
            }
        }
    }
    
    NSArray * temp = [_plusOneObject.charactersWithNumbers allObjects];
    for (NSUInteger i = 0; i < [_plusOneObject.charactersWithNumbers count]; i++) {
        Character * character = [temp objectAtIndex:i];
        if (character.isChanged == NO) {
            if([character.sprite.children count] > 0) {
                character.aimCountOnSingleSprite = 0;
                [[character.sprite.children firstObject] removeFromParent];
            }
        }
    }
}

//adds +1 or +2
- (void)incrementCharacter:(Character *)newCharacter {
    if (newCharacter.isBlocked || newCharacter.bonusType != BonusTypeNone) return;
    if (_plusOneObject.charactersWithNumbers != nil) {
        if (!newCharacter.isChanged) {
            newCharacter.isChanged = YES;
            if (newCharacter.aimCountOnSingleSprite == 2) {
                newCharacter.aimCountOnSingleSprite = 2;
            } else if (newCharacter.aimCountOnSingleSprite == 1) {
                newCharacter.aimCountOnSingleSprite = 2;
            } else {
                newCharacter.aimCountOnSingleSprite = 1;
            }
            
            [_plusOneObject addCharacterWithNumberToMutableSet:newCharacter];
        }
    } else {
        newCharacter.isChanged = YES;
        newCharacter.aimCountOnSingleSprite = 1;
        [_plusOneObject addCharacterWithNumberToMutableSet:newCharacter];
    }
}

-(void) clearArraysForRestart
{
    [self.spritesForRemove removeAllObjects];
    [self.sprites removeAllObjects];
}

#pragma mark - LeftMoves

- (NSDictionary *)dealWithLeftMovesWithObject:(GameScene *)object {
    if (self.currentMoves > 0) {
        LeftMoves * leftMovesObject = [LeftMoves new];
        CGPoint characersLayerCenter = CGPointMake(0 - object.charactersLayer.position.x, 0 - object.charactersLayer.position.y);
        CGPoint hornOfPlentyPosition = CGPointMake(characersLayerCenter.x + object.frame.size.width/HORN_OF_PLENTY_X_DELTA,
                                   characersLayerCenter.y - object.frame.size.height/HORN_OF_PLENTY_Y_DELTA);
        [leftMovesObject setEmitterOnPoint:hornOfPlentyPosition withObject:object.charactersLayer];
        NSInteger randomRow;
        NSInteger randomColumn;
        do {
            randomRow = arc4random() % NumRows;
            randomColumn = arc4random() % NumColumns;
        } while (_characters[randomColumn][randomRow].sprite == nil);
            
        if (_characters[randomColumn][randomRow].sprite != nil) {
            Character * character = _characters[randomColumn][randomRow];
            CGPoint pointOriginal = [object pointForColumn:randomColumn row:randomRow]; // from gamescene (tilesLayer)
            NSValue * point = [NSValue valueWithCGPoint:pointOriginal];
            NSValue * hornPos = [NSValue valueWithCGPoint:hornOfPlentyPosition];
            NSDictionary * allObjects = [NSDictionary dictionaryWithObjects:@[point, character, hornPos]
                                                                    forKeys:@[@"point", @"character", @"hornPos"]];
            _characters[randomColumn][randomRow] = nil;
            return allObjects;
        }
    }
    return nil;
}

#pragma mark - Helpers()

// helps in removeMatches()
- (NSSet *)helperForDublicateCharacterInChain:(NSSet *)set {
    if ([set count] > 0) {
        __block NSSet * sortSet = [NSMutableSet new];
        __block BOOL isBonusChain = NO;
        [set enumerateObjectsUsingBlock:^(Chain * chain, BOOL *stop) {
            sortSet = [sortSet setByAddingObjectsFromArray:chain.characters]; // deleting similar objects
            if (chain.chainCreatedWith == ChainCreatedWithBonus) isBonusChain = YES;
        }];
        Chain * chain = [Chain new];
        if (isBonusChain) chain.chainCreatedWith = ChainCreatedWithBonus;
        chain.characters = [sortSet allObjects];
        set = [NSSet setWithObject:chain];
    }
    return set;
}

- (void)helperForCheckCharacterInAims:(Character *)character {
    if (character != nil && character.characterType != ANCHOR_TYPE) {
        if ([_plusOneObject.charactersWithNumbers containsObject:character]) {
            [self putAmountToAimDictionaryWithCharacter:character clear:NO];
            NSArray * temp = [_plusOneObject.charactersWithNumbers allObjects];
            NSMutableArray * tempArray = [[NSMutableArray alloc] initWithArray:temp];
            [tempArray removeObject:_characters[character.column][character.row]];
            _plusOneObject.charactersWithNumbers = [[NSMutableSet alloc] initWithArray:tempArray];
        }
    }
}

- (void)putAmountToAimDictionaryWithCharacter:(Character *)character clear:(BOOL)clear {
    if (!clear) {
//        NSInteger count = 1;
        if ([_characterAdditionalAmount count] > 0) {
            NSInteger count = [[_characterAdditionalAmount valueForKey:[NSString stringWithFormat:@"type_%ld",
                                                              (long)character.characterType]] integerValue];
            count += character.aimCountOnSingleSprite;
            [_characterAdditionalAmount setValue:@(count) forKey:[NSString stringWithFormat:@"type_%ld",
                                                                  (long)character.characterType]];
        } else {
            _characterAdditionalAmount = [NSMutableDictionary new];
            [_characterAdditionalAmount setValue:@(character.aimCountOnSingleSprite) forKey:[NSString stringWithFormat:@"type_%ld",
                                                                  (long)character.characterType]];
        }
    } else {                                                                                                // setToZero
        [_characterAdditionalAmount removeObjectForKey:[NSString stringWithFormat:@"type_%ld", (long)character.characterType]];
    }
}

- (NSSet *)helper:(NSSet *)set {
    if ([set count] > 0) {
        NSMutableArray * array = [NSMutableArray new];
        [set enumerateObjectsUsingBlock:^(Chain * chain, BOOL *stop) {
            [array addObjectsFromArray:chain.characters];
        }];
        for (int i = 0; i < [array count]; i++) {
            Character * tempCharacter = [array objectAtIndex:i];
            [array removeObject:tempCharacter];
            if ([array containsObject:tempCharacter]) {
                continue;
            }
            [array addObject:tempCharacter];
        }
        Chain * chain = [Chain new];
        chain.characters = [NSArray arrayWithArray:array];
        set =  [NSSet setWithObject:chain];
    }
    return set;
}

@end
