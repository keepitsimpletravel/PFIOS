//
//  ParsingGooglePlace.h
//  Click
//
//  Created by Jignesh on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JSONParsingDelegate

@optional
- (void) fetchDataSuccess:(NSMutableDictionary *)dictData;
- (void) fetchDataFail:(NSError *)error;
@end

@interface JSONParsing : NSObject{

	NSMutableData* data;
    
}

@property (nonatomic, assign) NSObject<JSONParsingDelegate> *delegate;

-(id) init;
-(void)getDataFromURL:(NSString *)strURL withInfo:(NSMutableDictionary *)dictInfo;
-(void)getPostDataFromURL:(NSString *)strURL poststr:(NSString *)postString  withInfo:(NSMutableDictionary *)dictInfo;



@end
