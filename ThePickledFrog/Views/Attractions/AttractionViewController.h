//
//  AttractionsViewController.h
//
//  Created by Ashley Templeman on 11/12/2015.
//  Copyright © 2015 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "Activity.h"

@interface AttractionViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *ImageScrollView;
    UIScrollView *MainScrollView;
    id<DataSource> dataSource;
    
    NSString *title;
    Activity *activity;
    NSInteger currentIndex;
    NSDecimalNumber *latValue;
    NSDecimalNumber *longValue;
    
    NSInteger fromMap;
    Activity *mapActivity;
    NSMutableArray *allActivites;
    
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

- (void) setActivity:(Activity *)value;
- (void) setTitleValue:(NSString *)type;
- (void) setCurrentIndex:(NSInteger)index;
- (void) setFromMap:(NSInteger)value;
- (void) setActivityFromMap:(Activity *)value;
- (IBAction)loadMap;

@end
