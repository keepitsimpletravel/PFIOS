//
//  RightViewController.h
//  SWRevealSample
//
//  Created by Ashley Templeman on 20/3/17.
//  Copyright (c) 2014 DilumNavanjana. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DataSource.h"

@interface RightViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableView;
    NSInteger selection;
//    id<DataSource> dataSource;
    
    NSArray *options;
    
    BOOL _visible;
}
- (IBAction) menuClicked:(NSString *)type;

@end
