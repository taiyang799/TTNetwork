//
//  TTNetworkDownloadEngine.h
//  TTNetworking
//
//  Created by tw on 2018/1/17.
//  Copyright © 2018年 tw. All rights reserved.
//

#import "TTNetworkBaseEngine.h"

@interface TTNetworkDownloadEngine : TTNetworkBaseEngine

- (void)sendDownloadRequest:(NSString *_Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(TTDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(TTDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(TTDownloadFailureBlock _Nullable)downloadFailureBlock;

/**
 暂停所有下载请求
 */
- (void)suspendAllDownloadRequests;

/**
 暂停指定的下载请求
 */
- (void)suspendDownloadRequest:(NSString *_Nonnull)url;

- (void)suspendDownloadRequest:(NSString *_Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl;

- (void)suspendDownloadRequests:(NSArray *_Nonnull)urls;

- (void)suspendDownloadRequests:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl;


/**
 开始所有下载请求
 */
- (void)resumeAllDownloadRequests;

- (void)resumeDownloadRequest:(NSString *_Nonnull)url;

- (void)resumeDownloadRequest:(NSString *_Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl;

- (void)resumeDownloadRequests:(NSArray *_Nonnull)urls;

- (void)resumeDownloadRequests:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl;

- (void)cancelAllDownloadRequests;
- (void)cancelDownloadRequest:(NSString *_Nonnull)url;
- (void)cancelDownloadRequest:(NSString *_Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl;
- (void)cancelDownloadRequests:(NSArray *_Nonnull)urls;
- (void)cancelDownloadRequests:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl;

/**
 获取下载的百分比
 */
- (CGFloat)resumeDataRatioOfRequest:(NSString *_Nonnull)url;
- (CGFloat)resumeDataRatioOfRequest:(NSString *_Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl;

@end
