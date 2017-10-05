//
//  Food.h
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject
{
    
}
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *foodName;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, retain) NSDecimalNumber *longitude;
@property(nonatomic, retain) NSDecimalNumber *latitude;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *website;
@property(nonatomic, copy) NSString *brief;
@property(nonatomic, copy) NSString *openingHours;
@property(nonatomic, copy) NSString *taLink;
@property(nonatomic, copy) NSString *instaURL;
@property(nonatomic, copy) NSString *facebookURL;


-(id)initWithData:(NSString *)typ nm:(NSString *)name ddesc:(NSString *)desc dadd:(NSString *)add web:(NSString *)ws lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la phoneNumber:(NSString *)ph br:(NSString *)fb open:(NSString *)oh tal:(NSString *)link insta:(NSString*)iURL face:(NSString*)fURL;

@end
