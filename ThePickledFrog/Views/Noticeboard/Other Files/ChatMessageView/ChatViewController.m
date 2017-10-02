//
//  ChatViewController.m
//  ChatMessenger
//
//  Created by abcd on 11/04/16.
//  Copyright (c) 2016 ChatMessenger. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCustomCell.h"
#import "UserChatCustomCell.h"
#import "StaticClass.h"
#import "Singleton.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "DAKeyboardControl.h"
#import "Base64.h"
#import "PhotoChatCustomCell.h"
#import "PhotoUserChatCustomCell.h"
#import "Reachability.h"
#import "UserCustomCell.h"
#import "HomeViewController.h"
#import "RightViewController.h"
#import "SWRevealViewController.h"

#define kStatusBarHeight 20
#define kDefaultToolbarHeight 40
#define kKeyboardHeightPortrait 216
#define kKeyboardHeightLandscape 140
NSInteger photo=0, rowIndex;
@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize tableViewObj,chatArray,jobID,senderID,inputToolbar,timerObj,userTabelObj,userArray,userSubArray;
@synthesize spinner,actBgimg;
@synthesize imagePickerController,myImageData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheUpdated) name:@"SHOW" object:nil];
    
    zoomViewObj = [[ZoomViewController alloc]initWithNibName:@"ZoomViewController" bundle:nil];
    profileObj = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    searchViewObj = [[BrowseProfileViewController alloc]initWithNibName:@"BrowseProfileViewController" bundle:nil];
    
    // Do any additional setup after loading the view from its nib.
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    chatArray = [[NSMutableArray alloc]init];
    
    self.tableViewObj.rowHeight = 80.0;
    
    /* Calculate screen size */ // TODO - note that this was commented out in my code due to duplicate bar being seen
    self.inputToolbar = [[BHInputToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-kDefaultToolbarHeight, self.view.frame.size.width, kDefaultToolbarHeight)];
    [self.view addSubview:self.inputToolbar];
    inputToolbar.inputDelegate = self;
    inputToolbar.textView.placeholder = @"Enter Message";
    inputToolbar.textView.text = @"";
    
    timerObj = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getChatMessagesBack) userInfo:nil repeats:YES];
    
    self.view.keyboardTriggerOffset = inputToolbar.frame.size.height;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect toolBarFrame = inputToolbar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        inputToolbar.frame = toolBarFrame;
        
        CGRect tableViewFrame = self.tableViewObj.frame;
        tableViewFrame.size.height = keyboardFrameInView.origin.y - 100;
        self.tableViewObj.frame = tableViewFrame;
        // [controller tableViewScrollToBottomAnimated:NO];
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnAddPhotoClick) name:@"SENDPHOTO" object:nil];
}

- (void)cacheUpdated
{
    [self searchAutocompleteGroup:[StaticClass retrieveFromUserDefaults:@"SEARCH"]];
}

