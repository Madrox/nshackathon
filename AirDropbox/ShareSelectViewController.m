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
        self.title = NSLocalizedString(@"Select An Item to Share", @"Select An Item to Share");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    api = [API sharedAPI];
    
	// Do any additional setup after loading the view, typically from a nib.
    
//        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystem target:self action:@selector(insertNewObject:)];
//    self.navigationItem.leftBarButtonItem = self.backButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //set up rest client
    if (!restClient) {
            restClient =
            [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
            restClient.delegate = self;
    }

    //get metadata (list of all files and folders in root)
    [restClient loadMetadata:@"/"];
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
    //is item editable?
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

#pragma mark DBRestClientDelegate
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metad {
    metadata=metad;
    
    //root directory
    if (metadata.isDirectory) {
        _objects = [metadata.contents mutableCopy];
    }
    
    [self.tableView reloadData];
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"Error accessing files - Try again"];
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



@end
 