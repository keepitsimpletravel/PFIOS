//
//  DrinksViewController.h
//
//  Created by Ashley Templeman on 11/12/2015.
//  Copyright © 2015 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "Drink.h"

@interface DrinksViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *ImageScrollView;
    UIScrollView *MainScrollView;
    id<DataSource> dataSource;
    
    NSString *title;
    Drink *drink;
    NSInteger currentIndex;
    NSDecimalNumber *latValue;
    NSDecimalNumber *longValue;
    
    NSInteger fromMap;
    Drink *mapDrink;
    NSMutableArray *allDrinks;
    
    NSString *imageSelection;
    NSInteger lineSize;
    
    NSInteger selectedIndex;
    
    UIView *aboutView;
    UIView *contactView;
    
    NSInteger contactPosition;
    NSInteger aboutPosition;
    
    NSInteger iconWidth;
    NSInteger iconHeight;
}
@property (assign, nonatomic) NSInteger index;

- (void) setDrink:(Drink *)value;
- (void) setTitleValue:(NSString *)type;
- (void) setCurrentIndex:(NSInteger)index;
- (void) setFromMap:(NSInteger)value;
- (void) setDrinkFromMap:(Drink *)value;
- (IBAction)loadMap;

@end
