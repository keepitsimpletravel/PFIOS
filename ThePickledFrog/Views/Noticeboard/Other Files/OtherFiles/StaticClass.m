
#import "StaticClass.h"

@implementation StaticClass

// MD5 generating
+ (NSString *) returnMD5Hash:(NSString *)concat
{
	const char *concat_str = [concat UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, strlen(concat_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++)
		[hash appendFormat:@"%02X", result[i]];
	return [hash lowercaseString];
}

+ (void)saveToUserDefaults:(NSString*)myString : (NSString *) pref
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
		[standardUserDefaults setObject:myString forKey:pref];
		[standardUserDefaults synchronize];
	}
}

+ (NSString*)retrieveFromUserDefaults: (NSString *) pref
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
	
	if (standardUserDefaults) 
		val = [standardUserDefaults objectForKey: pref];
	
	return val;
}

// String Encoding
+(NSString * ) urlEncoding : (NSString *) raw 
{
	NSString *preparedString = [raw stringByReplacingOccurrencesOfString: @" " withString: @"%20"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"&" withString: @"%26"];
	return preparedString ;
}

// String Decoding 
+(NSString * ) urlDecode : (NSString *) raw 
{
	NSString *preparedString = [raw stringByReplacingOccurrencesOfString:  @"%20" withString: @" "];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%7B" withString: @"{"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2F" withString: @"/"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3A" withString: @":"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2C" withString: @","];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%7D" withString: @"}"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%22" withString: @" "];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%0A" withString: @"\n"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"+" withString: @" "];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%5C" withString: @""];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%27" withString: @"'"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%24" withString: @"$"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3F" withString: @"?"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3A" withString: @":"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2F" withString: @"/"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3F" withString: @"?"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3D" withString: @"="];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%26" withString: @"&"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3B" withString: @";"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"&amp;" withString: @"&"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%28" withString: @"("];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%29" withString: @")"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2A" withString: @"*"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2B" withString: @"+"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2E" withString: @"."];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2D" withString: @"-"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%40" withString: @"@"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3C" withString: @"<"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C3" withString: @""];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%83" withString: @""];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C2" withString: @""];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%A9" withString: @""];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%21" withString: @"!"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%0D" withString: @" "];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%09" withString: @" "];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3E" withString: @">"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%7E" withString: @"~"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%5C" withString: @"\\"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%5B" withString: @"["];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%5D" withString: @"]"];
	
	//preparedString = [preparedString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
	return preparedString;
	
}

@end
