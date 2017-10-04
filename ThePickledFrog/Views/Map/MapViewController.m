//
//  MapViewController.m
//
//  Created by Ashley Templeman on 27/01/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapViewController.h"
#import "MapEntity.h"
#import "MapAnnotation.h"
#import "HostelDetailsViewController.h"
#import "EatsViewController.h"
#import "DrinksViewController.h"
#import "AttractionViewController.h"
#import "SWRevealViewController.h"

@interface MapViewController ()

@end

#define METERS_PER_MILE 1609.344

@implementation MapViewController

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Action for when the view appears
- (void)viewWillAppear:(BOOL)animated {
    // Set the default starting point and the map view
    CLLocationCoordinate2D zoomLocation;

    NSString *longString = [NSString stringWithFormat:@"%.6lf", [longitude doubleValue]];
    double longValue = longString.doubleValue;
    
    zoomLocation.longitude = longValue;
    
    NSString *latString = [NSString stringWithFormat:@"%.6lf", [latitude doubleValue]];
    double latValue = latString.doubleValue;
    zoomLocation.latitude = latValue;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [mapView setRegion:viewRegion animated:NO];
    mapView.delegate = self;
    
    // Get the information from the database
    dataSource = [DataSource dataSource];
    allFoods = [dataSource getAllFoods];
    allDrinks = [dataSource getAllDrinks];
    allAttractions = [dataSource getAllActivities];
    
    // Setting of the Flags used to toggle links
//    hostelFlag = 0;
    drinkFlag = 0;
    foodFlag = 0;
    activityFlag = 0;
}

// View Did Load Function
- (void)viewDidLoad
{
    // Screen Setup
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    navigationBarHeight = 44;
    bottomTabBarHeight = 49;
    
    if(screenWidth <= 320){
        toolbarSpace = ((screenWidth - 150) / 6);
    } else if (screenWidth == 375){
        toolbarSpace = ((screenWidth - 150) / 6);
    } else if (screenWidth == 414){
        toolbarSpace = ((screenWidth - 150) / 6);
    } else if (screenWidth == 768){
        toolbarSpace = ((screenWidth - 150) / 6);
    }
    
    // Get Config Values
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    //NSString *headingFont = [configurationValues objectForKey:@"HeadingFont"];
    
    NSString *titleValue = @"MAP";
    UIFont* titleFont = [UIFont fontWithName:@"OpenSans-CondensedBold" size:24];
    CGSize requestedTitleSize = [titleValue sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    CGFloat titleWidth = MIN(screenWidth, requestedTitleSize.width);
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, 20)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:24];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.text = titleValue;
    self.navigationItem.titleView = navLabel;
    
    // Set the Line RGB from the configuration file
    NSString *lineR = [configurationValues objectForKey:@"LineRed"];
    NSInteger lineRed = [lineR integerValue];
    
    NSString *lineG = [configurationValues objectForKey:@"LineGreen"];
    NSInteger lineGreen = [lineG integerValue];
    
    NSString *lineB = [configurationValues objectForKey:@"LineBlue"];
    NSInteger lineBlue = [lineB integerValue];
    
    // Black Line
    UIView *lineViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 2)];
    lineViewOne.backgroundColor = Rgb2UIColor(lineRed, lineGreen, lineBlue);
    [self.view addSubview:lineViewOne];
    
    // Toolbar
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *fixedSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                  target:nil
                                                  action:nil];
    fixedSpace.width = toolbarSpace;

    [items addObject:fixedSpace];
    // Directions
