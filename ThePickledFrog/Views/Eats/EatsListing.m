//
//  SegmentedView.m
//  MakatiJunctionHostel
//
//  Created by Ashley Templeman on 18/4/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import "EatsListing.h"
#import "CurrencyConverter.h"
#import "TravelTipsViewController.h"
#import "SWRevealViewController.h"
#import "Food.h"
#import "ListingTableCell.h"
//#import "ListingNameOnlyTableCell.h"
#import "EatsViewController.h"
#import "DrinksViewController.h"
#import "AttractionViewController.h"
#import "ThumbnailLookup.h"
#import "LoadWebViewController.h"
#import "MapViewController.h"
#import "HomeViewController.h"

@interface EatsListing ()

@end

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation EatsListing
{
    NSArray *eatTypes1;
    NSArray *eatTypes2;
    //    NSArray *eatTypes3;
}

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
    // Do any additional setup after loading the view from its nib.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    //    NSInteger deviceType = 0;
    NSInteger homeImage = 0;
    NSInteger lineSize = 2;
    
    // Get Config Values
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    //    NSString *headingFont = [configurationValues objectForKey:@"HeadingFont"];
    //    NSString *bodyFont = [configurationValues objectForKey:@"BodyFont"];
    
    NSInteger buttonWidth = 0;
    NSInteger buttonHeight = 0;
    
    // need to determine screenWidth to compare which device is which
    if (screenWidth == 320){
        homeImage = 113.316;
        lineSize = 2;
        buttonWidth = screenWidth/2;
        buttonHeight = ((screenHeight-117)/4);
    }
    if (screenWidth == 375){
        homeImage = 133;
        lineSize = 2;
        buttonWidth = screenWidth/2;
        buttonHeight = ((screenHeight-117)/4);
    } else if (screenWidth == 414){
        homeImage = 146.799;
        lineSize = 2;
        buttonWidth = screenWidth/2;
        buttonHeight = ((screenHeight-117)/4);
    }
    
    NSString *titleValue = @"EATS";
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
    
    NSString *value = @"hostellogo.png";
    UIImage *image = [[UIImage alloc] init];
    image = [UIImage imageNamed:value];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:image];
    logoView.frame = CGRectMake((screenWidth/2)-(buttonWidth/2), yPosition, buttonWidth, buttonHeight);
    [ContentScrollView addSubview:logoView];
    
    yPosition = yPosition + homeImage + 2;
    
    UIView *tabbedSection = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, 30)];
    //    NSMutableArray *itemArray = [NSArray arrayWithObjects: @"Eats", @"Drinks", @"Attractions", nil];
    
    dataSource = [DataSource dataSource];
    NSMutableArray *itemArray = [dataSource getFoodTypes];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(10, 0, screenWidth-20, 30);
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    [segmentedControl addTarget:self action:@selector(segmentSelection:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor colorWithRed:((112) / 255.0) green:((175) / 255.0) blue:((0) / 255.0) alpha:1.0f];
    [tabbedSection addSubview:segmentedControl];
    [ContentScrollView addSubview:tabbedSection];
    
    yPosition = yPosition + tabbedSection.frame.size.height + 2;
    
    
    // Need to go through and get values for each type
    // Create each of the tableviews and add to an array
    eatsListingTable1 = [[UITableView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, screenHeight-51-yPosition)];
    
    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    eatsListingTable1.delegate = self;
    eatsListingTable1.dataSource = self;
    eatsListingTable1.hidden = NO;
    [ContentScrollView addSubview:eatsListingTable1];
    
    NSString *type1 = itemArray[0];
    eatTypes1 = [dataSource getAllFoodsForType:type1];
    //[dataSource getAllFoodsForType:itemsArray[0]];
    
    eatsListingTable2 = [[UITableView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, screenHeight-51-yPosition)];
    
    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    eatsListingTable2.delegate = self;
    eatsListingTable2.dataSource = self;
    eatsListingTable2.hidden = YES;
    [ContentScrollView addSubview:eatsListingTable2];
    
    NSString *type2 = itemArray[1];
    eatTypes2 = [dataSource getAllFoodsForType:type2];
    
    //    eatsListingTable3 = [[UITableView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, screenHeight-51-yPosition)];
    //
    //    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    //    eatsListingTable3.delegate = self;
    //    eatsListingTable3.dataSource = self;
    //    eatsListingTable3.hidden = YES;
    //    [ContentScrollView addSubview:eatsListingTable3];
    //
    //    eatsListingTable3 = [[UITableView alloc] initWithFrame:CGRectMake(0, yPosition, screenWidth, screenHeight-51-yPosition)];
    
    
    // Initialize thumbnails
    eatsThumbnails = [dataSource getThumbnailNames:@"Food"];
    
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

#pragma Phone Setup

// Setup the Orientation of the Devices
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
}

