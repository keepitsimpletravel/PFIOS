//
//  PhotoLookup.m
//
//  Created by Ashley Templeman on 8/01/2017.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import "PhotoLookup.h"

@implementation PhotoLookup

@synthesize identifier, photoName, orderNumber, area;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(id)initWithData:(NSString *)are identifier:(NSString *)idt namw:(NSString *)pn order:(NSInteger)ord
{
    self.area  = are;
    self.identifier = idt;
    self.orderNumber = ord;
    self.photoName = pn;
    
    return self;
}

@end