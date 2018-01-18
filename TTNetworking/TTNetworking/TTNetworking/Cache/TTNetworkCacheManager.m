//
//  TTNetworkCacheManager.m
//  TTNetworking
//
//  Created by tw on 2018/1/17.
//  Copyright © 2018年 tw. All rights reserved.
//

#import "TTNetworkCacheManager.h"
#import "TTNetworkRequestModel.h"
#import "TTNetworkConfig.h"
#import "TTNetworkUtils.h"
#import "TTNetworkCacheInfo.h"
#import "TTNetworkDownloadResumeDataInfo.h"

#ifndef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_With_QoS_Available 1140.11
#else
#define NSFoundationVersionNumber_With_QoS_Available NSFoundationVersionNumber_iOS_8_0
#endif

static dispatch_queue_t sj_cache_io_queue(){
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attr = DISPATCH_QUEUE_SERIAL;
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_With_QoS_Available) {
            attr = dispatch_queue_attr_make_with_qos_class(attr, QOS_CLASS_BACKGROUND, 0);
        }
        queue = dispatch_queue_create("com.sj.caching.io", attr);
    });
    return queue;
}

@implementation TTNetworkCacheManager{
    NSFileManager *_fileManager;
    NSString *_cacheBasePath;
    BOOL _isDebugMode;
}

#pragma mark- ============== Life Cycle Methods ==============
+ (TTNetworkCacheManager *)sharedManager{
    static TTNetworkCacheManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[TTNetworkCacheManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
        _cacheBasePath = [TTNetworkUtils createCacheBasePath];
        _isDebugMode = [TTNetworkConfig sharedConfig].debugMode;
    }
    return self;
}

//==================== Write Cache ====================//

#pragma mark- ============== Public Methods ==============
#pragma mark Write Cache
- (void)writeCacheWithRequestModel:(TTNetworkRequestModel *)requestModel asynchronously:(BOOL)asynchronously{
    if (asynchronously) {
        dispatch_async(sj_cache_io_queue(), ^{
            [self p_writeCacheWithRequestModel:requestModel];
        });
    }else{
        [self p_writeCacheWithRequestModel:requestModel];
    }
}

#pragma mark Load Cache
- (void)loadCacheWithUrl:(NSString *)url completionBlock:(TTLoadCacheArrCompletionBlock)completionBlock{
    NSString *partialIdentifer = [TTNetworkUtils generatePartialIdentiferWithBaseUrlStr:[TTNetworkConfig sharedConfig].baseUrl requestUrlStr:url methodStr:nil];
    [self p_loadCacheWithPartialIdentifer:partialIdentifer completionBlock:completionBlock];
}

- (void)loadCacheWithUrl:(NSString *)url method:(NSString *)method completionBlock:(TTLoadCacheArrCompletionBlock)completionBlock{
    NSString *partialIdentifer = [TTNetworkUtils generatePartialIdentiferWithBaseUrlStr:[TTNetworkConfig sharedConfig].baseUrl requestUrlStr:url methodStr:method];
    [self p_loadCacheWithPartialIdentifer:partialIdentifer completionBlock:completionBlock];
}

- (void)loadCacheWithUrl:(NSString *)url method:(NSString *)method parameters:(id _Nullable)parameters completionBlock:(TTLoadCacheCompletionBlock _Nullable)completionBlock{
    NSString *requestIdentifer = [TTNetworkUtils generateRequestIdentiferWithBaseUrlStr:[TTNetworkConfig sharedConfig].baseUrl requestUrlStr:url methodStr:method parameters:parameters];
    [self loadCacheWithUrl:requestIdentifer completionBlock:^(NSArray * _Nullable cacheArr) {
        if (completionBlock) {
            completionBlock(cacheArr);
        }
    }];
}

