//
//  EatsViewController.m
//
//  Created by Ashley Templeman on 11/12/2015.
//  Copyright © 2015 Keep It Simple Travel. All rights reserved.
//

#import "EatsViewController.h"
#import "MapViewController.h"
#import "PhotoLookup.h"
#import "CurrencyConverter.h"
#import "TravelTipsViewController.h"
#import "SWRevealViewController.h"
#import "LoadWebViewController.h"
#import "HomeViewController.h"

@interface EatsViewController ()
@property (nonatomic, retain) UIPageControl * pageControl;

@end

@implementation EatsViewController

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
    
    dataSource = [DataSource dataSource];
    NSArray *foodArray = [dataSource getAllFoods];
    
    if(fromMap == 1){
        // Need to update the currentIndex somehow
        for (int i = 0; i < [foodArray count]; i++)
        {
            Food *tempFood = foodArray[i];
            if ([mapFood.foodName isEqualToString:tempFood.foodName])
            {
                currentIndex = i;
                break;
            }
        }
    }
    
    // Screen Dimension Setup
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSInteger homeImage = 0;
    NSInteger smWidth = 0;
    NSInteger smHeight = 0;
    
    NSInteger mapButtonHeight = 0;
    NSInteger mapButtonWidth = 0;
    
    // need to determine screenWidth to compare which device is which
    if(screenHeight == 568){
        homeImage = 225.67;
//        imageSelection = @"@1x";
        smWidth = 75.913;//84.348;
        smHeight = 45.241;//50.268;
        lineSize = 2;
        iconHeight = 25.56;
        iconWidth = 23.004;
        mapButtonHeight = 39.984;
        mapButtonWidth = 240;
    } else if (screenHeight == 667){
        homeImage = 265;
//        imageSelection = @"@1x";
        lineSize = 2;
        smWidth = 89.1;
        smHeight = 53.1;
        iconWidth = 27;
        iconHeight = 30;
        mapButtonHeight = 49;
        mapButtonWidth = 294;
    } else if (screenHeight == 736){
        homeImage = 292.41;
//        imageSelection = @"@2x";
        lineSize = 2;
        smWidth = 93.591;//103.991;
        smHeight = 58.608;//65.121;
        iconHeight = 33.112;
        iconWidth = 29.801;
        mapButtonHeight = 54.08;
        mapButtonWidth = 324.50;
    }
    
    // Get Config Values
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString *titleValue = @"EATS";
//    NSString *headingFont = [configurationValues objectForKey:@"HeadingFont"];
//    NSString *bodyFont = [configurationValues objectForKey:@"BodyFont"];
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
    
    // Get the Food
    allFoods = foodArray;
    
    [self setFood:foodArray[currentIndex]];
    
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
    
    // Get Photos
    NSArray *photos = [dataSource getPhotoNames:@"Food" identifier:food.foodName];
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
    
    yPosition = yPosition + lineSize + 2;
    
    UIView *tabbedSection = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, 30)];
    NSArray *itemArray = [NSArray arrayWithObjects: @"About", @"Contact", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(0, 0, screenWidth, 30);
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    [segmentedControl addTarget:self action:@selector(tabSelection:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor blackColor];
    [tabbedSection addSubview:segmentedControl];
    [MainScrollView addSubview:tabbedSection];
    
    yPosition = yPosition + tabbedSection.frame.size.height + 15;
    
    NSInteger viewInitialPosition = yPosition;
    
    aboutPosition = 0;
    contactPosition = 0;

    aboutView = [[UIView alloc] init];
    NSString *foodName = food.foodName;
    foodName = [foodName stringByReplacingOccurrencesOfString:@"'" withString:@""];

    NSMutableParagraphStyle *paragraphStylesHeading = [[NSMutableParagraphStyle alloc] init];
    paragraphStylesHeading.alignment = NSTextAlignmentCenter;      //justified text
    paragraphStylesHeading.firstLineHeadIndent = 1.0;                //must have a value to make it work

    // Display the name
    NSDictionary *attributesHeading = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:foodName attributes: attributesHeading];

    // Name Label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, aboutPosition, screenWidth-80, 30)];
    nameLabel.attributedText = attributedString;
    nameLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
    nameLabel.numberOfLines = 1;
    nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    nameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:fontSize];

    [aboutView addSubview:nameLabel];
    aboutPosition = aboutPosition + nameLabel.frame.size.height + 5;

    // Opening Hours
    if ([food.openingHours length] != 0){
        attributedString = [[NSAttributedString alloc] initWithString:food.openingHours attributes: attributesHeading];
        
        UILabel *openingLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, aboutPosition, screenWidth-80, 30)];
        openingLabel.attributedText = attributedString;
        openingLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        openingLabel.numberOfLines = 1;
        openingLabel.lineBreakMode = NSLineBreakByCharWrapping;
        openingLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:fontSize];

        [aboutView addSubview:openingLabel];

        aboutPosition = aboutPosition + nameLabel.frame.size.height + 15;
    }

    // CREATE DESCRIPTION LABEL
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
    paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        
    NSAttributedString *attributedDescription = [[NSAttributedString alloc] initWithString:food.description attributes: attributes];

    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, aboutPosition, screenWidth-80, 9999)];
    descLabel.numberOfLines = 0;
    descLabel.lineBreakMode = UILineBreakModeWordWrap;
    [descLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:fontSize]];
    descLabel.attributedText = attributedDescription;
    descLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
    [descLabel sizeToFit];
    [aboutView addSubview:descLabel];
        
    aboutPosition = aboutPosition + 8 + descLabel.frame.size.height;
        
    aboutPosition = aboutPosition + 15;
    
    // Show Map Button
    UIButton *showmapButton = [[UIButton alloc] initWithFrame:CGRectMake(40, aboutPosition, screenWidth-80, mapButtonHeight)];
    UIImage *showmapButtonImage = [UIImage imageNamed:@"showmap.png"];
    [showmapButton setImage:showmapButtonImage forState:UIControlStateNormal];
    [showmapButton addTarget:self
                      action:@selector(loadEatMap)
            forControlEvents:UIControlEventTouchUpInside];
    [aboutView addSubview:showmapButton];
    
    aboutPosition = aboutPosition + showmapButton.frame.size.height + 25;

    // Social Media buttons
    UIButton *fbButton = [[UIButton alloc] initWithFrame:CGRectMake(40, aboutPosition, smWidth, smHeight)];
    UIImage *fbImage = [UIImage imageNamed:@"likeus.png"];
    if ([food.facebookURL length] > 0){
        
    } else {
        fbButton.alpha = 0.4;
        fbButton.enabled = NO;
    }
    
    [fbButton setImage:fbImage forState:UIControlStateNormal];
    [fbButton addTarget:self
                    action:@selector(openFacebook)
                forControlEvents:UIControlEventTouchUpInside];
    [aboutView addSubview:fbButton];
    
    NSInteger xPosition = 40 + smWidth + 15;
       
    UIButton *taButton = [[UIButton alloc] initWithFrame:CGRectMake(xPosition, aboutPosition, smWidth, smHeight)];
    UIImage *taImage = [UIImage imageNamed:@"rateus.png"];
    
    if ([food.taLink length] > 0){
        
    } else {
        taButton.alpha = 0.4;
        taButton.enabled = NO;
    }
    
    [taButton setImage:taImage forState:UIControlStateNormal];
    [taButton addTarget:self
                action:@selector(loadTALink)
                forControlEvents:UIControlEventTouchUpInside];
    [aboutView addSubview:taButton];
        
    xPosition = xPosition + smWidth + 15;
        
    UIButton *instaButton = [[UIButton alloc] initWithFrame:CGRectMake(xPosition, aboutPosition, smWidth, smHeight)];
    UIImage *instaImage = [UIImage imageNamed:@"followus.png"];
    
    if ([food.instaURL length] > 0){
        
    } else {
        instaButton.alpha = 0.4;
        instaButton.enabled = NO;
    }
    
    [instaButton setImage:instaImage forState:UIControlStateNormal];
    [instaButton addTarget:self
            action:@selector(openInstagram)
            forControlEvents:UIControlEventTouchUpInside];
    [aboutView addSubview:instaButton];
    
    aboutPosition = aboutPosition + smHeight + 15;

    CGRect frame = aboutView.frame;
    aboutView.frame = CGRectMake(0, viewInitialPosition, screenWidth, aboutPosition);
    [MainScrollView addSubview:aboutView];

    contactView = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, 300)];
    
    contactView.hidden = YES;
    
    CGRect frame2 = contactView.frame;
    contactView.frame = CGRectMake(0, viewInitialPosition, screenWidth, aboutPosition);
    
    // Set up the Contact View
    // Heading already added for name
    // Name Label
    attributedString = [[NSAttributedString alloc] initWithString:foodName attributes: attributesHeading];
    
    UILabel *contactNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, contactPosition, screenWidth-80, 30)];
    contactNameLabel.attributedText = attributedString;
    contactNameLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
    contactNameLabel.numberOfLines = 1;
    contactNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    contactNameLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:fontSize];
    
    [contactView addSubview:contactNameLabel];
    
    contactPosition = contactPosition + contactNameLabel.frame.size.height + 5;
    
    // Address
    NSInteger noValues = 0;
    
    if ([food.address length] > 0) {
        UIImageView *addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, contactPosition, iconWidth, iconHeight)];
        
        UIImage *iconImage = [UIImage imageNamed:@"addresscontact.png"];
        addressIcon.image = iconImage;
        
        [contactView addSubview:addressIcon];
        
        paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
        attributes = @{NSParagraphStyleAttributeName: paragraphStyles};

        NSAttributedString *attributedAddress = [[NSAttributedString alloc] initWithString:food.address attributes: attributes];
        
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
    
        if(contactNameLabel.frame.size.height > addressIcon.frame.size.height){
            contactPosition = contactPosition + addressLabel.frame.size.height + 25;
        } else {
            contactPosition = contactPosition + addressIcon.frame.size.height + 25;
        }
    }
    
    // Phone
    if ([food.phone length] > 0){
        UIImageView *phoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, contactPosition, iconWidth, iconHeight)];
        
        UIImage *iconImage = [UIImage imageNamed:@"phonecontact.png"];
        phoneIcon.image = iconImage;
        
        [contactView addSubview:phoneIcon];
        
        paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
        attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        
        NSAttributedString *attributedPhone = [[NSAttributedString alloc] initWithString:food.phone attributes: attributes];
        
        NSInteger xStart = 20 + phoneIcon.frame.size.width + 20;
        NSInteger xEnd = screenWidth - xStart - 40;
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(xStart, contactPosition, xEnd, 9999)];
        phoneLabel.numberOfLines = 0;
        phoneLabel.lineBreakMode = UILineBreakModeWordWrap;
        [phoneLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:fontSize]];
        phoneLabel.attributedText = attributedPhone;
        phoneLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        [phoneLabel sizeToFit];
        
        [contactView addSubview:phoneLabel];
        noValues = 1;
        
        if(phoneLabel.frame.size.height > phoneIcon.frame.size.height){
            contactPosition = contactPosition + phoneLabel.frame.size.height + 20;
        } else {
            contactPosition = contactPosition + phoneIcon.frame.size.height + 20;
        }
    }
    
    // Website
    if ([food.website length] > 0){
        UIImageView *webIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, contactPosition, iconWidth, iconHeight)];
        
        UIImage *iconImage = [UIImage imageNamed:@"websitecontact.png"];
        webIcon.image = iconImage;
        
        [contactView addSubview:webIcon];
        
        paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
        attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        
        NSAttributedString *attributedWebsite = [[NSAttributedString alloc] initWithString:food.website attributes: attributes];
        
        NSInteger xStart = 20 + webIcon.frame.size.width + 20;
        NSInteger xEnd = screenWidth - xStart - 40;
        
        UILabel *webLabel = [[UILabel alloc] initWithFrame:CGRectMake(xStart, contactPosition, xEnd, 9999)];
        webLabel.numberOfLines = 0;
        webLabel.lineBreakMode = UILineBreakModeWordWrap;
        [webLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:fontSize]];
        webLabel.attributedText = attributedWebsite;
        webLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        [webLabel sizeToFit];
        
        [contactView addSubview:webLabel];
        noValues = 1;
        
        if(webLabel.frame.size.height > webIcon.frame.size.height){
            contactPosition = contactPosition + webLabel.frame.size.height + 20;
        } else {
            contactPosition = contactPosition + webIcon.frame.size.height + 20;
        }
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
    
    contactPosition = contactPosition + 15;
    
    // Show Map Button
    UIButton *showmapButtonC = [[UIButton alloc] initWithFrame:CGRectMake(40, contactPosition, screenWidth-80, mapButtonHeight)];
    UIImage *showmapButtonImageC = [UIImage imageNamed:@"showmap.png"];
    [showmapButtonC setImage:showmapButtonImage forState:UIControlStateNormal];
    [showmapButtonC addTarget:self
                      action:@selector(loadEatMap)
            forControlEvents:UIControlEventTouchUpInside];
    [contactView addSubview:showmapButtonC];
    
    contactPosition = contactPosition + showmapButtonC.frame.size.height + 25;
    
    [MainScrollView addSubview:contactView];

    MainScrollView.contentSize = CGSizeMake(screenWidth, yPosition+aboutPosition);
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
- (void) setFood:(Food *)value
{
    food = value;
    NSDecimalNumber *longValue = food.longitude;
    NSDecimalNumber *latValue = food.latitude;
}

