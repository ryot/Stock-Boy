//
//  RTStocksTableViewController.h
//  Stock Boy
//
//  Created by Ryo Tulman on 2/28/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

@class RTStocksTableViewController;

#import <UIKit/UIKit.h>
#import "RTStockTableViewCell.h"
#import "RTPlayer.h"

@interface RTStocksTableViewController : UITableViewController

@property (nonatomic, strong) RTPlayer *player;

-(void)timerUpdate;

@end
