//
//  Staff.h
//
//  Created by Ashley Templeman on 29/09/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Staff : NSObject
{
    
}
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger age;
@property(nonatomic, copy) NSString *hometown;
@property(nonatomic, copy) NSString *books;
@property(nonatomic, copy) NSString *music;
@property(nonatomic, copy) NSString *movies;
@property(nonatomic, copy) NSString *eat;
@property(nonatomic, copy) NSString *drink;
@property(nonatomic, copy) NSString *details;

-(id)initWithData:(NSString*)nm age:(NSInteger)value hometown:(NSString*)ht books:(NSString*)bk music:(NSString*)mus movies:(NSString*)mov eat:(NSString*)et drink:(NSString*)drk details:(NSString*)dets;

@end
