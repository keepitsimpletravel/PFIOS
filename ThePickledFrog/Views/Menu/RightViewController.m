//
//  RightViewController.m
//  SWRevealSample
//
//  Created by DilumNavanjana on 31/3/14.
//  Copyright (c) 2014 DilumNavanjana. All rights reserved.
//

#import "RightViewController.h"
#import "HomeViewController.h"
#import "SWRevealViewController.h"
//#import "ChatViewController.h"
//#import "Reachability.h"
//#import "UIView+Toast.h"
//#import "DataSource.h"
#import "Noticeboard2.h"
#import "HostelDetailsViewController.h"
#import "EatsListing.h"
#import "DrinksListing.h"
#import "AttractionsListing.h"
#import "LoadWebViewController.h"
#import "DeveloperViewController.h"
#import "FeedbackViewController.h"
//#import "NetworkListingViewController.h"
//#import "TravelTipsViewController.h"
#import "ContactViewController.h"

@interface RightViewController ()

@end

#pragma mark - UIViewController(SWRevealViewController) Category

@implementation UIViewController(SWRevealViewController)

- (SWRevealViewController*)revealViewController
{
    UIViewController *parent = self;
    Class revealClass = [SWRevealViewController class];
    while ( nil != (parent = [parent parentViewController]) && ![parent isKindOfClass:revealClass] ) {}
    return (id)parent;
}

@end

@implementation RightViewController
{
    NSArray *types;
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
    
    // Set from Configuration PList
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];

    options = [configurationValues objectForKey:@"MenuOptions"];

    // Set Screen Dimensions
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    // Add Tableview programmatically
    NSInteger startPoint = screenWidth/5;//60;
    NSInteger endPoint = (screenWidth/5)*3;//200;

    UIView *headingView = [[UIView alloc] initWithFrame:CGRectMake(startPoint, 0, endPoint, 30)];

    UILabel *headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, endPoint, 30)];
    headingLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    headingLabel.textAlignment = NSTextAlignmentCenter;
    headingLabel.text = @"MENU";
    [headingView addSubview:headingLabel];

    [self.view addSubview:headingView];

    tableView = [[UITableView alloc] initWithFrame:CGRectMake(startPoint, 30, endPoint, screenHeight)];

    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.visible = NO;
    [super viewWillDisappear:animated];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

# pragma Table View

// Table View - Number of Rows
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [options count];
}

- (void)setVisible:(BOOL)visible {
    _visible = visible;
    [self setNeedsStatusBarAppearanceUpdate];
}

// Set up Cells and Rows for Table View
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSString *value = [options objectAtIndex:indexPath.row];
    cell.textLabel.text = value;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

// Did Select Action for Table View
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Determine which item was selected here
    selection = [indexPath row];

    if (selection == 0){
        HomeViewController *hostelVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:hostelVC];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    }
    else if (selection == 1){
        // About Our Hostel
        HostelDetailsViewController *hostelVC = [[HostelDetailsViewController alloc] initWithNibName:@"HostelDetailsViewController" bundle:nil];
        [hostelVC setFromMenu:1];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:hostelVC];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    }
    else if (selection == 2){
        EatsListing *eats = [[EatsListing alloc] initWithNibName:@"EatsListing" bundle:nil];
        [eats setFromMenu:1];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:eats];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    }
    else if (selection == 3){
        DrinksListing *drinks = [[DrinksListing alloc] initWithNibName:@"DrinksListing" bundle:nil];
        [drinks setFromMenu:1];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:drinks];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    }
    else if (selection == 4){
        AttractionsListing *acts = [[AttractionsListing alloc] initWithNibName:@"AttractionsListing" bundle:nil];
        [acts setFromMenu:1];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:acts];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    }
    else if (selection == 5){
        // Get Config Values
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
        NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
        dataSource = [DataSource dataSource];
        Detail *details = [dataSource getHostelDetails];
        
        NSString *webURL = details.bookingLink;
        
        LoadWebViewController *loadWebVC = [[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil];
        [loadWebVC setURL:webURL];
        [loadWebVC setFromMenu:1];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
        [loadWebVC setTitleValue:appTitle];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loadWebVC];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    }
    else if (selection == 6){
        // NOTICEBOARD
        Noticeboard2 *chat = [[Noticeboard2 alloc] initWithNibName:@"Noticeboard2" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chat];

        [self.navigationController pushViewController:chat animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    }
    else if (selection == 7){
        // Contact
        dataSource = [DataSource dataSource];
        Detail *detail = [dataSource getHostelDetails];
        ContactViewController *contactVC = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
        [contactVC setDetail:detail];
        [contactVC setFromMenu:1];

        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contactVC];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    }
    else if (selection == 8){
        // FEEDBACK
        FeedbackViewController *feedVC = [[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:nil];
        [feedVC setFromMenu:1];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedVC];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    }
    else if (selection == 9){
        DeveloperViewController *developer = [[DeveloperViewController alloc] initWithNibName:@"DeveloperViewController" bundle:nil];
        [developer setFromMenu:1];
        // Might be able to get the stack for the front view controller
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:developer];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    }
}

// Set Row Height for Table View
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 55;
}

# pragma Phone Setup

// Set Phone Orientation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
}

@end
