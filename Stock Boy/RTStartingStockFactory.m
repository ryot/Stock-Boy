//
//  RTStartingStockFactory.m
//  Stock Boy
//
//  Created by Ryo Tulman on 2/28/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTStartingStockFactory.h"
#import "RTStock.h"

@implementation RTStartingStockFactory

+(NSMutableArray *)generateStartingStocks {
    NSMutableArray *startingStocks = [NSMutableArray new];
    NSString *namePrefix = @"Corp ";
    for (NSInteger i = 0; i < 16; i++) {
        RTStock *newStock = [[RTStock alloc] initWithName:[namePrefix stringByAppendingString:[@(i) stringValue]] price:[self randomPrice] shares:[self randomShare]];
        [startingStocks addObject:newStock];
    }
    return startingStocks;
}

+ (NSInteger)randomPrice {
    NSInteger price = arc4random_uniform(20);
    return price;
}

+ (NSInteger)randomShare {
    NSInteger share;
    NSInteger r = arc4random_uniform(10);
    if (r > 7) {
        share = 5000;
    } else if(r > 5) {
        share = 7000;
    } else if (r > 3) {
        share = 8000;
    } else {
        share = 10000;
    }
    return share;
}
    
@end
