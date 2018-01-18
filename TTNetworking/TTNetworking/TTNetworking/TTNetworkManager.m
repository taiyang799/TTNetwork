
//
//  TTNetworkManager.m
//  TTNetworking
//
//  Created by tw on 2018/1/18.
//  Copyright © 2018年 tw. All rights reserved.
//

#import "TTNetworkManager.h"
#import "TTNetworkConfig.h"
#import "TTNetworkRequestPool.h"
#import "TTNetworkRequestEngine.h"
#import "TTNetworkUploadEngine.h"
#import "TTNetworkDownloadEngine.h"

@interface TTNetworkManager()

@property (nonatomic, strong) TTNetworkRequestEngine *requestEngine;
@property (nonatomic, strong) TTNetworkUploadEngine *uploadEngine;
@property (nonatomic, strong) TTNetworkDownloadEngine *downloadEngine;

@property (nonatomic, strong) TTNetworkRequestPool *requestPool;
@property (nonatomic, strong) TTNetworkCacheManager *cacheManager;

@end

@implementation TTNetworkManager

#pragma mark- ============== Life Cycle ===========
+ (TTNetworkManager *)sharedManager{
    static TTNetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[TTNetworkManager alloc] init];
    });
    return sharedManager;
}

- (void)dealloc{
    [self cancelAllCurrentRequests];
}

#pragma mark- ============== Public Methods ==============
- (void)addCustomHeader:(NSDictionary *)header{
    [[TTNetworkConfig sharedConfig] addCustomHeader:header];
}

- (NSDictionary *)customHeaders{
    return [TTNetworkConfig sharedConfig].customHeaders;
}

#pragma mark - Request API using GET Method
- (void)sendGetRequest:(NSString *_Nonnull)url
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodGET
                         parameters:nil
                          loadCache:NO
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendGetRequest:(NSString *_Nonnull)url
            parameters:(id _Nullable)parameters
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodGET
                         parameters:parameters
                          loadCache:NO
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendGetRequest:(NSString *_Nonnull)url
            parameters:(id _Nullable)parameters
             loadCache:(BOOL)loadCache
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodGET
                         parameters:parameters
                          loadCache:loadCache
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendGetRequest:(NSString *_Nonnull)url
            parameters:(id _Nullable)parameters
         cacheDuration:(NSTimeInterval)cacheDuration
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodGET
                         parameters:parameters
                          loadCache:NO
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendGetRequest:(NSString *_Nonnull)url
            parameters:(id _Nullable)parameters
             loadCache:(BOOL)loadCache
         cacheDuration:(NSTimeInterval)cacheDuration
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodGET
                         parameters:parameters
                          loadCache:loadCache
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}

#pragma mark- Request API using POST method
- (void)sendPostRequest:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
                success:(TTSuccessBlock _Nullable)successBlock
                failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodPOST
                         parameters:parameters
                          loadCache:NO
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendPostRequest:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
              loadCache:(BOOL)loadCache
                success:(TTSuccessBlock _Nullable)successBlock
                failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodPOST
                         parameters:parameters
                          loadCache:loadCache
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendPostRequest:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
          cacheDuration:(NSTimeInterval)cacheDuration
                success:(TTSuccessBlock _Nullable)successBlock
                failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodPOST
                         parameters:parameters
                          loadCache:NO
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendPostRequest:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
              loadCache:(BOOL)loadCache
          cacheDuration:(NSTimeInterval)cacheDuration
                success:(TTSuccessBlock _Nullable)successBlock
                failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodPOST
                         parameters:parameters
                          loadCache:loadCache
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}

#pragma mark- Request API using PUT method
- (void)sendPUTRequest:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodPUT
                         parameters:parameters
                          loadCache:NO
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendPUTRequest:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
             loadCache:(BOOL)loadCache
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodPUT
                         parameters:parameters
                          loadCache:loadCache
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendPUTRequest:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
         cacheDuration:(NSTimeInterval)cacheDuration
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodPUT
                         parameters:parameters
                          loadCache:NO
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendPUTRequest:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
             loadCache:(BOOL)loadCache
         cacheDuration:(NSTimeInterval)cacheDuration
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodPUT
                         parameters:parameters
                          loadCache:loadCache
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}

