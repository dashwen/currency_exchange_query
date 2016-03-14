//
//  Currency.m
//  yql_currency_converter
//
//  Created by Deshawn Dana on 3/2/16.
//  Copyright © 2016 Deshawn Dana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@implementation Currency

@synthesize countryName;
@synthesize currencyName;
@synthesize alphaCode;
@synthesize numericCode;
@synthesize minorUnits;
@synthesize symbol;

//sourced from dictionary code, mshafae cs411samplecode
-(Currency*) initWithCountry: (NSString*) aCountryName CurrencyName: (NSString*) aCurrencyName AlphaCode:(NSString*) anAlphaCode Symbol:(NSString*) aSymbol
{
    self = [super init];
    if (self) {
        countryName = aCountryName;
        currencyName = aCurrencyName;
        alphaCode = anAlphaCode;
        //numericCode = aNumericCode;
        //minorUnits = aMinorUnits;
        symbol = aSymbol;
    }
    return self;
}

-(NSString*) description
{
    return [NSString stringWithFormat: @"%@ %@ %@", self.countryName, self.currencyName, self.alphaCode];
}

@end
