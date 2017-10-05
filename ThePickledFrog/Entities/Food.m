//
//  Food.m
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import "Food.h"

@implementation Food

@synthesize foodName, description, type, address, website, longitude, latitude, phone, brief, taLink, openingHours, instaURL, facebookURL;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(id)initWithData:(NSString *)typ nm:(NSString *)name ddesc:(NSString *)desc dadd:(NSString *)add web:(NSString *)ws lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la phoneNumber:(NSString *)ph br:(NSString *)fb open:(NSString *)oh tal:(NSString *)link insta:(NSString*)iURL face:(NSString*)fURL
{
    self.foodName = name;
    self.description = desc;
    self.type = typ;
    self.address = add;
    self.website = ws;
    self.longitude = lo;
    self.latitude = la;
    self.phone = ph;
    self.brief = fb;
    self.openingHours = oh;
    self.taLink = link;
    self.instaURL = iURL;
    self.facebookURL = fURL;
    
    return self;
}

@end

