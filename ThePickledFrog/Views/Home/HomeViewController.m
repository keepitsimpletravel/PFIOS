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
    NSInteger borderX = 0;
    NSInteger borderY = 0;
    NSInteger borderMiddleX = 0;
    NSInteger borderMiddleY = 0;

    // Get Config Values
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    if (screenHeight == 568){
        lineSize = 2;
        buttonWidth = screenWidth/2;
        buttonHeight = ((screenHeight-117)/4);
//        borderX = ((screenWidth/2) * 0.05);
//        borderY = ((screenHeight/4) * 0.05);
        borderX = (buttonWidth * 0.05);
        borderY = (buttonHeight * 0.05);
        borderMiddleX = (buttonWidth * 0.03);
        borderMiddleY = (buttonWidth * 0.03);
    } else if (screenHeight == 667){
        lineSize = 2;
        buttonWidth = screenWidth/2;
        buttonHeight = ((screenHeight-117)/4);
        borderX = (buttonWidth * 0.05);
        borderY = (buttonHeight * 0.05);
        borderMiddleX = (buttonWidth * 0.03);
        borderMiddleY = (buttonWidth * 0.03);
    } else if (screenHeight == 736){
        lineSize = 2;
        buttonWidth = screenWidth/2;
        buttonHeight = ((screenHeight-117)/4);
//        borderX = ((screenWidth/2) * 0.05);
//        borderY = ((screenHeight/4) * 0.05);
        borderX = (buttonWidth * 0.05);
        borderY = (buttonHeight * 0.05);
        borderMiddleX = (buttonWidth * 0.03);
        borderMiddleY = (buttonWidth * 0.03);
    }
    NSString *titleValue = [configurationValues objectForKey:@"AppTitle"];
//    NSString *titleValue = @"THE PICKLED FROG";
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
    NSString *lineR = [configurationValues objectForKey:@"LineRed"];
    NSInteger lineRed = [lineR integerValue];
//    NSInteger lineRed = 0;
    
    NSString *lineG = [configurationValues objectForKey:@"LineGreen"];
    NSInteger lineGreen = [lineG integerValue];
//    NSInteger lineGreen = 0;
    
    NSString *lineB = [configurationValues objectForKey:@"LineBlue"];
    NSInteger lineBlue = [lineB integerValue];
