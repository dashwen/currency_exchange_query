//
//  Currency.h
//  yql_currency_converter
//
//  Created by Deshawn Dana on 3/2/16.
//  Copyright © 2016 Deshawn Dana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject

@property (strong) NSString* countryName;
@property (strong) NSString* currencyName;        //the actual name
@property (strong) NSString* alphaCode;           //alphacode
@property (strong) NSNumber* numericCode;
@property (strong) NSNumber* minorUnits;
@property (strong) NSString* symbol;

-(Currency*) initWithCountry: (NSString*) aCountryName CurrencyName: (NSString*) aCurrencyName AlphaCode:(NSString*) anAlphaCode Symbol:(NSString*) aSymbol;

-(NSString*) description;

@end