- (void)loadCacheWithRequestIdentifer:(NSString *)requstIdentifer completionBlock:(TTLoadCacheCompletionBlock)completionBlock{
    NSString *cacheDataFilePath = [TTNetworkUtils cacheDataFilePathWithRequestIdentifer:requstIdentifer];
    NSString *cacheInfoFilePath = [TTNetworkUtils cacheDataInfoFilePathWithRequestIdentifer:requstIdentifer];
    
    //load cache info
    TTNetworkCacheInfo *cacheInfo = [self p_loadCacheInfoWithRequestIdentifer:requstIdentifer];
    if (!cacheInfo) {
        if (_isDebugMode) {
            TTLog(@"=================== Load cache failed:Cache Info dose not exists in path:%@",cacheInfoFilePath);
        }
        
        [self removeCacheDataFile:cacheDataFilePath cacheInfoFile:cacheInfoFilePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(nil);
            }
        });
        return;
    }
    
    BOOL cacheValidation = [self p_checkCacheValidation:cacheInfo];
    
    if (!cacheValidation) {
        if (_isDebugMode) {
            TTLog(@"============= Load cache failed:Cache info is invalid");
        }
        [self removeCacheDataFile:cacheDataFilePath cacheInfoFile:cacheInfoFilePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(nil);
            }
        });
        return;
    }
    
    id cacheObject = [self p_loadCacheObjectWithCacheFilePath:cacheDataFilePath];
    if (!cacheObject) {
        if (_isDebugMode) {
            TTLog(@"============ Load cache failed:Cache data is missing");
        }
        
        [self removeCacheDataFile:cacheDataFilePath cacheInfoFile:cacheInfoFilePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(nil);
            }
        });
        return;
    }else{
        if (_isDebugMode) {
            TTLog(@"=============== Load cache succeed:Cache location:%@",cacheDataFilePath);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(cacheObject);
            }
        });
    }
}

#pragma mark Calculate Cache
- (void)calculateAllCacheSizeCompletionBlock:(TTCalculateSizeCompletionBlock)completionBlock{
    NSURL *diskCacheURL = [NSURL fileURLWithPath:_cacheBasePath isDirectory:YES];
    
    dispatch_async(sj_cache_io_queue(), ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:@[NSFileSize]
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += fileSize.unsignedIntegerValue;
            fileCount += 1;
        }
        
        NSString *totalSizeStr = nil;
        NSUInteger mb = 1024 * 1024;
        if (totalSize < mb) {
            totalSizeStr = [NSString stringWithFormat:@"%.4f KB",(totalSize * 1.0 / 1024)];
        }else{
            totalSizeStr = [NSString stringWithFormat:@"%.4f MB",totalSize * 1.0 /(mb)];
        }
        if (_isDebugMode) {
            TTLog(@"================ Calculate cache size succeed:total fileCount: %ld & totalSize: %@",(unsigned long)fileCount, totalSizeStr);
        }
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(fileCount, totalSize, totalSizeStr);
            });
        }
    });
}

#pragma mark Clear Cache
- (void)clearAllCacheCompletionBlock:(TTClearCacheCompletionBlock)completionBlock{
    dispatch_async(sj_cache_io_queue(), ^{
        NSError *removeCacheFolderError = nil;
        NSError *createCacheFolderError = nil;
        [_fileManager removeItemAtPath:_cacheBasePath error:&removeCacheFolderError];
        if (!removeCacheFolderError) {
            [_fileManager createDirectoryAtPath:_cacheBasePath
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&createCacheFolderError];
            if (!createCacheFolderError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    TTLog(@"================== Clearing all cache successfully");
                    if (completionBlock) {
                        completionBlock(YES);
                        return;
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_isDebugMode) {
                        TTLog(@"================== Clearing cache error: Failed to create cache folder after removing it");
                    }
                    if (completionBlock) {
                        completionBlock(NO);
                        return;
                    }
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_isDebugMode) {
                    TTLog(@"================== Clearing cache error: Failed to remove cache folder");
                }
                if (completionBlock) {
                    completionBlock(NO);
                    return;
                }
            });
        }
    });
}

