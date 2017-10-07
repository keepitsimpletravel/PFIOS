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
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *blurb;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, retain) NSDecimalNumber *longitude;
@property(nonatomic, retain) NSDecimalNumber *latitude;


- (id)initWithData:(NSString *)typ nm:(NSString *)nme bri:(NSString*)blu ddesc:(NSString *)desc lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la;

@end
