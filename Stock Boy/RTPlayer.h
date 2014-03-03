//
//  RTPlayer.h
//  Stock Boy
//
//  Created by Ryo Tulman on 3/1/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

@class RTPlayer;

#import <Foundation/Foundation.h>
#import "RTStock.h"

@interface RTPlayer : NSObject

@property (nonatomic, assign) NSInteger cash;
@property (nonatomic, strong) NSMutableDictionary *stockHoldings;

-(void)addToStockHoldings:(RTStock *)stock quantity:(NSInteger)quantity;
-(void)removeFromStockHoldings:(RTStock *)stock quantity:(NSInteger)quantity;


@end
