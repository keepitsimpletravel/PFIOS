

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface StaticClass : NSObject {

}

+ (NSString *) returnMD5Hash:(NSString *)concat;
+ (void)saveToUserDefaults:(NSString*)myString : (NSString *) pref;
+ (NSString*)retrieveFromUserDefaults: (NSString *) pref;
+ (NSString * ) urlEncoding : (NSString *) raw;
+ (NSString * ) urlDecode : (NSString *) raw;

@end
