//
//  MainViewController.m
//  App_Airport
//
//  Created by Сергей Горячев on 22.06.2021.
//

#import "MainViewController.h"
#import "SecondViewController.h"
#import "DataManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataManager sharedInstance] loadData];
    self.view.backgroundColor = UIColor.magentaColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDidComplete) name:kDataManagerLoadDataDidComplete object:nil];
    
    UIButton *openButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 400, 100, 15)];
    openButton.backgroundColor = UIColor.lightGrayColor;
    [openButton setTitle:@"Перейти" forState:UIControlStateNormal];
    openButton.tintColor = [UIColor whiteColor];

    [openButton addTarget:self action:@selector(openSecondViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openButton];
}

- (void)loadDidComplete {
    self.view.backgroundColor = UIColor.greenColor;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)openSecondViewController:(UIButton *)sender {
    SecondViewController *secondViewController = [[SecondViewController alloc] init];
    [self.navigationController showViewController:secondViewController sender:self];
}



@end
