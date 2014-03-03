//
//  RTStartingStockFactory.h
//  Stock Boy
//
//  Created by Ryo Tulman on 2/28/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTStartingStockFactory : NSObject

@property (nonatomic, strong) NSMutableArray *generatedStocks;

+(NSMutableArray *)generateStartingStocks;

@end
