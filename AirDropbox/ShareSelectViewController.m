//
//  MasterViewController.m
//  AirDropbox
//
//  Created by Brian on 3/30/13.
//  Copyright (c) 2013 nsmeetup. All rights reserved.
//

#import "ShareSelectViewController.h"

#import "DetailViewController.h"
#import "API.h"
#import <DropboxSDK/DropboxSDK.h>

#import "SVProgressHUD.h"

@interface ShareSelectViewController () {
    NSMutableArray *_objects;
}
@end

@implementation ShareSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Select Items to Share", @"Select Items to Share");
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
    // Once configured, the location manager must be "started".
    [locationManager startUpdatingLocation];
    
    api = [API sharedAPI];
    
	// Do any additional setup after loading the view, typically from a nib.
    
//        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystem target:self action:@selector(insertNewObject:)];
//    self.navigationItem.leftBarButtonItem = self.backButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
}

-(void) identifyAPIWithLatit:(float)latitude longit:(float)longitude
{
    [api identify:[[UIDevice currentDevice] name] andLatitude:latitude andLongitude:longitude andPicURL:nil];
    [api refresh];
    [locationManager stopUpdatingLocation];
}

-(void) viewDidAppear:(BOOL)animated
{    
    //set up rest client
    if (!restClient) {
            restClient =
            [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
            restClient.delegate = self;
    }

    
    //get metadata (list of all files and folders in root)
    [restClient loadMetadata:@"/"];
}

//Dropbox callback
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metad {
    metadata=metad;
    
    //root
    if (metadata.isDirectory) {
        _objects = [metadata.contents mutableCopy];
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"\t%@", file.filename);
//            [_objects addObject:file];
        }
//        NSLog(@"Folder '%@' contains:", metadata.path);
//        for (DBMetadata *file in metadata.contents) {
//            NSLog(@"\t%@", file.filename);
    }
    [self.tableView reloadData];
}

//Dropbox callback
- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}

- (void)restClient:(DBRestClient*)restClient loadedSharableLink:(NSString*)link
           forFile:(NSString*)path;
{
    //sanitize the path string (remove the initial "/")
    path = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    [api share:path toLink:link];
    
    [SVProgressHUD showSuccessWithStatus:@"Successful share!"];
}
- (void)restClient:(DBRestClient*)restClient loadSharableLinkFailedWithError:(NSError*)error;
{
    [SVProgressHUD showErrorWithStatus:@"Error sharing file"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    DBMetadata *cellMetadata = _objects[indexPath.row];
    cell.textLabel.text =  cellMetadata.filename;
    
    if(cellMetadata.isDirectory)
        cell.detailTextLabel.text = @"Folder";
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
    
//    if (!self.detailViewController) {
//        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
//    }
    

    
    DBMetadata *fileMetadata = _objects[indexPath.row];
    [restClient loadSharableLinkForFile:fileMetadata.path];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    self.detailViewController.detailItem = object;
//    [self.navigationController pushViewController:self.detailViewController animated:YES];
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
 