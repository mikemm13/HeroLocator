//
//  MapViewController.m
//  HeroLocator
//
//  Created by Miguel Martin Nieto on 10/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation MapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)centerMap:(id)sender {
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
