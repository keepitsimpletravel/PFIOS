//
//  HostelDetails2ViewController.m
//
//  Created by Ashley Templeman on 1/03/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import "HostelDetailsViewController.h"
//#import "Detail.h"
#import "PhotoLookup.h"
//#import "RoomViewController.h"
//#import "DirectionViewController.h"
//#import "CurrencyConverter.h"
//#import "TravelTipsViewController.h"
#import "SWRevealViewController.h"
//#import <QuartzCore/QuartzCore.h>
//#import "LoadWebViewController.h"
//#import "ThumbnailLookup.h"
//#import "MapViewController.h"
//#import "ContactViewController.h"
//#import "Square4HomeViewController.h"

@interface HostelDetailsViewController ()
@property (nonatomic, retain) UIPageControl * pageControl;

@end

@implementation HostelDetailsViewController

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

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

    // Set up Screen Dimensions
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    homeImage = 0;
    NSInteger iconSize = 0;
    NSInteger aboutToolbarButtonHeight = 0;
    NSInteger smWidth = 0;
    NSInteger smHeight = 0;
    NSInteger smSpacer = 0;
//    NSInteger contactButtonHeight = 0;
//    NSInteger contactButtonWidth = 0;
    
    // Get Details
    dataSource = [DataSource dataSource];
    detail = [dataSource getHostelDetails];
    
    // Determine how many sections are required
    NSInteger sections = 0;
    if (![detail.facebookURL isEqualToString:@""] || detail.facebookURL == nil) {
        sections++;
    }

    if (![detail.tripAdvisorURL isEqualToString:@""] || detail.tripAdvisorURL == nil) {
        sections++;
    }

    if (![detail.instagramURL isEqualToString:@""] || detail.instagramURL == nil) {
        sections++;
    }

    // Get Config Values
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSInteger fontSize = [[configurationValues objectForKey:@"TextSize"] integerValue];

