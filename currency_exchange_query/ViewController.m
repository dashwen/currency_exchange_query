//
//  ViewController.m
//  yql_currency_converter
//
//  Created by Deshawn Dana on 3/1/16.
//  Copyright © 2016 Deshawn Dana. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray* homeCurrencyPickerItems;
    NSMutableArray* foreignCurrencyPickerItems;
    NSMutableArray *currencies;
    NSMutableArray *keys;
    NSDictionary* currencyDictionary;
}

@end

@implementation ViewController

@synthesize homePicker;
@synthesize resultsLabel;


//source online http://stackoverflow.com/questions/18756196/how-to-dismiss-keyboard-when-user-tap-other-area-outside-textfield
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    homeCurrencyPickerItems = [[NSMutableArray alloc] init];
    foreignCurrencyPickerItems = [[NSMutableArray alloc] init];
    currencies = [[NSMutableArray alloc] init];
    keys = [[NSMutableArray alloc] init];
    
    
    //makes ARRAY for Dictionary of Currencies
    //NSArray* currencies = @[currencyObject, currencyObject2];
    //NSArray* keys = @[currencyObject.alphaCode, currencyObject2.alphaCode];
    
    
    
    // sets a string to be value of csv file
    NSString *iso4217Data = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iso4217" ofType:@"csv"] encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *rows = [iso4217Data componentsSeparatedByString:@"\n"];
  
    //Parses items of the csv file, stores each field separated by comma into a currency object and adds the objects by the keys
    int n = 0;
    for(int i=0; i<[rows count]-1; i++)
    {
        NSArray *split = [[rows objectAtIndex:i] componentsSeparatedByString:@","];
        NSString* tempCountryName = [split objectAtIndex:0];
        NSString* tempCurrencyName = [split objectAtIndex:1];
        NSString* tempAlphaCode = [split objectAtIndex:2];
        NSString* tempSymbol = [split objectAtIndex:5];
        NSLog(@"%@ %@ %@ %@", tempCountryName,tempCurrencyName,tempAlphaCode,tempSymbol);

    
        //create only one instance (emulates a singleton)
        Currency* currencyObject = [[Currency alloc]initWithCountry: tempCountryName CurrencyName:tempCurrencyName AlphaCode:tempAlphaCode Symbol:tempSymbol];
        
        //add to arrays keys, and objects
        [currencies addObject:currencyObject];
        [keys addObject:currencyObject.alphaCode];
        n++;
        NSLog(@" total = %i", n);
    }
    
    
    //ECHOS ARRAY OF OBJECTS
    //for(int i=0; i<[currencies count]; i++){
        //NSLog(@"From the array: (%p) %@", [currencies objectAtIndex:i], [[currencies objectAtIndex:i] description]);
    //}
    
    //ECHOS keys OF OBJECTS
    //for(int i=0; i<[keys count]; i++){
        //NSLog(@"From the keys: (%p) %@", [keys objectAtIndex:i], [[keys objectAtIndex:i] description]);
    //}
    
    
    currencyDictionary = [NSDictionary dictionaryWithObjects: currencies forKeys: keys];
    
    //ECHOS DICTIONARY OF OBJECTS USING KEY
    n=0;
    for(NSString* k in keys){
        n++;
        Currency* i = [currencyDictionary objectForKey: k];
        NSLog(@"From the dictionary: (%p) %@", i, [i description]);
        NSLog(@" total = %i", n);
       
    }
    
    
    //ExchangeRate* exchangeObject = [[ExchangeRate alloc] initWithHomeCurrency:[currencyDictionary objectForKey:@"AFN"] foreignCurrency:[currencyDictionary objectForKey:@"ALL"]] ;
    
    
    //initialize strings to display for home picker view component
    for(int i=0; i<[currencies count]; i++)
    {
        [homeCurrencyPickerItems addObject:[[currencies objectAtIndex:i] currencyName]];
        [foreignCurrencyPickerItems addObject:[[currencies objectAtIndex:i] currencyName]];
        
    }
    
    //initialize starting position for components in pickerview
    [homePicker selectRow:1 inComponent:0 animated:YES];
    [homePicker selectRow:2 inComponent:1 animated:YES];
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return homeCurrencyPickerItems.count;
            break;
        case 1:
            return foreignCurrencyPickerItems.count;
        default:
            break;
    }
    return 0;
}
- (NSString* )pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [homeCurrencyPickerItems objectAtIndex:row];
            break;
        case 1:
            return [foreignCurrencyPickerItems objectAtIndex:row];
        default:
            break;
    }
    return 0;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSString *resultString = homeCurrencyPickerItems[row];
    self.resultsLabel.text = [NSString stringWithFormat:@"%@ to %@",[homeCurrencyPickerItems objectAtIndex:[homePicker selectedRowInComponent:0]],[foreignCurrencyPickerItems objectAtIndex:[homePicker selectedRowInComponent:1]]];
    
    
    //gets the country name and uses it to find alpha code in keys array which is in the same order
    NSString* homeAlphaCode = [keys objectAtIndex:[homePicker selectedRowInComponent:0]];
    NSString* foreignAlphaCode = [keys objectAtIndex:[homePicker selectedRowInComponent:1]];
    
    ExchangeRate* erObj = [[ExchangeRate alloc] initWithHomeCurrency:[currencyDictionary objectForKey:homeAlphaCode] foreignCurrency:[currencyDictionary objectForKey:foreignAlphaCode]];
    
    
    NSNumber* rate = [erObj fetchExchangeRate];
    
    //update rate label
    self.rateLabel.text = [rate stringValue];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)calcuateAction:(id)sender {
    
    //Do not calculate if fields are empty
    if([ [self.textField text] length] == 0)
    {
        return;
    }
    
    //calculate exchange rate
    
    NSString* rate = self.rateLabel.text;
    
    float rateNum = [rate floatValue];
    
    NSString* userValue = self.textField.text;
    
    float userValueNum = [userValue floatValue];
    
    float newRate = rateNum*userValueNum;
    
    NSString * newRateString = [[NSNumber numberWithFloat:newRate] stringValue];
    
    self.rateLabel.text = newRateString;
    
    
    
    
    
}
@end