-(void)getChatMessagesBack
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        // No internet
        [self.view makeToast:@"No connection to the Internet was found. Please connect using WiFi or Mobile Data."];
    }
    else if (status == ReachableViaWiFi || status == ReachableViaWWAN)
    {
        //WiFi
        if ([[StaticClass retrieveFromUserDefaults:@"UID"] integerValue] > 0 ) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSString *strUrl=[NSString stringWithFormat:@"%@getMsg.php?userID=%@&senderID=%@&key=5a14ec5b310164f2dfe49e86b06124a",[[Singleton sharedSingleton]getBaseURL],[StaticClass retrieveFromUserDefaults:@"UID"],self.senderID];
            NSURL *url=[NSURL URLWithString:strUrl];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
            [request setDelegate:self];
            [request setDidFinishSelector:@selector(requestFinished:)];
            [request setDidFailSelector:@selector(requestFail:)];
            [request startAsynchronous];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    suggestionViewObj.hidden = YES;
    
    self.inputToolbar = [[BHInputToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-kDefaultToolbarHeight, self.view.frame.size.width, kDefaultToolbarHeight)];
    [self.view addSubview:self.inputToolbar];
    inputToolbar.inputDelegate = self;
    inputToolbar.textView.placeholder = @"Enter Message";
    inputToolbar.textView.text = @"";
    if (photo == 0) {
        inputToolbar.hidden = NO;
        self.inputToolbar.frame = CGRectMake(0, self.view.frame.size.height-kDefaultToolbarHeight, self.view.frame.size.width, kDefaultToolbarHeight);
        [inputToolbar.textView resignFirstResponder];
        if ([[StaticClass retrieveFromUserDefaults:@"UID"] integerValue] > 0 ) {
            [self getChatMessages];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Display Name" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",@"Cancel", nil] ;
            alertView.tag = 20;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
        }
        [self getAllMember];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 20) {
        if (buttonIndex == 0) {
            UITextField * alertTextField = [alertView textFieldAtIndex:0];
            NSLog(@"alerttextfiled - %@",alertTextField.text);
            
            Reachability *reachability = [Reachability reachabilityForInternetConnection];
            [reachability startNotifier];
            
            NetworkStatus status = [reachability currentReachabilityStatus];
            
            if(status == NotReachable)
            {
                // No internet
                [self.view makeToast:@"No connection to the Internet was found. Please connect using WiFi or Mobile Data."];
            }
            else if (status == ReachableViaWiFi || status == ReachableViaWWAN)
            {
                [StaticClass saveToUserDefaults:alertTextField.text :@"NAME"];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                NSString *strUrl=[NSString stringWithFormat:@"%@addUser.php?name=%@&device=%@&key=5a14ec5b310164f2dfe49e86b06124a",[[Singleton sharedSingleton]getBaseURL],[alertTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[StaticClass retrieveFromUserDefaults:@"TOKEN"]];
                NSURL *url=[NSURL URLWithString:strUrl];
                
                ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
                [request setDelegate:self];
                [request setDidFinishSelector:@selector(UserrequestFinished:)];
                [request setDidFailSelector:@selector(UserrequestFail:)];
                [request startAsynchronous];
            }
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (alertView.tag == 5001) {
        if (buttonIndex == 0) {
            NSDictionary *tempObj = [self.chatArray objectAtIndex:rowIndex];
            Reachability *reachability = [Reachability reachabilityForInternetConnection];
            [reachability startNotifier];
            
            NetworkStatus status = [reachability currentReachabilityStatus];
            
            if(status == NotReachable)
            {
                // No internet
                [self.view makeToast:@"No connection to the Internet was found. Please connect using WiFi or Mobile Data."];
            }
            else if (status == ReachableViaWiFi || status == ReachableViaWWAN)
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                NSString *strUrl=[NSString stringWithFormat:@"%@report.php?msgID=%@&userID=%@&key=5a14ec5b310164f2dfe49e86b06124a",[[Singleton sharedSingleton]getBaseURL],[tempObj valueForKey:@"msgID"],[StaticClass retrieveFromUserDefaults:@"UID"]];
                NSURL *url=[NSURL URLWithString:strUrl];
                ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
                [request setRequestMethod:@"GET"];
                [request setDelegate:self];
                [request setDidFinishSelector:@selector(sendReportedRequestFinished:)];
                [request setDidFailSelector:@selector(sendMessageRequestFail:)];
                [request startAsynchronous];
            }
        }
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)UserrequestFinished:(ASIHTTPRequest *)request
{
    @try {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if ([[dict valueForKey:@"data"] isEqualToString:@"success"]) {
            NSDictionary *userData = [dict valueForKey:@"user_data"];
            NSString *uID = [NSString stringWithFormat:@"%ld",[[userData valueForKey:@"userID"] integerValue]];
            [StaticClass saveToUserDefaults:uID :@"UID"];
            [StaticClass saveToUserDefaults:[userData valueForKey:@"isnotify"] :@"isNotify"];
            
            [self getChatMessages];
        }
    }
    @catch (NSException *exception) {
    }
}

- (void)UserrequestFail:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


///Get ChatMessages
-(void)getChatMessages
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        // No internet
        [self.view makeToast:@"No connection to the Internet was found. Please connect using WiFi or Mobile Data."];
    }
    else if (status == ReachableViaWiFi || status == ReachableViaWWAN)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *strUrl=[NSString stringWithFormat:@"%@getMsg.php?userID=%@&senderID=%@&key=5a14ec5b310164f2dfe49e86b06124a",[[Singleton sharedSingleton]getBaseURL],[StaticClass retrieveFromUserDefaults:@"UID"],self.senderID];
        NSURL *url=[NSURL URLWithString:strUrl];
        
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestFinished:)];
        [request setDidFailSelector:@selector(requestFail:)];
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    for (int i = 0;  i<[self.chatArray count]; i++) {
        NSDictionary *dict = [self.chatArray objectAtIndex:i];
        dict = nil;
    }
    [self.chatArray removeAllObjects];
    @try {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if ([[dict valueForKey:@"data"] isEqualToString:@"success"]) {
            NSArray *items = [dict valueForKey:@"msg_data"];
            for (NSDictionary *d in items) {
                [self.chatArray addObject:d];
            }
        }
    }
    @catch (NSException *exception) {
    }
    [self.tableViewObj reloadData];
    NSInteger rowNumbers = [self.tableViewObj numberOfRowsInSection:0];
    if (rowNumbers >0) {
        [self.tableViewObj scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumbers-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)requestFail:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

//Table Start////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tableViewObj) {
        return self.chatArray.count;
    }
    else{
        return userArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        if (tableView == tableViewObj) {
            NSDictionary *tempObj = [self.chatArray objectAtIndex:indexPath.row];
            if ([[tempObj valueForKey:@"type"] isEqualToString:@"Message"])
            {
                if ([[tempObj valueForKey:@"userID"] isEqualToString:[StaticClass retrieveFromUserDefaults:@"UID"]])
                {
                    static NSString *temp= @"UserChatCustomCell";
                    UserChatCustomCell *cellheader = (UserChatCustomCell *)[self.tableViewObj dequeueReusableCellWithIdentifier:temp];
                    if (cellheader == nil) {
                        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UserChatCustomCell" owner:self options:nil];
                        cellheader = [nib objectAtIndex:0];
                        cellheader.showsReorderControl = NO;
                        cellheader.selectionStyle = UITableViewCellSelectionStyleNone;
                        cellheader.backgroundColor=[UIColor clearColor];
                        [cellheader.btnReport addTarget:self action:@selector(btnReportClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    cellheader.btnReport.tag = indexPath.row;
                    //cellheader.lblName.text = [tempObj valueForKey:@"name"];
                    cellheader.lblBG.layer.cornerRadius = 3.0;
                    cellheader.lblBG.layer.masksToBounds = YES;
                    
                    cellheader.lblMessage.text = [tempObj valueForKey:@"message"];
                    cellheader.lblTime.text = [[tempObj valueForKey:@"time"] stringByReplacingOccurrencesOfString:@" ago" withString:@""];
                    return cellheader;
                    
                }
                else
                {
                    static NSString *temp= @"ChatCustomCell";
                    ChatCustomCell *cellheader = (ChatCustomCell *)[self.tableViewObj dequeueReusableCellWithIdentifier:temp];
                    if (cellheader == nil) {
                        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"ChatCustomCell" owner:self options:nil];
                        cellheader = [nib objectAtIndex:0];
                        cellheader.showsReorderControl = NO;
                        cellheader.selectionStyle = UITableViewCellSelectionStyleNone;
                        cellheader.backgroundColor=[UIColor clearColor];
                        [cellheader.btnPhoto addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
                        [cellheader.btnReport addTarget:self action:@selector(btnReportClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    cellheader.btnReport.tag = indexPath.row;

                    cellheader.btnPhoto.tag = indexPath.row;
                    cellheader.lblBG.layer.cornerRadius = 3.0;
                    cellheader.lblBG.layer.masksToBounds = YES;
                    
                    cellheader.lblName.text = [tempObj valueForKey:@"name"];
                    cellheader.lblMessage.text = [tempObj valueForKey:@"message"];
                    cellheader.imageObj.placeholderImage = [UIImage imageNamed:@"image.png"];
                    
                    cellheader.imageObj.imageURL = [NSURL URLWithString:[tempObj valueForKey:@"profile"]];
                    cellheader.lblTime.text = [[tempObj valueForKey:@"time"] stringByReplacingOccurrencesOfString:@" ago" withString:@""];
                    
                    cellheader.imageObj.layer.masksToBounds = YES;
                    cellheader.imageObj.layer.cornerRadius = 15.0;
                    return cellheader;
                }
            }
            else{
                if ([[tempObj valueForKey:@"userID"] isEqualToString:[StaticClass retrieveFromUserDefaults:@"UID"]]) {
                    
                    static NSString *temp= @"PhotoUserChatCustomCell";
                    PhotoUserChatCustomCell *cellheader = (PhotoUserChatCustomCell *)[self.tableViewObj dequeueReusableCellWithIdentifier:temp];
                    if (cellheader == nil) {
                        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoUserChatCustomCell" owner:self options:nil];
                        cellheader = [nib objectAtIndex:0];
                        cellheader.showsReorderControl = NO;
                        cellheader.selectionStyle = UITableViewCellSelectionStyleNone;
                        cellheader.backgroundColor=[UIColor clearColor];
                        [cellheader.btnReport addTarget:self action:@selector(btnReportClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    cellheader.btnReport.tag = indexPath.row;

                    //cellheader.lblName.text = [tempObj valueForKey:@"name"];
                    cellheader.lblBG.layer.cornerRadius = 3.0;
                    cellheader.lblBG.layer.masksToBounds = YES;
                    
                    //cellheader.lblMessage.text = [tempObj valueForKey:@"message"];
                    cellheader.lblTime.text = [[tempObj valueForKey:@"time"] stringByReplacingOccurrencesOfString:@" ago" withString:@""];
                    cellheader.photo.imageURL = [NSURL URLWithString:[tempObj valueForKey:@"image"]];
                    
                    return cellheader;
                    
                }
                else{
                    
                    static NSString *temp= @"PhotoChatCustomCell";
                    PhotoChatCustomCell *cellheader = (PhotoChatCustomCell *)[self.tableViewObj dequeueReusableCellWithIdentifier:temp];
                    if (cellheader == nil) {
                        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoChatCustomCell" owner:self options:nil];
                        cellheader = [nib objectAtIndex:0];
                        cellheader.showsReorderControl = NO;
                        cellheader.selectionStyle = UITableViewCellSelectionStyleNone;
                        cellheader.backgroundColor=[UIColor clearColor];
                        [cellheader.btnPhoto addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [cellheader.btnReport addTarget:self action:@selector(btnReportClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    cellheader.btnReport.tag = indexPath.row;

                    cellheader.btnPhoto.tag = indexPath.row;
                    cellheader.lblBG.layer.cornerRadius = 3.0;
                    cellheader.lblBG.layer.masksToBounds = YES;
                    
                    cellheader.lblName.text = [tempObj valueForKey:@"name"];
                    // cellheader.lblMessage.text = [tempObj valueForKey:@"message"];
                    cellheader.imageObj.placeholderImage = [UIImage imageNamed:@"image.png"];
                    
                    cellheader.imageObj.imageURL = [NSURL URLWithString:[tempObj valueForKey:@"profile"]];
                    cellheader.photo.imageURL = [NSURL URLWithString:[tempObj valueForKey:@"image"]];
                    
                    cellheader.lblTime.text = [[tempObj valueForKey:@"time"] stringByReplacingOccurrencesOfString:@" ago" withString:@""];
                    
                    cellheader.imageObj.layer.masksToBounds = YES;
                    cellheader.imageObj.layer.cornerRadius = 15.0;
                    return cellheader;
                }
            }
        }
        else{
            static NSString *temp= @"UserCustomCell";
            UserCustomCell *cellheader = (UserCustomCell *)[self.userTabelObj dequeueReusableCellWithIdentifier:temp];
            if (cellheader == nil) {
                NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UserCustomCell" owner:self options:nil];
                cellheader = [nib objectAtIndex:0];
                cellheader.showsReorderControl = NO;
                cellheader.selectionStyle = UITableViewCellSelectionStyleNone;
                cellheader.backgroundColor=[UIColor clearColor];
            }
            cellheader.imageObj.layer.masksToBounds = YES;
            cellheader.imageObj.layer.cornerRadius = 15.0;
            
            NSDictionary *tempObj = [userArray objectAtIndex:indexPath.row];
            cellheader.lblName.text = [tempObj valueForKey:@"name"];
            cellheader.imageObj.placeholderImage = [UIImage imageNamed:@"image.png"];
            cellheader.imageObj.imageURL = [NSURL URLWithString:[tempObj valueForKey:@"image"]];
            
            return cellheader;
        }
    }
    @catch (NSException *exception) {
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableViewObj) {
        NSDictionary *tempObj = [self.chatArray objectAtIndex:indexPath.row];
        if ([[tempObj valueForKey:@"type"] isEqualToString:@"Message"])
        {
            return 80;
        }else
        {
            return 150;
        }
    }
    else{
        return 40.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableViewObj) {
        NSDictionary *tempObj = [self.chatArray objectAtIndex:indexPath.row];
        if ([[tempObj valueForKey:@"type"] isEqualToString:@"Image"])
        {
            NSURL *url = [NSURL URLWithString:[tempObj valueForKey:@"image"]];
            [zoomViewObj setUrlStr:url];
            [self.navigationController pushViewController:zoomViewObj animated:YES];
        }
    }
    else{
        NSDictionary *tempObj = [userArray objectAtIndex:indexPath.row];
        self.inputToolbar.textView.text = [NSString stringWithFormat:@"%@ %@",[StaticClass retrieveFromUserDefaults:@"SEARCH"],[tempObj valueForKey:@"name"]];
        
        [StaticClass saveToUserDefaults:self.inputToolbar.textView.text :@"@NAME"];
        [StaticClass saveToUserDefaults:[tempObj valueForKey:@"userID"] :@"R_ID"];
        suggestionViewObj.hidden = YES;
    }
}

-(IBAction)btnUserProfileClick:(id)sender
{
    NSDictionary *tempObj = [self.chatArray objectAtIndex:[sender tag]];
    [profileObj setSenderID:[tempObj valueForKey:@"userID"]];
    [self.navigationController pushViewController:profileObj animated:YES];
    
}

-(IBAction)btnReportClick:(id)sender
{
    rowIndex = [sender tag];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Report" message:@"Are you sure to report this message?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    alert.tag= 5001;
    [alert show];
}

- (void)sendReportedRequestFinished:(ASIHTTPRequest *)request
{
    @try {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if ([[dict valueForKey:@"data"] isEqualToString:@"success"]) {
            [self.view makeToast:[dict valueForKey:@"msg"]];
            [self getChatMessages];
        }
        else{
            [self.view makeToast:[dict valueForKey:@"msg"]];
        }
    }
    @catch (NSException *exception) {
    }
}

#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    /* Move the toolbar to above the keyboard */
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect frame = self.inputToolbar.frame;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        frame.origin.y = self.view.frame.size.height - frame.size.height - kKeyboardHeightPortrait;
    }
    else {
        frame.origin.y = self.view.frame.size.width - frame.size.height - kKeyboardHeightLandscape - kStatusBarHeight;
    }
    self.inputToolbar.frame = frame;
    [UIView commitAnimations];
    keyboardIsVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    /* Move the toolbar back to bottom of the screen */
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect frame = self.inputToolbar.frame;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        frame.origin.y = self.view.frame.size.height - frame.size.height;
    }
    else {
        frame.origin.y = self.view.frame.size.width - frame.size.height;
    }
    self.inputToolbar.frame = frame;
    [UIView commitAnimations];
    keyboardIsVisible = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* No longer listen for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)inputButtonPressed:(NSString *)inputText
{
    /* Called when toolbar button is pressed */
    NSLog(@"Pressed button with text: '%@'", inputText);
    //  NSString *message = [inputText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        // No internet
        [self.view makeToast:@"No connection to the Internet was found. Please connect using WiFi or Mobile Data."];
    }
    else if (status == ReachableViaWiFi || status == ReachableViaWWAN)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *strUrl=[NSString stringWithFormat:@"%@sendMsg.php",[[Singleton sharedSingleton]getBaseURL]];
        NSURL *url=[NSURL URLWithString:strUrl];
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setPostValue:@"5a14ec5b310164f2dfe49e86b06124a" forKey:@"key"];
        [request setPostValue:inputText forKey:@"msg"];
        [request setPostValue:[StaticClass retrieveFromUserDefaults:@"UID"] forKey:@"userID"];
        [request setPostValue:@"" forKey:@"senderID"];
        [request setPostValue:[StaticClass retrieveFromUserDefaults:@"R_ID"] forKey:@"receiverID"];
        
        [request setPostValue:@"Message" forKey:@"type"];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(sendMessageRequestFinished:)];
        [request setDidFailSelector:@selector(sendMessageRequestFail:)];
        [request startAsynchronous];
    }
}

- (void)sendMessageRequestFinished:(ASIHTTPRequest *)request
{
    @try {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if ([[dict valueForKey:@"data"] isEqualToString:@"success"]) {
            [self.view makeToast:[dict valueForKey:@"msg"]];
            [StaticClass saveToUserDefaults:@"":@"R_ID"];
            [StaticClass saveToUserDefaults:@"" :@"SEARCH"];
            [self getChatMessages];
        }
        else{
            [self.view makeToast:[dict valueForKey:@"msg"]];
        }
    }
    @catch (NSException *exception) {
    }
}

- (void)sendMessageRequestFail:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

//AddPhoto
-(void)btnAddPhotoClick
{
    photo=1;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *photoAlert = [[UIAlertView alloc]initWithTitle:@"Select Photo" message:@"Select Photo from Camera or Library" delegate:self cancelButtonTitle:nil otherButtonTitles: @"Capture",@"Choose from Library",@"Cancel",nil];
        photoAlert.tag =1;
        [photoAlert show];
    }
    else
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.myImageData = UIImageJPEGRepresentation(selectedImage,1.0);
    [self sendPhoto];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag ==1)
    {
        if (buttonIndex == 0) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        if (buttonIndex == 1)
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

-(void)sendPhoto
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        // No internet
        [self.view makeToast:@"No connection to the Internet was found. Please connect using WiFi or Mobile Data."];
    }
    else if (status == ReachableViaWiFi || status == ReachableViaWWAN)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *strUrl=[NSString stringWithFormat:@"%@sendMsg.php",[[Singleton sharedSingleton]getBaseURL]];
        NSURL *url=[NSURL URLWithString:strUrl];
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setPostValue:[StaticClass retrieveFromUserDefaults:@"UID"] forKey:@"userID"];
        [request setPostValue:@"" forKey:@"senderID"];
        [request setPostValue:@"" forKey:@"msg"];
        [request setPostValue:@"Image" forKey:@"type"];
        
        [Base64 initialize];
        NSString *str = @"";
        if (self.myImageData != nil) {
            str = [Base64 encode:self.myImageData];
        }
        [request setPostValue:str forKey:@"image"];
        [request setPostValue:@"5a14ec5b310164f2dfe49e86b06124a" forKey:@"key"];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(onSendPhotoSuccess:)];
        [request setDidFailSelector:@selector(onSendPhotoSuccessFail:)];
        [request startAsynchronous];
    }
}

