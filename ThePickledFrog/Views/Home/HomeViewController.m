////
////  SquareHomeViewController.m
////
////  Created by Ashley Templeman on 18/06/2016.
////  Copyright © 2016 Keep It Simple Travel. All rights reserved.
////
//
#import "HomeViewController.h"
//#import "SQLiteDatabase.h"
//#import "DataSource.h"
//#import "HostelDetails2ViewController.h"
//#import "ChatViewController.h"
//#import "Reachability.h"
//#import "UIView+Toast.h"
//#import "CurrencyConverter.h"
//#import "PhotoLookup.h"
#import "SWRevealViewController.h"
//#import "LoadWebViewController.h"
//#import "LocalGuide.h"
//#import "TransportListingViewController.h"
//#import "MapViewController.h"
//#import "WhereNextListingViewController.h"
//#import "Noticeboard2.h"
//#import "TravelTipsViewController.h"

@interface HomeViewController ()
//@property (nonatomic, retain) UIPageControl * pageControl;
//
@end

@implementation HomeViewController

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
# pragma mark - View Loading

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // Screen Dimensions Setup
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
//    homeImage = 0;
    NSInteger buttonWidth = 0;
    NSInteger buttonHeight = 0;
//    buttonBorder = 1;
    NSInteger bottomTabBarHeight = 49;
    NSInteger yPosition = 64;
    NSInteger yBorder = 0;
    NSInteger xBorder = 0;

    // Get Config Values
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
//    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    if (screenHeight == 568){
        lineSize = 2;
        buttonWidth = screenWidth/2;
        buttonHeight = ((screenHeight-117)/4);
//        borderX = (width * 0.05);
//        borderY = (width * 0.05);
    } else if (screenHeight == 667){
        lineSize = 2;
        buttonWidth = screenWidth/2;
        buttonHeight = ((screenHeight-117)/4);
    } else if (screenHeight == 736){
        lineSize = 2;
        buttonWidth = screenWidth/2;
        buttonHeight = ((screenHeight-117)/4);
    }
//    NSString *titleValue = [configurationValues objectForKey:@"AppTitle"];
    NSString *titleValue = @"THE PICKLED FROG";
//    NSString *headingFont = [configurationValues objectForKey:@"HeadingFont"];
//    NSString *bodyFont = [configurationValues objectForKey:@"BodyFont"];
//    
    UIFont* titleFont = [UIFont fontWithName:@"Helvetica" size:18];
    CGSize requestedTitleSize = [titleValue sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    CGFloat titleWidth = MIN(screenWidth, requestedTitleSize.width);

    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, 20)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.text = titleValue;
    self.navigationItem.titleView = navLabel;

    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    backgroundView.opaque = YES;
//    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"png"]];
//    backgroundView.backgroundColor = [UIColor colorWithPatternImage:image];
    backgroundView.opaque = NO;
    [self.view addSubview:backgroundView];

    // Set the Line RGB from the configuration file
//    NSString *lineR = [configurationValues objectForKey:@"LineRed"];
//    NSInteger lineRed = [lineR integerValue];
    NSInteger lineRed = 0;
    
//    NSString *lineG = [configurationValues objectForKey:@"LineGreen"];
//    NSInteger lineGreen = [lineG integerValue];
    NSInteger lineGreen = 0;
    
