//
//  WhereNext.m
//  HostelBlocks
//
//  Created by Ashley Templeman on 5/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import "WhereNext.h"

@implementation WhereNext

@synthesize name, blurb, description, gettingThere, gettingThere2, gettingThere3;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

- (id)initWithData:(NSString *)nm blurb:(NSString*)brief description:(NSString *)desc getting:(NSString *)gt getting2:(NSString*)gt2 getting3:(NSString*)gt3
{
    self.name = nm;
    self.description = desc;
    self.blurb = brief;
    self.gettingThere = gt;
    self.gettingThere2 = gt2;
    self.gettingThere3 = gt3;
    
    return self;
}

@end
