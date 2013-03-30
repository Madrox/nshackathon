//
//  MasterViewController.h
//  AirDropbox
//
//  Created by Brian on 3/30/13.
//  Copyright (c) 2013 nsmeetup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@class DetailViewController;
@class API;
@interface ShareSelectViewController : UITableViewController <DBRestClientDelegate>
{
    DBRestClient* restClient;
    DBMetadata* metadata;
    API* apiWrapper;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
