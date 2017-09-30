//
//  Drink.m
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import "Drink.h"

@implementation Drink

@synthesize description, description2, description3, address, drinkName, website, longitude, latitude, phone, drinkBrief, taLink, openingHours, closestStop, facebookURL, twitterURL, gettingThere, instaURL;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(id)initWithData:(NSString *)name ddesc:(NSString *)desc ddesc2:(NSString *)desc2 ddesc3:(NSString *)desc3 dadd:(NSString *)add web:(NSString *)ws lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la phoneNumber:(NSString *)ph brief:(NSString *)db face:(NSString *)fURL tal:(NSString *)link opening:(NSString *)oh insta:(NSString*)iURL getting:(NSString*)gt closest:(NSString*)cs twitter:(NSString*)tURL
{
    self.drinkName = name;
    self.description = desc;
    self.description2 = desc2;
    self.description3 = desc3;
    self.address = add;
    self.website = ws;
    self.longitude = lo;
    self.latitude = la;
    self.phone = ph;
    self.drinkBrief = db;
    self.facebookURL = fURL;
    self.taLink = link;
    self.openingHours = oh;
    self.instaURL = iURL;
    self.gettingThere = gt;
    self.closestStop = cs;
    self.twitterURL = tURL;
    
    return self;
}

@end
