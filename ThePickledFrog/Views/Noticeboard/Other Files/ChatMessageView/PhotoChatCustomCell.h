//
//  ChatMessenger
//
//  Created by abcd on 11/04/16.
//  Copyright (c) 2016 ChatMessenger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface PhotoChatCustomCell : UITableViewCell{
   
    UILabel *lblBG;
    UILabel *lblName;
    UILabel *lblMessage;
    UILabel *lblTime;
    
    EGOImageView *imageObj;
    EGOImageView *photo;
}
@property (nonatomic,retain) IBOutlet UILabel *lblBG;
@property (nonatomic,retain) IBOutlet UILabel *lblName;
@property (nonatomic,retain) IBOutlet UILabel *lblMessage;
@property (nonatomic,retain) IBOutlet UILabel *lblTime;

@property (nonatomic,retain) IBOutlet EGOImageView *imageObj;
@property (nonatomic,retain) IBOutlet EGOImageView *photo;
@property (nonatomic,retain) IBOutlet UIButton *btnPhoto;

@property (nonatomic,retain) IBOutlet UIButton *btnReport;

-(void)drawImageView;
@end
