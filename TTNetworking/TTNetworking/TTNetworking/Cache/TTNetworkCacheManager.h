//
//  TTNetworkCacheManager.h
//  TTNetworking
//
//  Created by tw on 2018/1/17.
//  Copyright © 2018年 tw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTNetworkRequestModel, TTNetworkDownloadResumeDataInfo;

typedef void(^TTClearCacheCompletionBlock)(BOOL isSuccess);
typedef void(^TTLoadCacheCompletionBlock)(id _Nullable cacheObject);
typedef void(^TTLoadCacheArrCompletionBlock)(NSArray *_Nullable cacheArr);
typedef void(^TTCalculateSizeCompletionBlock)(NSUInteger fileCount, NSUInteger totalSize, NSString *_Nonnull totalSizeString);

@interface TTNetworkCacheManager : NSObject

+ (TTNetworkCacheManager *_Nonnull)sharedManager;

//============================ Write Cache ============================//
- (void)writeCacheWithRequestModel:(TTNetworkRequestModel *_Nonnull)requestModel asynchronously:(BOOL)asynchronously;

//============================= Load cache =============================//
- (void)loadCacheWithUrl:(NSString *_Nonnull)url completionBlock:(TTLoadCacheArrCompletionBlock _Nullable)completionBlock;

- (void)loadCacheWithUrl:(NSString *_Nonnull)url method:(NSString *_Nonnull)method completionBlock:(TTLoadCacheArrCompletionBlock _Nullable)completionBlock;

- (void)loadCacheWithUrl:(NSString *_Nonnull)url method:(NSString *_Nonnull)method parameters:(id _Nullable)parameters completionBlock:(TTLoadCacheCompletionBlock _Nullable)completionBlock;

- (void)loadCacheWithRequestIdentifer:(NSString *_Nonnull)requstIdentifer completionBlock:(TTLoadCacheCompletionBlock _Nullable)completionBlock;

//============================ calculate cache ============================//
- (void)calculateAllCacheSizeCompletionBlock:(TTCalculateSizeCompletionBlock _Nullable)completionBlock;

//============================== clear cache ==============================//
- (void)clearAllCacheCompletionBlock:(TTClearCacheCompletionBlock _Nullable)completionBlock;

- (void)clearCacheWithUrl:(NSString * _Nonnull)url completionBlock:(TTClearCacheCompletionBlock _Nullable)completionBlock;

- (void)clearCacheWithUrl:(NSString * _Nonnull)url method:(NSString * _Nonnull)method completionBlock:(TTClearCacheCompletionBlock _Nullable)completionBlock;

- (void)clearCacheWithUrl:(NSString * _Nonnull)url method:(NSString * _Nonnull)method parameters:(id _Nullable)parameters completionBlock:(TTClearCacheCompletionBlock _Nullable)completionBlock;

//============================== Update resume data or resume data info ==============================//
- (void)updateResumeDataInfoAfterSuspendWithRequestModel:(TTNetworkRequestModel *_Nonnull)requestModel;

- (void)removeResumeDataAndResumeDataInfoFileWithRequestModel:(TTNetworkRequestModel *_Nonnull)requestModel;

- (void)removeCompleteDownloadDataAndClearResumeDataInfoFileWithRequestModel:(TTNetworkRequestModel *_Nonnull)requestModel;

//============================== Load resume data info ==============================//
- (TTNetworkDownloadResumeDataInfo *_Nullable)loadResumeDataInfo:(NSString *_Nonnull)filePath;

@end