- (void)clearCacheWithUrl:(NSString *)url completionBlock:(TTClearCacheCompletionBlock)completionBlock{
    NSString *partiticalIdentifier = [TTNetworkUtils generatePartialIdentiferWithBaseUrlStr:[TTNetworkConfig sharedConfig].baseUrl
                                                                              requestUrlStr:url
                                                                                  methodStr:nil];
    [self p_clearCacheWithIdentifer:partiticalIdentifier completionBlock:completionBlock];
}

- (void)clearCacheWithUrl:(NSString *)url method:(NSString *)method completionBlock:(TTClearCacheCompletionBlock)completionBlock{
    NSString *partiticalIdentifier = [TTNetworkUtils generatePartialIdentiferWithBaseUrlStr:[TTNetworkConfig sharedConfig].baseUrl
                                                                              requestUrlStr:url
                                                                                  methodStr:method];
    [self p_clearCacheWithIdentifer:partiticalIdentifier completionBlock:completionBlock];
}

- (void)clearCacheWithUrl:(NSString *)url method:(NSString *)method parameters:(id)parameters completionBlock:(TTClearCacheCompletionBlock)completionBlock{
    NSString *requestIdentifier = [TTNetworkUtils generateRequestIdentiferWithBaseUrlStr:[TTNetworkConfig sharedConfig].baseUrl
                                                                              requestUrlStr:url
                                                                                  methodStr:method
                                                                              parameters:parameters];
    [self p_clearCacheWithIdentifer:requestIdentifier completionBlock:completionBlock];
}

#pragma mark Update resume data or resume data info
- (void)updateResumeDataInfoAfterSuspendWithRequestModel:(TTNetworkRequestModel *)requestModel{
    NSData *resumeData = requestModel.task.error.userInfo[NSURLSessionDownloadTaskResumeData];
    [resumeData writeToFile:requestModel.resumeDataFilePath options:NSDataWritingAtomic error:nil];
    
    int64_t downloadedByte = requestModel.task.countOfBytesReceived;
    int64_t totalByte = requestModel.task.countOfBytesExpectedToReceive;
    CGFloat percent = 1.0 * downloadedByte/totalByte;
    TTNetworkDownloadResumeDataInfo *dataInfo = [self loadResumeDataInfo:requestModel.resumeDataInfoFilePath];
    dataInfo.resumeDataLength = [NSString stringWithFormat:@"%lld",downloadedByte];
    dataInfo.totalDataLength = [NSString stringWithFormat:@"%lld", totalByte];
    dataInfo.resumeDataRatio = [NSString stringWithFormat:@"%.2f",percent];
    [NSKeyedArchiver archiveRootObject:dataInfo toFile:requestModel.resumeDataInfoFilePath];
}

- (void)removeResumeDataAndResumeDataInfoFileWithRequestModel:(TTNetworkRequestModel *)requestModel{
    [_fileManager removeItemAtPath:requestModel.resumeDataFilePath error:nil];
    [_fileManager removeItemAtPath:requestModel.resumeDataInfoFilePath error:nil];
}

- (void)removeCompleteDownloadDataAndClearResumeDataInfoFileWithRequestModel:(TTNetworkRequestModel *)requestModel{
    NSError *moveFileError = nil;
    [_fileManager moveItemAtPath:requestModel.resumeDataFilePath toPath:requestModel.downloadFilePath error:&moveFileError];
    if (moveFileError.code == 516) {
        [_fileManager removeItemAtPath:requestModel.resumeDataFilePath error:nil];
    }
    [_fileManager removeItemAtPath:requestModel.resumeDataInfoFilePath error:nil];
}

- (void)removeCacheDataFile:(NSString *)cacheDataFilePath cacheInfoFile:(NSString *)cacheInfoFilePath{
    if ([_fileManager fileExistsAtPath:cacheDataFilePath]) {
        [_fileManager removeItemAtPath:cacheDataFilePath error:nil];
    }
    if ([_fileManager fileExistsAtPath:cacheInfoFilePath]) {
        [_fileManager removeItemAtPath:cacheInfoFilePath error:nil];
    }
}

