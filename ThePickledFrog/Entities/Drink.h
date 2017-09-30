//
//  Drink.h
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Drink : NSObject
{
    
}
@property(nonatomic, copy) NSString *drinkName;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *description2;
@property(nonatomic, copy) NSString *description3;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *website;
@property(nonatomic, retain) NSDecimalNumber *longitude;
@property(nonatomic, retain) NSDecimalNumber *latitude;
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *drinkBrief;
@property(nonatomic, copy) NSString *facebookURL;
@property(nonatomic, copy) NSString *taLink;
@property(nonatomic, copy) NSString *openingHours;
@property(nonatomic, copy) NSString *instaURL;
@property(nonatomic, copy) NSString *gettingThere;
@property(nonatomic, copy) NSString *closestStop;
@property(nonatomic, copy) NSString *twitterURL;

-(id)initWithData:(NSString *)name ddesc:(NSString *)desc ddesc2:(NSString *)desc2 ddesc3:(NSString *)desc3 dadd:(NSString *)add web:(NSString *)ws lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la phoneNumber:(NSString *)ph brief:(NSString *)db face:(NSString *)fURL tal:(NSString *)link opening:(NSString *)oh insta:(NSString*)iURL getting:(NSString*)gt closest:(NSString*)cs twitter:(NSString*)tURL;

@end
