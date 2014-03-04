//
//  RTPlayer.m
//  Stock Boy
//
//  Created by Ryo Tulman on 3/1/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTPlayer.h"

@implementation RTPlayer

-(id)init {
    self = [super init];
    if (self) {
        self.cash = 100;
        self.stockHoldings = [NSMutableDictionary new];
    }
    return self;
}

-(void)addToStockHoldings:(RTStock *)stock quantity:(NSInteger)quantity {
    NSInteger currentHolding = [[self.stockHoldings objectForKey:stock.name] integerValue];
    if (currentHolding) {
        currentHolding += quantity;
        [self.stockHoldings setObject:[NSNumber numberWithInteger:currentHolding] forKey:stock.name];
    } else {
        [self.stockHoldings setObject:[NSNumber numberWithInteger:quantity] forKey:stock.name];
    }
    self.cash -= stock.price * quantity;
}

-(void)removeFromStockHoldings:(RTStock *)stock quantity:(NSInteger)quantity {
    NSInteger currentHolding = [[self.stockHoldings objectForKey:stock.name] integerValue];
    if (currentHolding >= quantity) {
        currentHolding -= quantity;
        [self.stockHoldings setObject:[NSNumber numberWithInteger:currentHolding] forKey:stock.name];
        self.cash += stock.price * quantity;
    } else if (currentHolding < quantity) {
        self.cash += stock.price * currentHolding;
        [self.stockHoldings setObject:[NSNumber numberWithInteger:0] forKey:stock.name];
        currentHolding = 0;
    }
    if (!currentHolding) {
        [self.stockHoldings removeObjectForKey:stock.name];
    }
}

-(void)liquidateAllStockHoldings {

}



@end
