//
//  API.h
//  AirDropbox
//
//  Created by David Horn on 3/30/13.
//  Copyright (c) 2013 nsmeetup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject
{
    NSString *guid;
    NSMutableData *apiData;
    NSDictionary *stats;
}
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSMutableData *apiData;
@property (nonatomic, retain) NSDictionary *stats;


+ (API *)sharedAPI;

- (NSArray *)shares;
- (NSString *)identify: (NSString *)username andLatitude:(float)lat andLongitude:(float) lon andPicURL:(NSString *)pic;
- (NSDictionary *)status;
- (NSURLConnection *)share: (NSString *)name toLink:(NSString *)dropbox_link;
- (NSURLConnection *)refresh;


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end



