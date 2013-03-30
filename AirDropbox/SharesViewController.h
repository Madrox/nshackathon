//
//  SharesViewController.h
//  AirDropbox
//
//  Created by David Horn on 3/30/13.
//  Copyright (c) 2013 nsmeetup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"

@interface SharesViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableViewCell *menuItemCell;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) API *api;

@end