//    NSString *imageValue = @"mapDirections.png";
//
//    UIImage *directionsImage = [UIImage imageNamed:imageValue];
//    UIButton *directionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    // Need to determine the height of the image
//    directionsButton.bounds = CGRectMake(0, 0, 30, 30);
//    [directionsButton setImage:directionsImage forState:UIControlStateNormal];
//    UIBarButtonItem *directionsItem = [[UIBarButtonItem alloc] initWithCustomView:directionsButton];
//    [directionsButton addTarget:self
//                      action:@selector(showDirections:)
//            forControlEvents:UIControlEventTouchUpInside];
//
//    [items addObject:directionsItem];
//    [items addObject:fixedSpace];

    // Eats
    NSString *imageValue = @"eatingmap.png";
    
    UIImage *eatImage = [UIImage imageNamed:imageValue];
    UIButton *eatButton = [UIButton buttonWithType:UIButtonTypeCustom];

    eatButton.bounds = CGRectMake(0, 0, 30, 30);
    [eatButton setImage:eatImage forState:UIControlStateNormal];
    UIBarButtonItem *eatItem = [[UIBarButtonItem alloc] initWithCustomView:eatButton];
    [eatButton addTarget:self
                       action:@selector(displayAllFoodPins)
             forControlEvents:UIControlEventTouchUpInside];

    [items addObject:eatItem];
    [items addObject:fixedSpace];

    // Drinks
    imageValue = @"drinkingmap.png";
    
    UIImage *drinkImage = [UIImage imageNamed:imageValue];
    UIButton *drinkButton = [UIButton buttonWithType:UIButtonTypeCustom];

    drinkButton.bounds = CGRectMake(0, 0, 30, 30);
    [drinkButton setImage:drinkImage forState:UIControlStateNormal];
    UIBarButtonItem *drinkItem = [[UIBarButtonItem alloc] initWithCustomView:drinkButton];
    [drinkButton addTarget:self
                      action:@selector(displayAllDrinkPins)
            forControlEvents:UIControlEventTouchUpInside];

    [items addObject:drinkItem];
    [items addObject:fixedSpace];

    // Attractions
    imageValue = @"attractionmap.png";

    UIImage *attractionImage = [UIImage imageNamed:imageValue];
    UIButton *attractionsButton = [UIButton buttonWithType:UIButtonTypeCustom];

    attractionsButton.bounds = CGRectMake(0, 0, 30, 30);
    [attractionsButton setImage:attractionImage forState:UIControlStateNormal];
    UIBarButtonItem *attractionsItem = [[UIBarButtonItem alloc] initWithCustomView:attractionsButton];
    [attractionsButton addTarget:self
                   action:@selector(displayAllAttractionPins)
         forControlEvents:UIControlEventTouchUpInside];

    [items addObject:attractionsItem];
    [items addObject:fixedSpace];
    
    // Hostel
    imageValue = @"mapHostelIcon.png";

    UIImage *hostelImage = [UIImage imageNamed:imageValue];
    UIButton *hostelButton = [UIButton buttonWithType:UIButtonTypeCustom];

    hostelButton.bounds = CGRectMake(0, 0, 30, 30);
    [hostelButton setImage:hostelImage forState:UIControlStateNormal];
    UIBarButtonItem *hostelItem = [[UIBarButtonItem alloc] initWithCustomView:hostelButton];
    [hostelButton addTarget:self
                          action:@selector(displayHostelPosition)
                forControlEvents:UIControlEventTouchUpInside];

    [items addObject:hostelItem];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, screenHeight-49, screenWidth, 49);
    [toolbar setItems:items animated:NO];
    toolbar.barTintColor = Rgb2UIColor(236, 240, 241);
    [self.view addSubview:toolbar];
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 66, screenWidth, screenHeight-53-64)];
    mapView.delegate = self;
    
    // Black Line
    UIView *lineViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-51, screenWidth, 2)];
    lineViewTwo.backgroundColor = Rgb2UIColor(0, lineGreen, lineBlue);
    [self.view addSubview:lineViewTwo];
    
    // Button on the MapView
    UIButton *locButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locButton setFrame:CGRectMake(10, mapView.bounds.size.height - 70, 30, 60)];
    [locButton addTarget:self action:@selector(showLocation) forControlEvents:UIControlEventTouchUpInside];
    [locButton setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [mapView addSubview:locButton];

    [self.view addSubview:mapView];

    // Determine the type that was selected
    if (displayType == 0){
        [self displayHostelPosition:hostelDetails];
        hostelFlag = 1;
    }
    else if (displayType == 2){
        [self displayDrinkPosition:drink];
        hostelFlag = 0;
    } else if (displayType == 3){
        [self displayFoodPosition:eat];
        hostelFlag = 0;
    } else if (displayType == 4){
        [self displayActivityPosition:activity];
        hostelFlag = 0;
    }

    // Set the flags and status for the map display
    locationStatus = 0;
    pinStatus = 0;
    directionStatus = 0;
    originalSelecion = displayType;

    pinCount = 0;
    
    //SWReveal Slider
    SWRevealViewController *revealController = [self revealViewController];
    
    //     Add an image to your project & set that image here.
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburgermenu.png"]
                                                                              style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
}

