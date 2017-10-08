//
//  WhereNext.h
//  HostelBlocks
//
//  Created by Ashley Templeman on 8/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "WhereNext.h"

@interface WhereNextViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *ImageScrollView;
    UIScrollView *MainScrollView;
    id<DataSource> dataSource;
    
    NSString *title;
    WhereNext *whereNext;
    NSInteger currentIndex;
    NSDecimalNumber *latValue;
    NSDecimalNumber *longValue;
    
    NSMutableArray *allNexts;
    
    NSString *imageSelection;
    NSInteger lineSize;
    
    UIScrollView *ContentScrollView;
}
@property (assign, nonatomic) NSInteger index;

- (void) setWhereNext:(WhereNext *)value;
- (void) setTitleValue:(NSString *)type;
- (void) setCurrentIndex:(NSInteger)index;

@end
