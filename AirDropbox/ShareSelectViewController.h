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

@interface ShareSelectViewController : UITableViewController <DBRestClientDelegate>
{
    DBRestClient* restClient;
    DBMetadata* metadata;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
