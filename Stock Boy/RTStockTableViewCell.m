//
//  RTStockTableViewCell.m
//  Stock Boy
//
//  Created by Ryo Tulman on 2/28/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTStockTableViewCell.h"

@implementation RTStockTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCell:(RTStock *)stock {
    if (stock) {
        self.cellStock = stock;
        self.stockName.text = self.cellStock.name;
        self.stockPrice.text = [@"$" stringByAppendingString:[@(self.cellStock.price) stringValue]];
    }
}

@end
