//
//  ViewController.m
//  loadingDemo
//
//  Created by sdanke on 16/5/7.
//  Copyright © 2016年 sdanke. All rights reserved.
//

#import "ViewController.h"
#import "LoadingView.h"

@interface ViewController ()
@property (nonatomic, strong) LoadingView           *loadingView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LoadingView *view = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    view.center = self.view.center;
    view.backgroundColor = [UIColor colorWithRed:0 green:160/255.0 blue:250/255.0 alpha:1];
    [self.view addSubview:view];
    self.loadingView = view;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.bounds.size.width/2 - 25, CGRectGetMaxY(self.loadingView.frame) + 20, 50, 30);
    [btn setTitle:@"start" forState:UIControlStateNormal];
    [btn setTitleColor:self.loadingView.backgroundColor forState:UIControlStateNormal];
    [btn setTitle:@"stop" forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

- (void)btnAction:(UIButton *)sender {

    sender.selected = !sender.selected;
    if (sender.isSelected) {
        [self.loadingView startLoading];
    } else {
        [self.loadingView stopLoading];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