// Set the current index
- (void) setCurrentIndex:(NSInteger)value
{
    currentIndex = value;
}

// Set whether the load was from the Map
- (void) setFromMap:(NSInteger)value
{
    fromMap = value;
}

// Set the Food object sent by the map
- (void) setFoodFromMap:(Food *)value
{
    mapFood = value;
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
    NSString *webURL = [configurationValues objectForKey:@"BookingURL"];
    
    LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
    [loadWebVC setURL:webURL];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
    [loadWebVC setTitleValue:appTitle];
    
    [self.navigationController pushViewController:loadWebVC animated:YES];
}

// Trip Advisor Action
- (IBAction)loadTALink
{
    NSString *urlToDisplay = food.taLink;
    
    LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
    [loadWebVC setURL:urlToDisplay];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Set from Configuration PList
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
    [loadWebVC setTitleValue:appTitle];
    
    [self.navigationController pushViewController:loadWebVC animated:YES];
}

// Instagram Action
- (IBAction) openInstagram
{
    NSString *urlToDisplay = food.instaURL;
    
    LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
    [loadWebVC setURL:urlToDisplay];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Set from Configuration PList
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
    [loadWebVC setTitleValue:appTitle];
    
    [self.navigationController pushViewController:loadWebVC animated:YES];
}

// Facebook Action
- (IBAction) openFacebook
{
    NSString *urlToDisplay = food.facebookURL;
    
    LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
    [loadWebVC setURL:urlToDisplay];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Set from Configuration PList
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
    [loadWebVC setTitleValue:appTitle];
    
    [self.navigationController pushViewController:loadWebVC animated:YES];
}

- (IBAction)loadEatMap
{
    MapViewController *map = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    
    [map setLatitude:food.latitude];
    [map setLongitude:food.longitude];
    [map setFood:food];
    [self.navigationController pushViewController:map animated:YES];
}

- (IBAction)tabSelection:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        contactView.hidden = YES;
        aboutView.hidden = NO;
    } else if (sender.selectedSegmentIndex == 1){
        contactView.hidden = NO;
        aboutView.hidden = YES;
    }
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

// Travel Tips Action
- (IBAction)loadInfo
{
    TravelTipsViewController *tt = [[TravelTipsViewController alloc] initWithNibName:@"TravelTipsViewController" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:tt animated:YES];
}

@end
