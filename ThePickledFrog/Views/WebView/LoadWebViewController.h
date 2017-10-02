//
//  LoadWebViewController.h
//  HostelBlocks
//
//  Created by Ashley Templeman on 3/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"

@interface LoadWebViewController : UIViewController
{
//    NSString *imageSelection;
    UIWebView *webView;
    NSInteger lineSize;
    NSString *fullURL;
    NSString *title;
//    id<DataSource> dataSource;
    UIActivityIndicatorView *loadingIndicator;
    NSInteger fromMenu;
}
@property (strong, nonatomic) IBOutlet UIWebView *viewWeb;

- (void) setURL:(NSString *)urlValue;
- (void) setTitleValue:(NSString *)titleValues;
- (void) setFromMenu:(NSInteger)value;

@end
