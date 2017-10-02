//
//  Detail.m
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import "Detail.h"

@implementation Detail

@synthesize name, description, address, email, phone, longitude, latitude, website, bookingLink, instagramURL, facebookURL, tripAdvisorURL;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(id)initWithData:(NSString *)n ddesc:(NSString *)desc dph:(NSString *)ph dadd:(NSString *)add dem:(NSString *)em web:(NSString *)ws lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la book:(NSString *)bURL ta:(NSString *)tripURL ig:(NSString *)insta fb:(NSString *)faceURL
{
    self.name = n;
    self.description = desc;
    self.bookingLink = bURL;
    self.address = add;
    self.email = em;
    self.phone = ph;
    self.website = ws;
    self.longitude = lo;
    self.latitude = la;
    self.instagramURL = insta;
    self.facebookURL = faceURL;
    self.tripAdvisorURL = tripURL;
    
    return self;
}

@end
