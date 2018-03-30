//
//  NetworkErrorView.m
//  
//
//  Created by mrjlovetian@gmail.com on 09/20/2017.
//  Copyright (c) 2017 mrjlovetian@gmail.com. All rights reserved.
//

#import "MRJNetworkErrorView.h"

#define MRJ_NAV_HEITHT 64
#define MRJ_SCREEN [UIScreen mainScreen].bounds.size

@interface MRJNetworkErrorView()

@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) UILabel *lbText;

@end

@implementation MRJNetworkErrorView

+ (id)node {
    CGRect frame = CGRectMake(0, MRJ_NAV_HEITHT, MRJ_SCREEN.width, MRJ_SCREEN.height - MRJ_NAV_HEITHT);
    MRJNetworkErrorView *view = [[MRJNetworkErrorView alloc] initWithFrame:frame];
    view.tag = 999999;
    return view;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    NSURL *boundleUrl = [[NSBundle bundleForClass:[MRJNetworkErrorView class]] URLForResource:@"MRJViewState" withExtension:@"bundle"];
    NSBundle *citysBundle = [NSBundle bundleWithURL:boundleUrl];
    UIImage *img = [UIImage imageNamed:[citysBundle pathForResource:@"network_error@2x" ofType:@"png"]];
    _iv = [[UIImageView alloc] initWithImage:img];
    CGPoint centPoint = CGPointMake(MRJ_SCREEN.width/2, self.frame.size.height/2.0 - _iv.frame.size.height - 20);
    _iv.center = centPoint;
    [self addSubview:_iv];
    
    _lbText = [[UILabel alloc] initWithFrame:CGRectMake(0, _iv.frame.size.height + _iv.frame.origin.y + 14, MRJ_SCREEN.width, 18)];
    _lbText.text = @"网络中断";
    _lbText.textAlignment = NSTextAlignmentCenter;
    _lbText.textColor = [UIColor grayColor];
    _lbText.font = [UIFont systemFontOfSize:13];
    [self addSubview:_lbText];
    
    UILabel *lbText2 = [[UILabel alloc] initWithFrame:CGRectMake(0, _lbText.frame.size.height + _lbText.frame.origin.y, MRJ_SCREEN.width, 18)];
    lbText2.text = @"请点击屏幕刷新";
    lbText2.textAlignment = NSTextAlignmentCenter;
    lbText2.textColor = [UIColor grayColor];
    lbText2.font = [UIFont systemFontOfSize:13];
    [self addSubview:lbText2];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.bounds];
    btn.backgroundColor = [UIColor clearColor];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setEmptyMes:(NSString *)emptyMes {
    _emptyMes = emptyMes;
    self.lbText.text = _emptyMes;
}

- (void)setEmptyImage:(UIImage *)emptyImage {
    _emptyImage = emptyImage;
    self.iv.image = _emptyImage;
}

- (void)btnClick:(UIButton *)btn {
    self.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(clickRefreshKKNetworkErrorView:)]) {
        [self.delegate clickRefreshKKNetworkErrorView:self];
    }
}

@end
