//
//  MRHViewController.m
//  MRJViewState
//
//  Created by mrjlovetian@gmail.com on 09/20/2017.
//  Copyright (c) 2017 mrjlovetian@gmail.com. All rights reserved.
//

#import "MRJViewController.h"
#import <MRJViewState/UIView+MRJState.h>
#import "MRJNetworkErrorView.h"

@interface MRJViewController () <MRJNetworkErrorViewDelegate>

@end

@implementation MRJViewController

#pragma mark Method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 60, 100, 60);
    [btn setTitle:@"网络错误" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btna = [UIButton buttonWithType:UIButtonTypeCustom];
    btna.frame = CGRectMake(160, 60, 100, 60);
    [btna setTitle:@"没有数据" forState:UIControlStateNormal];
    [btna setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [btna addTarget:self action:@selector(clicka) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btna];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)click:(UIButton *)btn{
    self.view.currentLoadingState = MRJLoadDataStateLoading;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.view.currentLoadingState = MRJLoadDataStateNoData;
        
        self.view.currentLoadingState = MRJLoadDataStateNetworkFailed;
        MRJNetworkErrorView *netErrorView = [MRJNetworkErrorView node];
        netErrorView.tag = 66;
        netErrorView.delegate = self;
        [self.view addSubview:netErrorView];
    });
}

- (void)clicka {
    self.view.currentLoadingState = MRJLoadDataStateLoading;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.currentLoadingState = MRJLoadDataStateNoData;
    });
}

#pragma mark MRJNetworkErrorViewDelegate

- (void)clickRefreshKKNetworkErrorView:(MRJNetworkErrorView *)view {
    self.view.currentLoadingState = MRJLoadDataStateDefault;
    [self.view viewWithTag:66].hidden = YES;
}

@end
