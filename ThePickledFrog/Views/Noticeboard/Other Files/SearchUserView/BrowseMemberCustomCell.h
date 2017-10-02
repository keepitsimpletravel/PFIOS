//
//  NotificationCustomCell.h
//  Facebook
//
//  Created by  test on 17/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface BrowseMemberCustomCell : UITableViewCell{
   
    UILabel *lblName;
    EGOImageView *imageObj;
}
@property (nonatomic,retain) IBOutlet UILabel *lblName;
@property (nonatomic,retain) IBOutlet EGOImageView *imageObj;
@property (nonatomic,retain) IBOutlet UIButton *btnCheck;
@end