//    NSInteger bedSpacer;

    if (screenHeight == 568){
        lineSize = 2;
        homeImage = 225.67;

//        bedImageHeight = 100.536;
//        bedImageWidth = 251.34;
//        bedSpacer = 40;
//        
//        imageSelection = @"@1x";
        iconSize = (screenWidth/4) * 0.6;
        aboutToolbarButtonHeight = 51.68;
        smWidth = 91.249;
        smHeight = 60.577;
//        contactButtonHeight = 39.984;
//        contactButtonWidth = 240;
        
        // Need to determine space for buttons
        smSpacer = (screenWidth - (sections * smWidth)) / (sections + 1);
    } else if (screenHeight == 667){
        lineSize = 2;
        homeImage = 265;

//        bedImageHeight = 118;
//        bedImageWidth = 295;
//        bedSpacer = 40;
        

//        imageSelection = @"@2x";
        iconSize = (screenWidth/4) * 0.6;
        aboutToolbarButtonHeight = 60;
//        contactButtonHeight = 49;
//        contactButtonWidth = 294;

        smWidth = 107.1;
        smHeight = 71.1;

        // Need to determine space for buttons
        smSpacer = (screenWidth - (sections * smWidth)) / (sections + 1);
    } else if (screenHeight == 736){
        lineSize = 2;
        homeImage = 292.41;

//        bedImageHeight = 130.243;
//        bedImageWidth = 325.607;
//        bedSpacer = 40;
//        
//        imageSelection = @"@3x";
        iconSize = (screenWidth/4) * 0.6;
        aboutToolbarButtonHeight = 65.62;
        smWidth = 118.211;
        smHeight = 78.476;
//        contactButtonHeight = 54.08;
//        contactButtonWidth = 324.50;
        
        // Need to determine space for buttons
        smSpacer = (screenWidth - (sections * smWidth)) / (sections + 1);
    }

    NSString *titleValue = [configurationValues objectForKey:@"HostelDetailsTitle"];
    UIFont* titleFont = [UIFont fontWithName:@"OpenSans-CondensedBold" size:24];
    CGSize requestedTitleSize = [titleValue sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    CGFloat titleWidth = MIN(screenWidth, requestedTitleSize.width);
    
    
//    NSString *headingFont = [configurationValues objectForKey:@"HeadingFont"];
//    NSString *bodyFont = [configurationValues objectForKey:@"BodyFont"];
    
//    UIFont* titleFont = [UIFont fontWithName:@"headingFont" size:18];
//    CGSize requestedTitleSize = [titleValue sizeWithAttributes:@{NSFontAttributeName: titleFont}];
//    CGFloat titleWidth = MIN(screenWidth, requestedTitleSize.width);

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

    longitude = detail.longitude;
    latitude = detail.latitude;

    // Get each detail item and pull out of the Detail object
    NSString *name = detail.name;
    NSString *phone = detail.phone;
    NSString *email = detail.email;
    NSString *address = detail.address;
    NSString *webpage = detail.website;
    NSString *desc = detail.description;

    // Create Scroll View
    ContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,yPosition, screenWidth,screenHeight-49-64-2-2-2)];
    ContentScrollView.delegate = self;
    ContentScrollView.scrollEnabled = YES;
    ContentScrollView.userInteractionEnabled=YES;

    // Add Image Scroll View
    ImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, screenWidth, homeImage)];
    ImageScrollView.scrollEnabled = YES;
    ImageScrollView.userInteractionEnabled=YES;
    [ImageScrollView setPagingEnabled:YES];
    [ImageScrollView setAlwaysBounceVertical:NO];
    ImageScrollView.delegate = self;

    // Get Photos
    NSArray *photos = [dataSource getPhotoNames:@"Details" identifier:@"Details"];
    int displayValue = 0;

    for (int i = 0; i < [photos count]; i++)
    {
        CGFloat xOrigin = i * ImageScrollView.frame.size.width;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, ImageScrollView.frame.size.width, ImageScrollView.frame.size.height)];

        PhotoLookup *pl = photos[i];
        NSString *name = pl.photoName;
        name = [name stringByAppendingString:@".jpg"];
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
        [ContentScrollView addSubview:self.pageControl];
    }
    
    yPosition = yPosition + homeImage - 64-2;
    
    // Small Black Line between Image and Table View
    UIView *imageLine = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, lineSize)];
    imageLine.backgroundColor = Rgb2UIColor(lineRed, lineGreen, lineBlue);
    [ContentScrollView addSubview:imageLine];

    yPosition = yPosition + lineSize;

    NSInteger startSpot = 0;

    UIView *buttonToolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, aboutToolbarButtonHeight)];

    UIButton *bookAboutBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth/5, aboutToolbarButtonHeight)];
    UIImage *bookBarImage = [UIImage imageNamed:@"bookabedhostel.png"];
    [bookAboutBarButton setImage:bookBarImage forState:UIControlStateNormal];
    [bookAboutBarButton addTarget:self
                 action:@selector(loadBooking)
       forControlEvents:UIControlEventTouchUpInside];
    [buttonToolbarView addSubview:bookAboutBarButton];
    
    startSpot = startSpot + (screenWidth/5);

    UIButton *callAboutBarButton = [[UIButton alloc] initWithFrame:CGRectMake(startSpot, 0, (screenWidth/5), aboutToolbarButtonHeight)];
    UIImage *callBarImage = [UIImage imageNamed:@"callushostel.png"];
    [callAboutBarButton setImage:callBarImage forState:UIControlStateNormal];
    [callAboutBarButton addTarget:self
                 action:@selector(callPhone)
       forControlEvents:UIControlEventTouchUpInside];
    [buttonToolbarView addSubview:callAboutBarButton];
    
    startSpot = startSpot + (screenWidth/5);
    
    UIButton *dirAboutBarButton = [[UIButton alloc] initWithFrame:CGRectMake(startSpot, 0, (screenWidth/5), aboutToolbarButtonHeight)];
    UIImage *dirBarImage = [UIImage imageNamed:@"directionshostel.png"];
    [dirAboutBarButton setImage:dirBarImage forState:UIControlStateNormal];
    [dirAboutBarButton addTarget:self
                 action:@selector(loadDirections)
       forControlEvents:UIControlEventTouchUpInside];
    [buttonToolbarView addSubview:dirAboutBarButton];
    
    startSpot = startSpot + (screenWidth/5);
    
    UIButton *emailAboutBarButton = [[UIButton alloc] initWithFrame:CGRectMake(startSpot, 0, (screenWidth/5), aboutToolbarButtonHeight)];
    UIImage *emailBarImage = [UIImage imageNamed:@"emailushostel.png"];
    [emailAboutBarButton setImage:emailBarImage forState:UIControlStateNormal];
    [emailAboutBarButton addTarget:self
                 action:@selector(openEmail)
       forControlEvents:UIControlEventTouchUpInside];
    [buttonToolbarView addSubview:emailAboutBarButton];
    
    startSpot = startSpot + (screenWidth/5);
    
    UIButton *mapAboutBarButton = [[UIButton alloc] initWithFrame:CGRectMake(startSpot, 0, (screenWidth/5), aboutToolbarButtonHeight)];
    UIImage *mapBarImage = [UIImage imageNamed:@"showmaphostel.png"];
    [mapAboutBarButton setImage:mapBarImage forState:UIControlStateNormal];
    [mapAboutBarButton addTarget:self
                 action:@selector(loadMap)
       forControlEvents:UIControlEventTouchUpInside];
    [buttonToolbarView addSubview:mapAboutBarButton];
    
    [ContentScrollView addSubview:buttonToolbarView];

    yPosition = yPosition + buttonToolbarView.frame.size.height;

    // Small Black Line between Image and Table View
    UIView *menuLine = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, lineSize)];
    menuLine.backgroundColor = Rgb2UIColor(0, lineGreen, lineBlue);
    [ContentScrollView addSubview:menuLine];
    
    yPosition = yPosition + lineSize + 15;

    // Set the Text RGB from the configuration file
    NSString *textR = [configurationValues objectForKey:@"TextRed"];
    NSInteger textRed = [textR integerValue];
    
    NSString *textG = [configurationValues objectForKey:@"TextGreen"];
    NSInteger textGreen = [textG integerValue];

    NSString *textB = [configurationValues objectForKey:@"TextBlue"];
    NSInteger textBlue = [textB integerValue];

    name = [name uppercaseString];
    NSMutableParagraphStyle *paragraphStylesHeading = [[NSMutableParagraphStyle alloc] init];
    paragraphStylesHeading.alignment = NSTextAlignmentCenter;      //justified text
    paragraphStylesHeading.firstLineHeadIndent = 1.0;                //must have a value to make it work

    NSDictionary *attributesHeading = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:name attributes: attributesHeading];

    // Name Label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, yPosition, screenWidth-60, 30)];
    nameLabel.attributedText = attributedString;
    nameLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
    nameLabel.numberOfLines = 1;
    nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    nameLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:fontSize];

    [ContentScrollView addSubview:nameLabel];

    yPosition = yPosition + nameLabel.frame.size.height + 15;

    // CREATE DESCRIPTION LABEL
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
    paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
    
    NSAttributedString *attributedDescription = [[NSAttributedString alloc] initWithString:desc attributes: attributes];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 9999)];
    descLabel.numberOfLines = 0;
    descLabel.lineBreakMode = UILineBreakModeWordWrap;
    [descLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:fontSize]];
    descLabel.attributedText = attributedDescription;
    descLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
    [descLabel sizeToFit];
    [ContentScrollView addSubview:descLabel];

    yPosition = yPosition + 15 + descLabel.frame.size.height;
    yPosition = yPosition + lineSize + 10;

    
    
    
    
    
    
    
    
