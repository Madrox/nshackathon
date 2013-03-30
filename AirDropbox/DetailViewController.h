//
//  DetailViewController.h
//  AirDropbox
//
//  Created by Brian on 3/30/13.
//  Copyright (c) 2013 nsmeetup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
