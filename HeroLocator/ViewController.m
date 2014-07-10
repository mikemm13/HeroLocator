//
//  ViewController.m
//  HeroLocator
//
//  Created by Miguel Martin Nieto on 10/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *northImage;
@property (weak, nonatomic) IBOutlet UIImageView *westImage;
@property (weak, nonatomic) IBOutlet UIImageView *eastImage;
@property (weak, nonatomic) IBOutlet UIImageView *southImage;

@property (strong,nonatomic) UIImage *northFace;
@property (strong,nonatomic) UIImage *southFace;
@property (strong,nonatomic) UIImage *eastFace;
@property (strong,nonatomic) UIImage *westFace;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        if (_locationManager) {
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            
            self.locationManager.distanceFilter = 500;
            [self.locationManager startUpdatingLocation];
            [self.locationManager startUpdatingHeading];
        }
    }
    [self clearImages];
}

- (BOOL)locationServicesEnabled{
    return [CLLocationManager locationServicesEnabled];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    for (CLLocation *location in locations) {
        NSLog(@"%@",location);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    NSLog(@"%f", newHeading.trueHeading);
    NSLog(@"%f", newHeading.magneticHeading);
    [self clearImages];
    if (newHeading.magneticHeading < 10 || newHeading.magneticHeading > 350) {
        NSLog(@"Santa Claus");
        self.northImage.image = [UIImage imageNamed:@"santa.jpeg"];
    } else if(newHeading.magneticHeading > 80 && newHeading.magneticHeading < 100){
        NSLog(@"East");
        self.eastImage.image = [UIImage imageNamed:@"putin.jpeg"];
    } else if (newHeading.magneticHeading > 170 && newHeading.magneticHeading < 190){
        NSLog(@"Pal sur");
        self.southImage.image = [UIImage imageNamed:@"chiquito.jpeg"];
    } else if (newHeading.magneticHeading > 260 && newHeading.magneticHeading < 280){
        NSLog(@"Salvaje oeste");
        self.westImage.image = [UIImage imageNamed:@"clint.jpeg"];
    }
    
}

- (BOOL) locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    return YES;
}

- (void)clearImages{
    self.northImage.image = nil;
    self.westImage.image = nil;
    self.southImage.image = nil;
    self.eastImage.image = nil;
}

@end
