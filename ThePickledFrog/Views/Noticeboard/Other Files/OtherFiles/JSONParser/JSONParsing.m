//
//  ParsingGooglePlace.m
//  Click
//
//  Created by Jignesh on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONParsing.h"
#import "AppDelegate.h"

@implementation JSONParsing

AppDelegate *appDelegate;

@synthesize delegate;

#pragma mark -
#pragma mark init methods


- (id) init 
{
	if ((self = [super init])) {
    
    }
	return self;
}

-(void)getDataFromURL:(NSString *)strURL withInfo:(NSMutableDictionary *)dictInfo
{       
    
//    appDelegate = [AppDelegate SharedApplication];
    
	NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120.0];
    
     NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection start];
}

-(void)getPostDataFromURL:(NSString *)strURL poststr:(NSString *)postString  withInfo:(NSMutableDictionary *)dictInfo
{
    //    appDelegate = [AppDelegate SharedApplication];
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:200.0];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark -
#pragma mark - methods for connection

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{	
	data = [NSMutableData data];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)dataObj 
{
    //NSString *json_string = [[NSString alloc] initWithData:dataObj encoding:NSUTF8StringEncoding];
    data = [[NSMutableData alloc]initWithData:dataObj];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSData *jsonData = [json_string dataUsingEncoding:NSASCIIStringEncoding];
    NSError * error;
    NSMutableDictionary *dictDataInfo=[NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:kNilOptions
                                                                        error:&error];;
    
    if ([delegate respondsToSelector:@selector(fetchDataSuccess:)]) {
        [delegate fetchDataSuccess:dictDataInfo];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
	NSLog(@"ERROR with theConenction %@",error);
	UIAlertView *connectionAlert = [[UIAlertView alloc] initWithTitle:@"Information !" message:@"Internet / Service Connection Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[connectionAlert show];
	
    if ([delegate respondsToSelector:@selector(fetchDataFail:)]) {
        [delegate fetchDataFail:error];
    }
    
	return;
}

@end