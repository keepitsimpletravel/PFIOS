//
//  MapAnnotation.h
//
//  Created by Ashley Templeman on 24/02/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>
{

}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location Type:(NSInteger)type;
- (MKAnnotationView *)annotationView;

@end