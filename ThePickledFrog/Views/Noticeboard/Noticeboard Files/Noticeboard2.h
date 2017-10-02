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

@interface Noticeboard2 : UIViewController <BHInputToolbarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    UITableView *tableViewChat;
    UIToolbar *toolbar;
    
//    IBOutlet UILabel *lblHeader;
//    
//    UITableView *tableViewObj;
    NSMutableArray *chatArray;
    NSMutableArray *chatImageArray;
    NSDictionary *imageDictionary;
//    NSString *jobID;
    NSString *senderID;
    UIImageView *image;

//    UIActivityIndicatorView *spinner;
//    UIImageView *actBgimg;
//    
    BHInputToolbar *inputToolbar;
    NSTimer *timerObj;

//    NSData *myImageData;
    UIImagePickerController *imagePickerController;
    ZoomViewController *zoomViewObj;
//    
//    ProfileViewController *profileObj;
//    BrowseProfileViewController *searchViewObj;
//    
//    IBOutlet UIView *suggestionViewObj;
//    
//    NSInteger lineSize;
//    UIToolbar *toolbar;
//    UIView *toolbarLine;
//    
    NSInteger loginSuccess;
    NSString *user;
    UIView *toolbarLine;
    
    NSInteger cellHeight;
    NSInteger globalcellWidth;
    
    UITapGestureRecognizer *tap;
    BOOL isFullScreen;
    CGRect prevFrame;
    
    CGFloat screenHeight;
    CGFloat screenWidth;
    
    NSInteger cellCounter;
//    
@private
    BOOL keyboardIsVisible;
    
}
@property (nonatomic,retain) NSData *myImageData;
@property (nonatomic, strong) UIImageView *imageView; 
//@property (nonatomic,retain) UIImagePickerController *imagePickerController;
//
//@property (nonatomic, strong) NSTimer *timerObj;
//
@property (nonatomic, strong) BHInputToolbar *inputToolbar;
//
//@property (nonatomic,retain) NSString *jobID;
@property (nonatomic,retain) NSString *senderID;
//@property (nonatomic,retain) UIActivityIndicatorView *spinner;
//@property (nonatomic,retain) UIImageView *actBgimg;
//
//@property (nonatomic,retain) IBOutlet UITableView *tableViewObj;
//@property (nonatomic,retain) IBOutlet UITableView *userTabelObj;
@property (nonatomic,retain) NSMutableArray *chatArray;
@property (nonatomic,retain) NSMutableArray *chatImageArray;
@property (nonatomic,retain) NSDictionary *imageDictionary;
//@property (nonatomic,retain) NSMutableArray *userArray;
//@property (nonatomic,retain) NSMutableArray *userSubArray;

@end