- (void)onSendPhotoSuccess:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
    if ([[dict valueForKey:@"data"] isEqualToString:@"success"]) {
        photo=0;
        [self.view.window makeToast:[dict valueForKey:@"msg"]];
        self.myImageData = nil;
        [self getChatMessages];
    }
    else{
        [self.view makeToast:[dict valueForKey:@"msg"]];
    }
}

- (void)onSendPhotoSuccessFail:(ASIHTTPRequest *)request
{
    [self.view makeToast:@"Internet-anslutning inte finns!"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(IBAction)btnBackClick:(id)sender
{
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    homeViewController.title = @"The Pickled Frog";
    
    RightViewController *rightViewController = rightViewController = [[RightViewController alloc] init];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rightViewController frontViewController:frontNavigationController];
    revealController.delegate = self;
    
    revealController.rightViewController = rightViewController;
    [self.navigationController pushViewController:revealController animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)atext
{
    [textView resignFirstResponder];
    return YES;
}

-(IBAction)btnProfileClick:(id)sender
{
    [profileObj setSenderID:@""];
    
    [self.navigationController pushViewController:profileObj animated:YES];
}

-(IBAction)btnSearchClick:(id)sender
{
    [self.navigationController pushViewController:searchViewObj animated:YES];
}

-(void)getAllMember
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl=[NSString stringWithFormat:@"%@activeUser.php?userID=%@&key=5a14ec5b310164f2dfe49e86b06124a",[[Singleton sharedSingleton]getBaseURL],[StaticClass retrieveFromUserDefaults:@"UID"]];
    NSURL *url=[NSURL URLWithString:strUrl];
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestUserFinished:)];
    [request setDidFailSelector:@selector(requestUserFail:)];
    [request startAsynchronous];
}

