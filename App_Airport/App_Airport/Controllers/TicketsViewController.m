//
//  TicketsViewController.m
//  App_Airport
//
//  Created by Сергей Горячев on 30.06.2021.
//

#import "TicketsViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataHelper.h"
#import "NotificationCenter.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"
#define AirlineLogo(iata) [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png", iata]];

@interface TicketsViewController ()
    @property (nonatomic) TicketType ticketType;
    @property (nonatomic, strong) NSArray *tickets;
    @property (nonatomic, strong) NSArray *prices;
    @property (nonatomic, strong) NSArray *currentArray;
    @property (nonatomic, strong) UISegmentedControl *segmentedControl;
    @property (nonatomic, strong) UIDatePicker *datePicker;
    @property (nonatomic, strong) UITextField *dateTextField;
@end

@implementation TicketsViewController {
    BOOL isFavorites;
    TicketTableViewCell *notificationCell;
}

- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        isFavorites = YES;
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
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.minimumDate = [NSDate date];
        
        _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
        _dateTextField.hidden = YES;
        _dateTextField.inputView = _datePicker;
        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
        [keyboardToolbar sizeToFit];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
        keyboardToolbar.items = @[flexBarButton, doneBarButton];
        
        _dateTextField.inputAccessoryView = keyboardToolbar;
        [self.view addSubview:_dateTextField];
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

- (void)doneButtonDidTap:(UIBarButtonItem *)sender {
    if (_datePicker.date && notificationCell) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@ за %@ руб.", notificationCell.ticket.from, notificationCell.ticket.to, notificationCell.ticket.price];
        
        NSURL *imageURL;
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", notificationCell.ticket.airline]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSURL *urlLogo = AirlineLogo(notificationCell.ticket.airline);
            NSData *data = [NSData dataWithContentsOfURL:urlLogo];
            UIImage *imageLogo = [[UIImage alloc] initWithData:data];
            UIImage *logo = imageLogo;
            NSData *pngData = UIImagePNGRepresentation(logo);
            [pngData writeToFile:path atomically:YES];
        }
        imageURL = [NSURL fileURLWithPath:path];
        
        Notification notification = NotificationMake(@"Напоминание о билете", message, _datePicker.date, imageURL);
        [[NotificationCenter sharedInstance] sendNotification:notification];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Успешно" message:[NSString stringWithFormat:@"Уведомление будет отправлено - %@", _datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    _datePicker.date = [NSDate date];
    notificationCell = nil;
    [self.view endEditing:YES];
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
    
    UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:@"Напомнить" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self->notificationCell = [tableView cellForRowAtIndexPath:indexPath];
        [self->_dateTextField becomeFirstResponder];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:notificationAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