//    NSString *lineB = [configurationValues objectForKey:@"LineBlue"];
//    NSInteger lineBlue = [lineB integerValue];
    NSInteger lineBlue = 0;
    
    // Set Line below status bar
    UIView *statusBarLine = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, lineSize)];
    statusBarLine.backgroundColor = Rgb2UIColor(lineRed, lineGreen, lineBlue);
    [self.view addSubview:statusBarLine];

    yPosition = yPosition + lineSize;
    
    
    // Blocks Button Area
    NSInteger buttonStartX = 0;
    
    UIImageView *logoView = [[UIView alloc] initWithFrame:CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight)];
    logoView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:logoView];
    
    UIImageView *aboutView = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth, yPosition, buttonWidth, buttonHeight)];
    aboutView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:aboutView];
    
    yPosition = yPosition + buttonHeight;
    
    UIImageView *seeView = [[UIView alloc] initWithFrame:CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight)];
    seeView.backgroundColor = [UIColor redColor];
    [self.view addSubview:seeView];
    
    UIImageView *partyView = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth, yPosition, buttonWidth, buttonHeight)];
    partyView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:partyView];
    
    yPosition = yPosition + buttonHeight;
    
    UIImageView *transportView = [[UIView alloc] initWithFrame:CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight)];
    transportView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:transportView];
    
    UIImageView *eatView = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth, yPosition, buttonWidth, buttonHeight)];
    eatView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:eatView];
    
    yPosition = yPosition + buttonHeight;
    
    UIImageView *nextView = [[UIView alloc] initWithFrame:CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight)];
    nextView.backgroundColor = [UIColor redColor];
    [self.view addSubview:nextView];
    
    NSString *value = @"noticeboard.png";
    UIButton *noticeboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [noticeboardButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
            [noticeboardButton addTarget:self
                             action:@selector(loadNoticeboard)
                   forControlEvents:UIControlEventTouchUpInside];
    noticeboardButton.frame = CGRectMake(buttonWidth, yPosition, buttonWidth, buttonHeight);
    [self.view addSubview:noticeboardButton];
    
    
    
    
    
    
//    UIButton *hostelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [hostelButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
//        [hostelButton addTarget:self
//                         action:@selector(loadHostel)
//               forControlEvents:UIControlEventTouchUpInside];
//    NSString *value = @"hostel.png";
    
//    // ADD THE HOSTEL BUTTON
//    NSInteger buttonStartX = horizontalSpacing;
//    yPosition = yPosition + verticalSpacing;
//    
//    NSString *value = @"hostel.png";
//
//    UIButton *hostelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [hostelButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
//    [hostelButton addTarget:self
//                     action:@selector(loadHostel)
//           forControlEvents:UIControlEventTouchUpInside];
//    
//    hostelButton.frame = CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight);
//    [self.view addSubview:hostelButton];
//
//    buttonStartX = buttonStartX + buttonWidth + horizontalSpacing;
//    
//    // Local Guide
//    value = @"localGuide.png";
//    
//    UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [guideButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
//    [guideButton addTarget:self
//                     action:@selector(loadGuide)
//           forControlEvents:UIControlEventTouchUpInside];
//    
//    guideButton.frame = CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight);
//    [self.view addSubview:guideButton];
//    
//    // Transport
//    buttonStartX = horizontalSpacing;
//    yPosition = yPosition + buttonHeight + verticalSpacing;
//    
//    value = @"transport.png";
//    
//    UIButton *transportButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [transportButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
//    [transportButton addTarget:self
//                    action:@selector(loadTransport)
//          forControlEvents:UIControlEventTouchUpInside];
//    
//    transportButton.frame = CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight);
//    [self.view addSubview:transportButton];
//    
//    // Where Next
//    buttonStartX = buttonStartX + buttonWidth + horizontalSpacing;
//    
//    value = @"whereNext.png";
//    
//    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [nextButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
//        [nextButton addTarget:self
//                            action:@selector(loadNext)
//                  forControlEvents:UIControlEventTouchUpInside];
//    
//    nextButton.frame = CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight);
//    [self.view addSubview:nextButton];
//
//    // Noticeboard
//    buttonStartX = horizontalSpacing;
//    yPosition = yPosition + buttonHeight + verticalSpacing;
//    
//    value = @"noticeboardlong.png";
//    
//    UIButton *noticeboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [noticeboardButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
//    [noticeboardButton addTarget:self
//                            action:@selector(loadNoticeboard)
//                  forControlEvents:UIControlEventTouchUpInside];
//    
//    noticeboardButton.frame = CGRectMake(buttonStartX, yPosition, (buttonWidth*2)+horizontalSpacing, buttonHeight);
////    noticeboardButton.frame = CGRectMake(buttonStartX+(buttonWidth/2), yPosition, buttonWidth, buttonHeight);
//    [self.view addSubview:noticeboardButton];
//    
////    // Noticeboard
////    buttonStartX = buttonStartX + buttonWidth + horizontalSpacing;
////    
////    value = @"noticeboard.png";
////    range = [value rangeOfString:@"."];
////    if (range.location != NSNotFound)
////    {
////        NSArray *myArray = [value componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
////        value = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
////    }
////    
////    UIButton *noticeboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
////    [noticeboardButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
////    [noticeboardButton addTarget:self
////                        action:@selector(loadNoticeboard)
////              forControlEvents:UIControlEventTouchUpInside];
////    
////    noticeboardButton.frame = CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight);
////    [self.view addSubview:noticeboardButton];
//    
////    // Chat
////    buttonStartX = horizontalSpacing;
////    yPosition = yPosition + buttonHeight + verticalSpacing;
////    
////    value = @"chat.png";
////    range = [value rangeOfString:@"."];
////    if (range.location != NSNotFound)
////    {
////        NSArray *myArray = [value componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
////        value = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
////    }
////    
////    UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
////    [chatButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
////    [chatButton addTarget:self
////                        action:@selector(loadChat)
////              forControlEvents:UIControlEventTouchUpInside];
////    
////    chatButton.frame = CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight);
////    [self.view addSubview:chatButton];
//
////    // Where Next
////    buttonStartX = buttonStartX + buttonWidth + horizontalSpacing;
////    
////    value = @"whereNext.png";
////    range = [value rangeOfString:@"."];
////    if (range.location != NSNotFound)
////    {
////        NSArray *myArray = [value componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
////        value = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
////    }
////    
////    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
////    [nextButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
////    [nextButton addTarget:self
////                   action:@selector(loadNext)
////         forControlEvents:UIControlEventTouchUpInside];
////    
////    nextButton.frame = CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight);
////    [self.view addSubview:nextButton];
////    
////    yPosition = yPosition + buttonHeight + verticalSpacing;
    
    // Set Line below status bar
    UIView *toolbarLine = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-51, screenWidth, lineSize)];
    toolbarLine.backgroundColor = Rgb2UIColor(lineRed, lineGreen, lineBlue);
    [self.view addSubview:toolbarLine];

    // Toolbar
    NSMutableArray *items = [[NSMutableArray alloc] init];

    
    // Booking
    NSString *imageValue = @"bookingtoolbar.png";
