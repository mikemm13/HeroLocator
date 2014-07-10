//
//  Bar.h
//  HeroLocator
//
//  Created by Miguel Martin Nieto on 10/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    classic_bar = 0,
    tapas_bar = 1,
    piano_bar = 2,
    discoteque = 3
} BAR_TYPE;

@interface Bar : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *name;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSArray *barsList;
@property (nonatomic) BAR_TYPE type;

@end
