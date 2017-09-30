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
@property(nonatomic, copy) NSString *foodName;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *description2;
@property(nonatomic, copy) NSString *description3;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *website;
@property(nonatomic, retain) NSDecimalNumber *longitude;
@property(nonatomic, retain) NSDecimalNumber *latitude;
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *brief;
@property(nonatomic, copy) NSString *openingHours;
@property(nonatomic, copy) NSString *taLink;
@property(nonatomic, copy) NSString *gettingThere;
@property(nonatomic, copy) NSString *instaURL;
@property(nonatomic, copy) NSString *closestStop;
@property(nonatomic, copy) NSString *facebookURL;
@property(nonatomic, copy) NSString *twitterURL;


-(id)initWithData:(NSString *)name ddesc:(NSString *)desc ddesc2:(NSString *)desc2 ddesc3:(NSString *)desc3 dadd:(NSString *)add web:(NSString *)ws lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la phoneNumber:(NSString *)ph br:(NSString *)fb open:(NSString *)oh tal:(NSString *)link getting:(NSString*)gt insta:(NSString*)iURL closest:(NSString*)cs face:(NSString*)fURL twit:(NSString*)twURL;

@end
