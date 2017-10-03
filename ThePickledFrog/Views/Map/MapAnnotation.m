//
//  MapAnnotation.m
//
//  Created by Ashley Templeman on 24/02/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

- (id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location Type:(NSInteger)type
{
    if(self)
    {
        _title = newTitle;
        _coordinate = location;
        _type = type;
    }
    
    return self;
}

// Creating the Annotation View
- (MKAnnotationView *)annotationView
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    if (_type == 0){
//        annotationView.image = [UIImage imageNamed:@"detailsPin.png"];
        annotationView.image = [UIImage imageNamed:@"mapHostelIcon.png"];
    } else if (_type == 2){
        annotationView.image = [UIImage imageNamed:@"mapEats.png"];
    } else if (_type == 3){
        annotationView.image = [UIImage imageNamed:@"mapDrink.png"];
    } else if (_type == 4){
        annotationView.image = [UIImage imageNamed:@"mapAttractions.png"];
    }

    if (_type != 5){
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    return annotationView;
}



@end
