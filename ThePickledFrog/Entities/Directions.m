//
//  Directions.m
//
//  Created by Ashley Templeman on 19/09/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import "Directions.h"

@implementation Directions

@synthesize name, description, description2, description3, description4, description5, description6, description7, description8, description9, description10, description11, description12, description13, description14, description15, description16, description17;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(id)initWithData:(NSString *)sn description:(NSString *)desc description2:(NSString *)desc2 description3:(NSString *)desc3 description4:(NSString *)desc4 description5:(NSString *)desc5 description6:(NSString *)desc6 description7:(NSString *)desc7 description8:(NSString *)desc8 description9:(NSString *)desc9 description10:(NSString *)desc10 description11:(NSString *)desc11 description12:(NSString *)desc12 description13:(NSString *)desc13 description14:(NSString *)desc14 description15:(NSString *)desc15 description16:(NSString *)desc16 description17:(NSString *)desc17
{
    self.name = sn;
    self.description = desc;
    self.description2 = desc2;
    self.description3 = desc3;
    self.description4 = desc4;
    self.description5 = desc5;
    self.description6 = desc6;
    self.description7 = desc7;
    self.description8 = desc8;
    self.description9 = desc9;
    self.description10 = desc10;
    self.description11 = desc11;
    self.description12 = desc12;
    self.description13 = desc13;
    self.description14 = desc14;
    self.description15 = desc15;
    self.description16 = desc16;
    self.description17 = desc17;
    
    return self;
}

@end
