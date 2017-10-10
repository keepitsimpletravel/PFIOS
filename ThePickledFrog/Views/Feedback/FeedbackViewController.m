//
//  FeedbackViewController.m
//
//  Created by Ashley Templeman on 28/04/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import "FeedbackViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CurrencyConverter.h"
#import "LoadWebViewController.h"
#import "SWRevealViewController.h"
#import "Detail.h"
#import "MapViewController.h"
#import "TravelTipsViewController.h"
#import "HomeViewController.h"

@interface FeedbackViewController ()

@end

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation FeedbackViewController

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
    
    NSInteger feedbackButtonWidth = 0;
    NSInteger feedbackButtonHeight = 0;
    
    if (screenWidth == 320){
        homeImage = 113.316;
        lineSize = 2;
        feedbackButtonWidth = 250.488;
        feedbackButtonHeight = 41.748;
    }
    if (screenWidth == 375){
        homeImage = 133;
        lineSize = 2;
        feedbackButtonWidth = 294;
        feedbackButtonHeight = 49;
    } else if (screenWidth == 414){
        homeImage = 146.799;
        lineSize = 2;
        feedbackButtonWidth = 324.503;
        feedbackButtonHeight = 54.084;
    }
    
    NSString *titleValue = @"FEEDBACK";
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
    
    yPosition = yPosition + lineSize + 15;
    
    // Set the Text RGB from the configuration file
    NSString *textR = [configurationValues objectForKey:@"TextRed"];
    NSInteger textRed = [textR integerValue];
    
    NSString *textG = [configurationValues objectForKey:@"TextGreen"];
    NSInteger textGreen = [textG integerValue];
    
    NSString *textB = [configurationValues objectForKey:@"TextBlue"];
    NSInteger textBlue = [textB integerValue];
    
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentJustified;
    paragraphStyles.firstLineHeadIndent = 1.0;                //must have a value to make it work
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
  
    NSString *description = @"The Pickled Frog would love to hear any feedback; postive or negative about us. All your feedback will be utilised to help improve the services which The Pickled Frog provides.";
    
    NSAttributedString *attributedDescription = [[NSAttributedString alloc] initWithString:description attributes: attributes];
    
    // CREATE DESCRIPTION LABEL
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 9999)];
    
    descLabel.numberOfLines = 0;
    descLabel.lineBreakMode = UILineBreakModeWordWrap;
    [descLabel setFont:[UIFont fontWithName:bodyFont size:fontSize]];
    descLabel.attributedText = attributedDescription;
    [descLabel sizeToFit];
    
    [self.view addSubview:descLabel];
    
    yPosition = 15 + descLabel.frame.size.height + yPosition;
    
    // Feedback text view
    feedbackTextView = [[UITextView alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, screenHeight-51-yPosition-15-feedbackButtonHeight-15)];
    feedbackTextView.text = @"Enter Feedback";
    feedbackTextView.font = [UIFont fontWithName:@"Arial" size:fontSize];
    
    feedbackTextView.layer.borderColor = Rgb2UIColor(lineRed, lineGreen, lineBlue).CGColor;
    [[feedbackTextView layer] setBorderWidth:2.3];
    [[feedbackTextView layer] setCornerRadius:15];
    
    feedbackTextView.delegate = self;
    
    [self.view addSubview:feedbackTextView];
    
    yPosition = yPosition + feedbackTextView.frame.size.height + 15;
    
    // Submit Button
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit addTarget:self
               action:@selector(submitFeedback)
     forControlEvents:UIControlEventTouchUpInside];
    [submit setImage:[UIImage imageNamed:@"submitfeedback.png"] forState:UIControlStateNormal];
    submit.frame = CGRectMake(40, yPosition, screenWidth-80, feedbackButtonHeight);
    [self.view addSubview:submit];
    
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

# pragma Mail

// Submit Feedback Action
- (IBAction)submitFeedback {
    dataSource = [DataSource dataSource];
    Detail *detail = [dataSource getHostelDetails];
    
    // Email Subject
    NSString *emailTitle = @"Pickled Frog Feedback";
    // Email Content
    NSString *content = feedbackTextView.text;
    NSString *messageBody = content;
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:detail.email];
    
    // Setting up the email to be sent
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
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

# pragma Text View
// Method to clear text view when user clicks in it. Only happens with the inital place holder text
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSString *currentText = textView.text;
    
    if([currentText isEqualToString:@"Enter Feedback"])
    {
        textView.text = @"";
    }
}

// Setting the First Responder of the Text View
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

# pragma Phone Setup

// Set the phone orientation
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

- (void) setFromMenu:(NSInteger)value
{
    fromMenu = value;
}

@end
