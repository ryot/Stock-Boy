//
//  UIColor+ColorConjurer.m
//  MVC
//
//  Created by Ryo Tulman on 2/20/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "UIColor+ColorConjurer.h"

@implementation UIColor (ColorConjurer)

+(UIColor *)returnRandomColor {
    float randRed = 0.0, randGreen = 0.0, randBlue = 0.0;
    while (randRed < 0.45) {
        randRed = (float)rand() / RAND_MAX;
    } while (randGreen < 0.45) {
        randGreen = (float)rand() / RAND_MAX;
    } while (randBlue < 0.45) {
        randBlue = (float)rand() / RAND_MAX;
    }
    return [UIColor colorWithRed:randRed green:randGreen blue:randBlue alpha:1.0];
}

+(UIColor *)lightenGivenColor:(UIColor *)givenColor {
    //return [UIColor blueColor];
    CGFloat r,g,b,a;
    [givenColor getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:r*1.2 green:g*1.2 blue:b*1.2 alpha:1.0];
}

@end
