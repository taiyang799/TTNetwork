//
//  TTNetworkUtils.h
//  TTNetworking
//
//  Created by tw on 2018/1/16.
//  Copyright © 2018年 tw. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *_Nonnull const TTNetworkCacheBaseFolderName;
extern NSString *_Nonnull const TTNetworkCacheFileSuffix;
extern NSString *_Nonnull const TTNetworkCacheInfoFileSuffix;
extern NSString *_Nonnull const TTNetworkDownloadResumeDataInfoFileSuffix;

@interface TTNetworkUtils : NSObject

+ (NSString *_Nullable)appVersionStr;

+ (NSString *_Nonnull)generateMD5StringFromString:(NSString *_Nonnull)string;

+ (NSString *_Nonnull)generateCompleteRequestUrlStrWithBaseUrlStr:(NSString *_Nonnull)baseUrlStr requestUrlStr:(NSString *_Nonnull)requestUrlStr;

+ (NSString *_Nonnull)generatePartialIdentiferWithBaseUrlStr:(NSString *_Nonnull)baseUrlStr
                                                requestUrlStr:(NSString *_Nullable)requestUrlStr
                                                    methodStr:(NSString *_Nullable)metodStr;

+ (NSString *_Nonnull)generateRequestIdentiferWithBaseUrlStr:(NSString *_Nullable)baseUrlStr
                                                requestUrlStr:(NSString *_Nullable)requestUrlStr
                                                    methodStr:(NSString *_Nullable)metodStr
                                                   parameters:(id _Nullable)parameters;

+ (NSString *_Nonnull)generateDownloadRequestIdentiferWithBaseUrlStr:(NSString *_Nullable)baseUrlStr requestUrlStr:(NSString *_Nonnull)requestUrlStr;

+ (NSString *_Nonnull)createBasePathWithFolderName:(NSString *_Nonnull)folderName;

+ (NSString *_Nonnull)createCacheBasePath;

+ (NSString *_Nonnull)cacheDataFilePathWithRequestIdentifer:(NSString *_Nonnull)requestIdentifer;

+ (NSString *_Nonnull)cacheDataInfoFilePathWithRequestIdentifer:(NSString *_Nonnull)requestIdentifer;

+ (NSString * _Nonnull)resumeDataFilePathWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer downloadFileName:(NSString * _Nonnull)downloadFileName;

+ (NSString * _Nonnull)resumeDataInfoFilePathWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer;

+ (BOOL)availabilityOfData:(NSData * _Nonnull)data;

+ (NSString * _Nullable)imageFileTypeForImageData:(NSData * _Nonnull)imageData;

@end
