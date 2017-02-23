//
//  ViewController.h
//  imageStoreInCoreData
//
//  Created by Nagam Pawan on 2/4/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManger;
    BOOL firstLaunch;

}

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)longPressImage:(id)sender;
- (IBAction)Fetch:(id)sender;

@property (strong, nonatomic) NSArray *array;
@end

