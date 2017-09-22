//
//  UIView+State.m
//  investment
//
//  Created by mrjlovetian@gmail.com on 09/20/2017.
//  Copyright (c) 2017 mrjlovetian@gmail.com. All rights reserved.
//



#import "UIView+MRJState.h"
#import <objc/runtime.h>
#import "Masonry/Masonry.h"
#import "SVProgressHUD.h"

@interface ImageWithTitleView : UIView

@property(nonatomic,strong)UIButton *imageView;
@property(nonatomic,strong)UIButton *titleLabel;

@end

#define LoadingStateBackgroundColor [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0f]

@implementation UIView (MRJState)

@dynamic currentLoadingState;

- (void)setCurrentLoadingState:(MRJLoadDataState)currentLoadingState{
    
    if (self.currentLoadingState != currentLoadingState) {
        if (self.currentLoadingState == MRJLoadDataStateNoData) {
            [self.noDataView removeFromSuperview];
            self.noDataView = nil;
        }
        else if (self.currentLoadingState == MRJLoadDataStateInitalLoading) {
            UIView *stateView = self.MRJLoadingDataView;
            [UIView animateWithDuration:0.4 animations:^{
                stateView.alpha = 0;
            } completion:^(BOOL finished) {
                [stateView.subviews.firstObject dismiss];
                [stateView removeFromSuperview];
                self.MRJLoadingDataView = nil;
            }];
          
        }
        else if (self.currentLoadingState == MRJLoadDataStateLoading) {
            UIView *stateView = self.waitingView;
            [stateView.subviews.firstObject dismiss];
            [stateView removeFromSuperview];
            self.waitingView = nil;
        }
        else if (self.currentLoadingState == MRJLoadDataStateNetworkFailed) {
            [UIView animateWithDuration:0.3 animations:^{
                self.networkFailedView.alpha = 0;
            } completion:^(BOOL finished) {
                if (self.currentLoadingState != MRJLoadDataStateNetworkFailed) {
                    [self.networkFailedView removeFromSuperview];
                    self.networkFailedView = nil;
                }
            }];
            
        }
        objc_setAssociatedObject(self, @selector(currentLoadingState), @(currentLoadingState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        //放在superview上可以防止直接放在self上会出现点击事件传递到原界面情况
        UIView *superView = self;
        if (![superView isKindOfClass:[UIView class]]) {
            superView=self;
        }
        UIView *stateView = nil;
        switch (currentLoadingState) {
            case MRJLoadDataStateDefault:
                break;
            case MRJLoadDataStateInitalLoading:
            {
                stateView = self.MRJLoadingDataView;
                [stateView.subviews.firstObject showProgress:-1 status:nil];
                [stateView.subviews.firstObject setDefaultMaskType:SVProgressHUDMaskTypeNone];
            }
                break;
            case MRJLoadDataStateLoading:
            {
                stateView=self.waitingView;
                [stateView.subviews.firstObject showProgress:-1 status:nil];
                [stateView.subviews.firstObject setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            }
                break;
            case MRJLoadDataStateNoData:
                stateView=self.noDataView;
                break;
            case MRJLoadDataStateNetworkFailed:
                
                stateView=[self networkFailedView];
                stateView.alpha=1;
                [stateView viewWithTag:1].hidden=self.loadingStateProperties.error.shouldHideReload;
                ((UILabel*) [stateView viewWithTag:2]).text=self.loadingStateProperties.error.localizedDescription;
                [stateView viewWithTag:3].hidden=self.loadingStateProperties.error.shouldHideReload;
                break;
        }
        if (stateView) {
            [superView addSubview:stateView];
            UIEdgeInsets insets = self.loadingStateProperties.loadingAreaInsets;
            
            if (self.loadingStateProperties.ignoreNavBar == NO) {
                insets.top += 64;
            }
            
            [stateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(superView).with.offset(insets.top);
                make.left.equalTo(superView).with.offset(insets.left);
                make.bottom.equalTo(superView).with.offset(insets.bottom);
                make.right.equalTo(superView).with.offset(insets.right);
                if ([superView isKindOfClass:[UIScrollView class]]) {
                    make.width.equalTo(superView.mas_width);
                    make.height.equalTo(@(superView.frame.size.height-insets.top));
                }
            }];
            [superView bringSubviewToFront:stateView];
        }
        
    }
}

- (MRJLoadDataState)currentLoadingState{
    return [objc_getAssociatedObject(self, @selector(currentLoadingState)) integerValue];
}

- (MRJLoadStateProperty *)loadingStateProperties{
    if (objc_getAssociatedObject(self, _cmd)==nil) {
        MRJLoadStateProperty *properties=[MRJLoadStateProperty defaultProperties];
        objc_setAssociatedObject(self, _cmd, properties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return properties;
    }else{
        return objc_getAssociatedObject(self, _cmd);
    }
}


- (void)setNoDataView:(UIView *)noDataView{
    
    objc_setAssociatedObject(self, @selector(noDataView), noDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
}
- (UIView*)noDataView{
    if (objc_getAssociatedObject(self, _cmd)==nil) {
        UIView *bgView=UIView.new;
        bgView.backgroundColor = LoadingStateBackgroundColor;;
        UIView *customerView=[self.loadingStateProperties customerViewForLoadState:MRJLoadDataStateNoData];
        if (customerView) {
            [bgView addSubview:customerView];
            [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bgView);
            }];
        }else{
            ImageWithTitleView *_noDataView=[[ImageWithTitleView alloc] initWithFrame:bgView.bounds];
            [_noDataView.imageView setImage:self.loadingStateProperties.noDataImage forState:UIControlStateNormal];
            [_noDataView.titleLabel setTitle:self.loadingStateProperties.noDataDescription forState:UIControlStateNormal];
            [_noDataView.titleLabel addTarget:self action:@selector(clickedImageOrTitle) forControlEvents:UIControlEventTouchUpInside];
            [_noDataView.imageView addTarget:self action:@selector(clickedImageOrTitle) forControlEvents:UIControlEventTouchUpInside];
            

            
            [bgView addSubview:_noDataView];
            [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bgView);
            }];
        }
        
        self.noDataView=bgView;
        return bgView;
    }else{
        return objc_getAssociatedObject(self,_cmd);
    }
    
}