//    NSInteger lineBlue = 0;
    
    // Set Line below status bar
    UIView *statusBarLine = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, lineSize)];
    statusBarLine.backgroundColor = Rgb2UIColor(lineRed, lineGreen, lineBlue);
    [self.view addSubview:statusBarLine];

    yPosition = yPosition + lineSize;
    
    
    // Blocks Button Area
    NSInteger buttonStartX = 0;

    NSString *value = @"hostellogo.png";
    UIImage *image = [[UIImage alloc] init];
    image = [UIImage imageNamed:value];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:image];
    logoView.frame = CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight);
    [self.view addSubview:logoView];
    
    value = @"abo1.jpg";
    UIButton *hostelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [hostelButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
            [hostelButton addTarget:self
                             action:@selector(loadHostel)
                   forControlEvents:UIControlEventTouchUpInside];
    hostelButton.frame = CGRectMake(buttonWidth, yPosition, buttonWidth, buttonHeight);
    hostelButton.layer.borderWidth = 3.0f;
    hostelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:hostelButton];
    
    yPosition = yPosition + buttonHeight;
    
    value = @"exp8.jpg";
    UIButton *seeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [seeButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
    [seeButton addTarget:self
                     action:@selector(loadAttractions)
           forControlEvents:UIControlEventTouchUpInside];
    seeButton.frame = CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight);
    seeButton.layer.borderWidth = 3.0f;
    seeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:seeButton];
    
    value = @"par5.jpg";
    UIButton *partyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [partyButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
    [partyButton addTarget:self
                     action:@selector(loadDrinks)
           forControlEvents:UIControlEventTouchUpInside];
    partyButton.frame = CGRectMake(buttonWidth, yPosition, buttonWidth, buttonHeight);
    partyButton.layer.borderWidth = 3.0f;
    partyButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:partyButton];
    
    yPosition = yPosition + buttonHeight;

    value = @"tra3.jpg";
    UIButton *transportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [transportButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
    [transportButton addTarget:self
                  action:@selector(loadTransport)
        forControlEvents:UIControlEventTouchUpInside];
    transportButton.frame = CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight);
    transportButton.layer.borderWidth = 3.0f;
    transportButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:transportButton];
    
    value = @"eat2.jpg";
    UIButton *eatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [eatButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
    [eatButton addTarget:self
                    action:@selector(loadEats)
          forControlEvents:UIControlEventTouchUpInside];
    eatButton.frame = CGRectMake(buttonWidth, yPosition, buttonWidth, buttonHeight);
    eatButton.layer.borderWidth = 3.0f;
    eatButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:eatButton];
    
    yPosition = yPosition + buttonHeight;
    
    value = @"nex3.jpg";
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
    [nextButton addTarget:self
                        action:@selector(loadNext)
              forControlEvents:UIControlEventTouchUpInside];
    nextButton.frame = CGRectMake(buttonStartX, yPosition, buttonWidth, buttonHeight);
    nextButton.layer.borderWidth = 3.0f;
    nextButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:nextButton];
    
    value = @"noticeboard.png";
    UIButton *noticeboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [noticeboardButton setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
            [noticeboardButton addTarget:self
                             action:@selector(loadNoticeboard)
                   forControlEvents:UIControlEventTouchUpInside];
    noticeboardButton.frame = CGRectMake(buttonWidth, yPosition, buttonWidth, buttonHeight);
    [self.view addSubview:noticeboardButton];
    
    // Set Line below status bar
    UIView *toolbarLine = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-51, screenWidth, lineSize)];
    toolbarLine.backgroundColor = Rgb2UIColor(lineRed, lineGreen, lineBlue);
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
// Booking Action
- (IBAction)loadBooking
{
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
}
//
// Chat Action
- (IBAction)loadChat
{
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
}
//
- (IBAction)loadNoticeboard
{
//    Noticeboard2 *chat = [[Noticeboard2 alloc] initWithNibName:@"Noticeboard2" bundle:nil];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chat];
//    
//    [self.navigationController pushViewController:chat animated:YES];
}
//
// Hostel Action
- (IBAction)loadHostel
{
//    HostelDetails2ViewController *hostelVC = [[HostelDetails2ViewController alloc] initWithNibName:@"HostelDetails2ViewController" bundle:nil];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    [self.navigationController pushViewController:hostelVC animated:YES];
}

// Local Guide Action
- (IBAction)loadGuide
{
//    LocalGuide *guideVC = [[LocalGuide alloc] initWithNibName:@"LocalGuide" bundle:nil];
//    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    [self.navigationController pushViewController:guideVC animated:YES];
}
//
// Eats Action
- (IBAction)loadEats
{
//    EatListingViewController *eats = [[EatListingViewController alloc] initWithNibName:@"EatListingViewController" bundle:nil];
////    [eats setTitle:@"Eats"];
////    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
////    
////    [self.navigationController pushViewController:eats animated:YES];
}

- (IBAction)loadNext
{
//    WhereNextListingViewController *nextVC = [[WhereNextListingViewController alloc] initWithNibName:@"WhereNextListingViewController" bundle:nil];
//
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    [self.navigationController pushViewController:nextVC animated:YES];
}

// Map Action
- (IBAction)loadMap
{
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
}

// Transport Action
- (IBAction)loadTransport
{
//    TransportListingViewController *tranListing = [[TransportListingViewController alloc] initWithNibName:@"TransportListingViewController" bundle:nil];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStylePlain target:nil action:nil];
//
//    [self.navigationController pushViewController:tranListing animated:YES];
}

// Currency Action
- (IBAction)loadCurrency
{
//    CurrencyConverter *cc = [[CurrencyConverter alloc] initWithNibName:@"CurrencyConverter" bundle:nil];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationController pushViewController:cc animated:YES];
}

// Home Action
- (IBAction)loadHome
{
    // No action required on this screen as the button
}

// Travel Tips Action
- (IBAction)loadInfo
{
//    TravelTipsViewController *tt = [[TravelTipsViewController alloc] initWithNibName:@"TravelTipsViewController" bundle:nil];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationController pushViewController:tt animated:YES];
}

# pragma Scroll View

// Scroll View End Scroll - Set Page
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if (scrollView == ImageScrollView){
//        CGFloat width = scrollView.frame.size.width;
//        NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
//        
//        self.pageControl.currentPage = page;
//    }
}

@end
