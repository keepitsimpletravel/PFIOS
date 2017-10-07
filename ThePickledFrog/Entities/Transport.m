//
//  Transport.m
//  HostelBlocks
//
//  Created by Ashley Templeman on 5/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import "Transport.h"

@implementation Transport

@synthesize name, blurb, description, type, longitude, latitude;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

- (id)initWithData:(NSString *)typ nm:(NSString *)nme bri:(NSString*)blu ddesc:(NSString *)desc lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la
{
    self.name = nme;
    self.description = desc;
    self.blurb = blu;
    self.type = typ;
    self.longitude = lo;
    self.latitude = la;
    
    return self;
}

@end
