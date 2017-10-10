//
//  FeedbackViewController.h
//
//  Created by Ashley Templeman on 28/04/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DataSource.h"

@interface FeedbackViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    UITextView *feedbackTextView;
    MFMailComposeViewController *mailComposer;
    NSString *imageSelection;
    NSInteger lineSize;
    id<DataSource> dataSource;
    NSInteger fromMenu;
}
- (void) setFromMenu:(NSInteger)value;

@end
