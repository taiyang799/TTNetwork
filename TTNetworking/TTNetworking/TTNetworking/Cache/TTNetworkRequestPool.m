//
//  TTNetworkRequestPool.m
//  TTNetworking
//
//  Created by tw on 2018/1/16.
//  Copyright © 2018年 tw. All rights reserved.
//

#import "TTNetworkRequestPool.h"
#import "TTNetworkUtils.h"
#import "TTNetworkConfig.h"
#import "TTNetworkRequestModel.h"
#import "TTNetworkProtocol.h"

#import <pthread/pthread.h>
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

#define Lock()   pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

static char currentRequestModelsKey;

@interface TTNetworkRequestModel()<TTNetworkProtocol>

@end

@implementation TTNetworkRequestPool{
    pthread_mutex_t _lock;
    BOOL _isDebugMode;
}

#pragma mark- ============== Life Cycle ==============
+ (TTNetworkRequestPool *)sharedPool{
    static TTNetworkRequestPool *sharedPool = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPool = [[TTNetworkRequestPool alloc] init];
    });
    return sharedPool;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //lock
        pthread_mutex_init(&_lock, NULL);
        //debug mode or not
        _isDebugMode = [TTNetworkConfig sharedConfig].debugMode;
    }
    return self;
}

#pragma mark- ============== Public Methods ==============
- (TTCurrentRequestModels *)currentRequestModels{
    TTCurrentRequestModels *currentTasks = objc_getAssociatedObject(self, &currentRequestModelsKey);
    if (currentTasks) {
        return currentTasks;
    }
    currentTasks = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &currentRequestModelsKey, currentTasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return currentTasks;
}

- (void)addRequestModel:(TTNetworkRequestModel *)requestModel{
    Lock();
    [self.currentRequestModels setObject:requestModel forKey:[NSString stringWithFormat:@"%ld", (unsigned long)requestModel.task.taskIdentifier]];
    Unlock();
}

- (void)removeRequestModel:(TTNetworkRequestModel *)requestModel{
    Lock();
    [self.currentRequestModels removeObjectForKey:[NSString stringWithFormat:@"%ld",(unsigned long)requestModel.task.taskIdentifier]];
    Unlock();
}

- (void)changeRequestModel:(TTNetworkRequestModel *)requestModel forKey:(NSString *)key{
    Lock();
    [self.currentRequestModels removeObjectForKey:key];
    [self.currentRequestModels setObject:requestModel forKey:[NSString stringWithFormat:@"%ld",(unsigned long)requestModel.task.taskIdentifier]];
    Unlock();
}

- (BOOL)remainingCurrentRequests{
    NSArray *keys = [self.currentRequestModels allKeys];
    if (keys.count > 0) {
        TTLog(@"=============== There is remaining current request");
        return YES;
    }else{
        TTLog(@"=============== There is not remaining current request");
        return NO;
    }
}

- (NSInteger)currentRequestCount{
    if (![self remainingCurrentRequests]) {
        return 0;
    }
    NSArray *keys = [self.currentRequestModels allKeys];
    TTLog(@"=================== There is %ld current requests",(unsigned long)keys.count);
    return keys.count;
}

- (void)logAllCurrentRequests{
    if ([self remainingCurrentRequests]) {
        [self.currentRequestModels enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, TTNetworkRequestModel * _Nonnull obj, BOOL * _Nonnull stop) {
            TTLog(@"=========== Log current request:\n %@", obj);
        }];
    }
}

- (void)cancelAllCurrentRequests{
    if ([self remainingCurrentRequests]) {
        for (TTNetworkRequestModel *requestModel in [self.currentRequestModels allValues]) {
            if (requestModel.requestType == TTRequestTypeDownload) {
                if (requestModel.backgroundDownloadSupport) {
                    NSURLSessionDownloadTask *downloadTask = (NSURLSessionDownloadTask *)requestModel.task;
                    [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                    }];
                }else{
                    [requestModel.task cancel];
                }
            }else{
                [requestModel.task cancel];
                [self removeRequestModel:requestModel];
            }
        }
        TTLog(@"================ Canceled call current requests");
    }
}

