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

@interface MapViewController () <UIActionSheetDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UISwitch *barsSwitch;
@property (strong, nonatomic) NSMutableArray *bars;
@property (strong, nonatomic) CLLocation *selectedLocation;
@property (strong, nonatomic) NSMutableArray *cameras;
@end

@implementation MapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchTextField.delegate = self;
    
    // Do any additional setup after loading the view.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bars" ofType:@"plist"];
    NSArray *barsFromFile = [NSArray arrayWithContentsOfFile:filePath];
    _bars = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in barsFromFile) {
        Bar *bar = [[Bar alloc] init];
        CLLocationDegrees latitude = [(NSNumber *)dictionary[@"latitude"] doubleValue];
        CLLocationDegrees longitude = [(NSNumber *)dictionary[@"longitude"] doubleValue];
        bar.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        bar.type = [dictionary[@"type"] intValue];
        [self.mapView addAnnotation:bar];
        [_bars addObject:bar];
    }
}

- (IBAction)centerMap:(id)sender {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 2000, 2000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
}

- (void) centerMap:(id)sender InCoordinate:(CLLocationCoordinate2D)coordinate{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000);
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


- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        if (self.barsSwitch.isOn) {
            [self localSearch:self.searchTextField.text];
        } else {
            [self geolocateAddress:self.searchTextField.text];
        }
        
        return NO;
    }
    return YES;
}

- (void)localSearch:(NSString *)searchString{
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    [searchRequest setNaturalLanguageQuery:searchString];
    [searchRequest setRegion:[self.mapView region]];
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            for (MKMapItem *poi in response.mapItems) {
                Bar *b = [[Bar alloc] init];
                b.name = poi.name;
                b.coordinate = poi.placemark.coordinate;
                [self.mapView addAnnotation:b];
            }
        }
    }];
    
}

- (void) geolocateAddress:(NSString *)address{
    NSMutableDictionary *placeDictionary = [[NSMutableDictionary alloc] init];
    NSArray *keys = @[@"Street", @"City"];
    NSArray * addressComponents = [address componentsSeparatedByString:@","];
    
    if (addressComponents.count == 2) {
        [addressComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [placeDictionary setObject:obj forKey:keys[idx]];
        }];
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressDictionary:placeDictionary completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count]) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            [self centerMap:self.mapView InCoordinate:coordinate];
        }
        
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *mkView;
    mkView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myBars"];
    
    if (!mkView) {
        mkView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myBars"];
    }
    
    if ([annotation isKindOfClass:[Bar class]]) {
        Bar *bar = (Bar *) annotation;
        
        [mkView setCanShowCallout:YES];
    
        
        switch (bar.type) {
            case classic_bar:
                
                mkView.image = [UIImage imageNamed:@"21-skull"];
                break;
            case discoteque:
                mkView.image = [UIImage imageNamed:@"21-skull"];

                break;
            case piano_bar:
                mkView.image = [UIImage imageNamed:@"21-skull"];

                break;
            case tapas_bar:
                mkView.image = [UIImage imageNamed:@"21-skull"];

                break;
            default:
                break;
        }
    }
    return mkView;
}

- (IBAction)mapTouch:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    CGPoint tapPoint = [tap locationInView:self.mapView];
    CLLocationCoordinate2D coord = [self.mapView convertPoint:tapPoint toCoordinateFromView:self.mapView];
    self.selectedLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    [self reverseGeocodeLocation];
}

- (void)reverseGeocodeLocation{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.selectedLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count) {
            NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
            NSMutableString *s = [NSMutableString stringWithFormat:@"$%@", [dictionary valueForKey:@"Street"]];
            [s appendString:[dictionary valueForKey:@"City"]];
            [s appendString:[dictionary valueForKey:@"State"]];
            [s appendString:[dictionary valueForKey:@"ZIP"]];
            
            self.searchTextField.text = s;
        }
    }];
    
}

- (void)addCameraUsingBar:(Bar *)bar{
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:bar.coordinate fromEyeCoordinate:bar.coordinate eyeAltitude:500];
    [camera setPitch:60];
    
    [self.cameras addObject:camera];
}

- (IBAction)fly:(id)sender{
    self.cameras = [[NSMutableArray alloc] init];
    for (Bar *b in self.bars) {
        [self addCameraUsingBar:b];
    }
    [self goToNextCamera];
}

- (void)goToNextCamera{
    if ([self.cameras count] == 0) {
        return;
    }
    MKMapCamera *nextCamera = [self.cameras firstObject];
    [self.cameras removeObjectAtIndex:0];
    
    [UIView animateWithDuration:2.5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.mapView setCamera:nextCamera];
    } completion:^(BOOL finished){
        [self goToNextCamera];
    }];
    
    
}

@end