#pragma mark load resume data info
- (TTNetworkDownloadResumeDataInfo *)loadResumeDataInfo:(NSString *)filePath{
    TTNetworkDownloadResumeDataInfo *dataInfo = nil;
    if ([_fileManager fileExistsAtPath:filePath isDirectory:nil]) {
        dataInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if ([dataInfo isKindOfClass:[TTNetworkDownloadResumeDataInfo class]]) {
            return dataInfo;
        }else{
            return nil;
        }
    }
    return nil;
}

#pragma mark - ============== Private Methods ==============
- (void)p_writeCacheWithRequestModel:(TTNetworkRequestModel *)requestModel{
    if (requestModel.responseData) {
        //path of cache file
        [requestModel.responseData writeToFile:requestModel.cacheDataFilePath atomically:YES];
        
        //write cache info data
        TTNetworkCacheInfo *cacheInfo = [[TTNetworkCacheInfo alloc] init];
        cacheInfo.creationDate = [NSDate date];
        cacheInfo.cacheDuration = [NSNumber numberWithInteger:requestModel.cacheDuration];
        cacheInfo.appVersionStr = [TTNetworkUtils appVersionStr];
        cacheInfo.requestIdentifer = requestModel.requestIdentifer;
        
        [NSKeyedArchiver archiveRootObject:cacheInfo toFile:requestModel.cacheDataInfoFilePath];
        if (_isDebugMode) {
            TTLog(@"============== Write cache succeed!\n ==================== cache object: %@\n =============== Cache Path: %@\n ============== Available duration: %@ seconds", requestModel.responseObject, requestModel.cacheDataFilePath, cacheInfo.cacheDuration);
        }
    }else{
        if (_isDebugMode) {
            TTLog(@"============== Write cache failed! reason: There is no responseData");
        }
    }
}

- (void)p_loadCacheWithPartialIdentifer:(NSString *)partialIdentifer completionBlock:(TTLoadCacheArrCompletionBlock)completionBlock{
    NSDirectoryEnumerator *enumerator = [_fileManager enumeratorAtPath:_cacheBasePath];
    NSMutableArray *requestIdentifersArr = [[NSMutableArray alloc] initWithCapacity:2];
    
    for (NSString *fileName in enumerator) {
        if ([fileName containsString:partialIdentifer]) {
            if ([fileName containsString:TTNetworkCacheFileSuffix]) {
                NSString *identifer = [fileName substringWithRange:NSMakeRange(0, (fileName.length - TTNetworkCacheFileSuffix.length - 1))];
                [requestIdentifersArr addObject:identifer];
            }else{
                //do not match cache data file
            }
        }
    }
    
    if (requestIdentifersArr.count > 0) {
        NSMutableArray *cacheObjArr = [[NSMutableArray alloc] initWithCapacity:2];
        
        for (NSString *requestIdentifer in requestIdentifersArr) {
            [self loadCacheWithRequestIdentifer:requestIdentifer completionBlock:^(id  _Nullable cacheObject) {
                if (cacheObject) {
                    [cacheObjArr addObject:cacheObject];
                }
            }];
        }
        
        if (_isDebugMode) {
            TTLog(@"================ Load cache succeed: Found cahce corresponding the url");
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock([cacheObjArr copy]);
            }
        });
    }else{
        if (_isDebugMode) {
            TTLog(@"================= Load cache failed: There is no any cache corresponding this url");
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(nil);
            }
        });
    }
}

