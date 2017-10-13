//
//  TransportViewController.m
//  HostelBlocks
//
//  Created by Ashley Templeman on 8/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import "TransportViewController.h"
#import "MapViewController.h"
#import "PhotoLookup.h"
#import "CurrencyConverter.h"
#import "SWRevealViewController.h"
#import "LoadWebViewController.h"
#import "Directions.h"
#import "KILabel.h"
#import "TravelTipsViewController.h"
#import "HomeViewController.h"

@interface TransportViewController ()
@property (nonatomic, retain) UIPageControl * pageControl;

@end

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation TransportViewController

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
    NSArray *transportArray = [dataSource getAllTransport];
    
    // Set the device dimensions
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSInteger homeImage = 0;
    NSInteger mapButtonHeight = 0;
    NSInteger mapButtonWidth = 0;
    
    // Get Config Values
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
//    NSString *headingFont = [configurationValues objectForKey:@"HeadingFont"];
//    NSString *bodyFont = [configurationValues objectForKey:@"BodyFont"];
    NSInteger fontSize = [[configurationValues objectForKey:@"TextSize"] integerValue];
    
    if (screenWidth == 320){
//        homeImage = 113.316;
        homeImage = 225.67;
        lineSize = 2;
        mapButtonHeight = 39.984;
        mapButtonWidth = 240;
        imageSelection = @"@1x";
    }
    if (screenWidth == 375){
//        homeImage = 133;
        homeImage = 265;
        mapButtonHeight = 49;
        mapButtonWidth = 294;
        lineSize = 2;
        imageSelection = @"@1x";
    } else if (screenWidth == 414){
//        homeImage = 146.799;
        homeImage = 292.41;
        mapButtonHeight = 54.08;
        mapButtonWidth = 324.50;
        imageSelection = @"@2x";
        lineSize = 2;
    }
    NSString *titleValue = @"TRANSPORT";
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
    ContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,yPosition, screenWidth,screenHeight-49-66)];
    ContentScrollView.delegate = self;
    ContentScrollView.scrollEnabled = YES;
    ContentScrollView.userInteractionEnabled=YES;
    
    // Get the data to display
    dataSource = [DataSource dataSource];
//    allTransports = [dataSource getAllTransport];
    
//    Transport *transport = [allTransports objectAtIndex:currentIndex];
    
    // Add Image Scroll View
    ImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, screenWidth, homeImage)];
    ImageScrollView.scrollEnabled = YES;
    ImageScrollView.userInteractionEnabled=YES;
    [ImageScrollView setPagingEnabled:YES];
    [ImageScrollView setAlwaysBounceVertical:NO];
    ImageScrollView.delegate = self;
    
    // Get Photos
    NSArray *photos = [dataSource getPhotoNames:@"Transport" identifier:transport.name];
    int displayValue = 0;
    
    for (int i = 0; i < [photos count]; i++)
    {
        CGFloat xOrigin = i * ImageScrollView.frame.size.width;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, ImageScrollView.frame.size.width, ImageScrollView.frame.size.height)];
        
        PhotoLookup *pl = photos[i];
        NSString *name = pl.photoName;
        [imageView setImage:[UIImage imageNamed:name]];
        [ImageScrollView addSubview:imageView];
    }
    [ContentScrollView addSubview:ImageScrollView];
    
    [ImageScrollView setContentSize:CGSizeMake(ImageScrollView.frame.size.width * [photos count], ImageScrollView.frame.size.height)];
    [ImageScrollView setContentOffset:CGPointMake(screenWidth*displayValue, 0)];
    
    // Set up Page Control
    if ([photos count] > 1)
    {
        self.pageControl = [[UIPageControl alloc] init];
        NSInteger placement = (screenWidth/2-50);
        self.pageControl.frame = CGRectMake(placement, homeImage-30, 100, 20);
        self.pageControl.numberOfPages = [photos count];
        self.pageControl.currentPage = displayValue;
        [MainScrollView addSubview:self.pageControl];
    }
    
    yPosition = yPosition + homeImage - 64-2;

    
    // Small Black Line between Image and Table View
    UIView *imageLine = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, lineSize)];
    imageLine.backgroundColor = Rgb2UIColor(lineRed, lineGreen, lineBlue);
    [ContentScrollView addSubview:imageLine];
    
    yPosition = yPosition + lineSize + 15;
    
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
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Directions" attributes: attributesHeading];
        
    // Display the name
    attributesHeading = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
    attributedString = [[NSAttributedString alloc] initWithString:transport.name attributes: attributesHeading];
        
    // Name Label
    UILabel *stationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 30)];
    stationNameLabel.attributedText = attributedString;
    stationNameLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
    stationNameLabel.numberOfLines = 1;
    stationNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    stationNameLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:fontSize];
        
    [ContentScrollView addSubview:stationNameLabel];
        
    yPosition = yPosition + stationNameLabel.frame.size.height + 15;
        
    // CREATE DESCRIPTION LABEL
    KILabel *descLabel1 = [[KILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 9999)];
    descLabel1.numberOfLines = 0;
    descLabel1.lineBreakMode = UILineBreakModeWordWrap;
    [descLabel1 setFont:[UIFont fontWithName:@"OpenSans-Light" size:fontSize]];
    
    descLabel1.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
    
    descLabel1.textAlignment = NSTextAlignmentJustified;
    descLabel1.text = transport.description;
    [descLabel1 sizeToFit];
    // Attach a block to be called when the user taps a URL
    descLabel1.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
        NSLog(@"URL tapped %@", string);
        // Load the URL using the Web View
        LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
        [loadWebVC setURL:string];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
        [loadWebVC setTitleValue:appTitle];
        
        [self.navigationController pushViewController:loadWebVC animated:YES];
    };
    
    [ContentScrollView addSubview:descLabel1];
    
    yPosition = yPosition + descLabel1.frame.size.height + 15;
    
    // Show Map Button
