//
//  RTStock.m
//  Stock Boy
//
//  Created by Ryo Tulman on 2/28/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTStock.h"

@implementation RTStock

-(id)initWithName:(NSString *)name price:(NSInteger)price shares:(NSInteger)shares {
    self = [super init];
    if (self) {
        self.name = name;
        self.price = price;
        self.totalShares = shares;
    }
    return self;
}

-(NSInteger)netWorth {
    return self.price * self.totalShares;
}

@end
