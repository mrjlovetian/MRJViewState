//
//  KKLoadStateProperty.h
//  
//
//  Created by mrjlovetian@gmail.com on 09/20/2017.
//  Copyright (c) 2017 mrjlovetian@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+MRJState.h"

typedef void (^NetworkReloadBlock)();
typedef void (^NoDataActionBlock)();

@interface MRJLoadStateProperty : NSObject

/// 自定义无数据说明 默认“这里空空如也，什么都没有”
@property(nonatomic, copy) NSString *noDataDescription;
/// 自定义无数据图片 默认empty02.png
@property(nonatomic, strong) UIImage *noDataImage;
/// 网络加载失败视图，指定的点击重新加载执行的block
@property(nonatomic, strong) NSError *error;
@property(nonatomic, copy) NetworkReloadBlock reloadNetworkBlock;
@property(nonatomic, copy) NoDataActionBlock noDataActionBlock;
/// 加载区域insets
@property(nonatomic, assign) UIEdgeInsets loadingAreaInsets;
/// 忽略导航高度，默认NO
@property(nonatomic, assign) BOOL ignoreNavBar;

/// 设置自定义视图，暂时支持无数据与初始状态自定义
- (void)setCustomerView:(UIView *)view forLoadState:(MRJLoadDataState)loadState;
/// 设置不同错误码显示视图
- (void)setCustomerView:(UIView *)view forError:(NSInteger)errorCode;
/// 获取设置的自定义视图，由UIView (State) 调用
- (UIView *)customerViewForLoadState:(MRJLoadDataState)loadState;
/// 获取设置的不同错误码显示视图
- (UIView *)customerViewForError:(NSInteger)errorCode;
+ (instancetype)defaultProperties;

@end
