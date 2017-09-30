//
//  Room.h
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject
{
    
}
@property(nonatomic, copy) NSString *roomType;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *price;

- (id)initWithData:(NSString *)rt description:(NSString*)desc pr:(NSString *)pric;

@end
