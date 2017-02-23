//
//  ViewController.m
//  imageStoreInCoreData
//
//  Created by Nagam Pawan on 2/4/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *myAlertView = [UIAlertController alertControllerWithTitle:@"Error" message:@"Device has no camera" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [myAlertView addAction:ok];
        [self presentViewController:myAlertView animated:YES completion:nil];
        
    }
    
       // Do any additional setup after loading the view, typically from a nib.
    [self saveImage];
    [self fetchData];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    locationManger = [[CLLocationManager alloc]init];
//    CLLocationCoordinate2D annotationCoord;
//    annotationCoord.latitude = 12.9719;
//    annotationCoord.longitude = 77.5299;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = locationManger.location.coordinate;
//    annotation.title = @"Neo rays";
//    annotation.subtitle = @"Bangalore";
    [locationManger setDelegate:self];
    [locationManger setDistanceFilter:kCLDistanceFilterNone];
    [locationManger setDesiredAccuracy:kCLLocationAccuracyBest];
    firstLaunch = YES;
    [self.mapView addAnnotation:annotation];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

-(NSManagedObjectContext *)getContext {
    AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appdelegate.persistentContainer.viewContext;
    return context;
}

-(void)saveImage {
    NSManagedObjectContext *context = [self getContext];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:context];
    UIImage *image = [UIImage imageNamed:@"pic.png"];
    NSData *data = UIImagePNGRepresentation(image);
    [object setValue:data forKey:@"image"];
    NSError *err = nil;
    if (![context save:&err]) {
        NSLog(@"image is not saved");
    } else {
        NSLog(@"image is saved");
    }
}

-(void)fetchData {
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Entity"];
    self.array = [[NSArray alloc]initWithArray:[context executeFetchRequest:request error:nil]];
}

- (IBAction)longPressImage:(id)sender {
    
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        UIImagePickerController *image = [[UIImagePickerController alloc]init];
        image.delegate = self;
        image.allowsEditing = YES;
        image.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:image animated:YES completion:nil];
    }];
    
    UIAlertAction *gallery = [UIAlertAction actionWithTitle:@"Choose From Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [action addAction:cancel];
    [action addAction:gallery];
    [action addAction:camera];
    [self presentViewController:action animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *chooseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imgView.image = chooseImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)Fetch:(id)sender {
   
    NSManagedObject *object = [self.array objectAtIndex:0];
    self.imgView.image = [UIImage imageWithData:[object valueForKey:@"image"]];
  }
@end
