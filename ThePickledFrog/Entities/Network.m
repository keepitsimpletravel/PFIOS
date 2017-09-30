//
//  Network.m
//  MakatiJunctionHostel
//
//  Created by Ashley Templeman on 17/3/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import "Network.h"

@implementation Network

@synthesize networkBrief, name, imageName, storeLink;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

- (id)initWithData:(NSString *)nm brief:(NSString *)netBrief iName:(NSString *)imageN sLink:(NSString *)sl
{
    self.name = nm;
    self.networkBrief = netBrief;
    self.imageName = imageN;
    self.storeLink = sl;
    
    return self;
}

@end
