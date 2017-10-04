//
//  Directions.h
//
//  Created by Ashley Templeman on 19/09/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Directions : NSObject
{
    
}
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *mode;
@property(nonatomic, copy) NSString *description;


-(id)initWithData:(NSString *)sn mode:(NSString *)mde description:(NSString *)desc;

@end
