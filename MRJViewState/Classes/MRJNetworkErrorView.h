//
//  NetworkErrorView.h
//  
//
//  Created by mrjlovetian@gmail.com on 09/20/2017.
//  Copyright (c) 2017 mrjlovetian@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRJNetworkErrorView;

@protocol MRJNetworkErrorViewDelegate

@required

- (void)clickRefreshKKNetworkErrorView:(MRJNetworkErrorView*)view;

@end

@interface MRJNetworkErrorView : UIView

@property (nonatomic, weak) id<MRJNetworkErrorViewDelegate> MRJdelegate;
@property (nonatomic, copy) NSString *emptyMes;
@property (nonatomic, strong) UIImage *emptyImage;

+ (id)node;

@end
