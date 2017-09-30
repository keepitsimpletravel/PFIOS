//
//  WhereNext.h
//  HostelBlocks
//
//  Created by Ashley Templeman on 5/5/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WhereNext : NSObject
{
    
}
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *blurb;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *gettingThere;
@property(nonatomic, copy) NSString *gettingThere2;
@property(nonatomic, copy) NSString *gettingThere3;

- (id)initWithData:(NSString *)nm blurb:(NSString*)brief description:(NSString *)desc getting:(NSString *)gt getting2:(NSString*)gt2 getting3:(NSString*)gt3;

@end
