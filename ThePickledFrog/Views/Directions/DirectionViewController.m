//
//  DirectionViewController.m
//
//  Created by Ashley Templeman on 2/02/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import "DirectionViewController.h"
#import "MapViewController.h"
#import "PhotoLookup.h"
#import "CurrencyConverter.h"
#import "SWRevealViewController.h"
#import "LoadWebViewController.h"
#import "Directions.h"
#import "TravelTipsViewController.h"
#import "SquareHomeViewController.h"

@interface DirectionViewController ()
@property (nonatomic, retain) UIPageControl * pageControl;

@end

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation DirectionViewController

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
    NSArray *directionsArray = [dataSource getAllDirections];
    
    // Set the device dimensions
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSInteger homeImage = 0;
    
    // Get Config Values
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString *headingFont = [configurationValues objectForKey:@"HeadingFont"];
    NSString *bodyFont = [configurationValues objectForKey:@"BodyFont"];
    NSInteger fontSize = [[configurationValues objectForKey:@"TextSize"] integerValue];
    
    if (screenWidth == 320){
        homeImage = 113.316;
        lineSize = 2;
        imageSelection = @"@1x";
    }
    if (screenWidth == 375){
        homeImage = 133;
        lineSize = 2;
        imageSelection = @"@1x";
    } else if (screenWidth == 414){
        homeImage = 146.799;
        imageSelection = @"@2x";
        lineSize = 2;
    }
    NSString *titleValue = @"Directions";
    UIFont* titleFont = [UIFont fontWithName:@"Helvetica" size:18];
    CGSize requestedTitleSize = [titleValue sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    CGFloat titleWidth = MIN(screenWidth, requestedTitleSize.width);
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, 20)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
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
    
    // Add Image Scroll View
//    UIImageView *headerImageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, screenWidth, homeImage)];
//    [headerImageView setImage:[UIImage imageNamed:@"header.jpg"]];
//    [ContentScrollView addSubview:headerImageView];
    
//    NSArray *photos = [dataSource getPhotoNames:@"Home" identifier:@"Home"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, homeImage)];
    
    NSString *name = @"header.jpg";
    
    // Add selector size to force correct photo usage - may not be required
    NSString *value = @"";