//    if (!(transport.transportMap != nil) || ![transport.transportMap isEqualToString:@""]){
//        UIButton *showmapButtonC = [[UIButton alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, mapButtonHeight)];
//        UIImage *showmapButtonImage = [UIImage imageNamed:@"showmapbutton.png"];
//        [showmapButtonC setImage:showmapButtonImage forState:UIControlStateNormal];
//        [showmapButtonC addTarget:self
//                       action:@selector(loadTransportMap)
//             forControlEvents:UIControlEventTouchUpInside];
//        [ContentScrollView addSubview:showmapButtonC];
//        
//        mapImage = transport.transportMap;
//    
//        yPosition = yPosition + mapButtonHeight + 25;
//        
//    }
    NSDecimalNumber *test = transport.longitude;
//    NSLog(@"longitude, %d", test);
    
    if(transport.longitude != nil){
        UIButton *showmapButton = [[UIButton alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, mapButtonHeight)];
        UIImage *showmapButtonImage = [UIImage imageNamed:@"showmap.png"];
        [showmapButton setImage:showmapButtonImage forState:UIControlStateNormal];
        [showmapButton addTarget:self
                       action:@selector(loadTransportMap)
             forControlEvents:UIControlEventTouchUpInside];
        [ContentScrollView addSubview:showmapButton];
    
        yPosition = yPosition + showmapButton.frame.size.height + 25;
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

// Setting the Direction object
- (void) setTransport:(Transport *)value
{
    transport = value;
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
    TravelTipsViewController *tt = [[TravelTipsViewController alloc] initWithNibName:@"TravelTipsViewController" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:tt animated:YES];
}

// Load Transport Map
- (IBAction)loadTransportMap
{
//    mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
//    mapImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [mapImageView setClipsToBounds:YES];
//    mapImageView.userInteractionEnabled = YES;
//    mapImageView.image = [UIImage imageNamed:transport.transportMap];
//    
//    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reduceImage)];
//    
//    tap.delegate = self;
//    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reduceImage)];
//    tapper.numberOfTapsRequired = 1;
//    
//    [mapImageView addGestureRecognizer:tapper];
//    
//    mapScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
//    mapScrollView.minimumZoomScale = 1.0;
//    mapScrollView.maximumZoomScale = 6.0;
//    mapScrollView.contentSize = mapImageView.frame.size;
//    mapScrollView.delegate = self;
//    
//    [mapScrollView addSubview:mapImageView];
//    [self.view addSubview:mapScrollView];
//    ContentScrollView.hidden = YES;
    
    MapViewController *map = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    
    [map setLatitude:transport.latitude];
    [map setLongitude:transport.longitude];
    [map setTransport:transport];
    [self.navigationController pushViewController:map animated:YES];
}

- (IBAction)reduceImage
{
    mapScrollView.hidden = YES;
    ContentScrollView.hidden = NO;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return mapImageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
}

// Set whether the load was from the Map
- (void) setFromMap:(NSInteger)value
{
    fromMap = value;
}

// Set the Activity object sent by the map
- (void) setTransportFromMap:(Food *)value
{
    mapTransport = value;
}

@end
