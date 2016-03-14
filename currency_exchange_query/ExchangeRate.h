//
//  Exchange.h
//  yql_currency_converter
//
//  Created by Deshawn Dana on 3/8/16.
//  Copyright © 2016 Deshawn Dana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface ExchangeRate : NSObject

@property (strong) Currency* homeCurrency;
@property (strong) Currency* foreignCurrency;

-(ExchangeRate*) initWithHomeCurrency: (Currency*) aHomeCurrency foreignCurrency: (Currency*) aForeignCurrency;
-(NSURL*) exchangeRateURL;
-(NSNumber*) fetchExchangeRate;

@end
