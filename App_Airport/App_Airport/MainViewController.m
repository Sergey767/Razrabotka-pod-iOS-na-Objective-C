//
//  MainViewController.m
//  App_Airport
//
//  Created by Сергей Горячев on 22.06.2021.
//

#import "MainViewController.h"
#import "PlaceViewController.h"
#import "TableViewController.h"
#import "DataManager.h"

@interface MainViewController ()
@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic) SearchRequest searchRequest;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DataManager sharedInstance] loadData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = @"Поиск";

    _departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_departureButton setTitle:@"Откуда" forState:UIControlStateNormal];
    _departureButton.tintColor = [UIColor blackColor];
    _departureButton.frame = CGRectMake(30.0, 140.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    _departureButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [_departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_departureButton];

    
    _arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_arrivalButton setTitle:@"Куда" forState:UIControlStateNormal];
    _arrivalButton.tintColor = [UIColor blackColor];
    _arrivalButton.frame = CGRectMake(30.0, CGRectGetMaxY(_departureButton.frame) + 20.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    _arrivalButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [_arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_arrivalButton];
    
    UIButton *openButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 400, 100, 15)];
    openButton.backgroundColor = UIColor.lightGrayColor;
    [openButton setTitle:@"Перейти" forState:UIControlStateNormal];
    openButton.tintColor = [UIColor whiteColor];
    
    [openButton addTarget:self action:@selector(openTableViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openButton];
}

- (void)placeButtonDidTap:(UIButton *)sender {
    PlaceViewController *placeViewController;
    if ([sender isEqual:_departureButton]) {
        placeViewController = [[PlaceViewController alloc] initWithType:PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc] initWithType:PlaceTypeArrival];
    }
    placeViewController.delegate = self;
    [self.navigationController pushViewController:placeViewController animated:YES];
}

- (void)openTableViewController:(UIButton *)sender {
    TableViewController *tableViewController = [[TableViewController alloc] init];
    [self.navigationController showViewController:tableViewController sender:self];
}

//MARK:- Delegate

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    [self setPlace:place withDataType:dataType andPlaceType:placeType forButton:(placeType == PlaceTypeDeparture) ? _departureButton : _arrivalButton];
}

- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton *)button {
    NSString *title;
    NSString *iata;
    
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    }
    else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    
    if (placeType == PlaceTypeDeparture) {
        _searchRequest.origin = iata;
    } else {
        _searchRequest.destination = iata;
    }
    
    [button setTitle:title forState:UIControlStateNormal];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
