//
//  Food.m
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import "Food.h"

@implementation Food

@synthesize foodName, description, description2, description3, address, website, longitude, latitude, phone, brief, taLink, openingHours, gettingThere, instaURL, facebookURL, twitterURL, closestStop;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(id)initWithData:(NSString *)name ddesc:(NSString *)desc ddesc2:(NSString *)desc2 ddesc3:(NSString *)desc3 dadd:(NSString *)add web:(NSString *)ws lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la phoneNumber:(NSString *)ph br:(NSString *)fb open:(NSString *)oh tal:(NSString *)link getting:(NSString*)gt insta:(NSString*)iURL closest:(NSString*)cs face:(NSString*)fURL twit:(NSString*)twURL
{
    self.foodName = name;
    self.description = desc;
    self.description2 = desc2;
    self.description3 = desc3;
    self.address = add;
    self.website = ws;
    self.longitude = lo;
    self.latitude = la;
    self.phone = ph;
    self.brief = fb;
    self.openingHours = oh;
    self.taLink = link;
    self.gettingThere = gt;
    self.instaURL = iURL;
    self.closestStop = cs;
    self.facebookURL = fURL;
    self.twitterURL = twURL;
    
    return self;
}

@end

