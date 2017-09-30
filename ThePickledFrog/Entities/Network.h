//
//  Network.h
//  MakatiJunctionHostel
//
//  Created by Ashley Templeman on 17/3/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Network : NSObject
{
    
}
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *networkBrief;
@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, copy) NSString *storeLink;

- (id)initWithData:(NSString *)nm brief:(NSString*)netBrief iName:(NSString *)imageN sLink:(NSString*)sl;

@end
