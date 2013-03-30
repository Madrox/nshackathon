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
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
@end
