//
//  API.h
//  AirDropbox
//
//  Created by David Horn on 3/30/13.
//  Copyright (c) 2013 nsmeetup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject

@property (strong,nonatomic) NSString *guid;
@property (strong,nonatomic) NSMutableData *data;
@property (strong,nonatomic) NSDictionary *stats;

- (NSArray *)shares;
- (NSString *)identify;
- (NSDictionary *)status;
- (NSURLConnection *)share: (NSString *)name toLink:(NSString *)dropbox_link;
- (NSURLConnection *)refresh;


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
