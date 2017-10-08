//
//  TravelTipsViewController.m
//  HostelBlocks
//
//  Created by Ashley Templeman on 11/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import "TravelTipsViewController.h"
#import "MapViewController.h"
#import "PhotoLookup.h"
#import "CurrencyConverter.h"
#import "SWRevealViewController.h"
#import "LoadWebViewController.h"
#import "Directions.h"
#import "HomeViewController.h"

@interface TravelTipsViewController ()
@property (nonatomic, retain) UIPageControl * pageControl;

@end

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation TravelTipsViewController

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
    [super viewDidLoad];
    
    // Get Directions objects
    dataSource = [DataSource dataSource];
    NSArray *travelTipsArray = [dataSource getTravelTips];
    
    // Set the device dimensions
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSInteger homeImage = 0;
    
    // Get Config Values
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
//    NSString *headingFont = [configurationValues objectForKey:@"HeadingFont"];
//    NSString *bodyFont = [configurationValues objectForKey:@"BodyFont"];
//    NSInteger fontSize = [[configurationValues objectForKey:@"TextSize"] integerValue];
    
    NSInteger buttonWidth = 0;
    NSInteger buttonHeight = 0;
    
    if (screenWidth == 320){
        homeImage = 113.316;
        lineSize = 2;
        buttonWidth = screenWidth/2;
        buttonHeight = ((screenHeight-117)/4);
    }
    if (screenWidth == 375){
        homeImage = 133;
        lineSize = 2;
//        imageSelection = @"@1x";
        buttonWidth = screenWidth/2;
        buttonHeight = ((screenHeight-117)/4);
    } else if (screenWidth == 414){
        homeImage = 146.799;
//        imageSelection = @"@2x";
        lineSize = 2;
        buttonWidth = screenWidth/2;
        buttonHeight = ((screenHeight-117)/4);
    }
    NSString *titleValue = @"TRAVEL TIPS";
    UIFont* titleFont = [UIFont fontWithName:@"OpenSans-CondensedBold" size:24];
    CGSize requestedTitleSize = [titleValue sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    CGFloat titleWidth = MIN(screenWidth, requestedTitleSize.width);
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, 20)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:24];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.text = titleValue;
    self.navigationItem.titleView = navLabel;
    
    NSInteger yPosition = 64;
    
    // Set the Line RGB from the configuration file
    NSString *lineR = [configurationValues objectForKey:@"LineRed"];
    NSInteger lineRed = [lineR integerValue];
    
    NSString *lineG = [configurationValues objectForKey:@"LineGreen"];
    NSInteger lineGreen = [lineG integerValue];
    
    NSString *lineB = [configurationValues objectForKey:@"LineBlue"];
    NSInteger lineBlue = [lineB integerValue];
    
    // Set Line below status bar
    UIView *statusBarLine = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, lineSize)];
    statusBarLine.backgroundColor = Rgb2UIColor(lineRed, lineGreen, lineBlue);
    [self.view addSubview:statusBarLine];
    
    yPosition = yPosition + lineSize;
    
    // Create Scroll View
    ContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, screenWidth,screenHeight-49)];
    ContentScrollView.delegate = self;
    ContentScrollView.scrollEnabled = YES;
    ContentScrollView.userInteractionEnabled=YES;
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, homeImage)];
//    
//    NSString *name = @"header.jpg";
//    
//    // Add selector size to force correct photo usage - may not be required
//    NSString *value = @"";
//    
//    [imageView setImage:[UIImage imageNamed:name]];
//    
//    [ContentScrollView addSubview:imageView];
//    
//    yPosition = yPosition + homeImage;
//    
//    // Small Black Line between Image and Table View
//    UIView *imageLine = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, lineSize)];
//    imageLine.backgroundColor = Rgb2UIColor(lineRed, lineGreen, lineBlue);
//    [ContentScrollView addSubview:imageLine];
//    
//    yPosition = yPosition + lineSize + 15;
    
    NSString *value = @"hostellogo.png";
    UIImage *image = [[UIImage alloc] init];
    image = [UIImage imageNamed:value];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:image];
    logoView.frame = CGRectMake((screenWidth/2)-(buttonWidth/2), yPosition, buttonWidth, buttonHeight);
    [ContentScrollView addSubview:logoView];
    
    yPosition = yPosition + homeImage + 10;
    
    // Set the Text RGB from the configuration file
    NSString *textR = [configurationValues objectForKey:@"TextRed"];
    NSInteger textRed = [textR integerValue];
    
    NSString *textG = [configurationValues objectForKey:@"TextGreen"];
    NSInteger textGreen = [textG integerValue];
    
    NSString *textB = [configurationValues objectForKey:@"TextBlue"];
    NSInteger textBlue = [textB integerValue];
    
    NSMutableParagraphStyle *paragraphStylesHeading = [[NSMutableParagraphStyle alloc] init];
    paragraphStylesHeading.alignment = NSTextAlignmentCenter;      //justified text
    paragraphStylesHeading.firstLineHeadIndent = 1.0;                //must have a value to make it work
    
    NSDictionary *attributesHeading = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Travel Tips" attributes: attributesHeading];
    
    for (int i = 0; i < [travelTipsArray count]; i++){
        TravelTip *tip = [travelTipsArray objectAtIndex:i];
        
        // Display the name
        attributesHeading = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
        attributedString = [[NSAttributedString alloc] initWithString:tip.name attributes: attributesHeading];
        
        // Name Label
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 30)];
        nameLabel.attributedText = attributedString;
        nameLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        nameLabel.numberOfLines = 1;
        nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        nameLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:16];
        
        [ContentScrollView addSubview:nameLabel];
        
        yPosition = yPosition + nameLabel.frame.size.height + 15;
        
        // CREATE DESCRIPTION LABEL
        NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
        NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        
        NSAttributedString *attributedDescription = [[NSAttributedString alloc] initWithString:tip.description attributes: attributes];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 9999)];
        descLabel.numberOfLines = 0;
        descLabel.lineBreakMode = UILineBreakModeWordWrap;
        [descLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:16]];
        descLabel.attributedText = attributedDescription;
        descLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        [descLabel sizeToFit];
        [ContentScrollView addSubview:descLabel];
        
        yPosition = yPosition + 15 + descLabel.frame.size.height;
    }
    
    // Set Content Size for Scroll View
    ContentScrollView.contentSize = CGSizeMake(screenWidth, yPosition);
    [self.view addSubview:ContentScrollView];
    
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
    infoButton.enabled = NO;
    infoButton.alpha = 0.4;
    
    [items addObject:infoItem];
    
    // Map
    imageValue = @"maptoolbar.png";
    UIImage *mapButtonImage = [UIImage imageNamed:imageValue];
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.bounds = CGRectMake(0, 0, screenWidth / 6, 49);
    [mapButton setImage:mapButtonImage
               forState:UIControlStateNormal];
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
    
    [items addObject:homeItem];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, screenHeight-49, screenWidth, 49);
    [toolbar setItems:items animated:NO];
    toolbar.barTintColor = Rgb2UIColor(236, 240, 241);
    [self.view addSubview:toolbar];
    
    //SWReveal Slider
    SWRevealViewController *revealController = [self revealViewController];
    
    //     Add an image to your project & set that image here.
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburgermenu.png"]
                                                                              style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
}

