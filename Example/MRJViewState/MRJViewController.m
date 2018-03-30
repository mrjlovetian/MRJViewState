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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(60, 60, 60, 60);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
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

#pragma mark MRJNetworkErrorViewDelegate

- (void)clickRefreshKKNetworkErrorView:(MRJNetworkErrorView *)view {
    self.view.currentLoadingState = MRJLoadDataStateDefault;
    [self.view viewWithTag:66].hidden = YES;
}

@end
