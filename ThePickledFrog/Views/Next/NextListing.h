//
//  SegmentedView.h
//  MakatiJunctionHostel
//
//  Created by Ashley Templeman on 18/4/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"

@interface NextListing : UIViewController
{
    NSInteger viewNumber;
    id<DataSource> dataSource;
    NSArray *nextThumbnails;
    UITableView *nextListingTable1;
    UITableView *nextListingTable2;
    UITableView *nextListingTable3;
    NSInteger selectedRow;
    
    UIScrollView *ContentScrollView;
    NSInteger fromMenu;
}

- (void)setViewNumber:(NSInteger)value;
- (void) setFromMenu:(NSInteger)value;

@end
