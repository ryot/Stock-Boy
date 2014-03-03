//
//  RTStocksTableViewController.m
//  Stock Boy
//
//  Created by Ryo Tulman on 2/28/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTStocksTableViewController.h"
#import "RTStockTableViewCell.h"
#import "RTStartingStockFactory.h"
#import "RTStock.h"
#import "UIColor+ColorConjurer.h"

@interface RTStocksTableViewController ()

@property (nonatomic, strong) NSMutableArray *stocks;
@property (nonatomic, weak) IBOutlet UILabel *cashLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger counter;
@property (weak, nonatomic) IBOutlet UILabel *livingExpenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *livingExpenseAmountLabel;

@end

@implementation RTStocksTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.stocks = [RTStartingStockFactory generateStartingStocks];
    self.player = [[RTPlayer alloc] init];
    self.cashLabel.text = [@"$" stringByAppendingString:[@(self.player.cash) stringValue]];
    self.livingExpenseLabel.hidden = YES;
    self.livingExpenseAmountLabel.hidden = YES;
    self.counter = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                                  target:self
                                                selector:@selector(timerUpdate)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.stocks.count;
}

- (RTStockTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RTStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    RTStock *thisStock = [self.stocks objectAtIndex:indexPath.row];
    [cell updateCell:thisStock];
    thisStock.stockCell = cell;
    NSInteger amount = [(NSNumber *)[self.player.stockHoldings objectForKey:thisStock.name] integerValue];
    cell.holdLabel.text = [@(amount) stringValue];
    if (amount > 0) {
        cell.holdLabel.textColor = [UIColor redColor];
    } else {
        cell.holdLabel.textColor = [UIColor orangeColor];
    }
    return cell;
}
- (IBAction)buyOnePressed:(id)sender {
    RTStockTableViewCell *cell = (RTStockTableViewCell *)[[[sender superview] superview] superview];
    if ((cell)&&(self.player.cash > cell.cellStock.price)) {
        [self.player addToStockHoldings:cell.cellStock quantity:1];
        NSInteger amount = [(NSNumber *)[self.player.stockHoldings objectForKey:cell.cellStock.name] integerValue];
        cell.holdLabel.text = [@(amount) stringValue];
        cell.holdLabel.textColor = [UIColor redColor];
        self.cashLabel.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%ld", self.player.cash]];
    } else {
        //!!! warn player
    }
}
- (IBAction)buyTenPressed:(id)sender {
    RTStockTableViewCell *cell = (RTStockTableViewCell *)[[[sender superview] superview] superview];
    if ((cell)&&(self.player.cash > cell.cellStock.price * 10)) {
        [self.player addToStockHoldings:cell.cellStock quantity:10];
        NSInteger amount = [(NSNumber *)[self.player.stockHoldings objectForKey:cell.cellStock.name] integerValue];
        cell.holdLabel.text = [@(amount) stringValue];
        cell.holdLabel.textColor = [UIColor redColor];
        self.cashLabel.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%ld", self.player.cash]];
    } else {
        //!!! warn player
    }
}
- (IBAction)sellOnePressed:(id)sender {
    RTStockTableViewCell *cell = (RTStockTableViewCell *)[[[sender superview] superview] superview];
    if ((cell)&&([self.player.stockHoldings objectForKey:cell.cellStock.name])) {
        [self.player removeFromStockHoldings:cell.cellStock quantity:1];
        NSInteger amount = [(NSNumber *)[self.player.stockHoldings objectForKey:cell.cellStock.name] integerValue];
        cell.holdLabel.text = [@(amount) stringValue];
        if (amount == 0) {
            cell.holdLabel.textColor = [UIColor orangeColor];
        }
        self.cashLabel.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%ld", self.player.cash]];
    } else {
        //!!! warn player
    }
}
- (IBAction)sellTenPressed:(id)sender {
    RTStockTableViewCell *cell = (RTStockTableViewCell *)[[[sender superview] superview] superview];
    if ((cell)&&([self.player.stockHoldings objectForKey:cell.cellStock.name])) {
        [self.player removeFromStockHoldings:cell.cellStock quantity:10];
        NSInteger amount = [(NSNumber *)[self.player.stockHoldings objectForKey:cell.cellStock.name] integerValue];
        cell.holdLabel.text = [@(amount) stringValue];
        if (amount == 0) {
            cell.holdLabel.textColor = [UIColor orangeColor];
        }
        self.cashLabel.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%ld", self.player.cash]];
    } else {
        //!!! warn player
    }
}

-(void)timerUpdate {
    if ((self.counter >= 28)&&(self.counter % 28 == 0)) {
        self.livingExpenseLabel.hidden = NO;
        self.livingExpenseAmountLabel.hidden = NO;
        self.player.cash -= 10;
        self.cashLabel.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%ld", self.player.cash]];
    } else if (self.counter % 30 == 0) {
        self.livingExpenseAmountLabel.hidden = YES;
        self.livingExpenseLabel.hidden = YES;
    }
    for (RTStock *thisStock in self.stocks) {
        NSInteger priceChange;
        NSInteger r = arc4random_uniform(28);
        if (r > 12) {
            priceChange = 0;
        } else if (r > 10) {
            priceChange = -3;
        } else if (r > 8) {
            priceChange = -2;
        } else if(r > 6) {
            priceChange = -1;
        } else if (r > 4) {
            priceChange = 3;
        } else if (r > 2) {
            priceChange = 2;
        } else {
            priceChange = 1;
        }
        if (priceChange > 0) {
            thisStock.stockCell.backgroundColor = [UIColor colorWithRed:0.814 green:1.000 blue:0.837 alpha:1.000];
        } else if (priceChange < 0) {
            thisStock.stockCell.backgroundColor = [UIColor colorWithRed:1.000 green:0.759 blue:0.792 alpha:1.000];
        } else  if (priceChange == 0) {
            thisStock.stockCell.backgroundColor = [UIColor lightenGivenColor:thisStock.stockCell.backgroundColor];
        }
        thisStock.price += priceChange;
        if (thisStock.price < 1) {
            thisStock.price = 1;
        }
    }
    [self.tableView reloadData];
    self.counter++;
    //check if game over
    if (self.player.cash < 0) {
        [self gameOver];
    }
}

-(void)gameOver {
    [self.timer invalidate];
    self.livingExpenseLabel.hidden = YES;
    self.livingExpenseAmountLabel.hidden = YES;
    self.cashLabel.text = @"BANKRUPT";
    self.cashLabel.textColor = [UIColor redColor];
    [self.view setUserInteractionEnabled:NO];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
