//
//  Exchange.m
//  yql_currency_converter
//
//  Created by Deshawn Dana on 3/8/16.
//  Copyright © 2016 Deshawn Dana. All rights reserved.
//


//sourced from shafae cs411samplecode

#import <Foundation/Foundation.h>
#import "ExchangeRate.h"

@implementation ExchangeRate

@synthesize homeCurrency;
@synthesize foreignCurrency;


-(ExchangeRate*) initWithHomeCurrency:(Currency*) aHomeCurrency foreignCurrency:(Currency*) aForeignCurrency
{
    self = [super init];
    if(self){
        homeCurrency = aHomeCurrency;
        foreignCurrency = aForeignCurrency;
        
    }
    return self;
}
 

-(NSString*) description
{
    return [NSString stringWithFormat: @"%@ %@", self.homeCurrency, self.foreignCurrency];
}

-(NSURL*) exchangeRateURL
{
    NSString* urlString = [NSString stringWithFormat: @"https://query.yahooapis.com/v1/public/yql?q=select%%20*%%20from%%20yahoo.finance.xchange%%20where%%20pair%%20in%%20(%%22%@%@%%22)&format=json&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=", self.homeCurrency.alphaCode, self.foreignCurrency.alphaCode];
    return [NSURL URLWithString: urlString];
}

-(NSNumber*) fetchExchangeRate
{

    //----------------- sourced from shafae for fetch --------------------------------------------------------------------//
    NSNumber* rate;
    
    NSString* yqlQuery = [NSString stringWithFormat: @"select * from yahoo.finance.xchange where pair in (\"%@%@\")", self.homeCurrency.alphaCode, self.foreignCurrency.alphaCode];
    
    NSString* urlString = [NSString stringWithFormat: @"https://query.yahooapis.com/v1/public/yql?q=%@&format=json&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=", [yqlQuery stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]];
    
    NSLog(@"The url is %@", urlString);
    
    NSURL *yahooFinanaceRESTQueryURL = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL: yahooFinanaceRESTQueryURL];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSLog(@"Starting request...");
    NSData *yahooFinanaceQueryResults = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    NSLog(@"...finished!");
    if( response.statusCode == 200 ){
        NSLog(@"Successful request!");
        id unknownObject = [NSJSONSerialization
                            JSONObjectWithData: yahooFinanaceQueryResults
                            options: 0
                            error: &error];
        NSDictionary *exchangeRatesDictionary;
        
        if (!error) {
            NSLog(@"Loaded JSON Data Successfully");
            if( [unknownObject isKindOfClass: [NSDictionary class]]){
                NSLog(@"It's a dictionary!");
                exchangeRatesDictionary = unknownObject;
                NSDictionary *result = [[[exchangeRatesDictionary valueForKey: @"query"] valueForKey:@"results"] valueForKey: @"rate"];
                rate = [NSNumber numberWithFloat: [[result objectForKey: @"Rate"] floatValue]];
                //lastFetchedOn = [NSDate date];
            }else{
                exchangeRatesDictionary = nil;
                //return 1;
            }
        }else{
            NSLog(@"There was an unfortunate error; nothing was loaded.");
            //return 1;
        }
    }else{
        // response.statusCode != 200 (400? 500?)
        NSLog(@"Could not fetch exchange rate. %@", error.description);
    }
    NSLog(@"%@ to %@ rate is %@ fetched",self.homeCurrency.alphaCode, self.foreignCurrency.alphaCode, rate);
    return rate;
}

@end

