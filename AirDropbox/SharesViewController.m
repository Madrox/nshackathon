//
//  SharesViewController.m
//  AirDropbox
//
//  Created by David Horn on 3/30/13.
//  Copyright (c) 2013 nsmeetup. All rights reserved.
//

#import "SharesViewController.h"

@interface SharesViewController ()

@end

@implementation SharesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"View Local Shares";
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.api shares] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *share = [[[self.api shares] objectAtIndex:indexPath.row] objectForKey:@"fields"];
    
    cell.textLabel.text = [share objectForKey:@"name"];
    return cell;
}



- (void)populate {
    [self.api refresh];
    [self.tableView reloadData];
    
    
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(populate)
                                   userInfo:nil
                                    repeats:NO];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *share = [[[self.api shares] objectAtIndex:indexPath.row] objectForKey:@"fields"];

    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [share objectForKey:@"link"]]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.api = [API sharedAPI];
    
    
    [self populate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.api = nil;
}

@end
