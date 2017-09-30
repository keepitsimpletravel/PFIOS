//
//  Activity.m
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import "Activity.h"

@implementation Activity

@synthesize description, description2, description3, address, activityName, website, longitude, latitude, phone, brief, taLink, facebookURL, twitterURL, openingHours, gettingThere, closestStop, instagramURL;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(id)initWithData:(NSString *)name ddesc:(NSString *)desc ddesc2:(NSString *)desc2 ddesc3:(NSString *)desc3 ddadd:(NSString *)add web:(NSString *)ws lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la phoneNumber:(NSString *)ph brie:(NSString *)ab tal:(NSString*)tlink insta:(NSString*)iurl open:(NSString*)oh getting:(NSString*)gt stop:(NSString*)cs face:(NSString*)furl twit:(NSString*)twURL
{
    self.activityName = name;
    self.description = desc;
    self.description2 = desc2;
    self.description3 = desc3;
    self.address = add;
    self.website = ws;
    self.longitude = lo;
    self.latitude = la;
    self.phone = ph;
    self.brief = ab;
    self.taLink = tlink;
    self.facebookURL = furl;
    self.openingHours = oh;
    self.gettingThere = gt;
    self.closestStop = cs;
    self.twitterURL = twURL;
    self.instagramURL = iurl;
    
    return self;
}

@end