# pragma Scrolling View

// Scroll View - End Scroll
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == ImageScrollView){
        CGFloat width = scrollView.frame.size.width;
        NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
        
        self.pageControl.currentPage = page;
    }
}

# pragma Setting of Objects

// Setting the Title of View
- (void) setTitleValue:(NSString *)type
{
    title = type;
}

// Setting the Selection Index
- (void) setCurrentIndex:(NSInteger)value
{
    currentIndex = value;
}

# pragma Phone Setup

// Setting the Orientation of the phone
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
}

# pragma Button Actions

// Home Action
- (IBAction)backToHome
{
//    [self.navigationController popToRootViewControllerAnimated:NO];
    HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:home animated:YES];
}

// Currency Action
- (IBAction)loadCurrency
{
    CurrencyConverter *cc = [[CurrencyConverter alloc] initWithNibName:@"CurrencyConverter" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:cc animated:YES];
}

// Booking Action
- (IBAction)loadBooking
{
    // Get Config Values
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    dataSource = [DataSource dataSource];
    Detail *details = [dataSource getHostelDetails];
    
    NSString *webURL = details.bookingLink;
    
    LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
    [loadWebVC setURL:webURL];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
    [loadWebVC setTitleValue:appTitle];
    
    [self.navigationController pushViewController:loadWebVC animated:YES];
}

- (IBAction)loadMap
{
    dataSource = [DataSource dataSource];
    Detail *details = [dataSource getHostelDetails];
    MapViewController *map = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    [map setLatitude:details.latitude];
    [map setLongitude:details.longitude];
    [map setDetails:details];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController pushViewController:map animated:YES];
}

// Travel Tips Action
- (IBAction)loadInfo
{
    // Do Nothing
}

@end
