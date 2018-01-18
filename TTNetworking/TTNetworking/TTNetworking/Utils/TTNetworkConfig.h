//
//  TTNetworkConfig.h
//  TTNetworking
//
//  Created by tw on 2018/1/16.
//  Copyright © 2018年 tw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTNetworkConfig : NSObject

/**
 base url，默认为nil
 */
@property (nonatomic, strong) NSString *_Nullable baseUrl;

/**
 默认参数，默认为nil
 */
@property (nonatomic, strong) NSDictionary *_Nullable defailtParameters;

/**
 自定义头，默认为nil
 */
@property (nonatomic, strong, readonly) NSDictionary *_Nullable customHeaders;

/**
 请求超时时间，默认为20秒
 */
@property (nonatomic, assign) NSTimeInterval timeoutSeconds;

/**
 如果把这个值设置为YES，那么就会打印所有详细log
 */
@property (nonatomic, assign) BOOL debugMode;

/**
 单例
 */
+ (TTNetworkConfig *_Nullable)sharedConfig;

- (void)addCustomHeader:(NSDictionary *_Nonnull)header;

@end
