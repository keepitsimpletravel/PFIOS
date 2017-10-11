//
//  DeveloperViewController.h
//
//  Created by Ashley Templeman on 10/05/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import <MessageUI/MessageUI.h>

@interface DeveloperViewController : UIViewController<UIScrollViewDelegate, MFMailComposeViewControllerDelegate>
{
    UIScrollView *ImageScrollView;
    UIScrollView *MainScrollView;
    UIScrollView *ContentScrollView;
	
    NSString *imageSelection;
    NSInteger lineSize;
    
    id<DataSource> dataSource;
    NSInteger fromMenu;
}
- (void) setFromMenu:(NSInteger)value;

@end