//    NSRange range = [name rangeOfString:@"."];
//    if (range.location != NSNotFound)
//    {
//        NSArray *myArray = [name componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
//        value = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
//        name = value;
//    }
    
    [imageView setImage:[UIImage imageNamed:name]];
    
    [ContentScrollView addSubview:imageView];
    
    yPosition = yPosition + homeImage;
    
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
    
    // Get the data to display
    dataSource = [DataSource dataSource];
    NSArray *allDirections = [dataSource getAllDirections];
    
    for (int i = 0; i < [allDirections count]; i++){
        Directions *direction = [allDirections objectAtIndex:i];
        
        // Display the name
        attributesHeading = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
        attributedString = [[NSAttributedString alloc] initWithString:direction.name attributes: attributesHeading];
        
        // Name Label
        UILabel *stationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 30)];
        stationNameLabel.attributedText = attributedString;
        stationNameLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        stationNameLabel.numberOfLines = 1;
        stationNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        stationNameLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:fontSize];
        
        [ContentScrollView addSubview:stationNameLabel];
        
        yPosition = yPosition + stationNameLabel.frame.size.height + 15;
        
        // CREATE DESCRIPTION LABEL
        NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
        NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        
        NSAttributedString *attributedDescription = [[NSAttributedString alloc] initWithString:direction.description attributes: attributes];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 9999)];
        descLabel.numberOfLines = 0;
        descLabel.lineBreakMode = UILineBreakModeWordWrap;
        [descLabel setFont:[UIFont fontWithName:bodyFont size:fontSize]];
        descLabel.attributedText = attributedDescription;
        descLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        [descLabel sizeToFit];
        [ContentScrollView addSubview:descLabel];
        
        yPosition = yPosition + 8 + descLabel.frame.size.height;
        
        // ADD Second Description Column
        NSAttributedString *attributedDescription2 = [[NSAttributedString alloc] initWithString:direction.description2 attributes: attributes];
        UILabel *descLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 9999)];
        descLabel2.numberOfLines = 0;
        descLabel2.lineBreakMode = UILineBreakModeWordWrap;
        [descLabel2 setFont:[UIFont fontWithName:bodyFont size:fontSize]];
        descLabel2.attributedText = attributedDescription2;
        descLabel2.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        [descLabel2 sizeToFit];
        [ContentScrollView addSubview:descLabel2];
        
        yPosition = yPosition + descLabel2.frame.size.height + 8;
        
        if (!(direction.description3 == nil) || ![direction.description3 isEqualToString:@""]){
            // ADD third Description Column
            NSAttributedString *attributedDescription3 = [[NSAttributedString alloc] initWithString:direction.description3 attributes: attributes];
            UILabel *descLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 9999)];
            descLabel3.numberOfLines = 0;
            descLabel3.lineBreakMode = UILineBreakModeWordWrap;
            [descLabel3 setFont:[UIFont fontWithName:bodyFont size:fontSize]];
            descLabel3.attributedText = attributedDescription3;
            descLabel3.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
            [descLabel3 sizeToFit];
            [ContentScrollView addSubview:descLabel3];
            
            yPosition = yPosition + descLabel3.frame.size.height + 8;
        }
        
        if (!(direction.description4 == nil) || ![direction.description4 isEqualToString:@""]){
            // ADD third Description Column
            NSAttributedString *attributedDescription4 = [[NSAttributedString alloc] initWithString:direction.description4 attributes: attributes];
            UILabel *descLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 9999)];
            descLabel4.numberOfLines = 0;
            descLabel4.lineBreakMode = UILineBreakModeWordWrap;
            [descLabel4 setFont:[UIFont fontWithName:bodyFont size:fontSize]];
            descLabel4.attributedText = attributedDescription4;
            descLabel4.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
            [descLabel4 sizeToFit];
            [ContentScrollView addSubview:descLabel4];
            
            yPosition = yPosition + descLabel4.frame.size.height;
        }
        
        yPosition = yPosition + 15;
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
    NSString *imageValue = @"booking.png";
//    range = [imageValue rangeOfString:@"."];
////    if (range.location != NSNotFound)
////    {
////        NSArray *myArray = [imageValue componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
////        imageValue = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
////    }
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
    imageValue = @"currency.png";
//    range = [imageValue rangeOfString:@"."];
////    if (range.location != NSNotFound)
////    {
////        NSArray *myArray = [imageValue componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
////        imageValue = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
////    }
    
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
    imageValue = @"info.png";
//    range = [imageValue rangeOfString:@"."];
////    if (range.location != NSNotFound)
////    {
////        NSArray *myArray = [imageValue componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
////        imageValue = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
////    }
//    
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
    imageValue = @"toolbarMap.png";
////    range = [imageValue rangeOfString:@"."];
////    if (range.location != NSNotFound)
////    {
////        NSArray *myArray = [imageValue componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
////        imageValue = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
////    }
    
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
    imageValue = @"toolbarHome.png";
////    range = [imageValue rangeOfString:@"."];
////    if (range.location != NSNotFound)
////    {
////        NSArray *myArray = [imageValue componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
////        imageValue = [NSString stringWithFormat:@"%@%@.%@", myArray[0], imageSelection, myArray[1]];
////    }
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
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
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
- (void) setDirection:(Directions *)value
{
    direction = value;
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
    SquareHomeViewController *home = [[SquareHomeViewController alloc] initWithNibName:@"SquareHomeViewController" bundle:nil];
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
    NSString *webURL = [configurationValues objectForKey:@"BookingURL"];
    
    LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
    [loadWebVC setURL:webURL];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
    [loadWebVC setTitleValue:appTitle];
    
    [self.navigationController pushViewController:loadWebVC animated:YES];
}

// Feedback Action
- (IBAction)loadFeedback
{
//    FeedbackViewController *feedback = [[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:nil];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStylePlain target:nil action:nil];
//    
//    [self.navigationController pushViewController:feedback animated:YES];
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

@end
