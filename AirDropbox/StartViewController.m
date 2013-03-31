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
    
    }
    return self;
}

//after view creation
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

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    
    NSString* name = [[UIDevice currentDevice] name];
    [api identify:name andLatitude:latitude andLongitude:longitude andPicURL:nil];
    [api refresh];
    [locationManager stopUpdatingLocation];
}

#pragma mark DBSessionDelegate
-(void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId
{
    
}

#pragma mark CLLocationManagerDelegate
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
}
@end
