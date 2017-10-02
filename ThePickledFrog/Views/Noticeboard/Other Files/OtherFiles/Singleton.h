

#import <Foundation/Foundation.h>

@interface Singleton : NSObject
{
    NSString *dbPath;
}
@property (nonatomic,retain) NSString *dbPath;

+(Singleton*) sharedSingleton;
- (NSString *) getBaseURL;
- (NSString *) getNBURL;
-(NSString *)getdbPath;
@end
