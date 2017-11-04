//
//  ChatViewController.m
//  ChatMessenger
//
//  Created by abcd on 11/04/16.
//  Copyright (c) 2016 ChatMessenger. All rights reserved.
//

#import "Noticeboard2.h"
#import "ChatCustomCell.h"
#import "NoticeboardCustomCell.h"
#import "StaticClass.h"
#import "Singleton.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "DAKeyboardControl.h"
#import "Base64.h"
#import "Reachability.h"
#import "RightViewController.h"
#import "PhotoNoticeboardCustomCell.h"
#import "SWRevealViewController.h"
#import "zoomPopup.h"
#import "HomeViewController.h"

#define kStatusBarHeight 20
#define kDefaultToolbarHeight 40
#define kKeyboardHeightPortrait 216
#define kKeyboardHeightLandscape 140
NSInteger photoV=0, rowIn;
@interface Noticeboard2 ()

@end

@implementation Noticeboard2

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@synthesize senderID, inputToolbar, chatArray, myImageData, chatImageArray, imageDictionary;
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    user = @"0";
    cellCounter = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheUpdated) name:@"SHOW" object:nil];

    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    chatArray = [[NSMutableArray alloc]init];
    chatImageArray = [[NSMutableArray alloc]init];
    
    // Screen Dimensions Setup
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    NSInteger homeImage = 0;
    NSInteger yPosition = 64;
    NSInteger lineSize = 0;
    
    if (screenHeight == 568){
        homeImage = 225.67;
        lineSize = 2;
    } else if (screenHeight == 667){
        homeImage = 265;
        lineSize = 2;
    } else if (screenHeight == 736){
        homeImage = 292.41;
        lineSize = 2;
    }
    NSString *titleValue = @"NOTICEBOARD";
    
    UIFont* titleFont = [UIFont fontWithName:@"Helvetica" size:18];
    CGSize requestedTitleSize = [titleValue sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    CGFloat titleWidth = MIN(screenWidth, requestedTitleSize.width);
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, 20)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.text = titleValue;
    self.navigationItem.titleView = navLabel;
    
    // Set Home Button
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    
    anotherButton.tintColor = [UIColor blueColor];
    
    self.navigationItem.leftBarButtonItem = anotherButton;
    
    // Set Line below status bar
    UIView *statusBarLine = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, lineSize)];
    statusBarLine.backgroundColor = Rgb2UIColor(0, 0, 0);
    [self.view addSubview:statusBarLine];
    
    yPosition = yPosition + lineSize;

    // Add Table View
    // Create each of the tableviews and add to an array
    tableViewChat = [[UITableView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, screenHeight-51-66)];
    
    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    tableViewChat.delegate = self;
    tableViewChat.dataSource = self;
    tableViewChat.hidden = NO;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-51-66)];
    backgroundView.opaque = YES;
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"png"]];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:image];
    backgroundView.opaque = NO;
    tableViewChat.backgroundView = backgroundView;

    [self.view addSubview:tableViewChat];
    
    timerObj = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getChatMessagesBack) userInfo:nil repeats:NO];
    
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
    
            CGRect tableViewFrame = tableViewChat.frame;
            tableViewFrame.size.height = keyboardFrameInView.origin.y - 100;
        tableViewChat.frame = CGRectMake(0, 66, screenWidth, screenHeight-51-66);
