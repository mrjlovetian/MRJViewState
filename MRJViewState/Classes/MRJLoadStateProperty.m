//
//  MRJLoadStateProperty.m
//  
//
//  Created by mrjlovetian@gmail.com on 09/20/2017.
//  Copyright (c) 2017 mrjlovetian@gmail.com. All rights reserved.
//

#import "MRJLoadStateProperty.h"

@interface MRJLoadStateProperty ()
@property(nonatomic,strong)NSMutableDictionary *customerViewDictionary;
@property(nonatomic,strong)NSMutableDictionary *customerErrorViewDictionary;
@end

@implementation MRJLoadStateProperty
+ (instancetype)defaultProperties{
    MRJLoadStateProperty *properties=[[MRJLoadStateProperty alloc] init];
    return properties;
}

- (NSError *)error{
    if (!_error) {
        _error= [NSError errorWithDomain:@"网络中断" code:-1009 userInfo:nil];
    }
    return _error;
}

- (NSString *)noDataDescription{
    if (!_noDataDescription) {
        return @"这里空空如也，什么都没有";
    }
    return _noDataDescription;
}

- (UIImage *)noDataImage{
    if (!_noDataImage) {
        return [UIImage imageNamed:@"commentDefaultPage_ico"];
    }
    return _noDataImage;
}

- (void)setCustomerView:(UIView *)view forLoadState:(MRJLoadDataState)loadState{
    if (view) {
        [self.customerViewDictionary setObject:view forKey:@(loadState)];
    }
}
- (UIView *)customerViewForLoadState:(MRJLoadDataState)loadState{
    return [self.customerViewDictionary objectForKey:@(loadState)];
}

- (UIView *)customerViewForError:(NSInteger)errorCode{
    return [self.customerErrorViewDictionary objectForKey:@(errorCode)];
}

- (void)setCustomerView:(UIView *)view forError:(NSInteger)errorCode{
    if(view){
        [self.customerErrorViewDictionary setObject:view forKey:@(errorCode)];
    }
}

- (NSMutableDictionary *)customerViewDictionary{
    if (!_customerViewDictionary) {
        _customerViewDictionary=[NSMutableDictionary dictionaryWithCapacity:5];
    }
    return _customerViewDictionary;
}

- (NSMutableDictionary *)customerErrorViewDictionary{
    if(!_customerErrorViewDictionary){
        _customerErrorViewDictionary=[NSMutableDictionary dictionaryWithCapacity:3];
    }
    return _customerErrorViewDictionary;
}

@end