# pragma Pin Display

// Displaying Hostel Pin
- (void)displayHostelPosition {
    if (hostelFlag == 1){
        for (MapAnnotation *annotation in mapView.annotations){
            if(annotation.type == 0){
                [mapView removeAnnotation:annotation];
            }
        }
        hostelFlag = 0;
    } else {
        hostelFlag = 1;
        
        Detail *details = [dataSource getHostelDetails];
        NSDecimalNumber *latitude = details.latitude;
        NSString *latString = [NSString stringWithFormat:@"%.6lf", [latitude doubleValue]];
        double latValue = latString.doubleValue;
        
        NSDecimalNumber *longitude = details.longitude;
        NSString *longString = [NSString stringWithFormat:@"%.6lf", [longitude doubleValue]];
        double longValue = longString.doubleValue;
        
        NSString *title = details.name;
        NSString *address = details.address;
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latValue;
        coordinate.longitude = longValue;
        
        MapAnnotation *point = [[MapAnnotation alloc] initWithTitle:title Location:coordinate Type:0];
        [mapView addAnnotation:point];
        
        
    }
}

// Displaying Specific Hostel Pin
- (void)displayHostelPosition:(Detail *)details {
    if (hostelFlag == 1){
        for (MapAnnotation *annotation in mapView.annotations){
            if(annotation.type == 0){
                [mapView removeAnnotation:annotation];
            }
        }
        hostelFlag = 0;
    } else {
        NSDecimalNumber *latitude = details.latitude;
        NSString *latString = [NSString stringWithFormat:@"%.6lf", [latitude doubleValue]];
        double latValue = latString.doubleValue;
    
        NSDecimalNumber *longitude = details.longitude;
        NSString *longString = [NSString stringWithFormat:@"%.6lf", [longitude doubleValue]];
        double longValue = longString.doubleValue;
    
        NSString *title = details.name;
        NSString *address = details.address;
    
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latValue;
        coordinate.longitude = longValue;
    
        MapAnnotation *point = [[MapAnnotation alloc] initWithTitle:title Location:coordinate Type:0];
        [mapView addAnnotation:point];
        
        hostelFlag = 1;
    }
    
    
}

// Display Drink Pins
- (void)displayDrinkPosition:(Drink *)drinkEntity {
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
    NSDecimalNumber *latitude = drinkEntity.latitude;
    NSString *latString = [NSString stringWithFormat:@"%.6lf", [latitude doubleValue]];
    double latValue = latString.doubleValue;
    
    NSDecimalNumber *longitude = drinkEntity.longitude;
    NSString *longString = [NSString stringWithFormat:@"%.6lf", [longitude doubleValue]];
    double longValue = longString.doubleValue;
    
    NSString *title = drinkEntity.drinkName;
    NSString *address = drinkEntity.address;
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latValue;
    coordinate.longitude = longValue;
    
    MapAnnotation *point = [[MapAnnotation alloc] initWithTitle:title Location:coordinate Type:3];
    [mapView addAnnotation:point];
}

