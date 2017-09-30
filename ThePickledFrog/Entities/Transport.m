//
//  Transport.m
//  HostelBlocks
//
//  Created by Ashley Templeman on 5/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import "Transport.h"

@implementation Transport

@synthesize name, blurb, description, description2, description3, description4, description5, description6, description7, description8;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

- (id)initWithData:(NSString *)tname bl:(NSString*)brief d1:(NSString*)desc d2:(NSString *)desc2 d3:(NSString *)desc3 d4:(NSString *)desc4 d5:(NSString *)desc5 d6:(NSString *)desc6 d7:(NSString *)desc7 d8:(NSString *)desc8
{
    self.name = tname;
    self.description = desc;
    self.blurb = brief;
    self.description2 = desc2;
    self.description3 = desc3;
    self.description4 = desc4;
    self.description5 = desc5;
    self.description6 = desc6;
    self.description7 = desc7;
    self.description8 = desc8;
    
    return self;
}

@end
