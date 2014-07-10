//
//  MapViewController.m
//  HeroLocator
//
//  Created by Miguel Martin Nieto on 10/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Bar.h"

@interface MapViewController () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSArray *bars;
@end

@implementation MapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bars" ofType:@"plist"];
    _bars = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    for (NSDictionary *dictionary in self.bars) {
        Bar *bar = [[Bar alloc] init];
        CLLocationDegrees latitude = [(NSNumber *)dictionary[@"latitude"] doubleValue];
        CLLocationDegrees longitude = [(NSNumber *)dictionary[@"longitude"] doubleValue];
        bar.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        [self.mapView addAnnotation:bar];
    }
}

- (IBAction)centerMap:(id)sender {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 2000, 2000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    
}

- (IBAction)changeView:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select view" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Satellite", @"Hybrid", @"Standard", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self.mapView setMapType:MKMapTypeSatellite];
            break;
        case 1:
            [self.mapView setMapType:MKMapTypeHybrid];
            break;
        case 2:
            [self.mapView setMapType:MKMapTypeStandard];
            break;
            
        default:
            break;
    }
}

@end