// Display Food Pins
- (void)displayFoodPosition:(Food *)foodEntity {
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
    NSDecimalNumber *latitude = foodEntity.latitude;
    NSString *latString = [NSString stringWithFormat:@"%.6lf", [latitude doubleValue]];
    double latValue = latString.doubleValue;
    
    NSDecimalNumber *longitude = foodEntity.longitude;
    NSString *longString = [NSString stringWithFormat:@"%.6lf", [longitude doubleValue]];
    double longValue = longString.doubleValue;
    
    NSString *title = foodEntity.foodName;
    NSString *address = foodEntity.address;
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latValue;
    coordinate.longitude = longValue;
    
    MapAnnotation *point = [[MapAnnotation alloc] initWithTitle:title Location:coordinate Type:2];
    [mapView addAnnotation:point];
}

// Display Activity Pins
- (void)displayActivityPosition:(Activity *)act {
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
    NSDecimalNumber *latitude = act.latitude;
    NSString *latString = [NSString stringWithFormat:@"%.6lf", [latitude doubleValue]];
    double latValue = latString.doubleValue;
    
    NSDecimalNumber *longitude = act.longitude;
    NSString *longString = [NSString stringWithFormat:@"%.6lf", [longitude doubleValue]];
    double longValue = longString.doubleValue;
    
    NSString *title = act.activityName;
    NSString *address = act.address;
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latValue;
    coordinate.longitude = longValue;
    
    MapAnnotation *point = [[MapAnnotation alloc] initWithTitle:title Location:coordinate Type:4];
    [mapView addAnnotation:point];
}

# pragma Setting of Variables

// Setting the Longitude
- (void) setLongitude:(NSDecimalNumber *)value
{
    longitude = value;
}

// Setting the Latitude
- (void) setLatitude:(NSDecimalNumber *)value
{
    latitude = value;
}

// Set Hostel Details
- (void) setDetails:(Detail *)value
{
    hostelDetails = value;
    displayType = 0;
}

// Set Drinks
- (void) setDrink:(Drink *)value
{
    drink = value;
    displayType = 2;
}

// Set Eats
- (void) setFood:(Food *)value
{
    eat = value;
    displayType = 3;
}

// Set Activity
- (void) setActivity:(Activity *)value
{
    activity = value;
    displayType = 4;
}

# pragma - Actions