//    // Get Bed Data
//    NSArray *beds = [dataSource getAllRooms];
//    
//    // Need a way to update this...
////    NSArray* thumbnails = [dataSource getThumbnailNames:@"Beds"];
//    
//    NSArray *thumbnails = [[NSArray alloc] initWithObjects:@"2doubleroom.png", @"2femaledorm.png", @"2mixeddorm.png", @"2tripleroom.png", @"2twinroom.png", nil];
//    
//    NSDictionary *attributesRoomHeading = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
//    NSAttributedString *attributedStringRoom = [[NSAttributedString alloc] initWithString:@"ROOMS" attributes: attributesRoomHeading];
//    
//    // Room Label
//    UILabel *roomHeading = [[UILabel alloc] initWithFrame:CGRectMake(30, yPosition, screenWidth-60, 30)];
//    roomHeading.attributedText = attributedStringRoom;
//    roomHeading.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
//    roomHeading.numberOfLines = 1;
//    roomHeading.lineBreakMode = NSLineBreakByCharWrapping;
//    roomHeading.font = [UIFont fontWithName:@"Roboto-Bold" size:fontSize];
//    
//    [ContentScrollView addSubview:roomHeading];
//    
//    yPosition = yPosition + roomHeading.frame.size.height + 10;
//    
//    NSInteger bedColumn = 1;
//    NSInteger startX = 40;
//    
//    for (int i = 0; i < [beds count]; i++){
//        // Need to calculate the position for starting
////        if (bedColumn == 2){
////            startX = 40 + bedImageWidth + 15;
////        } else {
////            startX = 40;
////        }
//        // First time through the yPosition is correct
//        
////        ThumbnailLookup *thumbnailLookup = [thumbnails objectAtIndex:i];
//
//        NSArray *thumbnails = [[NSArray alloc] initWithObjects:@"doubleroom.png", @"femaledorm.png", @"mixeddorm.png", @"tripleroom.png", @"twinroom.png", nil];
//        
////        UIImage *bedImage = [UIImage imageNamed:thumbnailLookup.photoName];
//        UIImage *bedImage = [UIImage imageNamed:thumbnails[i]];
//        UIButton *roomButton = [[UIButton alloc] initWithFrame:CGRectMake(startX, yPosition, bedImageWidth, bedImageHeight)];
//
//        [roomButton setImage:bedImage forState:UIControlStateNormal];
//        roomButton.tag = i;
//
//        [roomButton addTarget: self
//                    action: @selector(selectedBed:)
//            forControlEvents: UIControlEventTouchUpInside];
//        [ContentScrollView addSubview:roomButton];
//        
////        // Update bedRow, bedColumn
////        if (bedColumn == 1){
////            bedColumn++;
////        } else {
////            bedColumn = 1;
//            // Now need to set the yPosition
//            yPosition = yPosition + roomButton.frame.size.height + 5;
////        }
//        
////        // Check if this is the last item in the list
////        if (i == [beds count]-1){
////            // check to see if the yPosition needs to be updated
////            if (bedColumn == 2){
////                yPosition = yPosition + roomButton.frame.size.height + 15;
////            }
////        }
//    }
//    
////    // Small Black Line between Facilities and Rooms
////    UIView *facLin = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, 2)];
////    facLin.backgroundColor = Rgb2UIColor(lineRed, lineGreen, lineBlue);
////    [ContentScrollView addSubview:facLin];
//    
//    yPosition = yPosition + lineSize + 10;
//    
//    // Facilities
//    NSDictionary *attributesFacilitiesHeading = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
//    NSAttributedString *attributedStringFacilities = [[NSAttributedString alloc] initWithString:@"FACILITIES" attributes: attributesFacilitiesHeading];
//    
//    // Facilities Label
//    UILabel *facilityHeading = [[UILabel alloc] initWithFrame:CGRectMake(30, yPosition, screenWidth-60, 30)];
//    facilityHeading.attributedText = attributedStringFacilities;
//    facilityHeading.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
//    facilityHeading.numberOfLines = 1;
//    facilityHeading.lineBreakMode = NSLineBreakByCharWrapping;
//    facilityHeading.font = [UIFont fontWithName:@"Roboto-Bold" size:14];
//    
//    [ContentScrollView addSubview:facilityHeading];
//    
//    yPosition = yPosition + facilityHeading.frame.size.height;
//    
//    NSArray *faciltiesArray = [dataSource getFacilities];
//    
//    NSInteger facilityColumn = 1;
//    for (int i = 0; i < [faciltiesArray count]; i++){
//        // Need to calculate the position for starting
//        if (facilityColumn == 2){
//            startX = 40 + bedImageWidth + 15;
//        } else {
//            startX = 40;
//        }
//        // First time through the yPosition is correct
//        NSString *facility = faciltiesArray[i];
//        
//        UIView *labelView = [[UILabel alloc] initWithFrame:CGRectMake(startX, yPosition, bedImageWidth, 9999)];
//
//        
//        NSDictionary *attributesHeadingFac = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
//        NSAttributedString *attributedStringFac = [[NSAttributedString alloc] initWithString:facility attributes: attributesHeadingFac];
//        
//        UILabel *facilityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bedImageWidth, 30)];
//        facilityLabel.numberOfLines = 0;
//        facilityLabel.lineBreakMode = UILineBreakModeWordWrap;
//        [facilityLabel setFont:[UIFont fontWithName:bodyFont size:14]];
//        facilityLabel.attributedText = attributedStringFac;
//        facilityLabel.textAlignment = NSTextAlignmentCenter;
//        facilityLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
//        [labelView addSubview:facilityLabel];
//        [ContentScrollView addSubview:labelView];
//        
//        // Update bedRow, bedColumn
//        if (facilityColumn == 1){
//            facilityColumn++;
//        } else {
//            facilityColumn = 1;
//            // Now need to set the yPosition
//            yPosition = yPosition + facilityLabel.frame.size.height;
//        }
//        
//        // Check if this is the last item in the list
//        if (i == [faciltiesArray count]-1){
//            // check to see if the yPosition needs to be updated
//            if (facilityColumn == 2){
//                yPosition = yPosition + facilityLabel.frame.size.height;
//            }
//        }
//    }
//
//    yPosition = yPosition + 10;
//    // Staff Heading
//    
//    // Staff
//    
//    yPosition = yPosition + lineSize + 15;
//    
//    UIButton *contactButton = [[UIButton alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, contactButtonHeight)];
//    UIImage *contactButtonImage = [UIImage imageNamed:@"contactusbutton.png"];
//    [contactButton setImage:contactButtonImage forState:UIControlStateNormal];
//    [contactButton addTarget:self
//                 action:@selector(loadContact)
//       forControlEvents:UIControlEventTouchUpInside];
//    [ContentScrollView addSubview:contactButton];
//    
//    yPosition = yPosition + contactButton.frame.size.height + 25;
//    
    // Icon Displays
    NSInteger smStart = 0;

    if (![detail.facebookURL isEqualToString:@""]) {
        UIButton *fbButton = [[UIButton alloc] initWithFrame:CGRectMake(smSpacer, yPosition, smWidth, smHeight)];
        UIImage *fbImage = [UIImage imageNamed:@"likeus.png"];
        [fbButton setImage:fbImage forState:UIControlStateNormal];

        [fbButton addTarget:self
                        action:@selector(openFacebook)
                        forControlEvents:UIControlEventTouchUpInside];
        [ContentScrollView addSubview:fbButton];
        
        smStart = smSpacer + smWidth + smSpacer;
    }
    
    if (![detail.tripAdvisorURL isEqualToString:@""]) {
        UIButton *taButton = [[UIButton alloc] initWithFrame:CGRectMake(smStart, yPosition, smWidth, smHeight)];
        UIImage *taImage = [UIImage imageNamed:@"rateus.png"];
        [taButton setImage:taImage forState:UIControlStateNormal];
        [taButton addTarget:self
                     action:@selector(loadTALink)
           forControlEvents:UIControlEventTouchUpInside];
        [ContentScrollView addSubview:taButton];
        
        smStart = smStart + smWidth + smSpacer;
    }
    
    if (![detail.instagramURL isEqualToString:@""]) {
        UIButton *instaButton = [[UIButton alloc] initWithFrame:CGRectMake(smStart, yPosition, smWidth, smHeight)];
        UIImage *instaImage = [UIImage imageNamed:@"followus.png"];
        [instaButton setImage:instaImage forState:UIControlStateNormal];
        [instaButton addTarget:self
                     action:@selector(openInstagram)
           forControlEvents:UIControlEventTouchUpInside];
        [ContentScrollView addSubview:instaButton];
        
        smStart = smStart + smWidth + smSpacer;
    }
    yPosition = yPosition + smHeight + 15;
    
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

    // Add an image to your project & set that image here.
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburgermenu.png"]
                                                                              style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
    [[UIBarButtonItem appearance] setTintColor:Rgb2UIColor(lineRed, lineGreen, lineBlue)];

    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
}

