//
//  TTNetworkHeader.h
//  TTNetworking
//
//  Created by tw on 2018/1/16.
//  Copyright © 2018年 tw. All rights reserved.
//

#ifndef TTNetworkHeader_h
#define TTNetworkHeader_h

#import <AFNetworking/AFNetworking.h>

//Log used to debug
#ifdef DEBUG
#define TTLog(...) NSLog(@"%s line number:%d \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define TTLog(...)
#endif

//============== Callbacks: Only for ordinary request ==================//
typedef void(^TTSuccessBlock)(id responseObject);
typedef void(^TTFailureBlock)(NSURLSessionTask *task, NSError *error, NSInteger statusCode);

//============== Callbacks: Only for upload request ==================//
typedef void(^TTUploadSuccessBlock)(id responseObject);
typedef void(^TTUploadProgressBlock)(NSProgress *uploadProgress);
typedef void(^TTUploadFailureBlock)(NSURLSessionTask *task, NSError *error, NSInteger statusCode, NSArray<UIImage *> *uploadFailedImages);

//============== Callbacks: Only for download request ==================//
typedef void(^TTDownloadSuccessBlock)(id responseObject);
typedef void(^TTDownloadProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress);
typedef void(^TTDownloadFailureBlock)(NSURLSessionTask *task, NSError *error, NSString *resumedDataPath);

/**
 HTTP Request method
 */
typedef NS_ENUM(NSInteger, TTRequestMethod){
    TTRequestMethodGET = 60000,
    TTRequestMethodPOST,
    TTRequestMethodPUT,
    TTRequestMethodDELETE,
};

/**
 Request type
 */
typedef NS_ENUM(NSInteger, TTRequestType){
    TTRequestTypeOrdinary = 70000,
    TTRequestTypeUpload,
    TTRequestTypeDownload,
};

/**
 Manual operation by user (start, suspend, resume, cancel
 */
typedef NS_ENUM(NSInteger, TTDownloadManualOperation){
    TTDownloadManualOperationStart = 80000,
    TTDownloadManualOperationSuspend,
    TTDownloadManualOperationResume,
    TTDownloadManualOperationCancel,
};

#endif /* TTNetworkHeader_h */
