//
//  Room.m
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import "Room.h"

@implementation Room

@synthesize roomType, description, price;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

- (id)initWithData:(NSString *)rt description:(NSString*)desc pr:(NSString *)pric
{
    self.roomType = rt;
    self.description = desc;
    self.price = pric;
    
    return self;
}

@end
