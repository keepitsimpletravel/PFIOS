//
//  Detail.h
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Detail : NSObject
{
    
}
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *website;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *description2;
@property(nonatomic, retain) NSDecimalNumber *longitude;
@property(nonatomic, retain) NSDecimalNumber *latitude;
@property(nonatomic, copy) NSString *instagramURL;
@property(nonatomic, copy) NSString *twitterURL;
@property(nonatomic, copy) NSString *facebookURL;
@property(nonatomic, copy) NSString *tripAdvisorURL;

-(id)initWithData:(NSString *)n ddesc:(NSString *)desc ddesc2:(NSString *)desc2 dadd:(NSString *)add dph:(NSString *)ph dem:(NSString *)em web:(NSString *)ws lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la ig:(NSString *)insta twit:(NSString *)twURL fb:(NSString *)faceURL ta:(NSString *)tripURL;

@end
