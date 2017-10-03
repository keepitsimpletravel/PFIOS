//
//  TravelTipsViewController.h
//  HostelBlocks
//
//  Created by Ashley Templeman on 11/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "TravelTip.h"

@interface TravelTipsViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *ImageScrollView;
    UIScrollView *MainScrollView;
    id<DataSource> dataSource;
    
    NSString *title;
    TravelTip *travelTip;
    NSInteger currentIndex;
    NSDecimalNumber *latValue;
    NSDecimalNumber *longValue;
    
    NSMutableArray *allTravelTips;
    
    NSString *imageSelection;
    NSInteger lineSize;
    
    UIScrollView *ContentScrollView;
}
@property (assign, nonatomic) NSInteger index;

//- (void) setTravel:(Transport *)value;
- (void) setTitleValue:(NSString *)type;
- (void) setCurrentIndex:(NSInteger)index;

@end
