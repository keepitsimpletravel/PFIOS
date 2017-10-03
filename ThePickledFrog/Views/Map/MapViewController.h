//
//  MapViewController.h
//
//  Created by Ashley Templeman on 27/01/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    NSDecimalNumber *longitude;
    NSDecimalNumber *latitude;
    Detail *hostelDetails;
    Drink *drink;
    Food *eat;
    Activity *activity;
    NSArray *allServices;
    
    NSInteger displayType;

    CLLocationManager *locationManager;
    NSInteger locationStatus;
    UIBarButtonItem *locationButton;
    UIBarButtonItem *mapPinsButton;
    UIBarButtonItem *routeButton;
    NSInteger pinStatus;
    NSInteger directionStatus;
    NSInteger originalSelecion;
    
    id<DataSource> dataSource;
    
    NSArray *allPins;
    NSInteger pinCount;
    
    MKMapView *mapView;
    MKRoute *routeDetails;
    
    UIBarButtonItem *allPinBarButton;
    UIBarButtonItem *onePinBarButton;
    UIBarButtonItem *backBarButton;
    UIBarButtonItem *locationBarButton;
    UIBarButtonItem *routeBarButton;
    UIBarButtonItem *flexibleSpace;
    
    NSInteger directionsStart;
    NSInteger pinsStart;
    
    NSInteger navigationBarHeight;
    NSInteger bottomTabBarHeight;
    
    NSArray *allFoods;
    NSArray *allDrinks;
    NSArray *allAttractions;
    
    NSInteger foodFlag;
    NSInteger drinkFlag;
    NSInteger activityFlag;
    NSInteger hostelFlag;
    
    NSInteger toolbarSpace;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (void) setLongitude:(NSDecimalNumber *)value;
- (void) setLatitude:(NSDecimalNumber *)value;
- (void) setDetails:(Detail *)value;
- (void) setDrink:(Drink *)value;
- (void) setFood:(Food *)value;
- (void) setActivity:(Activity *)value;
- (void) setServices:(NSArray *)value;
- (IBAction) goBack;
- (IBAction) showLocation;
- (IBAction) showAllPins:(UIBarButtonItem *)sender;
- (IBAction) showDirections:(UIBarButtonItem *)sender;

@end