#pragma Button Actions

// Home Action
- (IBAction)backToHome
{
    //    [self.navigationController popToRootViewControllerAnimated:NO];
    HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:home animated:YES];
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

- (void)setViewNumber:(NSInteger)value
{
    viewNumber = value;
}

// Table View - Number of Rows
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == eatsListingTable1) {
        return [eatTypes1 count];
    } else if (tableView == eatsListingTable2) {
        return [eatTypes2 count];
    }
    return 0;
}

// Set up the Table View Cells, rows
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    NSMutableArray *tableSublabelData = [[NSMutableArray alloc] init];
    
    if (tableView == eatsListingTable1){
        // Set the Food objects
        for (int i = 0; i < [eatTypes1 count]; i++){
            Food *food = [eatTypes1 objectAtIndex:i];
            [tableData addObject:food.foodName];
            [tableSublabelData addObject:food.brief];
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
        
        NSString *nameValue = [tableData objectAtIndex:indexPath.row];
        ThumbnailLookup *thumbnailToUse = [[ThumbnailLookup alloc] init];
        
        for (int i=0; i<[eatsThumbnails count]; i++){
            ThumbnailLookup *thumbnailLookup = [eatsThumbnails objectAtIndex:i];
            if([thumbnailLookup.identifier isEqualToString:nameValue]){
                // Then this is the one to use
                thumbnailToUse = thumbnailLookup;
            }
        }
        
        
        //        ThumbnailLookup *thumbnailLookup = [attractionsThumbnails objectAtIndex:indexPath.row];
        cell.thumbnailImageView.image = [UIImage imageNamed:thumbnailToUse.photoName];
        
        //        cell.thumbnailImageView.image = [UIImage imageNamed:[eatsThumbnails objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        return cell;
    } else if (tableView == eatsListingTable2) {
        for (int i = 0; i < [eatTypes2 count]; i++){
            Food *food = [eatTypes2 objectAtIndex:i];
            [tableData addObject:food.foodName];
            [tableSublabelData addObject:food.brief];
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
        
        // THIS WILL NEED TO CHANGE
        NSString *nameValue = [tableData objectAtIndex:indexPath.row];
        ThumbnailLookup *thumbnailToUse = [[ThumbnailLookup alloc] init];
        
        for (int i=0; i<[eatsThumbnails count]; i++){
            ThumbnailLookup *thumbnailLookup = [eatsThumbnails objectAtIndex:i];
            if([thumbnailLookup.identifier isEqualToString:nameValue]){
                // Then this is the one to use
                thumbnailToUse = thumbnailLookup;
            }
        }
        
        
        //        ThumbnailLookup *thumbnailLookup = [attractionsThumbnails objectAtIndex:indexPath.row];
        cell.thumbnailImageView.image = [UIImage imageNamed:thumbnailToUse.photoName];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        return cell;
    }
    return nil;
}

// Table View Did Select
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == eatsListingTable1){
        selectedRow = indexPath.row;
        Food *selection = [eatTypes1 objectAtIndex:selectedRow];
        [self foodClicked:selection];
    } else if (tableView == eatsListingTable2){
        selectedRow = indexPath.row;
        Food *selection = [eatTypes2 objectAtIndex:selectedRow];
        [self foodClicked:selection];
    }
}

// Table View Row Height
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 80;
}

# pragma Actions

// Food Action
- (IBAction) foodClicked: (Food*) food
{
    EatsViewController *eatListing = [[EatsViewController alloc] initWithNibName:@"EatsViewController" bundle:nil];
    
    [eatListing setTitle:@"Eats"];
    [eatListing setTitleValue:@"Eats"];
    [eatListing setFood:food];
//    [eatListing setCurrentIndex:selectedRow];
    [eatListing setFromMap:0];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController pushViewController:eatListing animated:YES];
}

- (IBAction)segmentSelection:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        eatsListingTable1.hidden = NO;
        eatsListingTable2.hidden = YES;
        //        [UIView animateWithDuration:(0.5) animations:^{
        //
        //            self.containerEat.alpha = 1;
        //            self.containerDrink.alpha = 0;
        //            self.containerAttraction.alpha = 0;
        //        }];
    } else if (sender.selectedSegmentIndex == 1){
        eatsListingTable1.hidden = YES;
        eatsListingTable2.hidden = NO;
        //        [UIView animateWithDuration:(0.5) animations:^{
        //            self.containerEat.alpha = 0;
        //            self.containerDrink.alpha = 1;
        //            self.containerAttraction.alpha = 0;
        //        }];
    }
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

- (IBAction)loadCurrency
{
    CurrencyConverter *cc = [[CurrencyConverter alloc] initWithNibName:@"CurrencyConverter" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:cc animated:YES];
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
