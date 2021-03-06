

#import "Singleton.h"

@implementation Singleton
@synthesize dbPath;

+(Singleton*) sharedSingleton
{
	static Singleton* theInstance = nil;
	if (theInstance == nil)
	{
		theInstance = [[self alloc] init];
	}
	return theInstance;
}

// returns base url
- (NSString *) getBaseURL
{
    return @"http://kistchatstorage.com/PickledFrogDB/";
}

- (NSString *) getNBURL
{
    return @"http://kistchatstorage.com/PickledFrogDB/";
}

-(NSString *)getdbPath
{
    return self.dbPath;
}

@end
