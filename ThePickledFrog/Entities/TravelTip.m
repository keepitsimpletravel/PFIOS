//
//  TravelTip.m
//  HostelBlocks
//
//  Created by Ashley Templeman on 11/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TravelTip.h"

@implementation TravelTip

@synthesize name, description;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

- (id)initWithData:(NSString *)tname desc:(NSString *)details
{
    self.name = tname;
    self.description = details;

    return self;
}

@end
