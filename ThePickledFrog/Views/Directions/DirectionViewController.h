//
//  DirectionViewController.h
//
//  Created by Ashley Templeman on 2/02/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "Directions.h"

@interface DirectionViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *ImageScrollView;
    UIScrollView *MainScrollView;
    id<DataSource> dataSource;
    
    NSString *title;
    Directions *direction;
    NSInteger currentIndex;
    NSDecimalNumber *latValue;
    NSDecimalNumber *longValue;
    
    NSInteger fromMap;
    Directions *mapDirection;
    NSMutableArray *allDirections;
    
    NSString *imageSelection;
    NSInteger lineSize;
    
    UIScrollView *ContentScrollView;
}
@property (assign, nonatomic) NSInteger index;

- (void) setDirection:(Directions *)value;
- (void) setTitleValue:(NSString *)type;
- (void) setCurrentIndex:(NSInteger)index;
- (void) setFromMap:(NSInteger)value;
- (void) setDirectionFromMap:(Directions *)value;
- (IBAction)loadMap;

@end