//    range = [imageValue rangeOfString:@"."];
//    if (range.location != NSNotFound)
//    {
//        NSArray *myArray = [imageValue componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
//        imageValue = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
//    }
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
//    range = [imageValue rangeOfString:@"."];
//    if (range.location != NSNotFound)
//    {
//        NSArray *myArray = [imageValue componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
//        imageValue = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
//    }
    
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
//    range = [imageValue rangeOfString:@"."];
//    if (range.location != NSNotFound)
//    {
//        NSArray *myArray = [imageValue componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
//        imageValue = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
//    }

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
//    range = [imageValue rangeOfString:@"."];
//    if (range.location != NSNotFound)
//    {
//        NSArray *myArray = [imageValue componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
//        imageValue = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
//    }
    
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
//    range = [imageValue rangeOfString:@"."];
//    if (range.location != NSNotFound)
//    {
//        NSArray *myArray = [imageValue componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
//        imageValue = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
//    }
    UIImage *imageHome = [UIImage imageNamed:imageValue];
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.bounds = CGRectMake(0, 0, screenWidth / 6, 49);
    [homeButton setImage:imageHome forState:UIControlStateNormal];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    [homeButton addTarget:self
                      action:@selector(loadHome)
            forControlEvents:UIControlEventTouchUpInside];
    homeButton.enabled = NO;
    homeButton.alpha = 0.4;

    [items addObject:homeItem];

    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, screenHeight-49, screenWidth, 49);
    [toolbar setItems:items animated:NO];
    toolbar.barTintColor = Rgb2UIColor(236, 240, 241);
    [self.view addSubview:toolbar];
    
    //SWReveal Slider
    SWRevealViewController *revealController = [self revealViewController];

    // Add an image to your project & set that image here.
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
            style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
}

//// View Will Apear
//- (void) viewWillAppear:(BOOL)animated
//{
////    [[self navigationController] setNavigationBarHidden:YES animated:YES];
//}

