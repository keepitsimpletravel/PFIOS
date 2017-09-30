//
//  Staff.m
//
//  Created by Ashley Templeman on 29/09/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Staff.h"

@implementation Staff

@synthesize name, age, drink, details, eat, movies, music; hometown;

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(id)initWithData:(NSString *)nm age:(NSInteger)value hometown:(NSString *)ht books:(NSString *)bk music:(NSString *)mus movies:(NSString *)mov eat:(NSString *)et drink:(NSString *)drk details:(NSString *)dets
{
    self.name = nm;
    self.age = value;
    self.hometown = ht;
    self.books = bk;
    self.music = mus;
    self.movies = mov;
    self.eat = et;
    self.drink = drk;
    self.details = dets;
    
    return self;
}

@end