#pragma mark- Request API using DELETE method
- (void)sendDeleteRequest:(NSString * _Nonnull)url
               parameters:(id _Nullable)parameters
                  success:(TTSuccessBlock _Nullable)successBlock
                  failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodDELETE
                         parameters:parameters
                          loadCache:NO
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendDeleteRequest:(NSString * _Nonnull)url
               parameters:(id _Nullable)parameters
                loadCache:(BOOL)loadCache
                  success:(TTSuccessBlock _Nullable)successBlock
                  failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodDELETE
                         parameters:parameters
                          loadCache:loadCache
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendDeleteRequest:(NSString * _Nonnull)url
               parameters:(id _Nullable)parameters
            cacheDuration:(NSTimeInterval)cacheDuration
                  success:(TTSuccessBlock _Nullable)successBlock
                  failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodDELETE
                         parameters:parameters
                          loadCache:NO
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendDeleteRequest:(NSString * _Nonnull)url
               parameters:(id _Nullable)parameters
                loadCache:(BOOL)loadCache
            cacheDuration:(NSTimeInterval)cacheDuration
                  success:(TTSuccessBlock _Nullable)successBlock
                  failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:TTRequestMethodDELETE
                         parameters:parameters
                          loadCache:loadCache
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}

#pragma mark- Request API using specific parameters
- (void)sendRequest:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock{
    if (parameters) {
        [self.requestEngine sendRequest:url
                                 method:TTRequestMethodPOST
                             parameters:parameters
                              loadCache:NO
                          cacheDuration:0
                                success:successBlock
                                failure:failureBlock];
    }else{
        [self.requestEngine sendRequest:url
                                 method:TTRequestMethodGET
                             parameters:nil
                              loadCache:NO
                          cacheDuration:0
                                success:successBlock
                                failure:failureBlock];
    }
}

- (void)sendRequest:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
          loadCache:(BOOL)loadCache
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock{
    if (parameters) {
        [self.requestEngine sendRequest:url
                                 method:TTRequestMethodPOST
                             parameters:parameters
                              loadCache:loadCache
                          cacheDuration:0
                                success:successBlock
                                failure:failureBlock];
    }else{
        [self.requestEngine sendRequest:url
                                 method:TTRequestMethodGET
                             parameters:nil
                              loadCache:loadCache
                          cacheDuration:0
                                success:successBlock
                                failure:failureBlock];
    }
}

- (void)sendRequest:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock{
    if (parameters) {
        [self.requestEngine sendRequest:url
                                 method:TTRequestMethodPOST
                             parameters:parameters
                              loadCache:NO
                          cacheDuration:cacheDuration
                                success:successBlock
                                failure:failureBlock];
    }else{
        [self.requestEngine sendRequest:url
                                 method:TTRequestMethodGET
                             parameters:nil
                              loadCache:NO
                          cacheDuration:cacheDuration
                                success:successBlock
                                failure:failureBlock];
    }
}

- (void)sendRequest:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
          loadCache:(BOOL)loadCache
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock{
    if (parameters) {
        [self.requestEngine sendRequest:url
                                 method:TTRequestMethodPOST
                             parameters:parameters
                              loadCache:loadCache
                          cacheDuration:cacheDuration
                                success:successBlock
                                failure:failureBlock];
    }else{
        [self.requestEngine sendRequest:url
                                 method:TTRequestMethodGET
                             parameters:nil
                              loadCache:loadCache
                          cacheDuration:cacheDuration
                                success:successBlock
                                failure:failureBlock];
    }
}

#pragma mark- Request API using specific request method
- (void)sendRequest:(NSString * _Nonnull)url
             method:(TTRequestMethod)method
         parameters:(id _Nullable)parameters
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:method
                         parameters:parameters
                          loadCache:NO
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendRequest:(NSString * _Nonnull)url
             method:(TTRequestMethod)method
         parameters:(id _Nullable)parameters
          loadCache:(BOOL)loadCache
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:method
                         parameters:parameters
                          loadCache:loadCache
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendRequest:(NSString * _Nonnull)url
             method:(TTRequestMethod)method
         parameters:(id _Nullable)parameters
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:method
                         parameters:parameters
                          loadCache:NO
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}

