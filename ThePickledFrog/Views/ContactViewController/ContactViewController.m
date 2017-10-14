//
//  ContactViewController.m
//  HostelBlocks
//
//  Created by Ashley Templeman on 9/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import "ContactViewController.h"
#import "MapViewController.h"
#import "HomeViewController.h"
#import "PhotoLookup.h"
#import "CurrencyConverter.h"
#import "TravelTipsViewController.h"
#import "SWRevealViewController.h"
#import "LoadWebViewController.h"
#import "KILabel.h"

@interface ContactViewController ()
@property (nonatomic, retain) UIPageControl * pageControl;

@end

@implementation ContactViewController

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
    [super viewDidLoad];
    
    // Screen Dimension Setup
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSInteger homeImage = 0;
    NSInteger smWidth = 0;
    NSInteger smHeight = 0;
    
    // need to determine screenWidth to compare which device is which
    if(screenHeight == 568){
        homeImage = 225.67;
        lineSize = 2;
        iconHeight = 25.56;
        iconWidth = 25.56;
    } else if (screenHeight == 667){
        homeImage = 265;
        lineSize = 2;
        iconHeight = 30;
        iconWidth = 30;
    } else if (screenHeight == 736){
        homeImage = 292.41;
        lineSize = 2;
        iconHeight = 33.112;
        iconWidth = 33.112;
    }
    
    // Get Config Values
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString *titleValue = [configurationValues objectForKey:@"HostelDetailsTitle"];
//    NSString *headingFont = [configurationValues objectForKey:@"HeadingFont"];
    NSString *bodyFont = [configurationValues objectForKey:@"BodyFont"];
    NSInteger fontSize = [[configurationValues objectForKey:@"TextSize"] integerValue];
    
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
    
    // Set the Text RGB from the configuration file
    NSString *textR = [configurationValues objectForKey:@"TextRed"];
    NSInteger textRed = [textR integerValue];
    
    NSString *textG = [configurationValues objectForKey:@"TextGreen"];
    NSInteger textGreen = [textG integerValue];
    
    NSString *textB = [configurationValues objectForKey:@"TextBlue"];
    NSInteger textBlue = [textB integerValue];
    
    
    // Set Line below status bar
    UIView *statusBarLine = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, lineSize)];
    statusBarLine.backgroundColor = Rgb2UIColor(lineRed, lineGreen, lineBlue);
    [self.view addSubview:statusBarLine];
    
    yPosition = yPosition + lineSize;
    
    // Add scroll view programmatically
    MainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,yPosition, screenWidth, screenHeight-64-49-4)];
    MainScrollView.delegate = self;
    MainScrollView.scrollEnabled = YES;
    MainScrollView.userInteractionEnabled=YES;
    
    // Add Image Scroll View
    ImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, screenWidth, homeImage)];
    ImageScrollView.scrollEnabled = YES;
    ImageScrollView.userInteractionEnabled=YES;
    [ImageScrollView setPagingEnabled:YES];
    [ImageScrollView setAlwaysBounceVertical:NO];
    ImageScrollView.delegate = self;
    
    NSMutableParagraphStyle *paragraphStylesHeading = [[NSMutableParagraphStyle alloc] init];
    paragraphStylesHeading.alignment = NSTextAlignmentCenter;      //justified text
    paragraphStylesHeading.firstLineHeadIndent = 1.0;                //must have a value to make it work
    
    // Display the name
    NSDictionary *attributesHeading = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
    
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
    paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
    
    
    // Get Photos
    dataSource = [DataSource dataSource];
    NSArray *photos = [dataSource getPhotoNames:@"Details" identifier:@"Details"];
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
    [MainScrollView addSubview:ImageScrollView];
    
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
    [MainScrollView addSubview:imageLine];
    
    yPosition = yPosition + lineSize + 15;
    
    contactPosition = 0;
    contactView = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, 300)];
    
    CGRect frame2 = contactView.frame;
    contactView.frame = CGRectMake(0, yPosition, screenWidth, contactPosition);
    
    // Set up the Contact View
    // Heading already added for name
    // Name Label
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:detail.name attributes: attributesHeading];
    
    UILabel *contactNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, contactPosition, screenWidth-80, 30)];
    contactNameLabel.attributedText = attributedString;
    contactNameLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
    contactNameLabel.numberOfLines = 1;
    contactNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    contactNameLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:fontSize];
    
    [contactView addSubview:contactNameLabel];
    
    contactPosition = contactPosition + contactNameLabel.frame.size.height + 15;
    
    // Contact
    contactView = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, 250)];
    // Set up the Contact View
    NSInteger contactPosition = 30; // + contactNameLabel.frame.size.height + 15;
    
    // Address
    NSInteger noValues = 0;
    
    if ([detail.address length] > 0) {
        UIImageView *addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, contactPosition, iconWidth, iconHeight)];
        
        UIImage *iconImage = [UIImage imageNamed:@"addresscontact.png"];
        addressIcon.image = iconImage;
        
        [contactView addSubview:addressIcon];
        
        NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
        attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        
        NSAttributedString *attributedAddress = [[NSAttributedString alloc] initWithString:detail.address attributes: attributes];
        
        NSInteger xStart = 20 + addressIcon.frame.size.width + 20;
        NSInteger xEnd = screenWidth - xStart - 40;
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(xStart, contactPosition, xEnd, 9999)];
        addressLabel.numberOfLines = 0;
        addressLabel.lineBreakMode = UILineBreakModeWordWrap;
        [addressLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:fontSize]];
        addressLabel.attributedText = attributedAddress;
        addressLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        [addressLabel sizeToFit];
        
        [contactView addSubview:addressLabel];
        noValues = 1;
        
        if(addressLabel.frame.size.height > addressIcon.frame.size.height){
            contactPosition = contactPosition + addressLabel.frame.size.height + 35;
        } else {
            contactPosition = contactPosition + addressIcon.frame.size.height + 35;
        }
    }
    
    // Phone
    if ([detail.phone length] > 0){
        UIImageView *phoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, contactPosition, iconWidth, iconHeight)];
        
        UIImage *iconImage = [UIImage imageNamed:@"phonecontact.png"];
        phoneIcon.image = iconImage;
        
        [contactView addSubview:phoneIcon];
        
        paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
        attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        
        NSString *test = [NSString stringWithFormat:@"%@ ", detail.phone];
        NSInteger xStart = 20 + phoneIcon.frame.size.width + 20;
        NSInteger xEnd = screenWidth - xStart - 40;
        
        UIButton *phoneLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [phoneLabel addTarget:self
                       action:@selector(callPhone)
             forControlEvents:UIControlEventTouchUpInside];
        [phoneLabel setTitle:test forState:UIControlStateNormal];
        phoneLabel.frame = CGRectMake(xStart, contactPosition, 150, 25);
        [phoneLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        phoneLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        phoneLabel.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:fontSize];
        [contactView addSubview:phoneLabel];
        noValues = 1;
        
        if(phoneLabel.frame.size.height > phoneIcon.frame.size.height){
            contactPosition = contactPosition + phoneLabel.frame.size.height + 25;
        } else {
            contactPosition = contactPosition + phoneIcon.frame.size.height + 25;
        }
    }
    
    // Website
    if ([detail.website length] > 0){
        UIImageView *webIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, contactPosition, iconWidth, iconHeight)];
        
        UIImage *iconImage = [UIImage imageNamed:@"websitecontact.png"];
        webIcon.image = iconImage;
        
        [contactView addSubview:webIcon];
        
        paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
        attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        
        NSString *test = [NSString stringWithFormat:@"%@   ", detail.website];
        NSAttributedString *attributedWebsite = [[NSAttributedString alloc] initWithString:test attributes: attributes];
        
        NSInteger xStart = 20 + webIcon.frame.size.width + 20;
        NSInteger xEnd = screenWidth - xStart - 40;
        
        KILabel *webLabel = [[KILabel alloc] initWithFrame:CGRectMake(xStart, contactPosition, xEnd, 9999)];
        webLabel.numberOfLines = 0;
        webLabel.lineBreakMode = UILineBreakModeWordWrap;
        [webLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:fontSize]];
        webLabel.attributedText = attributedWebsite;
        webLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        [webLabel sizeToFit];
        
        webLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
            NSLog(@"URL tapped %@", string);
            
            LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
            [loadWebVC setURL:string];
            
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
            
            NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
            [loadWebVC setTitleValue:appTitle];
            
            [self.navigationController pushViewController:loadWebVC animated:YES];
        };
        
        [contactView addSubview:webLabel];
        noValues = 1;
        
        if(webLabel.frame.size.height > webIcon.frame.size.height){
            contactPosition = contactPosition + webLabel.frame.size.height + 25;
        } else {
            contactPosition = contactPosition + webIcon.frame.size.height + 25;
        }
    }
    
    // Email
    if ([detail.email length] > 0){
        UIImageView *emailIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, contactPosition, iconWidth, iconHeight)];
        
        UIImage *iconImage = [UIImage imageNamed:@"emailcontact.png"];
        emailIcon.image = iconImage;
        
        [contactView addSubview:emailIcon];
        
        paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
        attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        
        NSString *test = [NSString stringWithFormat:@"%@ ", detail.email];
        NSAttributedString *attributedEmail = [[NSAttributedString alloc] initWithString:test attributes: attributes];
        
        NSInteger xStart = 20 + emailIcon.frame.size.width + 20;
        NSInteger xEnd = screenWidth - xStart - 40;
        
        KILabel *emailLabel = [[KILabel alloc] initWithFrame:CGRectMake(xStart, contactPosition, xEnd, 9999)];
        emailLabel.numberOfLines = 0;
        emailLabel.lineBreakMode = UILineBreakModeWordWrap;
        [emailLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:fontSize]];
        emailLabel.attributedText = attributedEmail;
        emailLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        [emailLabel sizeToFit];
        
        emailLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
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
        
        [contactView addSubview:emailLabel];
        noValues = 1;
        
        if(emailLabel.frame.size.height > emailIcon.frame.size.height){
            contactPosition = contactPosition + emailLabel.frame.size.height + 25;
        } else {
            contactPosition = contactPosition + emailIcon.frame.size.height + 25;
        }
        
        //        contactPosition = contactPosition + emailLabel.frame.size.height + 5;
    }
    
    if (noValues == 0){
        paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
        attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        
        NSAttributedString *attributedNo = [[NSAttributedString alloc] initWithString:@"No contact details are currently available" attributes: attributes];
        
        
        UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, contactPosition, screenWidth-80, 9999)];
        noLabel.numberOfLines = 0;
        noLabel.lineBreakMode = UILineBreakModeWordWrap;
        [noLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:fontSize]];
        noLabel.attributedText = attributedNo;
        noLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        [noLabel sizeToFit];
        
        [contactView addSubview:noLabel];
        noValues = 1;
        
        contactPosition = contactPosition + noLabel.frame.size.height + 5;
    }
    
//    contactView.hidden = YES;
//    [ContentScrollView addSubview:contactView];
    
    [MainScrollView addSubview:contactView];
    
    MainScrollView.contentSize = CGSizeMake(screenWidth, yPosition+contactPosition);
    [self.view addSubview:MainScrollView];
    
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

# pragma Setting Variables

// Setting Title
- (void) setTitleValue:(NSString *)type
{
    title = type;
}

// Setting Food Object
- (void) setDetail:(Detail *)value
{
    detail = value;
}

// Set the current index
- (void) setCurrentIndex:(NSInteger)value
{
    currentIndex = value;
}

# pragma Phone Setup

// Setting the phone orientation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
}

# pragma Scroll

// Method for actioning the end of the scrolling and to center the page
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == ImageScrollView){
        CGFloat width = scrollView.frame.size.width;
        NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
        
        self.pageControl.currentPage = page;
    }
}

# pragma Actions

// Map Action
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

// Home Action
- (IBAction)backToHome
{
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

-(IBAction)callPhone {
    // TODO PHONE NUMBER OF HOSTEL
    NSString *phoneNumber = [@"tel:" stringByAppendingString:detail.phone];
    //    NSString *phoneNumber = @"tel:(+61)404747178";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

@end