//#pragma mark - Navigation Methods
//
//// Booking Action
//- (IBAction)loadBooking
//{
//    // Get Config Values
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
//    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
//    NSString *webURL = [configurationValues objectForKey:@"BookingURL"];
//    
//    LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
//    [loadWebVC setURL:webURL];
//    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
//    [loadWebVC setTitleValue:appTitle];
//    
//    [self.navigationController pushViewController:loadWebVC animated:YES];
//}
//
//// Chat Action
//- (IBAction)loadChat
//{
//    // Check to see what the users connection is
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    [reachability startNotifier];
//    
//    NetworkStatus status = [reachability currentReachabilityStatus];
//    
//    if(status == NotReachable)
//    {
//        //No internet
//        [self.view makeToast:@"No connection to the Internet was found. Please connect using WiFi or Mobile Data."];
//    }
//    else if (status == ReachableViaWiFi)
//    {
//        // WiFi connection exists - so continue
//        ChatViewController *chat = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//        [self.navigationController pushViewController:chat animated:YES];
//    }
//    else if (status == ReachableViaWWAN)
//    {
//        // Internet - ask the question to the user
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection" message:@"Would you like to connect to chat using your mobile data?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//        
//        [alert show];
//    }
//}
//
//- (IBAction)loadNoticeboard
//{
//    Noticeboard2 *chat = [[Noticeboard2 alloc] initWithNibName:@"Noticeboard2" bundle:nil];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chat];
//    
//    [self.navigationController pushViewController:chat animated:YES];
//}
//
//// Hostel Action
//- (IBAction)loadHostel
//{
//    HostelDetails2ViewController *hostelVC = [[HostelDetails2ViewController alloc] initWithNibName:@"HostelDetails2ViewController" bundle:nil];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    [self.navigationController pushViewController:hostelVC animated:YES];
//}
//
//// Local Guide Action
//- (IBAction)loadGuide
//{
//    LocalGuide *guideVC = [[LocalGuide alloc] initWithNibName:@"LocalGuide" bundle:nil];
//    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    [self.navigationController pushViewController:guideVC animated:YES];
//}
//
//// Eats Action
//- (IBAction)loadEats
//{
////    EatListingViewController *eats = [[EatListingViewController alloc] initWithNibName:@"EatListingViewController" bundle:nil];
////    [eats setTitle:@"Eats"];
////    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
////    
////    [self.navigationController pushViewController:eats animated:YES];
//}
//
//- (IBAction)loadNext
//{
//    WhereNextListingViewController *nextVC = [[WhereNextListingViewController alloc] initWithNibName:@"WhereNextListingViewController" bundle:nil];
//
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    [self.navigationController pushViewController:nextVC animated:YES];
//}
//
//// Map Action
//- (IBAction)loadMap
//{
//    dataSource = [DataSource dataSource];
//    Detail *details = [dataSource getHostelDetails];
//    MapViewController *map = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
//    [map setLatitude:details.latitude];
//    [map setLongitude:details.longitude];
//    [map setDetails:details];
//    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    [self.navigationController pushViewController:map animated:YES];
//}
//
//// Transport Action
//- (IBAction)loadTransport
//{
//    TransportListingViewController *tranListing = [[TransportListingViewController alloc] initWithNibName:@"TransportListingViewController" bundle:nil];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStylePlain target:nil action:nil];
//
//    [self.navigationController pushViewController:tranListing animated:YES];
//}
//
//// Currency Action
//- (IBAction)loadCurrency
//{
//    CurrencyConverter *cc = [[CurrencyConverter alloc] initWithNibName:@"CurrencyConverter" bundle:nil];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationController pushViewController:cc animated:YES];
//}
//
//// Home Action
//- (IBAction)loadHome
//{
//    // No action required on this screen as the button
//}
//
//// Travel Tips Action
//- (IBAction)loadInfo
//{
//    TravelTipsViewController *tt = [[TravelTipsViewController alloc] initWithNibName:@"TravelTipsViewController" bundle:nil];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationController pushViewController:tt animated:YES];
//}
//
//# pragma Scroll View
//
//// Scroll View End Scroll - Set Page
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (scrollView == ImageScrollView){
//        CGFloat width = scrollView.frame.size.width;
//        NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
//        
//        self.pageControl.currentPage = page;
//    }
//}

@end
