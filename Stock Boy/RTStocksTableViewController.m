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

@property (weak, nonatomic) IBOutlet UIView *floatingStatus;
@property (nonatomic, strong) NSMutableArray *stocks;
@property (nonatomic, weak) IBOutlet UILabel *cashLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger counter;
@property (weak, nonatomic) IBOutlet UILabel *livingExpenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *livingExpenseAmountLabel;
@property (nonatomic, assign) NSInteger livingExpense;

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
    [self.view addSubview:self.floatingStatus];
    
    self.stocks = [RTStartingStockFactory generateStartingStocks];
    self.player = [[RTPlayer alloc] init];
    self.cashLabel.text = [@"$" stringByAppendingString:[@(self.player.cash) stringValue]];
    self.livingExpenseLabel.textColor = [UIColor clearColor];
    self.livingExpenseAmountLabel.textColor = [UIColor clearColor];
    self.livingExpense = 10;
    self.counter = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.17f
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.floatingStatus.frame;
    frame.origin.y = scrollView.contentOffset.y;
    self.floatingStatus.frame = frame;
    [self.view bringSubviewToFront:self.floatingStatus];
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
    if ((self.counter >= 40)&&(self.counter % 40 == 0)) {
        self.livingExpenseAmountLabel.text = [@"-$" stringByAppendingString:[NSString stringWithFormat:@"%ld", self.livingExpense]];
        self.livingExpenseLabel.textColor = [UIColor redColor];
        self.livingExpenseAmountLabel.textColor = [UIColor redColor];
        self.player.cash -= self.livingExpense;
        self.cashLabel.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%ld", self.player.cash]];
        self.livingExpense *= 1.1;
    } else {
        self.livingExpenseLabel.textColor = [UIColor alphaFadeGivenColor:self.livingExpenseLabel.textColor];
        self.livingExpenseAmountLabel.textColor = [UIColor alphaFadeGivenColor:self.livingExpenseAmountLabel.textColor];
    }
    for (RTStock *thisStock in self.stocks) {
        NSInteger priceChange;
        NSInteger r = arc4random_uniform(55);
        if (r > 10) {
            priceChange = 0;
        } else if (r > 9) {
            priceChange = -3;
        } else if (r > 8) {
            priceChange = -2;
        } else if (r > 5) {
            priceChange = -1;
        } else if (r > 4) {
            priceChange = 3;
        } else if (r > 2) {
            priceChange = 2;
        } else {
            priceChange = 1;
        }
        if (priceChange > 0) {
            thisStock.stockCell.backgroundColor = [UIColor colorWithRed:0.91 green:1.000 blue:0.96 alpha:1.000];
            //thisStock.stockCell.backgroundColor = [UIColor greenenGivenColor:thisStock.stockCell.backgroundColor];
        } else if (priceChange < 0) {
            thisStock.stockCell.backgroundColor = [UIColor colorWithRed:1.000 green:0.91 blue:0.96 alpha:1.000];
            //thisStock.stockCell.backgroundColor = [UIColor reddenGivenColor:thisStock.stockCell.backgroundColor];
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
    //check if liquidation needed
    if (self.player.cash < 0) {
        [self.player liquidateAllStockHoldings];
        if (self.player.cash < 0) {
            [self gameOver];
        }
    }
}

-(void)gameOver {
    [self.timer invalidate];
    self.livingExpenseLabel.hidden = YES;
    self.livingExpenseAmountLabel.hidden = YES;
    self.cashLabel.text = @"BANKRUPT";
    self.cashLabel.textColor = [UIColor redColor];
    self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
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
