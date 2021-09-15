//
//  TicketsViewController.m
//  App_Airport
//
//  Created by Сергей Горячев on 30.06.2021.
//

#import "TicketsViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataHelper.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"
#define MapPriceCellReuseIdentifier @"MapPriceCellIdentifier"

@interface TicketsViewController ()
    @property (nonatomic) TicketType ticketType;
    @property (nonatomic, strong) NSArray *tickets;
    @property (nonatomic, strong) NSArray *prices;
    @property (nonatomic, strong) NSArray *currentArray;
    @property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end

@implementation TicketsViewController {
    BOOL isFavorites;
}

- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        isFavorites = YES;
        self.tickets = [NSArray new];
        self.prices = [NSArray new];
        self.currentArray = [NSArray new];
        self.title = @"Избранное";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Билеты карты цен", @"Билеты"]];
        [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.tintColor = [UIColor blackColor];
        self.navigationItem.titleView = _segmentedControl;
        _segmentedControl.selectedSegmentIndex = 0;
        [self changeSource];
    }
    return self;
}

- (instancetype)initWithType:(TicketType)type {
    self = [super init];
    if (self) {
        _ticketType = type;
    }
    return self;
}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self) {
        _tickets = tickets;
        _currentArray = tickets;
        self.title = @"Билеты";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

- (instancetype)initWithMapPrices:(NSArray *)prices {
    self = [super init];
    if (self) {
        _prices = prices;
        _currentArray = prices;
        self.title = @"Билеты";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFavorites) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        [self changeSource];
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Билеты карты цен", @"Билеты"]];
    [_segmentedControl addTarget:self action:@selector(changeSourceTicket) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    [self changeSourceTicket];
    
}

- (void)changeSourceTicket {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _currentArray = _prices;
            break;
        case 1:
            _currentArray = _tickets;
        default:
            break;
    }
    [self.tableView reloadData];
}

- (void)changeSource {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _currentArray = [[CoreDataHelper sharedInstance] favoritesMapPrice];
            break;
        case 1:
            _currentArray = [[CoreDataHelper sharedInstance] favorites];
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    
    if (isFavorites) {
        if (_segmentedControl.selectedSegmentIndex == 0) {
            FavoriteMapPrice *favoriteMapPrice = [_currentArray objectAtIndex:indexPath.row];
            cell.favoriteMapPrice = favoriteMapPrice;
        } else if (_segmentedControl.selectedSegmentIndex == 1) {
            FavoriteTicket *favoriteTicket = [_currentArray objectAtIndex:indexPath.row];
            cell.favoriteTicket = favoriteTicket;
        }
    } else {
        if (_segmentedControl.selectedSegmentIndex == 0) {
            MapPrice *mapPrice = [_currentArray objectAtIndex:indexPath.row];
            cell.mapPrice = mapPrice;
        } else if (_segmentedControl.selectedSegmentIndex == 1) {
            Ticket *ticket = [_currentArray objectAtIndex:indexPath.row];
            cell.ticket = ticket;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isFavorites) return;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с билетом" message:@"Что необходимо сделать с выбранным билетом?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        if ([[CoreDataHelper sharedInstance] isFavoriteMapPrice:[_currentArray objectAtIndex:indexPath.row]]) {
            favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] removeFromFavoriteMapPrice:[self->_currentArray objectAtIndex:indexPath.row]];
            }];
        } else {
            favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] addToFavoriteMapPrice:[self->_currentArray objectAtIndex:indexPath.row]];
            }];
        }
    } else if (_segmentedControl.selectedSegmentIndex == 1) {
        if ([[CoreDataHelper sharedInstance] isFavorite:[_currentArray objectAtIndex:indexPath.row]]) {
            favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] removeFromFavorite:[self->_currentArray objectAtIndex:indexPath.row]];
            }];
        } else {
            favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] addToFavorite:[self->_currentArray objectAtIndex:indexPath.row]];
            }];
        }
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
