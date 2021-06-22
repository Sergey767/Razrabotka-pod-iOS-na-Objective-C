//
//  SecondViewController.m
//  App_Airport
//
//  Created by Сергей Горячев on 22.06.2021.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blueColor;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(150, 300, 150, 50)];
    button.backgroundColor = UIColor.redColor;
    [button setTitle:@"Показать" forState:UIControlStateNormal];
    button.tintColor = [UIColor blackColor];
    
    [button addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)changeText:(UIButton *)sender {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(150, 200, 150, 30)];
    textView.text = @"SecondViewController";
    [self.view addSubview:textView];
}


@end
