//
//  Step.m
//
//  Created by Ashley Templeman on 26/11/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import "Step.h"

@implementation Step

@synthesize name, step, order;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(id)initWithData:(NSString *)nm step:(NSString *)st order:(NSInteger)ord
{
    self.name = nm;
    self.step = st;
    self.order = ord;
    
    return self;
}

@end
