//
//  TransportViewController.h
//  HostelBlocks
//
//  Created by Ashley Templeman on 8/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "Transport.h"

@interface TransportViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *ImageScrollView;
    UIScrollView *MainScrollView;
    id<DataSource> dataSource;
    
    NSString *title;
    Transport *transport;
    NSInteger currentIndex;
    NSDecimalNumber *latValue;
    NSDecimalNumber *longValue;
    
    NSMutableArray *allTransports;
    
    NSString *imageSelection;
    NSInteger lineSize;
    
    UIScrollView *ContentScrollView;
    
    NSString *mapImage;
    UITapGestureRecognizer *tap;
    UIImageView *mapImageView;
    UIScrollView *mapScrollView;
    NSInteger fromMap;
    
    Transport *mapTransport;
}
@property (assign, nonatomic) NSInteger index;

- (void) setTransportFromMap:(Transport *)value;
- (void) setTransport:(Transport *)value;
- (void) setTitleValue:(NSString *)type;
- (void) setCurrentIndex:(NSInteger)index;
- (void) setFromMap:(NSInteger)value;

@end
