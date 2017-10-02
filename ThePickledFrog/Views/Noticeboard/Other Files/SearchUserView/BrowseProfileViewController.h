//
//  HomeViewController.h
//  CrewFinder
//
//  Created by abcd on 21/01/16.
//  Copyright (c) 2016 CrewFinder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SendViewController.h"

@interface BrowseProfileViewController : UIViewController {
    
    UITableView *tableViewobj;
    NSMutableArray *jobArray;
    UITextField *txtSearch;
    IBOutlet UILabel *lblNoData;

    SendViewController *sendViewObj;
    
}
@property (nonatomic,retain) IBOutlet UITextField *txtSearch;
@property (nonatomic,retain) IBOutlet UITableView *tableViewobj;
@property (nonatomic,retain) NSMutableArray *jobArray;
@property (nonatomic,retain) NSMutableArray *subJobArray;
@end
