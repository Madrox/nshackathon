//
//  StartViewController.h
//  AirDropbox
//
//  Created by Brian on 3/30/13.
//  Copyright (c) 2013 nsmeetup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import <CoreLocation/CoreLocation.h>

@interface StartViewController : UIViewController <DBSessionDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}


- (IBAction)share:(id)sender;
- (IBAction)pull:(id)sender;

@end
