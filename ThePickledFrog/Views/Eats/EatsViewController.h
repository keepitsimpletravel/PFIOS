//
//  EatsViewController.h
//
//  Created by Ashley Templeman on 2/02/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "Food.h"

@interface EatsViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *ImageScrollView;
    UIScrollView *MainScrollView;
    id<DataSource> dataSource;
    
    NSString *title;
    Food *food;
    NSInteger currentIndex;
    NSDecimalNumber *latValue;
    NSDecimalNumber *longValue;
    
    NSInteger fromMap;
    Food *mapFood;
    NSMutableArray *allFoods;
    
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

- (void) setFood:(Food *)value;
- (void) setTitleValue:(NSString *)type;
- (void) setCurrentIndex:(NSInteger)index;
- (void) setFromMap:(NSInteger)value;
- (void) setFoodFromMap:(Food *)value;
- (IBAction)loadMap;

@end
