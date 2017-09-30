//
//  PhotoLookup.h
//
//  Created by Ashley Templeman on 8/01/2017.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoLookup : NSObject
{
}
@property(nonatomic, copy) NSString *area;
@property(nonatomic, copy) NSString *identifier;
@property(nonatomic, copy) NSString *photoName;
@property(nonatomic, assign) NSInteger orderNumber;

-(id)initWithData:(NSString *)are identifier:(NSString *)idt namw:(NSString *)pn order:(NSInteger)ord;

@end