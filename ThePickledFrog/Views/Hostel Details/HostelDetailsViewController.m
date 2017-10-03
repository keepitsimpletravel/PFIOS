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
#import "ListingTableCell.h"
#import "ThumbnailLookup.h"
#import "Room.h"

@interface HostelDetailsViewController ()
@property (nonatomic, retain) UIPageControl * pageControl;

@end

@implementation HostelDetailsViewController
{
    NSArray *roomsTypes;
    NSArray *facilitiesTypes;
}

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
    NSInteger iconWidth = 0;
    NSInteger iconHeight = 0;
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

        bedImageHeight = 100.536;
//        bedImageWidth = 251.34;
        bedImageWidth = (screenWidth-80)/2;
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
        iconHeight = 25.56;
        iconWidth = 25.56;
    } else if (screenHeight == 667){
        lineSize = 2;
        homeImage = 265;

        bedImageHeight = 118;
//        bedImageWidth = 295;
        bedImageWidth = (screenWidth-80)/2;
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
        iconHeight = 30;
        iconWidth = 30;
    } else if (screenHeight == 736){
        lineSize = 2;
        homeImage = 292.41;

        bedImageHeight = 130.243;
//        bedImageWidth = 325.607;
        bedImageWidth = (screenWidth-80)/2;
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
        iconHeight = 33.112;
        iconWidth = 33.112;
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

    // Tabbed Section
    UIView *tabbedSection = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, 30)];
    NSArray *itemArray = [NSArray arrayWithObjects: @"Rooms", @"Facilities", @"Contact", nil];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(10, 0, screenWidth-20, 30);
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    [segmentedControl addTarget:self action:@selector(segmentSelection:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor blackColor];
    [tabbedSection addSubview:segmentedControl];
    [ContentScrollView addSubview:tabbedSection];

    yPosition = yPosition + tabbedSection.frame.size.height + 2;

    dataSource = [DataSource dataSource];

    // Rooms
    roomsListing = [[UITableView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth-10, 250)];
    roomsListing.delegate = self;
    roomsListing.dataSource = self;
    roomsListing.hidden = NO;
    [ContentScrollView addSubview:roomsListing];
    
    // Need to set the rest of the table view
    // Get Room objects
     roomsTypes = [dataSource getAllRooms];
    
    // Initialize thumbnails - need to get the thumbnails added
    //    eatsThumbnails = [dataSource getThumbnailNames:@"Food"];
    
    // Facilities
    // Need to add a view for the Facilities here
    facilitiesView = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, 250)];
    
