//
//  TTNetworkRequestEngine.m
//  TTNetworking
//
//  Created by tw on 2018/1/16.
//  Copyright © 2018年 tw. All rights reserved.
//

#import "TTNetworkRequestEngine.h"
#import "TTNetworkProtocol.h"
#import <AFNetworking.h>
#import "TTNetworkCacheManager.h"
#import "TTNetworkConfig.h"
#import "TTNetworkUtils.h"
#import "TTNetworkRequestPool.h"

@interface TTNetworkRequestEngine()<TTNetworkProtocol>

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) TTNetworkCacheManager *cacheManager;

@end

@implementation TTNetworkRequestEngine{
    NSFileManager *_fileManager;
    BOOL _isDebugMode;
}

#pragma mark- ============== Life Cycle Methods ==============
- (instancetype)init{
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
        _cacheManager = [TTNetworkCacheManager sharedManager];
        _isDebugMode = [TTNetworkConfig sharedConfig].debugMode;
        
        //AFSessionManager config
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        //RequestSerizer
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.requestSerializer.allowsCellularAccess = YES;
        _sessionManager.requestSerializer.timeoutInterval = [TTNetworkConfig sharedConfig].timeoutSeconds;
        
        //securityPolicy
        _sessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        [_sessionManager.securityPolicy setAllowInvalidCertificates:YES];
        _sessionManager.securityPolicy.validatesDomainName = NO;
        
        //ResponseSerializer
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml", @"text/html", @"application/json", @"text/plain", nil];
        
        //Queue
        _sessionManager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
    }
    return self;
}

#pragma mark- ============== Public Methods ==============
- (void)sendRequest:(NSString *)url
             method:(TTRequestMethod)method
         parameters:(id)parameters
          loadCache:(BOOL)loadCache
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(TTSuccessBlock)successBlock
            failure:(TTFailureBlock)failureBlock{
    //generate complete url string
    NSString *completeUrlStr = [TTNetworkUtils generateCompleteRequestUrlStrWithBaseUrlStr:[TTNetworkConfig sharedConfig].baseUrl
                                                                             requestUrlStr:url];
    //request method
    NSString *methodStr = [self p_methodStringFromRequestMethod:method];
    
    //generate a unique identifer of a certain request
    NSString *requestIdentifer = [TTNetworkUtils generateRequestIdentiferWithBaseUrlStr:[TTNetworkConfig sharedConfig].baseUrl
                                                                          requestUrlStr:url
                                                                              methodStr:methodStr
                                                                             parameters:parameters];
    
    if (loadCache) {
        //if client wants to load cache
        [_cacheManager loadCacheWithRequestIdentifer:requestIdentifer completionBlock:^(id  _Nullable cacheObject) {
            if (cacheObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_isDebugMode) {
                        TTLog(@"============ Request succeed by loading Cache! \n ================= Request url: %@\n ================= Response object: %@", completeUrlStr, cacheObject);
                    }
                    
                    if (successBlock) {
                        successBlock(cacheObject);
                        return;
                    }
                });
            }else{
                TTLog(@"============= Failed to load cache, start to sending network request...");
                [self p_sendRequestWithCompleteUrlStr:completeUrlStr
                                               method:methodStr
                                           parameters:parameters
                                            loadCache:loadCache
                                        cacheDuration:cacheDuration
                                     requestIdentifer:requestIdentifer
                                              success:successBlock
                                              failure:failureBlock];
            }
        }];
    }else{
        TTLog(@"=============== Do not need to load cache, start sending network request...");
        [self p_sendRequestWithCompleteUrlStr:completeUrlStr
                                       method:methodStr
                                   parameters:parameters
                                    loadCache:loadCache
                                cacheDuration:cacheDuration
                             requestIdentifer:requestIdentifer
                                      success:successBlock
                                      failure:failureBlock];
    }
}

#pragma mark- ============== Private Methods ==============
- (void)p_sendRequestWithCompleteUrlStr:(NSString *)completeUrlStr
                                 method:(NSString *)methodStr
                             parameters:(id)parameters
                              loadCache:(BOOL)loadCache
                          cacheDuration:(NSTimeInterval)cacheDuration
                       requestIdentifer:(NSString *)requestIdentifer
                                success:(TTSuccessBlock)successBlock
                                failure:(TTFailureBlock)failureBlock{
    //add custom headers
    [self addCustomHeaders];
    
    //add default parameters
    NSDictionary *completeParameters = [self addDefultParametersWithCustomParameters:parameters];
    
    //create corresponding request model
    TTNetworkRequestModel *requestModel = [[TTNetworkRequestModel alloc] init];
    requestModel.requestUrl = completeUrlStr;
    requestModel.method = methodStr;
    requestModel.parameters = completeParameters;
    requestModel.loadCache = loadCache;
    requestModel.cacheDuration = cacheDuration;
    requestModel.requestIdentifer = requestIdentifer;
    requestModel.successBlock = successBlock;
    requestModel.failureBlock = failureBlock;
    
    //create a session task corresponding to a request model
    NSError *__autoreleasing requestSerializationError = nil;
    NSURLSessionDataTask *dataTask = [self p_dataTaskWithRequestModel:requestModel
                                                    requestSerializer:_sessionManager.requestSerializer
                                                                error:&requestSerializationError];
    
    //save this request model
    requestModel.task = dataTask;
    
    //save this request model into request set
    [[TTNetworkRequestPool sharedPool] addRequestModel:requestModel];
    
    if (_isDebugMode) {
        TTLog(@"============== start requesting...\n ========= url: %@\n ================= method: %@\n ======= parameters: %@", completeUrlStr, methodStr, completeParameters);
    }
    
    //start request
    [dataTask resume];
}

