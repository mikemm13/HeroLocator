//
//  Bar.m
//  HeroLocator
//
//  Created by Miguel Martin Nieto on 10/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "Bar.h"

@implementation Bar
-(NSString *)title{
    return self.name;
}

- (void)setTitle:(NSString *)newTitle {
    self.name = newTitle;
}

@end
