//
//  ProfileViewController.h
//  ChatMessenger
//
//  Created by abcd on 15/11/16.
//  Copyright © 2016 ChatMessenger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "SettingsViewController.h"

@interface ProfileViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    IBOutlet UILabel *lblName;
    IBOutlet UIButton *btnUpdate;
    IBOutlet UIButton *btnSettings;
    SettingsViewController *settingsViewObj;
}
@property (nonatomic,retain) IBOutlet EGOImageView *profileImg;
@property (nonatomic,retain) NSData *myImageData;
@property (nonatomic,retain) UIImagePickerController *imagePickerController;
@property (nonatomic,retain) NSString *senderID;
@end
