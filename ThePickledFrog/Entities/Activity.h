//
//  Activity.h
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Activity : NSObject
{
    
}
@property(nonatomic, copy) NSString *activityName;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *description2;
@property(nonatomic, copy) NSString *description3;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *website;
@property(nonatomic, retain) NSDecimalNumber *longitude;
@property(nonatomic, retain) NSDecimalNumber *latitude;
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *brief;
@property(nonatomic, copy) NSString *taLink;
@property(nonatomic, copy) NSString *instagramURL;
@property(nonatomic, copy) NSString *openingHours;
@property(nonatomic, copy) NSString *gettingThere;
@property(nonatomic, copy) NSString *closestStop;
@property(nonatomic, copy) NSString *facebookURL;
@property(nonatomic, copy) NSString *twitterURL;


-(id)initWithData:(NSString *)name ddesc:(NSString *)desc ddesc2:(NSString *)desc2 ddesc3:(NSString *)desc3 ddadd:(NSString *)add web:(NSString *)ws lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la phoneNumber:(NSString *)ph brie:(NSString *)ab tal:(NSString*)tlink insta:(NSString*)iurl open:(NSString*)oh getting:(NSString*)gt stop:(NSString*)cs face:(NSString*)furl twit:(NSString*)twURL;

@end
