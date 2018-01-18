//
//  TTNetworkRequestPool.h
//  TTNetworking
//
//  Created by tw on 2018/1/16.
//  Copyright © 2018年 tw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTNetworkRequestModel;

typedef NSMutableDictionary<NSString *, TTNetworkRequestModel *> TTCurrentRequestModels;

@interface TTNetworkRequestPool : NSObject

//============================= Initialization =============================//
+ (TTNetworkRequestPool *_Nonnull)sharedPool;

//============================= Requests Management =============================//
- (TTCurrentRequestModels *_Nonnull)currentRequestModels;

- (void)addRequestModel:(TTNetworkRequestModel *_Nonnull)requestModel;

- (void)removeRequestModel:(TTNetworkRequestModel *_Nonnull)requestModel;

- (void)changeRequestModel:(TTNetworkRequestModel *_Nonnull)requestModel forKey:(NSString *_Nonnull)key;

//============================= Requests Info =============================//
- (BOOL)remainingCurrentRequests;

- (NSInteger)currentRequestCount;

- (void)logAllCurrentRequests;

//============================= Cancel requests =============================//
- (void)cancelAllCurrentRequests;

- (void)cancelCurrentRequestWithUrl:(NSString *_Nonnull)url;

- (void)cancelCurrentRequestWithUrls:(NSArray *_Nonnull)urls;

- (void)cancelCurrentRequestWithUrl:(NSString *_Nonnull)url
                                method:(NSString *_Nonnull)method
                            parameters:(id _Nullable)parameters;


@end
