//
//  StartViewController.m
//  AirDropbox
//
//  Created by Brian on 3/30/13.
//  Copyright (c) 2013 nsmeetup. All rights reserved.
//

#import "StartViewController.h"
#import "SharesViewController.h"
#import "ShareSelectViewController.h"
#import "API.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Once configured, the location manager must be "started".
    [locationManager startUpdatingLocation];
    
    //Activate dropbox auth (pops new screen or pulls from dropbox app)
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self.view.window.rootViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)share:(id)sender { 
    UITableViewController* shareView = [[ShareSelectViewController alloc] initWithNibName:@"ShareSelectViewController" bundle:nil];
    [self.navigationController pushViewController:shareView animated:YES];
    
}

- (IBAction)pull:(id)sender {
    UIViewController* pullView = [[SharesViewController alloc] initWithNibName:@"SharesViewController" bundle:nil];
    [self.navigationController pushViewController:pullView animated:YES];
}

-(void) identifyAPIWithLatit:(float)latitude longit:(float)longitude
{
    API* api = [API sharedAPI];
    [api identify:[[UIDevice currentDevice] name] andLatitude:latitude andLongitude:longitude andPicURL:nil];
    [api refresh];
    [locationManager stopUpdatingLocation];
}

/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // store all of the measurements, just so we can see what kind of data we might receive
    
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    
    NSLog(@"%f, %f",newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    [self identifyAPIWithLatit:newLocation.coordinate.latitude longit:newLocation.coordinate.longitude];
    
    // test the measurement to see if it is more accurate than the previous measurement
    //    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
    //        // store the location as the "best effort"
    //        self.bestEffortAtLocation = newLocation;
    //        // test the measurement to see if it meets the desired accuracy
    //        //
    //        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
    //        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
    //        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
    //        //
    //        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
    //            // we have a measurement that meets our requirements, so we can stop updating the location
    //            //
    //            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
    //            //
    //            [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
    //            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
    //            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
    //        }
    //    }
    //    // update the display with the new location data
    //    [self.tableView reloadData];
}
@end
