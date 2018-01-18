//
//  TTNetworkRequestModel.h
//  TTNetworking
//
//  Created by tw on 2018/1/16.
//  Copyright © 2018年 tw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNetworkHeader.h"

@interface TTNetworkRequestModel : NSObject

@property (nonatomic, readwrite, copy) NSString *requestIdentifer;
@property (nonatomic, readwrite, strong) NSURLSessionTask *task;
@property (nonatomic, readwrite, strong) NSURLResponse *response;
@property (nonatomic, readwrite, copy) NSString *requestUrl;
@property (nonatomic, readwrite, assign) BOOL ignoreBaseUrl;
@property (nonatomic, readwrite, copy) NSString *method;
@property (nonatomic, readwrite, strong) id responseObject;

//============== Only for ordinary request(GET,POST,PUT,DELETE) ==================//
@property (nonatomic, readwrite, strong) id parameters;
@property (nonatomic, readwrite, assign) BOOL loadCache;
@property (nonatomic, readwrite, assign) NSTimeInterval cacheDuration;
@property (nonatomic, readwrite, strong) NSData *responseData;
@property (nonatomic, readwrite, copy) TTSuccessBlock successBlock;
@property (nonatomic, readwrite, copy) TTFailureBlock failureBlock;

//============== Only for upload request ==================//
@property (nonatomic, readwrite, copy) NSString *uploadUrl;
@property (nonatomic, readwrite, copy) NSArray<UIImage *> *uploadImages;
@property (nonatomic, readwrite, copy) NSString *imagesIdentifer;
@property (nonatomic, readwrite, copy) NSString *mimeType;
@property (nonatomic, readwrite, assign) float imageCompressRatio;
@property (nonatomic, readonly, copy) NSString *cacheDataFilePath;
@property (nonatomic, readonly, copy) NSString *cacheDataInfoFilePath;

@property (nonatomic, readwrite, copy) TTUploadSuccessBlock uploadSuccessBlock;
@property (nonatomic, readwrite, copy) TTUploadFailureBlock uploadFailureBlock;
@property (nonatomic, readwrite, copy) TTUploadProgressBlock uploadProgressBlock;

//============== Only for download request ==================//
@property (nonatomic, readwrite, copy) NSString *downloadFilePath;
@property (nonatomic, readwrite, assign) BOOL resumableDownload;///< 是否支持断点下载，默认YES
@property (nonatomic, readwrite, assign) BOOL backgroundDownloadSupport;///< 是否支持后台下载
@property (nonatomic, readwrite, strong) NSOutputStream *stream;
@property (nonatomic, readwrite, assign) NSInteger totalLength;
@property (nonatomic, readonly, copy) NSString *resumeDataFilePath;
@property (nonatomic, readonly, copy) NSString *resumeDataInfoFilePath;
@property (nonatomic, readwrite, assign) TTDownloadManualOperation manualOperation;

@property (nonatomic, readwrite, copy) TTDownloadSuccessBlock downloadSuccessBlock;
@property (nonatomic, readwrite, copy) TTDownloadProgressBlock downloadProgressBlock;
@property (nonatomic, readwrite, copy) TTDownloadFailureBlock downloadFailureBlock;

- (TTRequestType)requestType;
- (NSString *)cacheDataFilePath;
- (NSString *)cacheDataInfoFilePath;
- (NSString *)resumeDataFilePath;
- (NSString *)resumeDataInfoFilePath;
- (void)clearAllBlocks;

@end
