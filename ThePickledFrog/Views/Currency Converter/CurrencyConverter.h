//
//  CurrencyConverter.h
//
//  Created by Ashley Templeman on 12/12/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Currency.h"
#import "DataSource.h"

@interface CurrencyConverter : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIScrollView *ImageScrollView;
    UIScrollView *MainScrollView;
    UIScrollView *ContentScrollView;
    
    NSString *imageSelection;
    NSInteger lineSize;
    id<DataSource> dataSource;
    
    UIButton *secondCurrencyButton;
    UIButton *firstCurrencyButton;
    
    CGFloat screenWidth;
    CGFloat screenHeight;
    NSInteger homeImage;
    
    UIPickerView *pickerCustom;
    
    UITextField *currencyEntry1;
    UITextField *currencyEntry2;
    NSInteger currentTF;
//    UIPickerView *myPickerView;
//    UIButton *doneButton;
    
    NSInteger currencyButtonSelection;
}
//@property (strong, nonatomic) IBOutlet UIPickerView *pickerCustom;

//@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
//@property (weak, nonatomic) IBOutlet UIPickerView *picker;


@end