//# pragma Phone Setup
//
//// Setup Phone Orientation
//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
//}
//
//# pragma Actions
//
//-(IBAction)callPhone {
//    // TODO PHONE NUMBER OF HOSTEL
//    NSString *phoneNumber = [@"tel:" stringByAppendingString:detail.phone];
////    NSString *phoneNumber = @"tel:(+61)404747178";
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
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
//// Home Action
//- (IBAction)backToHome
//{
////    [self.navigationController popToRootViewControllerAnimated:NO];
//    Square4HomeViewController *home = [[Square4HomeViewController alloc] initWithNibName:@"Square4HomeViewController" bundle:nil];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationController pushViewController:home animated:YES];
//}
//
//// Trip Advisor Action
//- (IBAction)loadTALink
//{
//    NSString *urlToDisplay = detail.tripAdvisorURL;
//    
//    LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
//    [loadWebVC setURL:urlToDisplay];
//    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    // Set from Configuration PList
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
//    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
//    
//    NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
//    [loadWebVC setTitleValue:appTitle];
//    
//    [self.navigationController pushViewController:loadWebVC animated:YES];
//}
//
//// Bed Selection Action
//- (IBAction) selectedBed: (id)sender
//{
//    NSInteger selection = ((UIButton*)sender).tag;
//    NSArray *rooms = [dataSource getAllRooms];
//    Room *roomSelection = rooms[selection];
//
//    RoomViewController *roomListing = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:nil];
//
//    [roomListing setTitle:@"ROOMS"];
//    [roomListing setTitleValue:@"ROOMS"];
//    [roomListing setRoom:roomSelection];
//    [roomListing setCurrentIndex:selection];
//
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    [self.navigationController pushViewController:roomListing animated:YES];
//}
//
//// Instagram Action
//- (IBAction) openInstagram
//{
//    NSString *urlToDisplay = detail.instagramURL;
//    
//    LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
//    [loadWebVC setURL:urlToDisplay];
//    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    // Set from Configuration PList
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
//    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
//    
//    NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
//    [loadWebVC setTitleValue:appTitle];
//    
//    [self.navigationController pushViewController:loadWebVC animated:YES];
//}
//
//// Twitter Action
//- (IBAction) openTwitter
//{
//    NSString *urlToDisplay = detail.twitterURL;
//    
//    LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
//    [loadWebVC setURL:urlToDisplay];
//    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    // Set from Configuration PList
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
//    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
//    
//    NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
//    [loadWebVC setTitleValue:appTitle];
//    
//    [self.navigationController pushViewController:loadWebVC animated:YES];
//}
//
//// Facebook Action
//- (IBAction) openFacebook
//{
//    NSString *urlToDisplay = detail.facebookURL;
//    
//    LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
//    [loadWebVC setURL:urlToDisplay];
//    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    // Set from Configuration PList
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
//    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
//    
//    NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
//    [loadWebVC setTitleValue:appTitle];
//    
//    [self.navigationController pushViewController:loadWebVC animated:YES];
//}
//
//// Directions Action
//- (IBAction) loadDirections
//{
//    DirectionViewController *dl = [[DirectionViewController alloc] initWithNibName:@"DirectionViewController" bundle:nil];
//    [self.navigationController pushViewController:dl animated:YES];
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
//- (IBAction)loadContact
//{
//    ContactViewController *contactVC = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
//    [contactVC setDetail:detail];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationController pushViewController:contactVC animated:YES];
//}
//
//- (IBAction)openWeb
//{
//    NSString *urlToDisplay = detail.website;
//    urlToDisplay = @"https://apac.littlehotelier.com/properties/makatijunctiondirect";
//    
//    LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
//    [loadWebVC setURL:urlToDisplay];
//    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    // Set from Configuration PList
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
//    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
//    
//    NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
//    [loadWebVC setTitleValue:appTitle];
//    
//    [self.navigationController pushViewController:loadWebVC animated:YES];
//}
//
//- (IBAction)openEmail
//{
//    if ([MFMailComposeViewController canSendMail])
//    {
//        // Email Subject
//        NSString *emailTitle = @"";
//        // Email Content
//        NSString *content = @"";
//        NSString *messageBody = content;
//        // To address
//        NSArray *toRecipents = [NSArray arrayWithObject:detail.email];
//        
//        // Setting up the email to be sent
//        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//        mc.mailComposeDelegate = self;
//        [mc setSubject:emailTitle];
//        [mc setMessageBody:messageBody isHTML:NO];
//        [mc setToRecipients:toRecipents];
//        
//        // Present mail view controller on screen
//        [self presentViewController:mc animated:YES completion:NULL];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
//                                                        message:@"Your device doesn't support the composer sheet"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles: nil];
//        [alert show];
//    }
//}
//
//// Action of the Mail being Sent
//- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
//{
//    switch (result)
//    {
//        case MFMailComposeResultCancelled:
//            NSLog(@"Email cancelled");
//            break;
//        case MFMailComposeResultSaved:
//            NSLog(@"Email saved");
//            break;
//        case MFMailComposeResultSent:
//            NSLog(@"Email sent");
//            break;
//        case MFMailComposeResultFailed:
//            NSLog(@"Email sent failure: %@", [error localizedDescription]);
//            break;
//        default:
//            break;
//    }
//    
//    // Close the Mail Interface
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}
//
//# pragma Scroll View
//
//// Scroll View - End Scroll and Set Page
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (scrollView == ImageScrollView){
//        CGFloat width = scrollView.frame.size.width;
//        NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
//        
//        self.pageControl.currentPage = page;
//    }
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
//- (void) setFromMenu:(NSInteger)value
//{
//    fromMenu = value;
//}

@end
