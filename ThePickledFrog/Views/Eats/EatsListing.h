//
//  SegmentedView.h
//  MakatiJunctionHostel
//
//  Created by Ashley Templeman on 18/4/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"

@interface EatsListing : UIViewController
{
    NSInteger viewNumber;
    id<DataSource> dataSource;
//    NSArray *foodTypes;
    NSArray *eatsThumbnails;
//    NSArray *drinksThumbnails;
//    NSArray *attractionsThumbnails;
    UITableView *eatsListingTable1;
    UITableView *eatsListingTable2;
//    UITableView *eatsListingTable3;
    NSInteger selectedRow;
    
    UIScrollView *ContentScrollView;
    NSInteger fromMenu;
}
@property (weak, nonatomic) IBOutlet UIView *containerEat;
@property (weak, nonatomic) IBOutlet UIView *containerDrink;
@property (weak, nonatomic) IBOutlet UIView *containerAttraction;

- (void)setViewNumber:(NSInteger)value;
- (void) setFromMenu:(NSInteger)value;

@end
