//
//  Transport.h
//  HostelBlocks
//
//  Created by Ashley Templeman on 5/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transport : NSObject
{
    
}
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *blurb;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *description2;
@property(nonatomic, copy) NSString *description3;
@property(nonatomic, copy) NSString *description4;
@property(nonatomic, copy) NSString *description5;
@property(nonatomic, copy) NSString *description6;
@property(nonatomic, copy) NSString *description7;
@property(nonatomic, copy) NSString *description8;


- (id)initWithData:(NSString *)tname bl:(NSString*)brief d1:(NSString*)desc d2:(NSString *)desc2 d3:(NSString *)desc3 d4:(NSString *)desc4 d5:(NSString *)desc5 d6:(NSString *)desc6 d7:(NSString *)desc7 d8:(NSString *)desc8;

@end
