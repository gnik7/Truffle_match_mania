//
//  Swap.m
//  CookieCrunch
//
//  Created by Кирилл on 04.05.15.
//  Copyright (c) 2015 Kirill Kramarchuk. All rights reserved.
//

#import "Swap.h"
#import "Character.h"

@implementation Swap

//для дебага
- (NSString *)description {
    return [NSString stringWithFormat:@"%@ swap %@ with %@", [super description], self.characterA, self.characterB];
}

//после добавление проверки на isPossibleSwap - я не могу сделат ни одного свайпа! Потому что, когда начинается свайп GameScene создает новый обьект KKSwap. Когда isPossibleSwap просматривает список - он не находит ничего! Это может иметь KKSwap обьект и описывать точно такое же движение, но на самом деле  памяти хранится другой обьект. Когда запускаю [set containsObject:obj] он вызывает isEqual: на этот обьект и всех обьектов, которые ое содержит, чтобы определить соотв ли они. По дефолту isEqual: сомтрит только на указатель обьекта и этот указатель никогда не найдет совпадение. Метод isEqual: нужно переписать, сделав умнее.
- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Swap class]]) return  NO;
    
    Swap * other = (Swap*)object;
    return (other.characterA == self.characterA && other.characterB == self.characterB) ||
            (other.characterB == self.characterA && other.characterA == self.characterB);
}
//обязательно преписывая isEqual: нужно еще переписать и hash, иначе [NSSet containsObject:] не будет работать.
//Если два обьекта равны, то значение хэша должно быть уникальным если это возможно. Битовое XOR.
- (NSUInteger)hash {
    return [self.characterA hash] ^ [self.characterB hash];
}

@end
