//
//  CurrencyViewController.m
//
//  Created by Ashley Templeman on 10/05/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import "CurrencyConverter.h"
#import "TravelTipsViewController.h"
#import "SWRevealViewController.h"
#import "LoadWebViewController.h"
#import "Currency.h"
#import "MapViewController.h"
#import "UMAlertView.h"
#import "HomeViewController.h"

@interface CurrencyConverter ()
<UMAlertViewDelegate>
{
    NSMutableArray *arrPicker;
}
@property (nonatomic, retain) UIPageControl * pageControl;
@property (nonatomic) UMAlertView *umAlertView;

@end

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation CurrencyConverter

//@synthesize pickerCustom;

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
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    homeImage = 0;
    
    // Get Config Values
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    // Set the font settings
//    NSString *headingFont = [configurationValues objectForKey:@"HeadingFont"];
//    NSString *bodyFont = [configurationValues objectForKey:@"BodyFont"];
    
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
//    backgroundView.opaque = YES;
//    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"png"]];
//    backgroundView.backgroundColor = [UIColor colorWithPatternImage:image];
//    backgroundView.opaque = NO;
//    [self.view addSubview:backgroundView];
    
    if (screenWidth == 320){
        homeImage = 113.316;
        lineSize = 2;
//        imageSelection = @"@1x";
    }
    if (screenWidth == 375){
        homeImage = 133;
        lineSize = 2;
//        imageSelection = @"@1x";
    } else if (screenWidth == 414){
        homeImage = 146.799;
//        imageSelection = @"@2x";
        lineSize = 2;
    }
    
    NSString *titleValue = @"CURRENCY CONVERTER";
    UIFont* titleFont = [UIFont fontWithName:@"Helvetica" size:18];
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
    
    // Add Image Scroll View
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, homeImage)];
    
    NSString *name = @"header.jpg";
    
    [imageView setImage:[UIImage imageNamed:name]];
    [ContentScrollView addSubview:imageView];
    
    yPosition = yPosition + homeImage;
    
    // Small Black Line between Image and Table View
    UIView *imageLine = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, lineSize)];
    imageLine.backgroundColor = Rgb2UIColor(lineRed, lineGreen, lineBlue);
    [ContentScrollView addSubview:imageLine];
    
    // Set the Text RGB from the configuration file
    NSString *textR = [configurationValues objectForKey:@"TextRed"];
    NSInteger textRed = [textR integerValue];
    
    NSString *textG = [configurationValues objectForKey:@"TextGreen"];
    NSInteger textGreen = [textG integerValue];
    
    NSString *textB = [configurationValues objectForKey:@"TextBlue"];
    NSInteger textBlue = [textB integerValue];
    
    // Setup the picker
    NSArray *all = [self getCurrencies];

    NSMutableArray *currencyValues;
    arrPicker = [[NSMutableArray alloc] init];
    // Need to add all currency titles to arrPicker
    for(int i=0; i < [all count]; i++){
        Currency *currency = [all objectAtIndex:i];
        [arrPicker addObject:currency.currencyName];
    }
    
    self.umAlertView = [[UMAlertView alloc] init];
    self.umAlertView.delegate = self;
    
    // Space - need to determine what this space should be
    NSInteger space = (screenHeight - 66 - 51 - 220-homeImage-60)/2;
    yPosition = yPosition + space;
    
    
    // Button Currency Converter
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // TODO - Y SIZE SHOULD BE CONFIGUREABLE FOR THE SCREEN - SO NO SCROLLING OCCURS ON THE SCREEN
    firstCurrencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstCurrencyButton.frame = CGRectMake(40, yPosition, screenWidth-80, 40);
    [firstCurrencyButton addTarget:self
                            action:@selector(PickerView:)
                  forControlEvents:UIControlEventTouchUpInside];
    [firstCurrencyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [firstCurrencyButton setBackgroundColor:[UIColor whiteColor]];
    [firstCurrencyButton setTitle:@"Select Currency" forState:UIControlStateNormal];
    firstCurrencyButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:14];
    [[firstCurrencyButton layer] setBorderWidth:2.0f];
    [[firstCurrencyButton layer] setBorderColor:[UIColor blackColor].CGColor];
    firstCurrencyButton.titleLabel.font = [UIFont systemFontOfSize:17];
    firstCurrencyButton.titleLabel.frame = CGRectMake(40, yPosition, screenWidth-80, 50);
    firstCurrencyButton.tag = 101;
    
    [ContentScrollView addSubview:firstCurrencyButton];
    
    yPosition = yPosition + firstCurrencyButton.frame.size.height + 15;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