- (NSURLSessionDataTask *)p_dataTaskWithRequestModel:(TTNetworkRequestModel *)requestModel
                                   requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                               error:(NSError *_Nullable __autoreleasing *)error{
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:requestModel.method
                                                              URLString:requestModel.requestUrl
                                                             parameters:requestModel.parameters
                                                                  error:error];
    __weak __typeof(self)weakSelf = self;
    NSURLSessionDataTask *dataTask = [_sessionManager dataTaskWithRequest:request
                                                           uploadProgress:nil
                                                         downloadProgress:nil
                                                        completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                            [weakSelf p_handleRequestModel:requestModel responseObject:responseObject error:error];
                                                        }];
    return dataTask;
}

- (void)p_handleRequestModel:(TTNetworkRequestModel *)requestModel
              responseObject:(id)responseObject
                       error:(NSError *)error{
    NSError *requestError = nil;
    BOOL requestSucceed = YES;
    
    if (error) {
        requestSucceed = NO;
        requestError = error;
    }
    
    if (requestSucceed) {
        requestModel.responseObject = responseObject;
        [self requestDidSucceedWithRequestModel:requestModel];
    }else{
        [self requestDidFailedWithRequestModel:requestModel error:requestError];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self handleRequestFinished:requestModel];
    });
}

- (NSString *)p_methodStringFromRequestMethod:(TTRequestMethod)method{
    switch (method) {
        case TTRequestMethodGET:
            return @"GET";
            break;
        case TTRequestMethodPOST:
            return @"POST";
            break;
        case TTRequestMethodPUT:
            return @"PUT";
            break;
        case TTRequestMethodDELETE:
            return @"DELETE";
            break;
    }
}

#pragma mark- ============== Override Methods ==============
- (void)requestDidSucceedWithRequestModel:(TTNetworkRequestModel *)requestModel{
    if (requestModel.cacheDuration > 0) {
        requestModel.responseData = [NSJSONSerialization dataWithJSONObject:requestModel.responseObject options:NSJSONWritingPrettyPrinted error:nil];
        if (requestModel.responseData) {
            [_cacheManager writeCacheWithRequestModel:requestModel asynchronously:YES];
        }else{
            TTLog(@"=============== Failed to write cache, since something was wrong when transfering response data");
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_isDebugMode) {
            TTLog(@"=========== Request succeed! \n =========== Request url:%@\n =========== Response object:%@", requestModel.requestUrl,requestModel.responseObject);
        }
        
        if (requestModel.successBlock) {
            requestModel.successBlock(requestModel.responseObject);
        }
    });
}

- (void)requestDidFailedWithRequestModel:(TTNetworkRequestModel *)requestModel error:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_isDebugMode) {
            TTLog(@"=========== Request failded! \n =========== Request model:%@ \n =========== NSError object:%@ \n =========== Status code:%ld",requestModel,error,(long)error.code);
        }
        if (requestModel.failureBlock){
            requestModel.failureBlock(requestModel.task, error, error.code);
        }
    });
}

- (id)addDefultParametersWithCustomParameters:(id)parameters{
    id parameters_spliced = nil;
    if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
        if ([[[TTNetworkConfig sharedConfig].defailtParameters allKeys] count] > 0) {
            NSMutableDictionary *defaultParameters_M = [[TTNetworkConfig sharedConfig].defailtParameters mutableCopy];
            [defaultParameters_M addEntriesFromDictionary:parameters];
            parameters_spliced = [defaultParameters_M copy];
        }else{
            parameters_spliced = parameters;
        }
    }else{
        parameters_spliced = [TTNetworkConfig sharedConfig].defailtParameters;
    }
    return parameters_spliced;
}

- (void)addCustomHeaders{
    NSDictionary *customHeaders = [TTNetworkConfig sharedConfig].customHeaders;
    if ([customHeaders allKeys] > 0) {
        NSArray *allKeys = [customHeaders allKeys];
        if ([allKeys count] >0) {
            [customHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
                [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
                if (_isDebugMode) {
                    TTLog(@"=========== added header:key:%@ value:%@",key,value);
                }
            }];
        }
    }
}

#pragma mark- ============== TTNetworkProtocol ==============
- (void)handleRequestFinished:(TTNetworkRequestModel *)requestModel{
    //clear all blocks
    [requestModel clearAllBlocks];
    
    //remove this requst model from request queue
    [[TTNetworkRequestPool sharedPool] removeRequestModel:requestModel];
}

@end
