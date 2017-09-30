//
//  Currency.m
//
//  Created by Ashley Templeman on 13/12/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@implementation Currency

@synthesize currencyName, code;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(id)initWithData:(NSString *)name currencyCode:(NSString *)cc
{
    self.currencyName = name;
    self.code = cc;
    
    return self;
}

@end