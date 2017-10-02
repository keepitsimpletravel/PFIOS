//
//  ChatMessenger
//
//  Created by abcd on 11/04/16.
//  Copyright (c) 2016 ChatMessenger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface ZoomViewController : UIViewController <UIScrollViewDelegate>{
    
//    UIScrollView *scrollObj;
    EGOImageView *imageObj;
    NSURL *urlStr;
}
@property (nonatomic,retain) NSURL *urlStr;
//@property (nonatomic,retain) IBOutlet UIScrollView *scrollObj;
@property (nonatomic,retain) IBOutlet EGOImageView *imageObj;
@end
