//
//  Step.h
//
//  Created by Ashley Templeman on 26/11/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Step : NSObject
{
}
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *step;
@property(nonatomic, assign) NSInteger order;

-(id)initWithData:(NSString *)name step:(NSString *)st order:(NSInteger)ord;

@end