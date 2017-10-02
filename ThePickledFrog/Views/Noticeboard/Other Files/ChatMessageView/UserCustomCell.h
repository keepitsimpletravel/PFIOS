//
//  ChatMessenger
//
//  Created by abcd on 11/04/16.
//  Copyright (c) 2016 ChatMessenger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface UserCustomCell : UITableViewCell{
   
    UILabel *lblName;
    EGOImageView *imageObj;
}
@property (nonatomic,retain) IBOutlet UILabel *lblName;
@property (nonatomic,retain) IBOutlet EGOImageView *imageObj;

@end