- (void)cancelCurrentRequestWithUrl:(NSString *)url{
    if (![self remainingCurrentRequests]) {
        return;
    }
    
    NSMutableArray *cancelRequetModelsArr = [NSMutableArray arrayWithCapacity:2];
    NSString *requestIdentiferOfUrl = [TTNetworkUtils generateMD5StringFromString:[NSString stringWithFormat:@"Url:%@",url]];
    
    [self.currentRequestModels enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, TTNetworkRequestModel * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.requestIdentifer containsString:requestIdentiferOfUrl]) {
            [cancelRequetModelsArr addObject:obj];
        }
    }];
    
    if ([cancelRequetModelsArr count] == 0) {
        TTLog(@"============== There is no request to be canceled");
    }else{
        if (_isDebugMode) {
            TTLog(@"========== Request to be canceled:");
            [cancelRequetModelsArr enumerateObjectsUsingBlock:^(TTNetworkRequestModel *requestModel, NSUInteger idx, BOOL * _Nonnull stop) {
                TTLog(@"============== cancel request with url[%ld]:%@",(unsigned long)idx, requestModel.requestUrl);
            }];
        }
        
        [cancelRequetModelsArr enumerateObjectsUsingBlock:^(TTNetworkRequestModel *requestModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (requestModel.requestType == TTRequestTypeDownload) {
                if (requestModel.backgroundDownloadSupport) {
                    NSURLSessionDownloadTask *downloadTask = (NSURLSessionDownloadTask *)requestModel.task;
                    if (requestModel.task.state == NSURLSessionTaskStateCompleted) {
                        TTLog(@"============= Canceled background support download request:%@",requestModel);
                        NSError *error = [NSError errorWithDomain:@"Request has been canceled" code:0 userInfo:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (requestModel.downloadFailureBlock) {
                                requestModel.downloadFailureBlock(requestModel.task, error, requestModel.resumeDataFilePath);
                            }
                            [self handleRequestFinished:requestModel];
                        });
                    }else{
                        [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                        }];
                        TTLog(@"==================== Background support download request %@ has been canceled", requestModel);
                    }
                }else{
                    [requestModel.task cancel];
                    TTLog(@"=================== Request %@ has been canceled", requestModel);
                }
            }else{
                [requestModel.task cancel];
                TTLog(@"=================== Request %@ has been canceled", requestModel);
                if (requestModel.requestType != TTRequestTypeDownload) {
                    [self removeRequestModel:requestModel];
                }
            }
        }];
        
        TTLog(@"================ All requests with request url : '%@' are canceled",url);
    }
}

- (void)cancelCurrentRequestWithUrls:(NSArray *)urls{
    if ([urls count] == 0) {
        TTLog(@"============== There is no input urls!");
        return;
    }
    if (![self remainingCurrentRequests]) {
        return;
    }
    
    [urls enumerateObjectsUsingBlock:^(NSString *url, NSUInteger idx, BOOL * _Nonnull stop) {
        [self cancelCurrentRequestWithUrl:url];
    }];
}

- (void)cancelCurrentRequestWithUrl:(NSString *)url method:(NSString *)method parameters:(id)parameters{
    if (![self remainingCurrentRequests]) {
        return;
    }
    
    NSString *requestIdentifer = [TTNetworkUtils generateRequestIdentiferWithBaseUrlStr:[TTNetworkConfig sharedConfig].baseUrl requestUrlStr:url methodStr:method parameters:parameters];
    
    [self p_cancelRequestWithRequestIdentifer:requestIdentifer];
}

#pragma mark - ============== Private Methods ==============
- (void)p_cancelRequestWithRequestIdentifer:(NSString *)requestIdentifer{
    [self.currentRequestModels enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, TTNetworkRequestModel * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.requestIdentifer isEqualToString:requestIdentifer]) {
            if (obj.task) {
                [obj.task cancel];
                TTLog(@"=============== Canceled request: %@",obj);
                if (obj.requestType != TTRequestTypeDownload) {
                    [self removeRequestModel:obj];
                }
            }else{
                TTLog(@"=================== There is no task of this request");
            }
        }
    }];
}

#pragma mark- ============== TTNetworkProtocol ==============
- (void)handleRequestFinished:(TTNetworkRequestModel *)requestModel{
    //clear all blocks
    [requestModel clearAllBlocks];
    
    //remove this request model from request queue
    [[TTNetworkRequestPool sharedPool] removeRequestModel:requestModel];
}

@end
