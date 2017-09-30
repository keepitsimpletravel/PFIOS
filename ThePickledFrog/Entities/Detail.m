//
//  Detail.m
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import "Detail.h"

@implementation Detail

@synthesize name, description, address, email, phone, longitude, latitude, website, description2, instagramURL, twitterURL, facebookURL, tripAdvisorURL;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(id)initWithData:(NSString *)n ddesc:(NSString *)desc ddesc2:(NSString *)desc2 dadd:(NSString *)add dph:(NSString *)ph dem:(NSString *)em web:(NSString *)ws lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la ig:(NSString *)insta twit:(NSString *)twURL fb:(NSString *)faceURL ta:(NSString *)tripURL
{
    self.name = n;
    self.description = desc;
    self.description2 = desc2;
    self.address = add;
    self.email = em;
    self.phone = ph;
    self.website = ws;
    self.longitude = lo;
    self.latitude = la;
    self.instagramURL = insta;
    self.twitterURL = twURL;
    self.facebookURL = faceURL;
    self.tripAdvisorURL = tripURL;
    
    return self;
}

@end
