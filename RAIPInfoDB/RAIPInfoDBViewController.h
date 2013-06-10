//
//  RAIPInfoDBViewController.h
//  RAIPInfoDB
//
//  Created by Roger Adams on 6/9/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AFJSONRequestOperation.h"

#define API_KEY [NSString stringWithFormat:@"PUT API KEY HERE"]

@interface RAIPInfoDBViewController : UIViewController {
    
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *buttonGetLocation;
@property (strong, nonatomic) IBOutlet UITextField *textFieldIPAddress;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *labelDetails;

@end
