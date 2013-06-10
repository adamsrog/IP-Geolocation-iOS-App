//
//  RAIPInfoDBViewController.m
//  RAIPInfoDB
//
//  Created by Roger Adams on 6/9/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import "RAIPInfoDBViewController.h"

@interface RAIPInfoDBViewController ()

@end

@implementation RAIPInfoDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_geometric"]];
    
    self.textFieldIPAddress.keyboardType = UIKeyboardTypeDecimalPad;
    self.buttonGetLocation.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    
    self.labelDetails.alpha = 0.0;
    self.labelDetails.text = nil;
    self.labelDetails.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    self.labelDetails.textColor = [UIColor whiteColor];
    self.labelDetails.numberOfLines = 6;
}

- (IBAction)retrieveLocationPressed:(id)sender {
    
    // dismiss keyboard & begin animating activityIndicator
    [self.textFieldIPAddress resignFirstResponder];
    [self.activityIndicator startAnimating];
    
    // prepare the request
    NSString *ipAddress = self.textFieldIPAddress.text;
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://api.ipinfodb.com/v3/ip-city/?key=%@&ip=%@&format=json", API_KEY, ipAddress]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    // prepare JSON request
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"JSON Request successful..");
        NSLog(@"%@", JSON);
        
        if ([[JSON objectForKey:@"cityName"] isEqualToString:@"-"]) {
            
            /* Occasionally for some IPs, the API returns a bunch of
             values containing '-' and '0'.  Check for this and
             inform the user that no information is available. */
            
            self.labelDetails.text = [NSString stringWithFormat:@"%@\nNo information found.", [JSON objectForKey:@"ipAddress"]];
            
        } else {
            
            // set map to retrieved location and zoom in
            CLLocationCoordinate2D location;
            location.latitude = [[JSON objectForKey:@"latitude"] doubleValue];
            location.longitude = [[JSON objectForKey:@"longitude"] doubleValue];
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 3000, 3000);
            [self.mapView setCenterCoordinate:location animated:YES];
            [self.mapView setRegion:region animated:YES];
            
            // check for zipCode and set accordingly
            if ([[JSON objectForKey:@"zipCode"] isEqualToString:@"-"]) {
                self.labelDetails.text = [NSString stringWithFormat:@"%@\n%@, %@ \n%@ (%@)\n(%@, %@)", [JSON objectForKey:@"ipAddress"], [[JSON objectForKey:@"cityName"] capitalizedString], [[JSON objectForKey:@"regionName"] capitalizedString], [[JSON objectForKey:@"countryName"] capitalizedString], [JSON objectForKey:@"countryCode"], [JSON objectForKey:@"latitude"], [JSON objectForKey:@"longitude"]];
            } else {
                self.labelDetails.text = [NSString stringWithFormat:@"%@\n%@, %@ (%@)\n%@ (%@)\n(%@, %@)", [JSON objectForKey:@"ipAddress"], [[JSON objectForKey:@"cityName"] capitalizedString], [[JSON objectForKey:@"regionName"] capitalizedString], [JSON objectForKey:@"zipCode"], [[JSON objectForKey:@"countryName"] capitalizedString], [JSON objectForKey:@"countryCode"], [JSON objectForKey:@"latitude"], [JSON objectForKey:@"longitude"]];
            }
        }
        
        // fade in details label
        [UIView animateWithDuration:0.3 animations:^{
            self.labelDetails.alpha = 1.0;
        }];
        [self.activityIndicator stopAnimating];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"response: %@", response);
        NSLog(@"error: %@", error.localizedDescription);
        
        // stop animating
        [self.activityIndicator stopAnimating];
    }];
    
    // execute JSON Request
    [operation start];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
