//
//  RTStock.h
//  Stock Boy
//
//  Created by Ryo Tulman on 2/28/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

@class RTStock;

#import <Foundation/Foundation.h>
#import "RTStockTableViewCell.h"

@interface RTStock : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger totalShares;
@property (nonatomic, strong) RTStockTableViewCell *stockCell;

-(id)initWithName:(NSString *)name price:(NSInteger)price shares:(NSInteger)shares;
-(NSInteger)netWorth;

@end
