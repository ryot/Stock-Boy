//
//  UIColor+ColorConjurer.h
//  MVC
//
//  Created by Ryo Tulman on 2/20/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorConjurer)

+ (UIColor *)returnRandomColor;
+ (UIColor *)lightenGivenColor:(UIColor *)givenColor;
+ (UIColor *)alphaFadeGivenColor:(UIColor *)givenColor;
+ (UIColor *)reddenGivenColor:(UIColor *)givenColor;
+ (UIColor *)greenenGivenColor:(UIColor *)givenColor;


@end
