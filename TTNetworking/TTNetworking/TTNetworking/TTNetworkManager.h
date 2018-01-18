//
//  TTNetworkManager.h
//  TTNetworking
//
//  Created by tw on 2018/1/18.
//  Copyright © 2018年 tw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNetworkRequestModel.h"
#import "TTNetworkCacheManager.h"

@interface TTNetworkManager : NSObject

+ (TTNetworkManager *_Nullable)sharedManager;

+ (instancetype _Nullable)new NS_UNAVAILABLE;

- (void)addCustomHeader:(NSDictionary *_Nonnull)header;

- (NSDictionary *_Nullable)customHeaders;

#pragma mark - Request API using GET Method
- (void)sendGetRequest:(NSString *_Nonnull)url
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendGetRequest:(NSString *_Nonnull)url
            parameters:(id _Nullable)parameters
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendGetRequest:(NSString *_Nonnull)url
            parameters:(id _Nullable)parameters
             loadCache:(BOOL)loadCache
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendGetRequest:(NSString *_Nonnull)url
            parameters:(id _Nullable)parameters
             cacheDuration:(NSTimeInterval)cacheDuration
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendGetRequest:(NSString *_Nonnull)url
            parameters:(id _Nullable)parameters
             loadCache:(BOOL)loadCache
         cacheDuration:(NSTimeInterval)cacheDuration
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock;

#pragma mark- Request API using POST method
- (void)sendPostRequest:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
                success:(TTSuccessBlock _Nullable)successBlock
                failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendPostRequest:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
              loadCache:(BOOL)loadCache
                success:(TTSuccessBlock _Nullable)successBlock
                failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendPostRequest:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
          cacheDuration:(NSTimeInterval)cacheDuration
                success:(TTSuccessBlock _Nullable)successBlock
                failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendPostRequest:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
              loadCache:(BOOL)loadCache
          cacheDuration:(NSTimeInterval)cacheDuration
                success:(TTSuccessBlock _Nullable)successBlock
                failure:(TTFailureBlock _Nullable)failureBlock;

#pragma mark- Request API using PUT method
- (void)sendPUTRequest:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
                success:(TTSuccessBlock _Nullable)successBlock
                failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendPUTRequest:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
              loadCache:(BOOL)loadCache
                success:(TTSuccessBlock _Nullable)successBlock
                failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendPUTRequest:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
          cacheDuration:(NSTimeInterval)cacheDuration
                success:(TTSuccessBlock _Nullable)successBlock
                failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendPUTRequest:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
              loadCache:(BOOL)loadCache
          cacheDuration:(NSTimeInterval)cacheDuration
                success:(TTSuccessBlock _Nullable)successBlock
                failure:(TTFailureBlock _Nullable)failureBlock;

#pragma mark- Request API using DELETE method
- (void)sendDeleteRequest:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendDeleteRequest:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
             loadCache:(BOOL)loadCache
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendDeleteRequest:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
         cacheDuration:(NSTimeInterval)cacheDuration
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendDeleteRequest:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
             loadCache:(BOOL)loadCache
         cacheDuration:(NSTimeInterval)cacheDuration
               success:(TTSuccessBlock _Nullable)successBlock
               failure:(TTFailureBlock _Nullable)failureBlock;

#pragma mark- Request API using specific parameters
- (void)sendRequest:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendRequest:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
          loadCache:(BOOL)loadCache
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendRequest:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendRequest:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
          loadCache:(BOOL)loadCache
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock;

#pragma mark- Request API using specific request method
- (void)sendRequest:(NSString * _Nonnull)url
             method:(TTRequestMethod)method
         parameters:(id _Nullable)parameters
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendRequest:(NSString * _Nonnull)url
             method:(TTRequestMethod)method
         parameters:(id _Nullable)parameters
          loadCache:(BOOL)loadCache
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendRequest:(NSString * _Nonnull)url
             method:(TTRequestMethod)method
         parameters:(id _Nullable)parameters
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock;

- (void)sendRequest:(NSString * _Nonnull)url
             method:(TTRequestMethod)method
         parameters:(id _Nullable)parameters
          loadCache:(BOOL)loadCache
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock;

#pragma mark- Request API upload images
- (void)sendUploadImageRequest:(NSString * _Nonnull)url
                    parameters:(id _Nullable)parameters
                         image:(UIImage * _Nonnull)image
                          name:(NSString * _Nonnull)name
                      mimeType:(NSString * _Nullable)mimeType
                      progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock;

- (void)sendUploadImageRequest:(NSString * _Nonnull)url
                 ignoreBaseUrl:(BOOL)ignoreBaseUrl
                    parameters:(id _Nullable)parameters
                         image:(UIImage * _Nonnull)image
                          name:(NSString * _Nonnull)name
                      mimeType:(NSString * _Nullable)mimeType
                      progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock;

- (void)sendUploadImagesRequest:(NSString * _Nonnull)url
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> * _Nonnull)images
                           name:(NSString * _Nonnull)name
                       mimeType:(NSString * _Nullable)mimeType
                       progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock;

- (void)sendUploadImagesRequest:(NSString * _Nonnull)url
                  ignoreBaseUrl:(BOOL)ignoreBaseUrl
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> * _Nonnull)images
                           name:(NSString * _Nonnull)name
                       mimeType:(NSString * _Nullable)mimeType
                       progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock;

