//
//  RTStockTableViewCell.h
//  Stock Boy
//
//  Created by Ryo Tulman on 2/28/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

@class RTStockTableViewCell;

#import <UIKit/UIKit.h>
#import "RTStock.h"
#import "RTStocksTableViewController.h"

@interface RTStockTableViewCell : UITableViewCell

@property (nonatomic, strong) RTStock *cellStock;
@property (weak, nonatomic) IBOutlet UILabel *stockName;
@property (weak, nonatomic) IBOutlet UILabel *stockPrice;
@property (weak, nonatomic) IBOutlet UILabel *holdLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyOneButton;
@property (weak, nonatomic) IBOutlet UIButton *sellOneButton;

-(void)updateCell:(RTStock *)stock;

@end
