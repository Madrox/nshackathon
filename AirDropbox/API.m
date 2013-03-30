//
//  API.m
//  AirDropbox
//
//  Created by David Horn on 3/30/13.
//  Copyright (c) 2013 nsmeetup. All rights reserved.
//

#import "API.h"

@implementation API


- (NSString *)identify {
    NSURL *url = [[NSURL alloc] initWithString:@"http://secret-tor-9906.herokuapp.com/identify"];
    self.guid = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    return self.guid;
}

- (NSURLConnection *)refresh {
    
    NSString *url = [NSString stringWithFormat:@"http://secret-tor-9906.herokuapp.com/%@",self.guid];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:req delegate:self];
    
    return conn;
}

- (NSArray *)shares {
    return [self.stats objectForKey:@"shares_near_me"];
}

- (NSDictionary *)status {
    return self.stats;
}

- (NSURLConnection *)share:(NSString *)name toLink:(NSString *)dropbox_link {
    NSString *url = [NSString stringWithFormat:@"http://secret-tor-9906.herokuapp.com/%@/share?name=%@&link=%@",self.guid,name,dropbox_link];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:req delegate:nil];
    
    return conn;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *jsonParsingError = nil;
    id object = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&jsonParsingError];
    
    if (jsonParsingError) {
        NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
    } else {
        self.stats = object;
    }
}

@end
