//
//  TableViewController.m
//  App_Airport
//
//  Created by Сергей Горячев on 30.06.2021.
//

#import "TableViewController.h"
#import "TableViewCell.h"

@interface TableViewController ()

@property (strong, nonnull) NSMutableArray *cityImageArray;
@property (strong) NSString *identifier;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cityImageArray = [NSMutableArray arrayWithObjects:@"london",@"moscow",@"newyork",@"paris",@"singapur", nil];

    self.identifier = @"TableViewCell";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cityImageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    if (!tableViewCell) {
        tableViewCell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier];
    }
    
    [tableViewCell configure:[UIImage imageNamed:self.cityImageArray[indexPath.row]]];
    
    return tableViewCell;
}

@end