- (UIView *)networkFailedView{
    if (objc_getAssociatedObject(self, _cmd) == nil) {
        UIView *bgView=UIView.new;
        bgView.backgroundColor=[UIColor clearColor];
        UIView *customerView=[self.loadingStateProperties customerViewForError:self.loadingStateProperties.error.code];
        if (customerView) {
            [bgView addSubview:customerView];
            [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bgView);
            }];
        }else{
            
            UIView *networkFailedView= [[[NSBundle bundleForClass:[MRJLoadStateProperty class]] loadNibNamed:@"MRJLoadDataStateNetworkFailed" owner:nil options:nil] lastObject];
            objc_setAssociatedObject(self, _cmd, networkFailedView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [((UIButton*)[networkFailedView viewWithTag:1]) addTarget:self action:@selector(reloadNetworkBlockClicked:) forControlEvents:UIControlEventTouchUpInside];

            [bgView addSubview:networkFailedView];
            [networkFailedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bgView);
            }];
        }
        
        self.networkFailedView=bgView;
        return bgView;
    }else{
        UIView *networkFailedView=objc_getAssociatedObject(self,_cmd);
        return networkFailedView;
    }
}

- (void)setNetworkFailedView:(UIView *)networkFailedView{
    objc_setAssociatedObject(self, @selector(networkFailedView), networkFailedView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)reloadNetworkBlockClicked:(id)sender{
    if (self.loadingStateProperties.reloadNetworkBlock) {
        self.loadingStateProperties.reloadNetworkBlock();
    }
}

- (UIView*)waitingView{
    if (objc_getAssociatedObject(self, _cmd)==nil) {
        UIView *bgView=UIView.new;
        bgView.backgroundColor=[UIColor clearColor];
        UIView *customerView=[self.loadingStateProperties customerViewForLoadState:MRJLoadDataStateLoading];
        if (customerView) {
            [bgView addSubview:customerView];
            [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bgView);
            }];
        }else{
            SVProgressHUD *MRJLoadingDataView = [[SVProgressHUD alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
            [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
            [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8f]];
            [bgView addSubview:MRJLoadingDataView];
            [MRJLoadingDataView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bgView);
            }];
        }
        self.waitingView=bgView;
        return bgView;
    }else{
        return objc_getAssociatedObject(self, _cmd);
    }
}

- (void)setWaitingView:(UIView *)waitingView{
    objc_setAssociatedObject(self, @selector(waitingView), waitingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)MRJLoadingDataView{
    if (objc_getAssociatedObject(self, _cmd)==nil) {
        UIView *bgView = UIView.new;
        bgView.backgroundColor = LoadingStateBackgroundColor;
        UIView *customerView = [self.loadingStateProperties customerViewForLoadState:MRJLoadDataStateInitalLoading];
        if (customerView) {
            [bgView addSubview:customerView];
            [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bgView);
            }];
        }else{
            SVProgressHUD *kkLoadingDataView = [[SVProgressHUD alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
            [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0 green:145/255.0 blue:232/255.0 alpha:1.0f]];
            [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
            [bgView addSubview:kkLoadingDataView];
            
            [kkLoadingDataView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bgView);
            }];
        }
        self.MRJLoadingDataView = bgView;
        return bgView;
    }else{
        return objc_getAssociatedObject(self, _cmd);
    }
}

-(void)setMRJLoadingDataView:(UIView *)MRJLoadingDataView{
    objc_setAssociatedObject(self, @selector(MRJLoadingDataView), MRJLoadingDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)clickedImageOrTitle{
    if (self.loadingStateProperties.noDataActionBlock) {
        self.loadingStateProperties.noDataActionBlock();
    }
}

@end

@implementation NSError (UIViewState)

-(BOOL)shouldHideReload{
    if (self.code==-1009 || self.code==-1004 || self.code==-1005) {
        return NO;//网络类错误允许重载
    }
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
-(void)setShouldHideReload:(BOOL)shouldHideReload{
    objc_setAssociatedObject(self, @selector(shouldHideReload), @(shouldHideReload), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation ImageWithTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.imageView=[[UIButton alloc] init];
        self.imageView.userInteractionEnabled=YES;
        self.imageView.contentMode=UIViewContentModeCenter;
        self.titleLabel=[[UIButton alloc] init];
        
        self.titleLabel.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.titleLabel.numberOfLines=0;
        [self.titleLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.titleLabel.titleLabel.font=[UIFont systemFontOfSize:14];
       
       
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).with.offset(-30);
            make.width.equalTo(self).multipliedBy(0.3);
            
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageView.mas_centerX);
            make.top.equalTo(self.imageView.mas_bottom).with.offset(10);
            make.width.equalTo(self);
        }];
    }
    return self;
}

@end
