//
//  MasterViewController.h
//  AirDropbox
//
//  Created by Brian on 3/30/13.
//  Copyright (c) 2013 nsmeetup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import <CoreLocation/CoreLocation.h>

@class DetailViewController;
@class API;
@interface ShareSelectViewController : UITableViewController <DBRestClientDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    NSMutableArray *locationMeasurements;
    CLLocation *bestEffortAtLocation;
    
    DBRestClient* restClient;
    DBMetadata* metadata;
    API* api;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