//            tableViewChat.frame = CGRectMake(0, 0, screenWidth, screenHeight-40
//                                             );
        }];
    
    // Set Line below status bar
    toolbarLine = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-49-lineSize, screenWidth, lineSize)];
    toolbarLine.backgroundColor = Rgb2UIColor(0, 0, 0);
    [self.view addSubview:toolbarLine];
    
    // Toolbar
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    // Booking
    NSString *imageValue = @"bookingtoolbar.png";
    UIImage *bookingImage = [UIImage imageNamed:imageValue];
    UIButton *bookingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bookingButton.bounds = CGRectMake(0, 0, screenWidth / 6, 49);
    [bookingButton setImage:bookingImage forState:UIControlStateNormal];
    UIBarButtonItem *bookingItem = [[UIBarButtonItem alloc] initWithCustomView:bookingButton];
    [bookingButton addTarget:self
                      action:@selector(loadBooking)
            forControlEvents:UIControlEventTouchUpInside];
    
    [items addObject:bookingItem];
    
    // Currency Converter
    imageValue = @"currencytoolbar.png";
    UIImage *currencyImage = [UIImage imageNamed:imageValue];
    UIButton *currencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    currencyButton.bounds = CGRectMake(0, 0, screenWidth / 6, 49);
    [currencyButton setImage:currencyImage forState:UIControlStateNormal];
    UIBarButtonItem *currencyItem = [[UIBarButtonItem alloc] initWithCustomView:currencyButton];
    [currencyButton addTarget:self
                       action:@selector(loadCurrency)
             forControlEvents:UIControlEventTouchUpInside];
    
    [items addObject:currencyItem];
    
    // Tool Tip
    imageValue = @"traveltipstoolbar.png";
    
    UIImage *infoImage = [UIImage imageNamed:imageValue];
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    infoButton.bounds = CGRectMake(0, 0, screenWidth / 6, 49);
    [infoButton setImage:infoImage forState:UIControlStateNormal];
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    [infoButton addTarget:self
                   action:@selector(loadInfo)
         forControlEvents:UIControlEventTouchUpInside];
    
    [items addObject:infoItem];
    
    // Map
    imageValue = @"maptoolbar.png";
    
    UIImage *mapImage = [UIImage imageNamed:imageValue];
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.bounds = CGRectMake(0, 0, screenWidth / 6, 49);
    [mapButton setImage:mapImage forState:UIControlStateNormal];
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithCustomView:mapButton];
    [mapButton addTarget:self
                  action:@selector(loadMap)
        forControlEvents:UIControlEventTouchUpInside];
    
    [items addObject:mapItem];
    
    // Home
    imageValue = @"hometoolbar.png";

    UIImage *imageHome = [UIImage imageNamed:imageValue];
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.bounds = CGRectMake(0, 0, screenWidth / 6, 49);
    [homeButton setImage:imageHome forState:UIControlStateNormal];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    [homeButton addTarget:self
                   action:@selector(backToHome)
         forControlEvents:UIControlEventTouchUpInside];
    homeButton.alpha = 0.4;
    
    [items addObject:homeItem];
    
    // this will need to be an instance variable to be able to hide on command
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, screenHeight-49, screenWidth, 49);
    [toolbar setItems:items animated:NO];
    toolbar.barTintColor = Rgb2UIColor(236, 240, 241);
    [self.view addSubview:toolbar];
    
    //SWReveal Slider
    SWRevealViewController *revealController = [self revealViewController];
    
    // Add an image to your project & set that image here.
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"login.png"]
                                                                              style:UIBarButtonItemStyleBordered target:self action:@selector(btnLogin:)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnAddPhotoClick) name:@"SENDPHOTO" object:nil];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_imageView setClipsToBounds:YES];
    _imageView.userInteractionEnabled = YES;
    _imageView.hidden = YES;
    _imageView.image = [UIImage imageNamed:@"image.png"];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgToFullScreen:)];
    tapper.numberOfTapsRequired = 1;
    
    [_imageView addGestureRecognizer:tapper];
    
    [self.view addSubview:_imageView];
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
        if (user > 0 ) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

            NSString *strUrl=[NSString stringWithFormat:@"%@getNB.php?userID=%@&senderID=%@&key=5a14ec5b310164f2dfe49e86b06124a",[[Singleton sharedSingleton]getBaseURL],user,self.senderID];
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
    
    if (loginSuccess == 1){
        self.inputToolbar = [[BHInputToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-kDefaultToolbarHeight, self.view.frame.size.width, kDefaultToolbarHeight)];
        [self.view addSubview:self.inputToolbar];
        inputToolbar.inputDelegate = self;
        inputToolbar.textView.placeholder = @"Enter Message";
        inputToolbar.textView.text = @"";
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 5001) {
        if (buttonIndex == 0) {
            NSDictionary *tempObj = [self.chatArray objectAtIndex:rowIn];
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
                NSString *strUrl=[NSString stringWithFormat:@"%@report.php?msgID=%@&userID=%@&key=5a14ec5b310164f2dfe49e86b06124a",[[Singleton sharedSingleton]getBaseURL],[tempObj valueForKey:@"msgID"],user];
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
    if (alertView.tag == 11)
    {
        // Need to set the login status
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        NSString *passwordEntered = alertTextField.text;

        // Compare the entered value to the password pin
        NSInteger entry = [passwordEntered integerValue];
        if(entry == 666666){
            loginSuccess = 1;

            // Show the available toolbar for entering details here
            // This will need to be conditional - when the user logs in
            self.inputToolbar = [[BHInputToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-kDefaultToolbarHeight, self.view.frame.size.width, kDefaultToolbarHeight)];
            [self.view addSubview:self.inputToolbar];
            inputToolbar.inputDelegate = self;
            inputToolbar.textView.placeholder = @"Enter Message";
            inputToolbar.textView.text = @"";

            toolbar.hidden = YES;

            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            toolbarLine.frame = CGRectMake(0, screenHeight-42, screenWidth, 2);

//            tableViewChat.frame = CGRectMake(0, 66, screenWidth, screenHeight-66-42);
            tableViewChat.frame = CGRectMake(0, 66, screenWidth, screenHeight-66-51);

        } else {
            NSInteger cancelIndex = [alertView cancelButtonIndex];
            if (buttonIndex != 1)
            {
                [self.view makeToast:@"Incorrect password entered, please try again."];
            }
        }
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)UserrequestFail:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

//Get ChatMessages
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
        NSString *strUrl=[NSString stringWithFormat:@"%@getNB.php?userID=%@&senderID=%@&key=5a14ec5b310164f2dfe49e86b06124a",[[Singleton sharedSingleton]getBaseURL],user,self.senderID];
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
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0;  i<[tempArray count]; i++) {
        NSDictionary *dict = [tempArray objectAtIndex:i];
        dict = nil;
    }
    [self.chatArray removeAllObjects];
    @try {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        
        
        
        if ([[dict valueForKey:@"data"] isEqualToString:@"success"]) {
            NSArray *items = [dict valueForKey:@"msg_data"];
            for (NSMutableDictionary *d in items) {
                NSMutableDictionary *copy = [d mutableCopy];

                // Setup an actual image array
                if([[d valueForKey:@"type"] isEqualToString:@"Image"]){
                    NSURL *url = [NSURL URLWithString:[d valueForKey:@"image"]];
                    NSData *data = [[NSData alloc]initWithContentsOfURL:url];
                    UIImage *image = [[UIImage alloc]initWithData:data];
                    [copy setObject:image forKey:@"image"];
                }
                NSLog(@"Added Message");
                [tempArray addObject:copy];
                NSString *Test = @"";
            }
        }
        
        self.chatArray = [[tempArray reverseObjectEnumerator] allObjects];
    }
    @catch (NSException *exception) {
    }
    [tableViewChat reloadData];
    NSInteger rowNumbers = [tableViewChat numberOfRowsInSection:0];
    if (rowNumbers >0) {
        [tableViewChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumbers-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)requestFail:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

////Table Start////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tableViewChat) {
        return self.chatArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    NSLog(@"Row: %d", indexPath.row);
    @try {
        if (tableView == tableViewChat) {
            NSDictionary *tempObj = [self.chatArray objectAtIndex:indexPath.row];
            
            if ([[tempObj valueForKey:@"type"] isEqualToString:@"Message"])
            {
                    static NSString *temp= @"NoticeboardCustomCell";
                    NoticeboardCustomCell *cellheader = (NoticeboardCustomCell *)[tableViewChat dequeueReusableCellWithIdentifier:temp];
                    if (cellheader == nil) {
                        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"NoticeboardCustomCell" owner:self options:nil];
                        cellheader = [nib objectAtIndex:0];
                        cellheader.showsReorderControl = NO;
                        cellheader.selectionStyle = UITableViewCellSelectionStyleNone;
                        cellheader.backgroundColor=[UIColor clearColor];
                        [cellheader.btnReport addTarget:self action:@selector(btnReportClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    cellheader.lblBG.layer.cornerRadius = 3.0;
                    cellheader.lblBG.layer.masksToBounds = YES;

                    cellheader.lblMessage.text = [tempObj valueForKey:@"message"];
                    cellheader.lblTime.text = [[tempObj valueForKey:@"time"] stringByReplacingOccurrencesOfString:@" ago" withString:@""];
                    return cellheader;
            }
            else{
                if ([[tempObj valueForKey:@"type"] isEqualToString:@"Image"]){
                    static NSString *temp= @"PhotoNoticeboardCustomCell";
                
                    PhotoNoticeboardCustomCell *cellheader = (PhotoNoticeboardCustomCell *)[tableViewChat dequeueReusableCellWithIdentifier:temp];
                    if (cellheader == nil) {
                        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoNoticeboardCustomCell" owner:self options:nil];
                        cellheader = [nib objectAtIndex:0];
                        cellheader.showsReorderControl = NO;
                        cellheader.selectionStyle = UITableViewCellSelectionStyleNone;
                        cellheader.backgroundColor=[UIColor clearColor];
                    }
                
                    
                    cellheader.lblBG.layer.cornerRadius = 3.0;
                    cellheader.lblBG.layer.masksToBounds = YES;
                
                    
                    NSLog(@"Sizes when drawing cell: height: %d, width: %d", cellHeight, globalcellWidth);
                    cellheader.photo.frame = CGRectMake(10, 5, globalcellWidth, cellHeight);
                    cellheader.photo.layer.masksToBounds = YES;
                    cellheader.photo.image = [tempObj valueForKey:@"image"];
                    cellheader.lblTime.backgroundColor = [UIColor whiteColor];
                    cellheader.lblTime.layer.masksToBounds = YES;
                    cellheader.lblTime.text = [[tempObj valueForKey:@"time"] stringByReplacingOccurrencesOfString:@" ago" withString:@""];
                
                    cellheader.clipsToBounds = YES;
                    return cellheader;

                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableViewChat) {
        NSDictionary *tempObj = [self.chatArray objectAtIndex:indexPath.row];
        if ([[tempObj valueForKey:@"type"] isEqualToString:@"Message"])
        {
            return 80;
        }
        else {
            NSDictionary *tempObj = [self.chatArray objectAtIndex:indexPath.row];
            
            UIImage *image = [tempObj valueForKey:@"image"];
            CGFloat height = image.size.height;
            CGFloat width = image.size.width;
            
            CGFloat maxWidth = screenWidth - 50;
            CGFloat maxHeight = screenHeight - 120;
            
            CGFloat ratio = 0;
            if (height > maxHeight){
                // need to make smaller
                ratio = maxHeight / height;
                height = maxHeight;
                width = width * ratio;
            }

            if (width > maxWidth){
                ratio = maxWidth / width;
                width = maxWidth;
                height = height * ratio;
            }
            globalcellWidth = screenWidth - 50;
            cellHeight = height;
            return cellHeight + 30;
        }
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableViewChat) {
        NSDictionary *tempObj = [self.chatArray objectAtIndex:indexPath.row];
        if ([[tempObj valueForKey:@"type"] isEqualToString:@"Image"])
        {
            UIImage *imageDisplay = [tempObj valueForKey:@"image"];

            // Max Height
            NSInteger maxHeight = screenHeight-150;
            NSInteger maxWidth = screenWidth-40;
            
            // Set the default image size best for the screen
            CGFloat height = imageDisplay.size.height;
            CGFloat width = imageDisplay.size.width;

            CGFloat ratio = 0;
            if (height > maxHeight){
                // need to make smaller
                ratio = maxHeight / height;
                height = maxHeight;
                width = width * ratio;
            }
            
            if (width > maxWidth){
                ratio = maxWidth / width;
                width = maxWidth;
                height = height * ratio;
            }
            
            UIScrollView *svImage = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 106, width, height)];
            
            // determine the size of the image
            // set content view to actual size of image
            svImage.contentSize = CGSizeMake(width, height);
            image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            
            image.image = imageDisplay;
            [svImage addSubview:image];
            // For supporting zoom,
            svImage.minimumZoomScale = 0.5;
            svImage.maximumZoomScale = 3.0;
            svImage.delegate = self;
            
            zoomPopup *popup = [[zoomPopup alloc] initWithMainview:self.view andStartRect:tableViewChat.frame];
            [popup setBlurRadius:10];
            [popup showPopup:svImage];
        }
    }
}

// Implement a single scroll view delegate method
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    return image;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    /* Move the toolbar to above the keyboard */
//    tableViewChat.frame = CGRectMake(0, 66, screenWidth, screenHeight-66-42);
    tableViewChat.frame = CGRectMake(0, 66, screenWidth, screenHeight-66-51);
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
    tableViewChat.frame = CGRectMake(0, 66, screenWidth, screenHeight-66-51);
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
        NSString *strUrl=[NSString stringWithFormat:@"%@sendNB.php",[[Singleton sharedSingleton]getBaseURL]];
        NSURL *url=[NSURL URLWithString:strUrl];
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setPostValue:@"5a14ec5b310164f2dfe49e86b06124a" forKey:@"key"];
        [request setPostValue:inputText forKey:@"msg"];
        [request setPostValue:user forKey:@"userID"];
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self getChatMessagesBack];
    [tableViewChat reloadData];
}


- (void)sendMessageRequestFail:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

//AddPhoto
-(void)btnAddPhotoClick
{
    photoV=1;
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
        NSString *strUrl=[NSString stringWithFormat:@"%@sendNB.php",[[Singleton sharedSingleton]getBaseURL]];
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
        photoV=0;
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)atext
{
    [textView resignFirstResponder];
    return YES;
}

- (void)requestUserFail:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
//
-(IBAction)btnLogin:(id)sender
{
    NSLog(@"Button Press");
    tableViewChat.frame = CGRectMake(0, 66, screenWidth, screenHeight-66-51);
    
    if(loginSuccess != 1 || loginSuccess == nil){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Login Password" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Login",@"Cancel", nil] ;
        alertView.tag = 11;
        alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        
        [alertView show];
    } else {
        [self.view makeToast:@"Already logged in"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Home Action
- (IBAction)backToHome
{
    HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:home animated:YES];
}

@end