//    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.barTintColor = [UIColor whiteColor];//Rgb2UIColor(0, 0, 0);
    numberToolbar.layer.borderWidth = 2.0f;
    numberToolbar.layer.borderColor = [UIColor blackColor].CGColor;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    
    // Text Field - Enter Amount
    // TODO - Y SIZE SHOULD BE CONFIGURABLE FOR THE SCREEN - SO NO SCROLLING OCCURS ON THE SCREEN
    currencyEntry1 = [[UITextField alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 50)];
    currencyEntry1.delegate = self;
    currencyEntry1.borderStyle = UITextBorderStyleRoundedRect;
    currencyEntry1.placeholder = @"Enter Amount";
    currencyEntry1.font = [UIFont fontWithName:@"Arial" size:14];
    currencyEntry1.keyboardType = UIKeyboardTypeNumberPad;
    currencyEntry1.layer.cornerRadius=8.0f;
    currencyEntry1.layer.masksToBounds=YES;
    currencyEntry1.layer.borderColor=[[UIColor blackColor]CGColor];
    currencyEntry1.layer.borderWidth= 1.0f;
    currencyEntry1.textAlignment = UITextAlignmentCenter;
    currencyEntry1.enabled = NO;
    CGFloat newFontSize = 20.0 ;
    UIFont *newFont = [currencyEntry1.font fontWithSize:newFontSize];
    currencyEntry1.font = newFont;
    currencyEntry1.inputAccessoryView = numberToolbar;
    [ContentScrollView addSubview:currencyEntry1];
    
    yPosition = yPosition + currencyEntry1.frame.size.height + 15;
    
    // Convert Button
    UIImageView *converterView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth/2)-30, yPosition, 60, 60)];
    [[converterView layer] setBorderWidth:2.0f];
    [[converterView layer] setBorderColor:[UIColor blackColor].CGColor];
    
    // Set the image
    UIImage *conversionImage = [UIImage imageNamed:@"convertButton.png"];
    [converterView setImage:conversionImage];
    
    [ContentScrollView addSubview:converterView];
    
    yPosition = yPosition + converterView.frame.size.height + 15;
    
    // Text Field - Enter Amount
    // TODO - Y SIZE SHOULD BE CONFIGURABLE FOR THE SCREEN - SO NO SCROLLING OCCURS ON THE SCREEN
    currencyEntry2 = [[UITextField alloc] initWithFrame:CGRectMake(40, yPosition, screenWidth-80, 50)];
    currencyEntry2.delegate = self;
    currencyEntry2.borderStyle = UITextBorderStyleRoundedRect;
    currencyEntry2.placeholder = @"Enter Amount";
    currencyEntry2.font = [UIFont fontWithName:@"Arial" size:14];
    currencyEntry2.keyboardType = UIKeyboardTypeNumberPad;
    currencyEntry2.layer.cornerRadius=8.0f;
    currencyEntry2.layer.masksToBounds=YES;
    currencyEntry2.layer.borderColor=[[UIColor blackColor]CGColor];
    currencyEntry2.layer.borderWidth= 1.0f;
    currencyEntry2.textAlignment = UITextAlignmentCenter;
    currencyEntry2.enabled = NO;
    CGFloat newFontSize2 = 20.0 ;
    UIFont *newFont2 = [currencyEntry2.font fontWithSize:newFontSize2];
    currencyEntry2.font = newFont2;
    currencyEntry2.inputAccessoryView = numberToolbar;
    
    
    [ContentScrollView addSubview:currencyEntry2];
    
    yPosition = yPosition + currencyEntry2.frame.size.height + 15;
    
    // Button Currency
    // TODO - Y SIZE SHOULD BE CONFIGUREABLE FOR THE SCREEN - SO NO SCROLLING OCCURS ON THE SCREEN
    secondCurrencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [firstCurrencyButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    secondCurrencyButton.frame = CGRectMake(40, yPosition, screenWidth-80, 40);
    [secondCurrencyButton setBackgroundColor:[UIColor whiteColor]];
    secondCurrencyButton.titleLabel.frame = CGRectMake(40, yPosition, screenWidth-80, 50);
    [secondCurrencyButton addTarget:self
                            action:@selector(PickerView:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    //    [firstCurrencyButton.titleLabel setText:@"Select Currency"];
    [secondCurrencyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [secondCurrencyButton setTitle:@"Australian Dollar" forState:UIControlStateNormal];
    secondCurrencyButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:14];
    [[secondCurrencyButton layer] setBorderWidth:2.0f];
    secondCurrencyButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [[secondCurrencyButton layer] setBorderColor:[UIColor blackColor].CGColor];
    secondCurrencyButton.tag = 102;
    
    [ContentScrollView addSubview:secondCurrencyButton];
    
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
    currencyButton.enabled = NO;
    currencyButton
    .alpha = 0.4;
    
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

//-(void)textViewDidBeginEditing:(UITextView *)textView
//{

    
//}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0,-170,screenWidth,screenHeight)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
    
    [UIView commitAnimations];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0,0,screenWidth,screenHeight)];
    [UIView commitAnimations];
}

