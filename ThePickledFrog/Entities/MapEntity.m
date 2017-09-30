//
//  MapEntity.m
//
//  Created by Ashley Templeman on 24/02/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import "MapEntity.h"

@implementation MapEntity

@synthesize name, longitude, latitude, type;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(id)initWithData:(NSString *)nm lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la ty:(NSInteger)typ
{
    self.name = nm;
    self.longitude = lo;
    self.latitude = la;
    self.type = typ;
    
    return self;
}

@end
