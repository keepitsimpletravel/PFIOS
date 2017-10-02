//
//  HostelDetails2ViewController.h
//
//  Created by Ashley Templeman on 1/03/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import <StoreKit/StoreKit.h>
#import <MessageUI/MessageUI.h>

@interface HostelDetailsViewController : UIViewController <UIScrollViewDelegate,MFMailComposeViewControllerDelegate>
{
    NSInteger lineSize;
    NSInteger homeImage;
    UIScrollView *ContentScrollView;
    id<DataSource> dataSource;
    NSDecimalNumber *longitude;
    NSDecimalNumber *latitude;
    UIScrollView *ImageScrollView;
    Detail *detail;
    UITableView *roomsListing;
    UIView *facilitiesView;
    UIView *contactView;
//    NSString *imageSelection;
    NSInteger bedImageWidth;
    NSInteger bedImageHeight;
//    NSInteger bedSpace;
////    NSInteger instaSpace;
////    NSInteger instaHeight;
////    NSInteger instaWidth;
////    NSInteger tripAdvisorHeight;
////    NSInteger tripAdvisorWidth;
////    NSInteger staffHeadingHeight;
////    NSInteger staffHeadingWidth;
//    MFMailComposeViewController *mailComposer;
//    NSInteger fromMenu;
}
//- (IBAction)staffButton;
//- (IBAction)loadMap;
//- (void) setFromMenu:(NSInteger)value;

@end
