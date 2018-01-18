//
//  TTNetworkUploadEngine.m
//  TTNetworking
//
//  Created by tw on 2018/1/17.
//  Copyright © 2018年 tw. All rights reserved.
//

#import "TTNetworkUploadEngine.h"
#import "TTNetworkRequestPool.h"
#import "TTNetworkConfig.h"
#import "TTNetworkUtils.h"
#import "TTNetworkProtocol.h"

@interface TTNetworkUploadEngine()<TTNetworkProtocol>

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation TTNetworkUploadEngine{
    BOOL _isDebugMode;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        //debug mode or not
        _isDebugMode = [TTNetworkConfig sharedConfig].debugMode;
        
        //AFSessionManager config
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        //RequestSerializer
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.requestSerializer.allowsCellularAccess = YES;
        
        _sessionManager.requestSerializer.timeoutInterval = [TTNetworkConfig sharedConfig].timeoutSeconds;
        
        
        //securityPolicy
        _sessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        [_sessionManager.securityPolicy setAllowInvalidCertificates:YES];
        _sessionManager.securityPolicy.validatesDomainName = NO;
        
        //ResponseSerializer
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
        
        //Queue
        _sessionManager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
    }
    return self;
}

- (void)sendUploadImagesRequest:(NSString *_Nonnull)url
                  ignoreBaseUrl:(BOOL)ignoreBaseUrl
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> *_Nonnull)images
                  compressRatio:(float)compressRatio
                           name:(NSString *_Nonnull)name
                       mimeType:(NSString *_Nullable)mimeType
                       progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock{
    if ([images count] == 0) {
        TTLog(@"=========== Upload image failed:There is no image to upload!");
        return;
    }
    
    //default method is POST
    NSString *methodStr = @"POST";
    
    //generate full request url
    NSString *completeUrlStr = nil;
    
    //generate a unique identifer of a spectific request
    NSString *requestIdentifer = nil;
    
    if (ignoreBaseUrl) {
        completeUrlStr = url;
        requestIdentifer = [TTNetworkUtils generateRequestIdentiferWithBaseUrlStr:nil requestUrlStr:url methodStr:methodStr parameters:parameters];
    }else{
        completeUrlStr = [[TTNetworkConfig sharedConfig].baseUrl stringByAppendingPathComponent:url];
        requestIdentifer = [TTNetworkUtils generateRequestIdentiferWithBaseUrlStr:[TTNetworkConfig sharedConfig].baseUrl requestUrlStr:url methodStr:methodStr parameters:parameters];
    }
    
    //add custom headers
    [self addCustomHeaders];
    
    //add default parameters
    NSDictionary * completeParameters = [self addDefaultParametersWithCustomParameters:parameters];
    
    //create corresponding request model and send request with it
    TTNetworkRequestModel *requestModel = [[TTNetworkRequestModel alloc] init];
    requestModel.requestUrl = completeUrlStr;
    requestModel.uploadUrl = url;
    requestModel.method = methodStr;
    requestModel.parameters = completeParameters;
    requestModel.uploadImages = images;
    requestModel.imageCompressRatio = compressRatio;
    requestModel.imagesIdentifer = name;
    requestModel.mimeType = mimeType;
    requestModel.requestIdentifer = requestIdentifer;
    requestModel.uploadSuccessBlock = uploadSuccessBlock;
    requestModel.uploadProgressBlock = uploadProgressBlock;
    requestModel.uploadFailureBlock = uploadFailureBlock;
    
    [self p_sendUploadImagesRequestWithRequestModel:requestModel];
}

#pragma mark- ============== Private Methods ==============
- (void)p_sendUploadImagesRequestWithRequestModel:(TTNetworkRequestModel *)requestModel{
    if (_isDebugMode) {
        TTLog(@"=========== Start upload request with url:%@...",requestModel.requestUrl);
    }
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionDataTask *uploadTask = [_sessionManager POST:requestModel.requestUrl parameters:requestModel.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [requestModel.uploadImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            float ratio = requestModel.imageCompressRatio;
            if (ratio > 1 || ratio < 0) {
                ratio = 1;
            }
            
            NSData *imageData = nil;
            NSString *imageType = nil;
            
            if ([requestModel.mimeType isEqualToString:@"png"] || [requestModel.mimeType isEqualToString:@"PNG"]) {
                imageData = UIImagePNGRepresentation(obj);
                imageType = @"png";
            }else if ([requestModel.mimeType isEqualToString:@"jpg"] || [requestModel.mimeType isEqualToString:@"JPG"]){
                imageData = UIImageJPEGRepresentation(obj, ratio);
                imageType = @"jpg";
            }else if ([requestModel.mimeType isEqualToString:@"jpeg"] || [requestModel.mimeType isEqualToString:@"JPEG"]){
                imageData = UIImageJPEGRepresentation(obj, ratio);
                imageType = @"jpeg";
            }else{
                imageData = UIImageJPEGRepresentation(obj, ratio);
                imageType = @"jpg";
            }
            
            long index = idx;
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
            long long totalMilliseconds = interval * 1000;
            
            NSString *fileName = [NSString stringWithFormat:@"%lld.%@", totalMilliseconds, imageType];
            NSString *identifer = [NSString stringWithFormat:@"%@%ld", requestModel.imagesIdentifer, index];
            
            [formData appendPartWithFileData:imageData name:identifer fileName:fileName mimeType:[NSString stringWithFormat:@"image/%@", imageType]];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (_isDebugMode) {
            TTLog(@"================ Upload image progress: %@", uploadProgress);
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (requestModel.uploadProgressBlock) {
                requestModel.uploadProgressBlock(uploadProgress);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_isDebugMode) {
            TTLog(@"=============== Upload image request succeed:%@\n ======== Successfully uploaded images:%@", responseObject, requestModel.uploadImages);
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (requestModel.uploadSuccessBlock) {
                requestModel.uploadSuccessBlock(responseObject);
            }
            [weakSelf handleRequestFinished:requestModel];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (_isDebugMode) {
            TTLog(@"========== Upload images request failed: \n ========== error:%@\n =========== status code:%ld\n =========== failed images:%@:", error, (long)error.code, requestModel.uploadImages);
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (requestModel.uploadFailureBlock) {
                requestModel.uploadFailureBlock(task, error, error.code, requestModel.uploadImages);
            }
            [weakSelf handleRequestFinished:requestModel];
        });
    }];
    
    requestModel.task = uploadTask;
    [[TTNetworkRequestPool sharedPool] addRequestModel:requestModel];
}

#pragma mark- ============== Override Methods ==============
- (id)addDefaultParametersWithCustomParameters:(id)parameters{
    id parameters_spliced = nil;
    if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
        if ([[[TTNetworkConfig sharedConfig].defailtParameters allKeys] count] > 0) {
            NSMutableDictionary *defaultParameters_m = [[TTNetworkConfig sharedConfig].defailtParameters mutableCopy];
            [defaultParameters_m addEntriesFromDictionary:parameters];
            parameters_spliced = [defaultParameters_m copy];
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

#pragma mark- ============== SJNetworkProtocol ==============
- (void)handleRequesFinished:(TTNetworkRequestModel *)requestModel{
    
    //clear all blocks
    [requestModel clearAllBlocks];
    
    //remove this requst model from request queue
    [[TTNetworkRequestPool sharedPool] removeRequestModel:requestModel];
}

@end
