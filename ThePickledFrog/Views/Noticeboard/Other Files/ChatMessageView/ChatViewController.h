//
//  ChatViewController.h
//  ChatMessenger
//
//  Created by abcd on 11/04/16.
//  Copyright (c) 2016 ChatMessenger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHInputToolbar.h"
#import "ZoomViewController.h"
#import "ProfileViewController.h"
#import "BrowseProfileViewController.h"

@interface ChatViewController : UIViewController <BHInputToolbarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UILabel *lblHeader;
    
    UITableView *tableViewObj;
    NSMutableArray *chatArray;
    NSString *jobID;
    NSString *senderID;
    
    UIActivityIndicatorView *spinner;
    UIImageView *actBgimg;
    
    BHInputToolbar *inputToolbar;
    NSTimer *timerObj;
    
    NSData *myImageData;
    UIImagePickerController *imagePickerController;
    ZoomViewController *zoomViewObj;
    
    ProfileViewController *profileObj;
    BrowseProfileViewController *searchViewObj;
    
    IBOutlet UIView *suggestionViewObj;
    
@private
    BOOL keyboardIsVisible;
    
}
@property (nonatomic,retain) NSData *myImageData;
@property (nonatomic,retain) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) NSTimer *timerObj;

@property (nonatomic, strong) BHInputToolbar *inputToolbar;

@property (nonatomic,retain) NSString *jobID;
@property (nonatomic,retain) NSString *senderID;
@property (nonatomic,retain) UIActivityIndicatorView *spinner;
@property (nonatomic,retain) UIImageView *actBgimg;

@property (nonatomic,retain) IBOutlet UITableView *tableViewObj;
@property (nonatomic,retain) IBOutlet UITableView *userTabelObj;
@property (nonatomic,retain) NSMutableArray *chatArray;
@property (nonatomic,retain) NSMutableArray *userArray;
@property (nonatomic,retain) NSMutableArray *userSubArray;

@end
