//
//  TravelTip.h
//  HostelBlocks
//
//  Created by Ashley Templeman on 11/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelTip : NSObject
{
    
}
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *description;

- (id)initWithData:(NSString *)tname desc:(NSString*)details;

@end
