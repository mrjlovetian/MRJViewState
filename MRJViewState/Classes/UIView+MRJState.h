//
//  UIView+State.h
//  investment
//
//  Created by mrjlovetian@gmail.com on 09/20/2017.
//  Copyright (c) 2017 mrjlovetian@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRJLoadStateProperty;

typedef NS_ENUM(NSInteger, MRJLoadDataState) {
    MRJLoadDataStateDefault = 0,
    MRJLoadDataStateInitalLoading,  /// 起始加载状态，蓝色覆盖原页面
    MRJLoadDataStateNoData,         /// 无数据状态
    MRJLoadDataStateLoading,        /// 加载中,黑色原界面可见，不可交互
    MRJLoadDataStateNetworkFailed   /// 无网络状态
};

/*
 一行代码设置加载状态
 self.view.currentLoadingState = MRJLoadDataState;
 或 self.tableView.currentLoadingState = MRJLoadDataState;
 其它可设置属性，可在loadingStateProperties设置
 加载区域为self 的父类bounds
 并将加载view加入到self的superview子视图
 */
@interface UIView (MRJState)

@property(nonatomic)MRJLoadDataState currentLoadingState;

@property(nonatomic, readonly)MRJLoadStateProperty *loadingStateProperties;

@end

@interface NSError (UIViewState)

@property(nonatomic)BOOL shouldHideReload;
@end


#import "MRJLoadStateProperty.h"
