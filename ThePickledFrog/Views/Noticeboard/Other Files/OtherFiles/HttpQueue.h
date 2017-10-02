

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface HttpQueue : NSObject {

	 NSOperationQueue *_queue;
	BOOL isShowed;
}

-(void) initQueue;
//- (void) queueItems : (NSString *) requestUrl  : (NSString *) _tagstr : (NSData *)bodyData;
- (void) queueItems : (NSString *) requestUrl  : (int) _tag : (NSData *)bodyData;
+ (HttpQueue*) sharedSingleton;
- (void) queueImages : (NSString *) requestUrl  : (int) _tag : (NSData *)bodyData : (NSString *)imageName;
- (void) queueImagesWork : (NSString *) requestUrl  : (int) _tag : (NSData *)bodyData : (NSString *)imageName : (NSString *)key;
-(void) getItems : (NSString *) requestUrl  : (int) _tag;
- (void) queueImagesAndVideo : (NSString *) requestUrl  : (int) _tag : (NSData *)bodyData :(NSData *)videoData : (NSString *)cateName : (NSString *)subCat : (NSString *)desc : (NSString *)type;
-(void) stopQueue;
@property (retain) NSOperationQueue *queue;
@end