// Function to show the directions to a specific pin
- (IBAction)showDirections:(UIBarButtonItem *)sender
{
    MKPlacemark *placemark;
    // Need to add a check for
    // Get the users location
    if(directionStatus == 0 && pinStatus == 0){
        UIButton *directionOff = [UIButton buttonWithType:UIButtonTypeCustom];
        [directionOff setFrame:CGRectMake(directionsStart, 10, 107, 28)];
        [directionOff addTarget:self action:@selector(showDirections:) forControlEvents:UIControlEventTouchUpInside];
        [directionOff setImage:[UIImage imageNamed:@"mapDirections.png"] forState:UIControlStateNormal];
        
        routeBarButton = [[UIBarButtonItem alloc] initWithCustomView:directionOff];
        
        // update the toolbar with the items
        [self setToolbarItems:[NSArray arrayWithObjects:backBarButton, flexibleSpace, routeBarButton, flexibleSpace, allPinBarButton, nil]];
        
        if (displayType == 0){
            // hostel
        
//        double latitude = -43.028433;
//        double longitude = 147.267367;
            double latitude = [hostelDetails.latitude doubleValue];
            double longitude = [hostelDetails.longitude doubleValue];
            placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) addressDictionary:nil];
        } else if (displayType == 2){
            // drink
            NSString *latitudeString = [NSString stringWithFormat:@"%.6lf", [drink.latitude doubleValue]];
            double latitude = [latitudeString doubleValue];
        
            NSString *longitudeString = [NSString stringWithFormat:@"%.6lf", [drink.longitude doubleValue]];
            double longitude = [longitudeString doubleValue];
            placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) addressDictionary:nil];
        } else if (displayType == 3){
            // eat
            NSString *latitudeString = [NSString stringWithFormat:@"%.6lf", [eat.latitude doubleValue]];
            double latitude = [latitudeString doubleValue];
        
            NSString *longitudeString = [NSString stringWithFormat:@"%.6lf", [eat.longitude doubleValue]];
            double longitude = [longitudeString doubleValue];
            placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) addressDictionary:nil];
        } else if (displayType == 4){
            // activity
            NSString *latitudeString = [NSString stringWithFormat:@"%.6lf", [activity.latitude doubleValue]];
            double latitude = [latitudeString doubleValue];
        
            NSString *longitudeString = [NSString stringWithFormat:@"%.6lf", [activity.longitude doubleValue]];
            double longitude = [longitudeString doubleValue];
            placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) addressDictionary:nil];
        }
    
        MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    
        [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
        [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
        directionsRequest.transportType = MKDirectionsTransportTypeWalking;
        MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Error %@", error.description);
                UIButton *directionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [directionsButton setFrame:CGRectMake(directionsStart, 10, 107, 28)];
                [directionsButton addTarget:self action:@selector(showDirections:) forControlEvents:UIControlEventTouchUpInside];
                [directionsButton setImage:[UIImage imageNamed:@"mapDirections.png"] forState:UIControlStateNormal];
                
                routeBarButton = [[UIBarButtonItem alloc] initWithCustomView:directionsButton];
                directionStatus = 0;
                
                // update the toolbar with the items
                [self setToolbarItems:[NSArray arrayWithObjects:backBarButton, flexibleSpace, routeBarButton, flexibleSpace, allPinBarButton, nil]];
                
                // Display Message stating no path could be found
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No route could be found." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                [alert show];
                
                
            } else {
                routeDetails = response.routes.lastObject;
                [mapView addOverlay:routeDetails.polyline];
            }
        }];
        directionStatus = 1;
    } else {
        if (directionStatus == 0 && pinStatus == 1){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please turn off all pins to display a single point to accurately determine directions." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alert show];
        }
        directionStatus = 0;
        [mapView removeOverlay:routeDetails.polyline];

        UIButton *directionOff = [UIButton buttonWithType:UIButtonTypeCustom];
        [directionOff setFrame:CGRectMake(directionsStart, 10, 107, 28)];
        [directionOff addTarget:self action:@selector(showDirections:) forControlEvents:UIControlEventTouchUpInside];
        [directionOff setImage:[UIImage imageNamed:@"directionsMap.png"] forState:UIControlStateNormal];
        
        routeBarButton = [[UIBarButtonItem alloc] initWithCustomView:directionOff];
        
        // update the toolbar with the items
        [self setToolbarItems:[NSArray arrayWithObjects:backBarButton, flexibleSpace, routeBarButton, flexibleSpace, allPinBarButton, nil]];
    }
}

# pragma Map Functions

// Rendering the Routing
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeDetails.polyline];
    routeLineRenderer.strokeColor = [UIColor redColor];
    routeLineRenderer.lineWidth = 5;
    return routeLineRenderer;
}

// Display the users location
- (IBAction)showLocation
{
    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    if(locationStatus == 0){
        locationStatus = 1;
        locationButton.title = @"Loc Off";
        mapView.showsUserLocation = YES;
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        
        [locationManager startUpdatingLocation];

    } else if (locationStatus == 1){
        locationStatus = 0;
        locationButton.title = @"Loc On";
        
        [locationManager stopUpdatingLocation];
        
        // need to hide the user location...
        mapView.showsUserLocation = NO;
    }
}

// Update the Users Location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
    
    CLLocation *location = [locations objectAtIndex:0];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 800, 800);
    [mapView setRegion:[mapView regionThatFits:region] animated:NO];
}

# pragma Display All Pins