- (void)sendUploadImageRequest:(NSString * _Nonnull)url
                    parameters:(id _Nullable)parameters
                         image:(UIImage * _Nonnull)image
                 compressRatio:(float)compressRatio
                          name:(NSString * _Nonnull)name
                      mimeType:(NSString * _Nullable)mimeType
                      progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock;

- (void)sendUploadImageRequest:(NSString * _Nonnull)url
                 ignoreBaseUrl:(BOOL)ignoreBaseUrl
                    parameters:(id _Nullable)parameters
                         image:(UIImage * _Nonnull)image
                 compressRatio:(float)compressRatio
                          name:(NSString * _Nonnull)name
                      mimeType:(NSString * _Nullable)mimeType
                      progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock;

- (void)sendUploadImagesRequest:(NSString * _Nonnull)url
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> * _Nonnull)images
                  compressRatio:(float)compressRatio
                           name:(NSString * _Nonnull)name
                       mimeType:(NSString * _Nullable)mimeType
                       progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock;

- (void)sendUploadImagesRequest:(NSString * _Nonnull)url
                  ignoreBaseUrl:(BOOL)ignoreBaseUrl
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> * _Nonnull)images
                  compressRatio:(float)compressRatio
                           name:(NSString * _Nonnull)name
                       mimeType:(NSString * _Nullable)mimeType
                       progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock;

#pragma mark- Request API download files
- (void)sendDownloadRequest:(NSString * _Nonnull)url
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock;

- (void)sendDownloadRequest:(NSString * _Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock;

- (void)sendDownloadRequest:(NSString * _Nonnull)url
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock;

- (void)sendDownloadRequest:(NSString * _Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock;

- (void)sendDownloadRequest:(NSString * _Nonnull)url
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock;

- (void)sendDownloadRequest:(NSString * _Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock;

- (void)sendDownloadRequest:(NSString * _Nonnull)url
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock;

- (void)sendDownloadRequest:(NSString * _Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock;

#pragma mark - Suspend download requests

- (void)suspendAllDownloadRequests;
- (void)suspendDownloadRequest:(NSString * _Nonnull)url;
- (void)suspendDownloadRequest:(NSString * _Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl;
- (void)suspendDownloadRequests:(NSArray *_Nonnull)urls;
- (void)suspendDownloadRequests:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl;

#pragma mark - Resume download requests

- (void)resumeAllDownloadRequests;
- (void)resumeDownloadReqeust:(NSString *_Nonnull)url;
- (void)resumeDownloadReqeust:(NSString *_Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl;
- (void)resumeDownloadReqeusts:(NSArray *_Nonnull)urls;
- (void)resumeDownloadReqeusts:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl;

#pragma mark - Cancel download requests

- (void)cancelAllDownloadRequests;
- (void)cancelDownloadRequest:(NSString * _Nonnull)url;
- (void)cancelDownloadRequest:(NSString * _Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl;
- (void)cancelDownloadRequests:(NSArray *_Nonnull)urls;
- (void)cancelDownloadRequests:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl;
- (CGFloat)resumeDataRatioOfRequest:(NSString *_Nonnull)url;
- (CGFloat)resumeDataRatioOfRequest:(NSString *_Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl;

#pragma mark- Cancel requests
- (void)cancelAllCurrentRequests;
- (void)cancelCurrentRequestWithUrl:(NSString * _Nonnull)url;
- (void)cancelCurrentRequestWithUrl:(NSString * _Nonnull)url
                             method:(NSString * _Nonnull)method
                         parameters:(id _Nullable)parameters;

#pragma mark- Cache operations
//=============================== Load cache ==================================//
- (void)loadCacheWithUrl:(NSString * _Nonnull)url
         completionBlock:(TTLoadCacheArrCompletionBlock _Nullable)completionBlock;

- (void)loadCacheWithUrl:(NSString * _Nonnull)url
                  method:(NSString * _Nonnull)method
              parameters:(id _Nullable)parameters
         completionBlock:(TTLoadCacheCompletionBlock _Nullable)completionBlock;




//=============================== calculate cache ===========================//
- (void)calculateCacheSizeCompletionBlock:(TTCalculateSizeCompletionBlock _Nullable)completionBlock;

//================================= clear cache ==============================//
- (void)clearAllCacheCompletionBlock:(TTClearCacheCompletionBlock _Nullable)completionBlock;

- (void)clearCacheWithUrl:(NSString * _Nonnull)url
          completionBlock:(TTClearCacheCompletionBlock _Nullable)completionBlock;

- (void)clearCacheWithUrl:(NSString * _Nonnull)url
                   method:(NSString * _Nonnull)method
          completionBlock:(TTClearCacheCompletionBlock _Nullable)completionBlock;

- (void)loadCacheWithUrl:(NSString * _Nonnull)url
                  method:(NSString * _Nonnull)method
         completionBlock:(TTLoadCacheArrCompletionBlock _Nullable)completionBlock;

- (void)clearCacheWithUrl:(NSString * _Nonnull)url
                   method:(NSString * _Nonnull)method
               parameters:(id _Nonnull)parameters
          completionBlock:(TTClearCacheCompletionBlock _Nullable)completionBlock;

#pragma mark- Request Info

- (void)logAllCurrentRequests;

- (BOOL)remainingCurrentRequests;
- (NSInteger)currentRequestCount;

@end