- (void)requestUserFinished:(ASIHTTPRequest *)request
{
    [userSubArray removeAllObjects];
    [userArray removeAllObjects];
    userArray = [[NSMutableArray alloc]init];
    userSubArray = [[NSMutableArray alloc]init];
    
    @try {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        //Frnd
        NSArray *items = [dict valueForKey:@"user_data"];
        if (![items isEqual: [NSNull null]]) {
            for (NSDictionary *d in items) {
                if (![[d valueForKey:@"userID"] isEqual: [NSNull null]]) {
                    [userArray addObject:d];
                    [userSubArray addObject:d];
                }
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    [self.userTabelObj reloadData];
}

- (void)requestUserFail:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)searchAutocompleteGroup:(NSString *)substring
{
    @try {
        if ([substring containsString:@"@"]) {
            suggestionViewObj.hidden = NO;
            NSString *curString;
            [userArray removeAllObjects];
            
            if(![substring isEqualToString:@""] )
            {
                for(NSDictionary *obj in  self.userSubArray)
                {
                    curString = [[obj valueForKey:@"search_name"] stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    substring = [substring stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    NSRange substringRange = [curString rangeOfString:substring options:NSCaseInsensitiveSearch];
                    if (substringRange.location != NSNotFound){
                        [self.userArray addObject:obj];
                    }
                }
            }
            else {
                for(NSDictionary *obj in  self.userSubArray){
                    [self.userArray addObject:obj];
                }
            }
            [self.userTabelObj  reloadData];
        }
        else{
            suggestionViewObj.hidden = YES;
        }
    }
    @catch (NSException *exception) {
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
}

@end
