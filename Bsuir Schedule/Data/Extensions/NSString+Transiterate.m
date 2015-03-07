//
//  NSString+Transiterate.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 18.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "NSString+Transiterate.h"

@implementation NSString (Transiterate)
- (NSString*)toLatinWithDictionary
{
    NSMutableString* newString = [NSMutableString string];
    NSRange range;
    NSString* symbol;
    NSString* newSymbol;
    
    for (int i = 0; i < [self length]; i ++)
    {
        //  Take regular symbol
        range = NSMakeRange(i, 1);
        symbol = [self substringWithRange:range];
        newSymbol = [self transliterateChar:symbol];
        if (newSymbol)
        {
            [newString appendString:newSymbol];
        }
        else
        {
            [newString appendString:symbol];
        }
    }
    return [NSString stringWithString:newString];
}

- (NSString*)transliterateChar:(NSString*)symbol
{
    //  For simlicity there is only
    NSArray* cyrillicChars = @[@"а", @"б", @"в", @"г", @"д", @"е", @"ё", @"ж", @"з", @"и", @"й", @"к", @"л", @"м", @"н", @"о", @"п", @"р", @"с", @"т", @"у", @"ф", @"х", @"ц", @"ч", @"ш", @"щ", @"ъ", @"ы", @"ь", @"э", @"ю", @"я",@"А", @"Б", @"В", @"Г", @"Д", @"Е", @"Ё", @"Ж", @"З", @"И", @"Й", @"К", @"Л", @"М", @"Н", @"О", @"П", @"Р", @"С", @"Т", @"У", @"Ф", @"Х", @"Ц", @"Ч", @"Ш", @"Щ", @"Ъ", @"Ы", @"Ь", @"Э", @"Ю", @"Я"];
    NSArray* latinChars = @[@"a", @"b", @"v", @"g", @"d", @"e", @"yo", @"zh", @"z", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"r", @"s", @"t", @"u", @"f", @"h", @"c", @"ch", @"sh", @"shch", @"'", @"y", @"'", @"e", @"yu", @"ya", @"A", @"B", @"V", @"G", @"D", @"E", @"Yo", @"Zh", @"Z", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"R", @"S", @"T", @"U", @"F", @"H", @"C", @"Ch", @"Sh", @"Shch", @"'", @"Y", @"'", @"E", @"Yu", @"Ya"];
    NSDictionary* convertDict = [NSDictionary dictionaryWithObjects:latinChars
                                                            forKeys:cyrillicChars];
    return [convertDict valueForKey:symbol];
}
@end
