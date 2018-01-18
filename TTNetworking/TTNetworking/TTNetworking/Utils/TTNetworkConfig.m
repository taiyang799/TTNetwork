//
//  TTNetworkConfig.m
//  TTNetworking
//
//  Created by tw on 2018/1/16.
//  Copyright © 2018年 tw. All rights reserved.
//

#import "TTNetworkConfig.h"

@interface TTNetworkConfig ()

@property (nonatomic, strong, readwrite) NSDictionary *customHeaders;

@end

@implementation TTNetworkConfig

+ (TTNetworkConfig *)sharedConfig{
    static TTNetworkConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.timeoutSeconds = 20;
    });
    return sharedInstance;
}

- (void)addCustomHeader:(NSDictionary *)header{
    if (![header isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    if ([[header allKeys] count] == 0) {
        return;
    }
    
    if (!_customHeaders) {
        _customHeaders = header;
        return;
    }
    
    NSMutableDictionary *headers_M = [_customHeaders mutableCopy];
    [header enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString *value, BOOL * _Nonnull stop) {
        [headers_M setObject:value forKey:key];
    }];
    _customHeaders = [headers_M copy];
}

@end
