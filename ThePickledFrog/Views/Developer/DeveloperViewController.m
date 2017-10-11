//
//  DeveloperViewController.m
//
//  Created by Ashley Templeman on 10/05/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import "DeveloperViewController.h"
#import "CurrencyConverter.h"
#import "SWRevealViewController.h"
#import "LoadWebViewController.h"
#import "MapViewController.h"
#import "Detail.h"
#import "KILabel.h"
#import <QuartzCore/QuartzCore.h>
#import "TravelTipsViewController.h"
#import "HomeViewController.h"

@interface DeveloperViewController ()
@property (nonatomic, retain) UIPageControl * pageControl;

@end

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation DeveloperViewController

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
    
    // Set the device dimensions
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSInteger homeImage = 0;
    
    // Get Config Values
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
	// Set the font settings
//    NSString *headingFont = [configurationValues objectForKey:@"HeadingFont"];
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
	
    NSString *titleValue = @"DEVELOPER";
    UIFont* titleFont = [UIFont fontWithName:@"OpenSans-CondensedBold" size:24];
    CGSize requestedTitleSize = [titleValue sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    CGFloat titleWidth = MIN(screenWidth, requestedTitleSize.width);
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, 20)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:24];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.text = titleValue;
    self.navigationItem.titleView = navLabel;
    
    if(fromMenu == 1){
        // Set Home Button
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"< Home" style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
        
        anotherButton.tintColor = [UIColor blueColor];
        
        self.navigationItem.leftBarButtonItem = anotherButton;
    }
    
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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, homeImage)];
    
    NSString *name = @"kistheader2.png";
    
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
    paragraphStylesHeading.alignment = NSTextAlignmentCenter;      
    paragraphStylesHeading.firstLineHeadIndent = 1.0;                // must have a value to make it work
    
    NSDictionary *attributesHeading = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"HOSTEL LAB" attributes: attributesHeading];
    
    // Display the name
    attributesHeading = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
    attributedString = [[NSAttributedString alloc] initWithString:@"HOSTEL LAB" attributes: attributesHeading];
        
    // Name Label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 30)];
    nameLabel.attributedText = attributedString;
    nameLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
    nameLabel.numberOfLines = 1;
    nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    nameLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:fontSize];
        
    [ContentScrollView addSubview:nameLabel];
        
    yPosition = yPosition + nameLabel.frame.size.height + 15;
    
    // CREATE DESCRIPTION LABEL
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentJustified;
    paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
       
	NSString *kistDescription1 = @"Hostel Lab is a company combining the world of budget travel and technology together. Our aim is to create a vast network of budget travel information, then connect this information with people interested in budget travel through innovative technology.";
    
    NSAttributedString *attributedDescription = [[NSAttributedString alloc] initWithString:kistDescription1 attributes: attributes];
        
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 9999)];
    descLabel.numberOfLines = 0;
    descLabel.lineBreakMode = UILineBreakModeWordWrap;
    [descLabel setFont:[UIFont fontWithName:bodyFont size:fontSize]];
    descLabel.attributedText = attributedDescription;
    descLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
    [descLabel sizeToFit];
    [ContentScrollView addSubview:descLabel];
        
    yPosition = yPosition + 15 + descLabel.frame.size.height;
	
	// Add in the website code from ContactViewController
    NSString *description2 = @"Here at Hostel Lab we have developed a streamlined mobile application platform which we call the Hostel Lab App Platform. The platform has been specifically designed by our team to cater for backpacker hostels.";
    
    attributedDescription = [[NSAttributedString alloc] initWithString:description2 attributes: attributes];
    
    UILabel *desc2Label = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 9999)];
    desc2Label.numberOfLines = 0;
    desc2Label.lineBreakMode = UILineBreakModeWordWrap;
    [desc2Label setFont:[UIFont fontWithName:bodyFont size:fontSize]];
    desc2Label.attributedText = attributedDescription;
    desc2Label.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
    [desc2Label sizeToFit];
    [ContentScrollView addSubview:desc2Label];
    
    yPosition = yPosition + 15 + desc2Label.frame.size.height;
    
    // Add in the Email code from ContactViewController
    NSString *description3 = @"The team is a group of long term friends that are passionate about budget travel and technology. This passion is why we choose to specialize in hostel mobile app development.";
    
    attributedDescription = [[NSAttributedString alloc] initWithString:description3 attributes: attributes];
    
    UILabel *desc3Label = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 9999)];
    desc3Label.numberOfLines = 0;
    desc3Label.lineBreakMode = UILineBreakModeWordWrap;
    [desc3Label setFont:[UIFont fontWithName:bodyFont size:fontSize]];
    desc3Label.attributedText = attributedDescription;
    desc3Label.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
    [desc3Label sizeToFit];
    [ContentScrollView addSubview:desc3Label];
    
    yPosition = yPosition + 15 + desc3Label.frame.size.height;
    
    NSString *description4 = @"For more information or any questions please email us a Info@keepitsimpletravel.com";
    
    KILabel *descLabel4 = [[KILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 9999)];
    descLabel4.numberOfLines = 0;
    descLabel4.lineBreakMode = UILineBreakModeWordWrap;
    [descLabel4 setFont:[UIFont fontWithName:bodyFont size:fontSize]];
    
    descLabel4.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
    
    descLabel4.textAlignment = NSTextAlignmentJustified;
    descLabel4.text = description4;
    [descLabel4 sizeToFit];
    // Attach a block to be called when the user taps a URL
    descLabel4.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
        NSLog(@"URL tapped %@", string);
        // Load the Email
        // Setting up the email to be sent
        // Email Subject
        NSString *emailTitle = @"";
        // Email Content
        NSString *content = @"";
        NSString *messageBody = content;
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:string];
        
        // Setting up the email to be sent
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    };
    [ContentScrollView addSubview:descLabel4];

    yPosition = yPosition + 15 + descLabel4.frame.size.height;
    
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

// Action of the Mail being Sent
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Travel Tips Action
- (IBAction)loadInfo
{
    TravelTipsViewController *tt = [[TravelTipsViewController alloc] initWithNibName:@"TravelTipsViewController" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:tt animated:YES];
}

- (void) setFromMenu:(NSInteger)value
{
    fromMenu = value;
}

@end