- (BOOL)p_checkCacheValidation:(TTNetworkCacheInfo *)cacheInfo{
    if (!cacheInfo || ![cacheInfo isKindOfClass:[TTNetworkCacheInfo class]]) {
        return NO;
    }
    
    //check duration
    NSDate *creationDate = cacheInfo.creationDate;
    NSTimeInterval pastDuration = - [creationDate timeIntervalSinceNow];
    NSTimeInterval cacheDuration = [cacheInfo.cacheDuration integerValue];
    
    if (cacheDuration <= 0) {
        if (_isDebugMode) {
            TTLog(@"================ Load cache info failed, reason: Did not set duration time, begin to clear cache...");
        }
        [self p_clearCacheWithIdentifer:cacheInfo.requestIdentifer completionBlock:nil];
        return NO;
    }
    if (pastDuration < 0 || pastDuration > cacheDuration) {
        if (_isDebugMode) {
            TTLog(@"============== Load cache info failed, reason:Cache is expired, begin to clear cache...");
        }
        [self p_clearCacheWithIdentifer:cacheInfo.requestIdentifer completionBlock:nil];
        return NO;
    }
    
    //check appVersion
    NSString *cacheAppVersionStr = cacheInfo.appVersionStr;
    NSString *currentAppVersionStr = [TTNetworkUtils appVersionStr];
    
    if ( (!cacheAppVersionStr) && (!currentAppVersionStr)) {
        if (_isDebugMode) {
            TTLog(@"=========== Load cache info failed, reason: Failed to load app version, begin to clear cache...");
        }
        [self p_clearCacheWithIdentifer:cacheInfo.requestIdentifer completionBlock:nil];
        return NO;
    }
    
    if (cacheAppVersionStr.length != currentAppVersionStr.length || ![cacheAppVersionStr isEqualToString:currentAppVersionStr]) {
        if (_isDebugMode) {
            TTLog(@"=========== Load cache info failed, reason: Failed to match app version, begin to clear cache...");
        }
        [self p_clearCacheWithIdentifer:cacheInfo.requestIdentifer completionBlock:nil];
        return NO;
    }
    return YES;
}

- (void)p_clearCacheWithIdentifer:(NSString *)identifier completionBlock:(TTClearCacheCompletionBlock _Nullable)completionBlock{
    NSMutableArray *deleteFileNamesArr = [[NSMutableArray alloc] initWithCapacity:2];
    NSDirectoryEnumerator *enumerator = [_fileManager enumeratorAtPath:_cacheBasePath];
    
    for (NSString *fileName in enumerator){
        if ([fileName containsString:identifier]) {
            NSString *deleteFilePath = [_cacheBasePath stringByAppendingPathComponent:fileName];
            [deleteFileNamesArr addObject:deleteFilePath];
        }
    }
    
    if ([deleteFileNamesArr count] > 0) {
        for (NSInteger index = 0; index < deleteFileNamesArr.count; index++) {
            dispatch_async(sj_cache_io_queue(), ^{
                [_fileManager removeItemAtPath:deleteFileNamesArr[index] error:nil];
                if (index == deleteFileNamesArr.count - 1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_isDebugMode) {
                            TTLog(@"=========== Clearing cache successfully!");
                        }
                        if (completionBlock) {
                            completionBlock(YES);
                            return;
                        }
                    });
                }
            });
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isDebugMode) {
                TTLog(@"=========== Clearing cache error: there is no corresponding cache info");
            }
            if (completionBlock) {
                completionBlock(NO);
                return;
            }
        });
    }
}

- (id)p_loadCacheObjectWithCacheFilePath:(NSString *)cacheFilePath{
    id cacheObject = nil;
    NSError *error = nil;
    
    if ([_fileManager fileExistsAtPath:cacheFilePath isDirectory:nil]) {
        NSData *data = [NSData dataWithContentsOfFile:cacheFilePath];
        cacheObject = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:&error];
        if (cacheObject) {
            return cacheObject;
        }
    }
    return cacheObject;
}

- (TTNetworkCacheInfo *)p_loadCacheInfoWithRequestIdentifer:(NSString *)requestIdentifer {
    NSString *cacheInfoFilePath = [TTNetworkUtils cacheDataInfoFilePathWithRequestIdentifer:requestIdentifer];
    TTNetworkCacheInfo *cacheInfo = nil;
    if ([_fileManager fileExistsAtPath:cacheInfoFilePath isDirectory:nil]) {
        cacheInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:cacheInfoFilePath];
        if ([cacheInfo isKindOfClass:[TTNetworkCacheInfo class]]) {
            return cacheInfo;
        }else{
            return nil;
        }
    }
    return nil;
}

@end
