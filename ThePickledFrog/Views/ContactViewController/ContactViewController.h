//
//  ContactViewController.h
//  HostelBlocks
//
//  Created by Ashley Templeman on 9/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "Detail.h"
#import <MessageUI/MessageUI.h>

@interface ContactViewController : UIViewController<UIScrollViewDelegate, MFMailComposeViewControllerDelegate>
{
    UIScrollView *ImageScrollView;
    UIScrollView *MainScrollView;
    id<DataSource> dataSource;
    
    NSString *title;
    Detail *detail;
    NSInteger currentIndex;
    NSDecimalNumber *latValue;
    NSDecimalNumber *longValue;
    
    NSString *imageSelection;
    NSInteger lineSize;
    
    NSInteger selectedIndex;
    UIView *contactView;
    NSInteger contactPosition;
    
    NSInteger iconWidth;
    NSInteger iconHeight;
    NSInteger fromMenu;
}
@property (assign, nonatomic) NSInteger index;

- (void) setDetail:(Detail *)value;
- (void) setCurrentIndex:(NSInteger)index;
- (IBAction)loadMap;
- (void) setFromMenu:(NSInteger)value;

@end