// Display all Food Pins
- (void)displayAllFoodPins {
    if (foodFlag == 1){
        for (MapAnnotation *annotation in mapView.annotations){
            if(annotation.type == 2){
                [mapView removeAnnotation:annotation];
            }
        }
        foodFlag = 0;
    } else {
        NSInteger count = [allFoods count];
        for (int i = 0; i<count; i++) {
            Food *eatEntity = allFoods[i];
        
            NSDecimalNumber *latitude = eatEntity.latitude;
            NSString *latString = [NSString stringWithFormat:@"%.6lf", [latitude doubleValue]];
            double latValue = latString.doubleValue;
            
            NSDecimalNumber *longitude = eatEntity.longitude;
            NSString *longString = [NSString stringWithFormat:@"%.6lf", [longitude doubleValue]];
            double longValue = longString.doubleValue;
            
            NSString *title = eatEntity.foodName;
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = latValue;
            coordinate.longitude = longValue;
            
            MapAnnotation *point = [[MapAnnotation alloc] initWithTitle:title Location:coordinate Type:2];
            [mapView addAnnotation:point];
        }
        CLLocationCoordinate2D zoomLocation = mapView.region.center;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
        [mapView setRegion:viewRegion animated:YES];
        
        foodFlag = 1;
    }
}

// Display all Drink Pins
- (void)displayAllDrinkPins {
    if (drinkFlag == 1){
        for (MapAnnotation *annotation in mapView.annotations){
            if(annotation.type == 3){
                [mapView removeAnnotation:annotation];
            }
        }
        drinkFlag = 0;
    } else {
        NSInteger count = [allDrinks count];
        for (int i = 0; i<count; i++) {
            Drink *drinkEntity = allDrinks[i];
        
            NSDecimalNumber *latitude = drinkEntity.latitude;
            NSString *latString = [NSString stringWithFormat:@"%.6lf", [latitude doubleValue]];
            double latValue = latString.doubleValue;
        
            NSDecimalNumber *longitude = drinkEntity.longitude;
            NSString *longString = [NSString stringWithFormat:@"%.6lf", [longitude doubleValue]];
            double longValue = longString.doubleValue;
        
            NSString *title = drinkEntity.drinkName;
        
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = latValue;
            coordinate.longitude = longValue;
        
            MapAnnotation *point = [[MapAnnotation alloc] initWithTitle:title Location:coordinate Type:3];
            [mapView addAnnotation:point];
        }
        CLLocationCoordinate2D zoomLocation = mapView.region.center;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
        [mapView setRegion:viewRegion animated:YES];
        
        drinkFlag = 1;
    }
}

// Display all Attactions Pins
- (void)displayAllAttractionPins {
    if (activityFlag == 1){
        for (MapAnnotation *annotation in mapView.annotations){
            if(annotation.type == 4){
                [mapView removeAnnotation:annotation];
            }
        }
        activityFlag = 0;
    } else {
        NSInteger count = [allAttractions count];
        for (int i = 0; i<count; i++) {
            Activity *act = allAttractions[i];
            NSDecimalNumber *latitude = act.latitude;
            NSString *latString = [NSString stringWithFormat:@"%.6lf", [latitude doubleValue]];
            double latValue = latString.doubleValue;
            
            NSDecimalNumber *longitude = act.longitude;
            NSString *longString = [NSString stringWithFormat:@"%.6lf", [longitude doubleValue]];
            double longValue = longString.doubleValue;
            
            NSString *title = act.activityName;
            NSString *address = act.address;
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = latValue;
            coordinate.longitude = longValue;
            
            MapAnnotation *point = [[MapAnnotation alloc] initWithTitle:title Location:coordinate Type:4];
            [mapView addAnnotation:point];
        }
        
        CLLocationCoordinate2D zoomLocation = mapView.region.center;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
        [mapView setRegion:viewRegion animated:YES];
        
        activityFlag = 1;
    }
}

