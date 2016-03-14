//
//  ViewController.h
//  yql_currency_converter
//
//  Created by Deshawn Dana on 3/1/16.
//  Copyright © 2016 Deshawn Dana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Currency.h"
#import "ExchangeRate.h"

@interface ViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *homePicker;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
- (IBAction)calcuateAction:(id)sender;


@end

