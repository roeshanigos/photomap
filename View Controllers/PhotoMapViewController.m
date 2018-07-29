//
//  PhotoMapViewController.m
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Copyright © 2018 Codepath. All rights reserved.
//

#import "PhotoMapViewController.h"
#import <MapKit/MapKit.h>
#import "LocationsViewController.h"
#import "AppDelegate.h"

@interface PhotoMapViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
//making it easier to picker controller
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (strong, nonatomic) UIImage *photo;

@end

@implementation PhotoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //setting what region to show in the mapview
    MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.78333, -122.416667), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:sfRegion animated:NO];
    self.cameraButton.layer.cornerRadius = self.cameraButton.frame.size.height/2;
    self.mapView.delegate = self;
    
    
}

- (IBAction)didTapCamera:(id)sender {
    
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    else {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

//how to actually do something with the image A DELEGATE METHOD
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.photo = originalImage;
    
    // do something
    [self performSegueWithIdentifier:@"tagSegue" sender:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLattitude:(NSNumber *)lattitude longitude:(NSNumber *)longitude {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navigationController = (UINavigationController *)[[appDelegate window] rootViewController];
    
    //pops to the photomap==self
    [navigationController popToViewController:self animated:YES];
    
    //setting a coordinate
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lattitude.floatValue, longitude.floatValue);
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    //annotation.title = annotation.coordinate;
    [self.mapView addAnnotation:annotation];
    
}


//delegate method for mapview
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    }
    
    UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
    UIImageView *infoView = (UIImageView*)annotationView.rightCalloutAccessoryView;
    infoView.image = 
    imageView.image = self.photo;
    
    return annotationView;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller we're about to go to
    LocationsViewController *locationsViewController = [segue destinationViewController];
    locationsViewController.delegate = self;
}


@end