// Display All Pins - Currently not in use
- (void)displayMapEntityPins:(NSArray *)entities {
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
    NSInteger count = [entities count];
    for (int i = 0; i<count; i++) {
        MapEntity *mapEntity = entities[i];
        
        NSDecimalNumber *latitude = mapEntity.latitude;
        NSString *latString = [NSString stringWithFormat:@"%.6lf", [latitude doubleValue]];
        double latValue = latString.doubleValue;
        
        NSDecimalNumber *longitude = mapEntity.longitude;
        NSString *longString = [NSString stringWithFormat:@"%.6lf", [longitude doubleValue]];
        double longValue = longString.doubleValue;
        
        NSString *title = mapEntity.name;
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latValue;
        coordinate.longitude = longValue;
        
        MapAnnotation *point = [[MapAnnotation alloc] initWithTitle:title Location:coordinate Type:mapEntity.type];
        [mapView addAnnotation:point];
    }
    
    CLLocationCoordinate2D zoomLocation = mapView.region.center;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
    [mapView setRegion:viewRegion animated:YES];
}

# pragma Map Annotations

// Creation of the Map Annotation for Map Views
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MapAnnotation class]])
    {
        MapAnnotation *pinLocation = (MapAnnotation *)annotation;
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapAnnotation"];
        
        if(annotationView == nil)
        {
            annotationView = pinLocation.annotationView;
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    } else {
        return nil;
    }
}

// Display Map Annotaction
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"accessory button tapped for annotation %@", view.annotation);
    
    MapAnnotation *selection = view.annotation;
    NSInteger type = selection.type;
    
    if (type == 0){
        // details
        HostelDetailsViewController *hdListing = [[HostelDetailsViewController alloc] initWithNibName:@"HostelDetailsViewController" bundle:nil];
        [hdListing setTitle:@"Hostel Details"];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationController.toolbarHidden=YES;
        [self.navigationController pushViewController:hdListing animated:YES];
    } else if (type == 2){
        // Food
        EatsViewController *eatsListing = [[EatsViewController alloc] initWithNibName:@"EatsViewController" bundle:nil];
        
        Food *eatValue = [dataSource getFoodByName:selection.title];
        
        [eatsListing setTitle:@"Eats"];
        [eatsListing setTitleValue:@"Eats"];
        [eatsListing setFood:eatValue];
        [eatsListing setFromMap:1];
        [eatsListing setFoodFromMap:eatValue];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationController.toolbarHidden=YES;
        
        [self.navigationController pushViewController:eatsListing animated:YES];
    } else if (type == 3){
        // Drink
        DrinksViewController *drinkListing = [[DrinksViewController alloc] initWithNibName:@"DrinksViewController" bundle:nil];
        
        Drink *drinkValue = [dataSource getDrinkByName:selection.title];
        
        [drinkListing setTitle:@"Drinks"];
        [drinkListing setTitleValue:@"Drinks"];
        [drinkListing setDrink:drinkValue];
        [drinkListing setFromMap:1];
        [drinkListing setDrinkFromMap:drinkValue];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationController.toolbarHidden=YES;
        
        [self.navigationController pushViewController:drinkListing animated:YES];
    } else if (type == 4){
        // Attraction
        AttractionViewController *attractionListing = [[AttractionViewController alloc] initWithNibName:@"AttractionViewController" bundle:nil];
        
        Activity *actValue = [dataSource getActivityByName:selection.title];
        
        [attractionListing setTitle:@"Attractions"];
        [attractionListing setTitleValue:@"Attractions"];
        [attractionListing setActivity:actValue];
        [attractionListing setFromMap:1];
        [attractionListing setActivityFromMap:actValue];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationController.toolbarHidden=YES;
        
        [self.navigationController pushViewController:attractionListing animated:YES];
    }
}

# pragma Phone Setup

// Setting the phone orientation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
}

# pragma Button Actions

// Home Action
- (IBAction)backToHome
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