// Update the responder for the text field when entering currency details
- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    self.currentResponder = textField;
    NSString *test = @"";
    
    if (textField == currencyEntry1){
        [currencyEntry1 becomeFirstResponder];
        currentTF = 1;

    } else if (textField == currencyEntry2){

//        MainScrollView.frame = CGRectMake(MainScrollView.frame.origin.x, -160, MainScrollView.frame.size.width, MainScrollView.frame.size.height);
        
//        MainScrollView.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)

        

        
        
        [currencyEntry2 becomeFirstResponder];
        currentTF = 2;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        MainScrollView.frame = CGRectMake(MainScrollView.frame.origin.x, 0, MainScrollView.frame.size.width, MainScrollView.frame.size.height);
        [UIView commitAnimations];
        return NO;
    }
    return YES;
}


//// Responder to return and hide the Drop Down List
//-(BOOL) textFieldShouldReturn: (UITextField *) textField {
//    [textField resignFirstResponder];
//    return YES;
//}

-(IBAction)PickerView:(id)sender
{
    UIButton *selected = sender;
    currencyButtonSelection = selected.tag;
    
    if(currencyButtonSelection == 102){
        [arrPicker addObject:@"Second"];
    }
    
    [_umAlertView um_showAlertViewTitle:@"Select Currency" pickerData:arrPicker haveCancelButton:YES completion:^{
        NSLog(@"UMAlertView show success");
    }];
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
    NSString *webURL = [configurationValues objectForKey:@"BookingURL"];
    
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


# pragma Conversion
// Method to send out query string and to receive the value
- (void)converterAction
{
    NSString *query = @"";
    NSString *firstCurrency = firstCurrencyButton.titleLabel.text;
    NSString *secondCurrency = secondCurrencyButton.titleLabel.text;
    
    NSString *firstCode = @"";
    NSString *secondCode = @"";

    NSArray *currencies = [self getCurrencies];

    for(int i=0; i<[currencies count]; i++){
        Currency *value = [currencies objectAtIndex:i];
        if([value.currencyName isEqualToString:firstCurrency]){
            firstCode = value.code;
        }

        if([value.currencyName isEqualToString:secondCurrency]){
            secondCode = value.code;
        }
    }

    NSString *amountString = @"";
    if (currentTF == 1){
        amountString = currencyEntry1.text;
    } else {
        amountString = currencyEntry2.text;
        NSString *temp = firstCode;
        firstCode = secondCode;
        secondCode = temp;
    }

    // Need to work out how to set the code
    query = [NSString stringWithFormat:@"https://www.exchangerate-api.com/%@/%@/%@?k=0eaf1227513081af92575a45", firstCode, secondCode,amountString];

    NSString *returnedCurrency = [NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:NULL];

    // Set the other Textfield
    if (currentTF == 1){
        currencyEntry2.text = returnedCurrency;
    } else {
        currencyEntry1.text = returnedCurrency;
    }
}

// ENHANCEMENT - Could look at databasing this
// Create the list of all currencies available to the user
- (NSArray *)getCurrencies
{
    NSMutableArray *currencyValue = [[NSMutableArray alloc] init];
    
    Currency *arg = [[Currency alloc] initWithData:@"Argentine Peso" currencyCode:@"ARS"];
    [currencyValue addObject:arg];
    Currency *aussie = [[Currency alloc] initWithData:@"Australian Dollar" currencyCode:@"AUD"];
    [currencyValue addObject:aussie];
    Currency *bahamas = [[Currency alloc] initWithData:@"Bahamian Dollar" currencyCode:@"BSD"];
    [currencyValue addObject:bahamas];
    Currency *bah = [[Currency alloc] initWithData:@"Bahraini Dinar" currencyCode:@"BHD"];
    [currencyValue addObject:bah];
    Currency *ban = [[Currency alloc] initWithData:@"Bangladeshi Taka" currencyCode:@"BDT"];
    [currencyValue addObject:ban];
    Currency *barb = [[Currency alloc] initWithData:@"Barbados Dollar" currencyCode:@"BBD"];
    [currencyValue addObject:barb];
    Currency *francWest = [[Currency alloc] initWithData:@"CFA Franc West" currencyCode:@"XOF"];
    [currencyValue addObject:francWest];
    Currency *bra = [[Currency alloc] initWithData:@"Brazilian Real" currencyCode:@"BRL"];
    [currencyValue addObject:bra];
    Currency *bul = [[Currency alloc] initWithData:@"Bulgarian Lev" currencyCode:@"BGN"];
    [currencyValue addObject:bul];
    Currency *francCentral = [[Currency alloc] initWithData:@"CFA Franc Central" currencyCode:@"XAF"];
    [currencyValue addObject:francCentral];
    Currency *can = [[Currency alloc] initWithData:@"Canadian Dollar" currencyCode:@"CAD"];
    [currencyValue addObject:can];
    Currency *chi = [[Currency alloc] initWithData:@"Chilean Peso" currencyCode:@"CLP"];
    [currencyValue addObject:chi];
    Currency *china = [[Currency alloc] initWithData:@"Chinese Renminbi" currencyCode:@"CNY"];
    [currencyValue addObject:china];
    Currency *col = [[Currency alloc] initWithData:@"Colombian Peso" currencyCode:@"COP"];
    [currencyValue addObject:col];
    Currency *cro = [[Currency alloc] initWithData:@"Croatian Kuna" currencyCode:@"HRK"];
    [currencyValue addObject:cro];
    Currency *czk = [[Currency alloc] initWithData:@"Czech Koruna" currencyCode:@"CZK"];
    [currencyValue addObject:czk];
    Currency *den = [[Currency alloc] initWithData:@"Danish Krone" currencyCode:@"DKK"];
    [currencyValue addObject:den];
    Currency *dom = [[Currency alloc] initWithData:@"Dominican Peso" currencyCode:@"DOP"];
    [currencyValue addObject:dom];
    Currency *ecd = [[Currency alloc] initWithData:@"East Caribbean Dollar" currencyCode:@"XCD"];
    [currencyValue addObject:ecd];
    Currency *egy = [[Currency alloc] initWithData:@"Egyptian Pound" currencyCode:@"EGP"];
    [currencyValue addObject:egy];
    Currency *euro = [[Currency alloc] initWithData:@"Euro" currencyCode:@"EUR"];
    [currencyValue addObject:euro];
    Currency *fiji = [[Currency alloc] initWithData:@"Fiji Dollar" currencyCode:@"FJD"];
    [currencyValue addObject:fiji];
    Currency *xpf = [[Currency alloc] initWithData:@"French Pacific Francs" currencyCode:@"XPF"];
    [currencyValue addObject:xpf];
    Currency *gha = [[Currency alloc] initWithData:@"Ghanaian Cedi" currencyCode:@"GHS"];
    [currencyValue addObject:gha];
    Currency *gua = [[Currency alloc] initWithData:@"Guatemalan Quetzal" currencyCode:@"GTQ"];
    [currencyValue addObject:gua];
    Currency *hon = [[Currency alloc] initWithData:@"Honduran Lempira" currencyCode:@"HNL"];
    [currencyValue addObject:hon];
    Currency *hk = [[Currency alloc] initWithData:@"Hong Kong Dollar" currencyCode:@"HKD"];
    [currencyValue addObject:hk];
    Currency *hun = [[Currency alloc] initWithData:@"Hungarian Forint" currencyCode:@"HUF"];
    [currencyValue addObject:hun];
    Currency *ice = [[Currency alloc] initWithData:@"Icelandic Krona" currencyCode:@"ISK"];
    [currencyValue addObject:ice];
    Currency *ind = [[Currency alloc] initWithData:@"Indian Rupee" currencyCode:@"INR"];
    [currencyValue addObject:ind];
    Currency *indo = [[Currency alloc] initWithData:@"Indonesian Rupiah" currencyCode:@"IDR"];
    [currencyValue addObject:indo];
    Currency *iran = [[Currency alloc] initWithData:@"Iranian Rial" currencyCode:@"IRR"];
    [currencyValue addObject:iran];
    Currency *irl = [[Currency alloc] initWithData:@"Israeli Shekel" currencyCode:@"ILS"];
    [currencyValue addObject:irl];
    Currency *jam = [[Currency alloc] initWithData:@"Jamaican Dollar" currencyCode:@"JMD"];
    [currencyValue addObject:jam];
    Currency *jap = [[Currency alloc] initWithData:@"Japanese Yen" currencyCode:@"JPY"];
    [currencyValue addObject:jap];
    Currency *jor = [[Currency alloc] initWithData:@"Jordanian Dinar" currencyCode:@"JOD"];
    [currencyValue addObject:jor];
    Currency *ken = [[Currency alloc] initWithData:@"Kenyan Shilling" currencyCode:@"KES"];
    [currencyValue addObject:ken];
    Currency *kor = [[Currency alloc] initWithData:@"Korean Won" currencyCode:@"KRW"];
    [currencyValue addObject:kor];
    Currency *kuw = [[Currency alloc] initWithData:@"Kuwaiti Dinar" currencyCode:@"KWD"];
    [currencyValue addObject:kuw];
    Currency *mal = [[Currency alloc] initWithData:@"Malaysian Ringgit" currencyCode:@"MYR"];
    [currencyValue addObject:mal];
    Currency *mau = [[Currency alloc] initWithData:@"Mauritian Rupee" currencyCode:@"MUR"];
    [currencyValue addObject:mau];
    Currency *mex = [[Currency alloc] initWithData:@"Mexican Peso" currencyCode:@"MXN"];
    [currencyValue addObject:mex];
    Currency *mor = [[Currency alloc] initWithData:@"Moroccan Dirham" currencyCode:@"MAD"];
    [currencyValue addObject:mor];
    Currency *myn = [[Currency alloc] initWithData:@"Myanmar Kyat" currencyCode:@"MMK"];
    [currencyValue addObject:myn];
    Currency *neth = [[Currency alloc] initWithData:@"Netherlands Antillian Guilder" currencyCode:@"ANG"];
    [currencyValue addObject:neth];
    Currency *nz = [[Currency alloc] initWithData:@"New Zealand Dollar" currencyCode:@"NZD"];
    [currencyValue addObject:nz];
    Currency *nig = [[Currency alloc] initWithData:@"Nigerian Naira" currencyCode:@"NGN"];
    [currencyValue addObject:nig];
    Currency *nor = [[Currency alloc] initWithData:@"Norwegian Krone" currencyCode:@"NOK"];
    [currencyValue addObject:nor];
    Currency *oman = [[Currency alloc] initWithData:@"Omani Rial" currencyCode:@"OMR"];
    [currencyValue addObject:oman];
    Currency *pak = [[Currency alloc] initWithData:@"Pakistani Rupee" currencyCode:@"PKR"];
    [currencyValue addObject:pak];
    Currency *pan = [[Currency alloc] initWithData:@"Panamanian Balboa" currencyCode:@"PAB"];
    [currencyValue addObject:pan];
    Currency *png = [[Currency alloc] initWithData:@"Papua New Guinean Kina" currencyCode:@"PGK"];
    [currencyValue addObject:png];
    Currency *peru = [[Currency alloc] initWithData:@"Peruvian Nuevo Sol" currencyCode:@"PEN"];
    [currencyValue addObject:peru];
    Currency *phi = [[Currency alloc] initWithData:@"Philippine Peso" currencyCode:@"PHP"];
    [currencyValue addObject:phi];
    Currency *pol = [[Currency alloc] initWithData:@"Polish Zloty" currencyCode:@"PLN"];
    [currencyValue addObject:pol];
    Currency *qat = [[Currency alloc] initWithData:@"Qatari Riyal" currencyCode:@"QAR"];
    [currencyValue addObject:qat];
    Currency *rom = [[Currency alloc] initWithData:@"Romanian Leu" currencyCode:@"RON"];
    [currencyValue addObject:rom];
    Currency *rus = [[Currency alloc] initWithData:@"Russian Rouble" currencyCode:@"RUB"];
    [currencyValue addObject:rus];
    Currency *sau = [[Currency alloc] initWithData:@"Saudi Riyal" currencyCode:@"SAR"];
    [currencyValue addObject:sau];
    Currency *ser = [[Currency alloc] initWithData:@"Serbian Dinar" currencyCode:@"RSD"];
    [currencyValue addObject:ser];
    Currency *sey = [[Currency alloc] initWithData:@"Seychellois Rupee" currencyCode:@"SCR"];
    [currencyValue addObject:sey];
    Currency *sin = [[Currency alloc] initWithData:@"Singapore Dollar" currencyCode:@"SGD"];
    [currencyValue addObject:sin];
    Currency *sa = [[Currency alloc] initWithData:@"South African Rand" currencyCode:@"ZAR"];
    [currencyValue addObject:sa];
    Currency *sl = [[Currency alloc] initWithData:@"Sri Lanka Rupee" currencyCode:@"LKR"];
    [currencyValue addObject:sl];
    Currency *swe = [[Currency alloc] initWithData:@"Swedish Krona" currencyCode:@"SEK"];
    [currencyValue addObject:swe];
    Currency *swi = [[Currency alloc] initWithData:@"Swiss Franc" currencyCode:@"CHF"];
    [currencyValue addObject:swi];
    Currency *tai = [[Currency alloc] initWithData:@"Taiwan Dollar" currencyCode:@"ARS"];
    [currencyValue addObject:tai];
    Currency *thb = [[Currency alloc] initWithData:@"Thai Baht" currencyCode:@"THB"];
    [currencyValue addObject:thb];
    Currency *tt = [[Currency alloc] initWithData:@"Trinidad And Tobago Dollar" currencyCode:@"TTD"];
    [currencyValue addObject:tt];
    Currency *tun = [[Currency alloc] initWithData:@"Tunisian Dinar" currencyCode:@"TND"];
    [currencyValue addObject:tun];
    Currency *tur = [[Currency alloc] initWithData:@"Turkish Lira" currencyCode:@"TRY"];
    [currencyValue addObject:tur];
    Currency *uae = [[Currency alloc] initWithData:@"UAE Dirham" currencyCode:@"AED"];
    [currencyValue addObject:uae];
    Currency *uk = [[Currency alloc] initWithData:@"Pound Sterling" currencyCode:@"GBP"];
    [currencyValue addObject:uk];
    Currency *us = [[Currency alloc] initWithData:@"US Dollar" currencyCode:@"USD"];
    [currencyValue addObject:us];
    Currency *ven = [[Currency alloc] initWithData:@"Venezuelan Bolivar Fuerte" currencyCode:@"VEF"];
    [currencyValue addObject:ven];
    Currency *viet = [[Currency alloc] initWithData:@"Vietnamese Dong" currencyCode:@"VND"];
    [currencyValue addObject:viet];
    Currency *zam = [[Currency alloc] initWithData:@"Zambian Kwacha" currencyCode:@"ZMW"];
    [currencyValue addObject:zam];
    
    return currencyValue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectUMAlertButton {
    if (currencyButtonSelection == 101){
        [firstCurrencyButton setTitle:[self.umAlertView selectData] forState: UIControlStateNormal];
    } else if (currencyButtonSelection == 102){
        [secondCurrencyButton setTitle:[self.umAlertView selectData] forState: UIControlStateNormal];
    }
    
    [self.umAlertView um_dismissAlertViewCompletion:^{
        NSLog(@"UMAlertView dismiss success");
        
        NSString *firstCurrency = firstCurrencyButton.titleLabel.text;
        NSString *secondCurrency = secondCurrencyButton.titleLabel.text;
        
        // Do Currency Code here
        if (![firstCurrency isEqualToString:@"Select Currency"] || ![secondCurrency isEqualToString:@"Select Currency"]){
            currencyEntry1.enabled = YES;
            currencyEntry2.enabled = YES;
        }
        
        if(([currencyEntry1.text length] > 0) || ([currencyEntry2.text length] > 0)){
            [self converterAction];
        }
    }];
    
}

- (void)selectUMAlertCancelButton {
    
    [self.umAlertView um_dismissAlertView];
    
}

-(void)cancelNumberPad{
    if(currentTF == 1){
        [currencyEntry1 resignFirstResponder];
        currencyEntry1.text = @"";
//        currencyEntry1.text = 
    } else if (currentTF == 2){
        [currencyEntry2 resignFirstResponder];
        currencyEntry2.text = @"";
    }
//    numberTextField.text = @"";
}

-(void)doneWithNumberPad{
    if (currentTF == 1){
        [currencyEntry1 resignFirstResponder];
//        currentTF = 1;
        
        if ([currencyEntry1.text length] > 0 && ![firstCurrencyButton.titleLabel.text isEqualToString:@"Select Currency"] && ![secondCurrencyButton.titleLabel.text isEqualToString:@"Select Currency"]){
            // conversion action can be selected
            [self converterAction];
        }
    } else if (currentTF == 2){
        [currencyEntry2 resignFirstResponder];
//        currentTF = 2;
        
        if ([currencyEntry2.text length] > 0 && ![firstCurrencyButton.titleLabel.text isEqualToString:@"Select Currency"] && ![secondCurrencyButton.titleLabel.text isEqualToString:@"Select Currency"]){
            // conversion action can be selected
            [self converterAction];
        }
    }

}

// Travel Tips Action
- (IBAction)loadInfo
{
    TravelTipsViewController *tt = [[TravelTipsViewController alloc] initWithNibName:@"TravelTipsViewController" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:tt animated:YES];
}

@end