- (void)sendRequest:(NSString * _Nonnull)url
             method:(TTRequestMethod)method
         parameters:(id _Nullable)parameters
          loadCache:(BOOL)loadCache
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock{
    [self.requestEngine sendRequest:url
                             method:method
                         parameters:parameters
                          loadCache:loadCache
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}

#pragma mark- Request API upload images
- (void)sendUploadImageRequest:(NSString * _Nonnull)url
                    parameters:(id _Nullable)parameters
                         image:(UIImage * _Nonnull)image
                          name:(NSString * _Nonnull)name
                      mimeType:(NSString * _Nullable)mimeType
                      progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock{
    [self.uploadEngine sendUploadImagesRequest:url
                                 ignoreBaseUrl:NO
                                    parameters:parameters
                                        images:@[image]
                                 compressRatio:1
                                          name:name
                                      mimeType:mimeType
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
}

- (void)sendUploadImageRequest:(NSString * _Nonnull)url
                 ignoreBaseUrl:(BOOL)ignoreBaseUrl
                    parameters:(id _Nullable)parameters
                         image:(UIImage * _Nonnull)image
                          name:(NSString * _Nonnull)name
                      mimeType:(NSString * _Nullable)mimeType
                      progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock{
    [self.uploadEngine sendUploadImagesRequest:url
                                 ignoreBaseUrl:ignoreBaseUrl
                                    parameters:parameters
                                        images:@[image]
                                 compressRatio:1
                                          name:name
                                      mimeType:mimeType
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
}

- (void)sendUploadImagesRequest:(NSString * _Nonnull)url
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> * _Nonnull)images
                           name:(NSString * _Nonnull)name
                       mimeType:(NSString * _Nullable)mimeType
                       progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock{
    [self.uploadEngine sendUploadImagesRequest:url
                                 ignoreBaseUrl:NO
                                    parameters:parameters
                                        images:images
                                 compressRatio:1
                                          name:name
                                      mimeType:mimeType
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
}

- (void)sendUploadImagesRequest:(NSString * _Nonnull)url
                  ignoreBaseUrl:(BOOL)ignoreBaseUrl
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> * _Nonnull)images
                           name:(NSString * _Nonnull)name
                       mimeType:(NSString * _Nullable)mimeType
                       progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock{
    [self.uploadEngine sendUploadImagesRequest:url
                                 ignoreBaseUrl:ignoreBaseUrl
                                    parameters:parameters
                                        images:images
                                 compressRatio:1
                                          name:name
                                      mimeType:mimeType
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
}

- (void)sendUploadImageRequest:(NSString * _Nonnull)url
                    parameters:(id _Nullable)parameters
                         image:(UIImage * _Nonnull)image
                 compressRatio:(float)compressRatio
                          name:(NSString * _Nonnull)name
                      mimeType:(NSString * _Nullable)mimeType
                      progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock{
    [self.uploadEngine sendUploadImagesRequest:url
                                 ignoreBaseUrl:NO
                                    parameters:parameters
                                        images:@[image]
                                 compressRatio:compressRatio
                                          name:name
                                      mimeType:mimeType
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
}

- (void)sendUploadImageRequest:(NSString * _Nonnull)url
                 ignoreBaseUrl:(BOOL)ignoreBaseUrl
                    parameters:(id _Nullable)parameters
                         image:(UIImage * _Nonnull)image
                 compressRatio:(float)compressRatio
                          name:(NSString * _Nonnull)name
                      mimeType:(NSString * _Nullable)mimeType
                      progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock{
    [self.uploadEngine sendUploadImagesRequest:url
                                 ignoreBaseUrl:ignoreBaseUrl
                                    parameters:parameters
                                        images:@[image]
                                 compressRatio:compressRatio
                                          name:name
                                      mimeType:mimeType
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
}

- (void)sendUploadImagesRequest:(NSString * _Nonnull)url
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> * _Nonnull)images
                  compressRatio:(float)compressRatio
                           name:(NSString * _Nonnull)name
                       mimeType:(NSString * _Nullable)mimeType
                       progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock{
    [self.uploadEngine sendUploadImagesRequest:url
                                 ignoreBaseUrl:NO
                                    parameters:parameters
                                        images:images
                                 compressRatio:compressRatio
                                          name:name
                                      mimeType:mimeType
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
}

- (void)sendUploadImagesRequest:(NSString * _Nonnull)url
                  ignoreBaseUrl:(BOOL)ignoreBaseUrl
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> * _Nonnull)images
                  compressRatio:(float)compressRatio
                           name:(NSString * _Nonnull)name
                       mimeType:(NSString * _Nullable)mimeType
                       progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock{
    [self.uploadEngine sendUploadImagesRequest:url
                                 ignoreBaseUrl:ignoreBaseUrl
                                    parameters:parameters
                                        images:images
                                 compressRatio:compressRatio
                                          name:name
                                      mimeType:mimeType
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
}

#pragma mark- Request API download files
- (void)sendDownloadRequest:(NSString * _Nonnull)url
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock{
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:NO
                            downloadFilePath:downloadFilePath
                                   resumable:YES
                           backgroundSupport:NO
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
}

- (void)sendDownloadRequest:(NSString * _Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock{
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:ignoreBaseUrl
                            downloadFilePath:downloadFilePath
                                   resumable:YES
                           backgroundSupport:NO
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
}

- (void)sendDownloadRequest:(NSString * _Nonnull)url
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock{
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:NO
                            downloadFilePath:downloadFilePath
                                   resumable:resumable
                           backgroundSupport:NO
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
}

- (void)sendDownloadRequest:(NSString * _Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock{
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:ignoreBaseUrl
                            downloadFilePath:downloadFilePath
                                   resumable:resumable
                           backgroundSupport:NO
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
}

- (void)sendDownloadRequest:(NSString * _Nonnull)url
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock{
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:NO
                            downloadFilePath:downloadFilePath
                                   resumable:YES
                           backgroundSupport:backgroundSupport
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
}

- (void)sendDownloadRequest:(NSString * _Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock{
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:ignoreBaseUrl
                            downloadFilePath:downloadFilePath
                                   resumable:YES
                           backgroundSupport:backgroundSupport
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
}

- (void)sendDownloadRequest:(NSString * _Nonnull)url
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock{
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:NO
                            downloadFilePath:downloadFilePath
                                   resumable:resumable
                           backgroundSupport:backgroundSupport
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
}

- (void)sendDownloadRequest:(NSString * _Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock{
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:ignoreBaseUrl
                            downloadFilePath:downloadFilePath
                                   resumable:resumable
                           backgroundSupport:backgroundSupport
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
}

#pragma mark - Suspend download requests

- (void)suspendAllDownloadRequests{
    [self.downloadEngine suspendAllDownloadRequests];
}

- (void)suspendDownloadRequest:(NSString * _Nonnull)url{
    [self.downloadEngine suspendDownloadRequest:url];
}

- (void)suspendDownloadRequest:(NSString * _Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    [self.downloadEngine suspendDownloadRequest:url ignoreBaseUrl:ignoreBaseUrl];
}

- (void)suspendDownloadRequests:(NSArray *_Nonnull)urls{
    [self.downloadEngine suspendDownloadRequests:urls];
}

- (void)suspendDownloadRequests:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    [self.downloadEngine suspendDownloadRequests:urls ignoreBaseUrl:ignoreBaseUrl];
}

#pragma mark - Resume download requests

- (void)resumeAllDownloadRequests{
    [self.downloadEngine resumeAllDownloadRequests];
}

- (void)resumeDownloadReqeust:(NSString *_Nonnull)url{
    [self.downloadEngine resumeDownloadRequest:url];
}

- (void)resumeDownloadReqeust:(NSString *_Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    [self.downloadEngine resumeDownloadRequest:url ignoreBaseUrl:ignoreBaseUrl];
}

- (void)resumeDownloadReqeusts:(NSArray *_Nonnull)urls{
    [self.downloadEngine resumeDownloadRequests:urls];
}

- (void)resumeDownloadReqeusts:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    [self.downloadEngine resumeDownloadRequests:urls ignoreBaseUrl:ignoreBaseUrl];
}

#pragma mark - Cancel download requests

- (void)cancelAllDownloadRequests{
    [self.downloadEngine cancelAllDownloadRequests];
}

- (void)cancelDownloadRequest:(NSString * _Nonnull)url{
    [self.downloadEngine cancelDownloadRequest:url];
}

- (void)cancelDownloadRequest:(NSString * _Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    [self.downloadEngine cancelDownloadRequest:url ignoreBaseUrl:ignoreBaseUrl];
}

- (void)cancelDownloadRequests:(NSArray *_Nonnull)urls{
    [self.downloadEngine cancelDownloadRequests:urls];
}

- (void)cancelDownloadRequests:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    [self.downloadEngine cancelDownloadRequests:urls ignoreBaseUrl:ignoreBaseUrl];
}

- (CGFloat)resumeDataRatioOfRequest:(NSString *_Nonnull)url{
    return [self.downloadEngine resumeDataRatioOfRequest:url];
}

- (CGFloat)resumeDataRatioOfRequest:(NSString *_Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    return [self.downloadEngine resumeDataRatioOfRequest:url ignoreBaseUrl:ignoreBaseUrl];
}

#pragma mark- Cancel requests
- (void)cancelAllCurrentRequests{
    [self.requestPool cancelAllCurrentRequests];
}

- (void)cancelCurrentRequestWithUrl:(NSString * _Nonnull)url{
    [self.requestPool cancelCurrentRequestWithUrl:url];
}

- (void)cancelCurrentRequestWithUrl:(NSString * _Nonnull)url
                             method:(NSString * _Nonnull)method
                         parameters:(id _Nullable)parameters{
    [self.requestPool cancelCurrentRequestWithUrl:url method:method parameters:parameters];
}

#pragma mark- Cache operations
//=============================== Load cache ==================================//
- (void)loadCacheWithUrl:(NSString * _Nonnull)url
         completionBlock:(TTLoadCacheArrCompletionBlock _Nullable)completionBlock{
    [self.cacheManager loadCacheWithUrl:url completionBlock:completionBlock];
}

- (void)loadCacheWithUrl:(NSString * _Nonnull)url
                  method:(NSString * _Nonnull)method
              parameters:(id _Nullable)parameters
         completionBlock:(TTLoadCacheCompletionBlock _Nullable)completionBlock{
    [self.cacheManager loadCacheWithUrl:url method:method parameters:parameters completionBlock:completionBlock];
}

//=============================== calculate cache ===========================//
- (void)calculateCacheSizeCompletionBlock:(TTCalculateSizeCompletionBlock _Nullable)completionBlock{
    [self.cacheManager calculateAllCacheSizeCompletionBlock:completionBlock];
}

//================================= clear cache ==============================//
- (void)clearAllCacheCompletionBlock:(TTClearCacheCompletionBlock _Nullable)completionBlock{
    [self.cacheManager clearAllCacheCompletionBlock:completionBlock];
}

- (void)clearCacheWithUrl:(NSString * _Nonnull)url
          completionBlock:(TTClearCacheCompletionBlock _Nullable)completionBlock{
    [self.cacheManager clearCacheWithUrl:url completionBlock:completionBlock];
}

- (void)clearCacheWithUrl:(NSString * _Nonnull)url
                   method:(NSString * _Nonnull)method
          completionBlock:(TTClearCacheCompletionBlock _Nullable)completionBlock{
    [self.cacheManager clearCacheWithUrl:url method:method completionBlock:completionBlock];
}

- (void)loadCacheWithUrl:(NSString * _Nonnull)url
                  method:(NSString * _Nonnull)method
         completionBlock:(TTLoadCacheArrCompletionBlock _Nullable)completionBlock{
    [self.cacheManager loadCacheWithUrl:url method:method completionBlock:completionBlock];
}

- (void)clearCacheWithUrl:(NSString * _Nonnull)url
                   method:(NSString * _Nonnull)method
               parameters:(id _Nonnull)parameters
          completionBlock:(TTClearCacheCompletionBlock _Nullable)completionBlock{
    [self.cacheManager clearCacheWithUrl:url method:method parameters:parameters completionBlock:completionBlock];
}

#pragma mark- Request Info

- (void)logAllCurrentRequests{
    [self.requestPool logAllCurrentRequests];
}

- (BOOL)remainingCurrentRequests{
    return [self.requestPool remainingCurrentRequests];
}

- (NSInteger)currentRequestCount{
    return [self.requestPool currentRequestCount];
}

#pragma mark- Setter and Getter
- (TTNetworkRequestPool *)requestPool{
    if (!_requestPool) {
        _requestPool = [TTNetworkRequestPool sharedPool];
    }
    return _requestPool;
}

- (TTNetworkCacheManager *)cacheManager{
    if (!_cacheManager) {
        _cacheManager = [TTNetworkCacheManager sharedManager];
    }
    return _cacheManager;
}

- (TTNetworkRequestEngine *)requestEngine{
    if (!_requestEngine) {
        _requestEngine = [[TTNetworkRequestEngine alloc] init];
    }
    return _requestEngine;
}

- (TTNetworkUploadEngine *)uploadEngine{
    if (!_uploadEngine) {
        _uploadEngine = [[TTNetworkUploadEngine alloc] init];
    }
    return _uploadEngine;
}

- (TTNetworkDownloadEngine *)downloadEngine{
    if (!_downloadEngine) {
        _downloadEngine = [[TTNetworkDownloadEngine alloc] init];
    }
    return _downloadEngine;
}

@end