//    NSDictionary *attributesFacilitiesHeading = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
//        NSAttributedString *attributedStringFacilities = [[NSAttributedString alloc] initWithString:@"FACILITIES" attributes: attributesFacilitiesHeading];
//    
//    // Facilities Label
//    UILabel *facilityHeading = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, screenWidth-60, 30)];
//    facilityHeading.attributedText = attributedStringFacilities;
//    facilityHeading.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
//    facilityHeading.numberOfLines = 1;
//    facilityHeading.lineBreakMode = NSLineBreakByCharWrapping;
//    facilityHeading.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:14];
//    
//    [facilitiesView addSubview:facilityHeading];
    
    NSInteger pos = 20;// + facilityHeading.frame.size.height;
    
    NSArray *faciltiesArray = [dataSource getFacilities];
    
    NSInteger facilityColumn = 1;
    NSInteger startX = 0;
    for (int i = 0; i < [faciltiesArray count]; i++){
        // Need to calculate the position for starting
        if (facilityColumn == 2){
            startX = 40 + bedImageWidth + 15;
        } else {
            startX = 40;
        }
        // First time through the yPosition is correct
        NSString *facility = faciltiesArray[i];
        UIView *labelView = [[UILabel alloc] initWithFrame:CGRectMake(startX, pos, bedImageWidth, 9999)];
        
        NSDictionary *attributesHeadingFac = @{NSParagraphStyleAttributeName: paragraphStylesHeading};
        NSAttributedString *attributedStringFac = [[NSAttributedString alloc] initWithString:facility attributes: attributesHeadingFac];
    
        UILabel *facilityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bedImageWidth, 30)];
        facilityLabel.numberOfLines = 0;
        facilityLabel.lineBreakMode = UILineBreakModeWordWrap;
        [facilityLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:14]];
        facilityLabel.attributedText = attributedStringFac;
        facilityLabel.textAlignment = NSTextAlignmentCenter;
        facilityLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        [labelView addSubview:facilityLabel];
        [facilitiesView addSubview:labelView];
    
        // Update bedRow, bedColumn
        if (facilityColumn == 1){
            facilityColumn++;
        } else {
            facilityColumn = 1;
            // Now need to set the yPosition
            pos = pos + facilityLabel.frame.size.height;
        }
    
        // Check if this is the last item in the list
        if (i == [faciltiesArray count]-1){
            // check to see if the yPosition needs to be updated
            if (facilityColumn == 2){
                pos = pos + facilityLabel.frame.size.height;
            }
        }
    }
    facilitiesView.hidden = YES;
    [ContentScrollView addSubview:facilitiesView];
    
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

        if(30 > addressIcon.frame.size.height){
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
        NSAttributedString *attributedPhone = [[NSAttributedString alloc] initWithString:test attributes: attributes];
        
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
        
        UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(xStart, contactPosition, xEnd, 9999)];
        emailLabel.numberOfLines = 0;
        emailLabel.lineBreakMode = UILineBreakModeWordWrap;
        [emailLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:fontSize]];
        emailLabel.attributedText = attributedEmail;
        emailLabel.textColor = Rgb2UIColor(textRed, textGreen, textBlue);
        [emailLabel sizeToFit];
        
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

    contactView.hidden = YES;
    [ContentScrollView addSubview:contactView];
    
    yPosition = yPosition + roomsListing.frame.size.height + 20;
    
    // Set Content Size for Scroll View
    ContentScrollView.contentSize = CGSizeMake(screenWidth, yPosition);
    [self.view addSubview:ContentScrollView];

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

- (void)setViewNumber:(NSInteger)value
{
    viewNumber = value;
}

// Table View - Number of Rows
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [roomsTypes count];
}

// Set up the Table View Cells, rows
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    NSMutableArray *tableSublabelData = [[NSMutableArray alloc] init];
    
//    if (tableView == eatsListingTable){
//         Set the Food objects
        for (int i = 0; i < [roomsTypes count]; i++){
            Room *room = [roomsTypes objectAtIndex:i];
            [tableData addObject:room.roomType];
            [tableSublabelData addObject:room.price];
        }
    
        static NSString *simpleTableIdentifier = @"ListingTableCell";
        
        ListingTableCell *cell = (ListingTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListingTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.nameLabel.text = [tableData objectAtIndex:indexPath.row];
        cell.extraLabel.text = [tableSublabelData objectAtIndex:indexPath.row];
        
//        ThumbnailLookup *thumbnailLookup = [eatsThumbnails objectAtIndex:indexPath.row];
//        cell.thumbnailImageView.image = [UIImage imageNamed:thumbnailLookup.photoName];
    
        //        cell.thumbnailImageView.image = [UIImage imageNamed:[eatsThumbnails objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        return cell;
//    }
//    return nil;
}

// Table View Did Select
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//        selectedRow = indexPath.row;
//        Food *selection = [eatTypes objectAtIndex:selectedRow];
//        [self foodClicked:selection];
}

// Table View Row Height
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 80;
}

- (IBAction)segmentSelection:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        roomsListing.hidden = NO;
        facilitiesView.hidden = YES;
        contactView.hidden = YES;
    } else if (sender.selectedSegmentIndex == 1){
        roomsListing.hidden = YES;
        facilitiesView.hidden = NO;
        contactView.hidden = YES;
    } else if (sender.selectedSegmentIndex == 2){
        roomsListing.hidden = YES;
        facilitiesView.hidden = YES;
        contactView.hidden = NO;
    }
}

@end
