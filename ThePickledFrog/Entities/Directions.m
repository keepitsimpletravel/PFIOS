//
//  Directions.m
//
//  Created by Ashley Templeman on 19/09/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import "Directions.h"

@implementation Directions

@synthesize name, mode, description;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(id)initWithData:(NSString *)sn mode:(NSString *)mde description:(NSString *)desc
{
    self.name = sn;
    self.description = desc;
    self.mode = mde;
    
    return self;
}

@end
