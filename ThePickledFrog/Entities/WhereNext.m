//
//  WhereNext.m
//  HostelBlocks
//
//  Created by Ashley Templeman on 5/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import "WhereNext.h"

@implementation WhereNext

@synthesize name, blurb, description, gettingThere, type;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

- (id)initWithData:(NSString*)typ name:(NSString *)nm blurb:(NSString*)brief description:(NSString *)desc getting:(NSString *)gt
{
    self.name = nm;
    self.description = desc;
    self.blurb = brief;
    self.gettingThere = gt;
    self.type = typ;
    
    return self;
}

@end
