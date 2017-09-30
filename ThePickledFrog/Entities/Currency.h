//
//  Currency.h
//
//  Created by Ashley Templeman on 13/12/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject
{
    
}
@property(nonatomic, copy) NSString *currencyName;
@property(nonatomic, copy) NSString *code;

-(id)initWithData:(NSString*)name currencyCode:(NSString*)cc;

@end
