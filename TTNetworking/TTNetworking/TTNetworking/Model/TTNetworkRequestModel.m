//
//  TTNetworkRequestModel.m
//  TTNetworking
//
//  Created by tw on 2018/1/16.
//  Copyright © 2018年 tw. All rights reserved.
//

#import "TTNetworkRequestModel.h"
#import "TTNetworkUtils.h"
#import "TTNetworkConfig.h"

@interface TTNetworkRequestModel()

@property (nonatomic, readwrite, copy) NSString *cacheDataFilePath;
@property (nonatomic, readwrite, copy) NSString *cacheDataInfoFilePath;

@property (nonatomic, readwrite, copy) NSString *resumeDataFilePath;
@property (nonatomic, readwrite, copy) NSString *resumeDataInfoFilePath;

@end

@implementation TTNetworkRequestModel

#pragma mark - ============== Public Methods ==============
- (TTRequestType)requestType{
    if (self.downloadFilePath) {
        return TTRequestTypeDownload;
    }else if (self.uploadUrl){
        return TTRequestTypeUpload;
    }else{
        return TTRequestTypeOrdinary;
    }
}

- (NSString *)cacheDataFilePath{
    if (self.requestType == TTRequestTypeOrdinary) {
        if (_cacheDataFilePath.length > 0) {
            return _cacheDataFilePath;
        }else{
            _cacheDataFilePath = [TTNetworkUtils cacheDataFilePathWithRequestIdentifer:_requestIdentifer];
            return _cacheDataFilePath;
        }
    }else{
        return nil;
    }
}

- (NSString *)cacheDataInfoFilePath{
    if (self.requestType == TTRequestTypeOrdinary) {
        if (_cacheDataInfoFilePath.length > 0) {
            return _cacheDataInfoFilePath;
        }else{
            _cacheDataInfoFilePath = [TTNetworkUtils cacheDataInfoFilePathWithRequestIdentifer:_requestIdentifer];
            return _cacheDataInfoFilePath;
        }
    }else{
        return nil;
    }
}

- (NSString *)resumeDataFilePath{
    if (self.requestType == TTRequestTypeDownload) {
        if (_resumeDataFilePath.length > 0) {
            return _resumeDataFilePath;
        }else{
            _resumeDataFilePath = [TTNetworkUtils resumeDataFilePathWithRequestIdentifer:_requestIdentifer downloadFileName:_downloadFilePath.lastPathComponent];
            return _resumeDataFilePath;
        }
    }else{
        return nil;
    }
}

- (NSString *)resumeDataInfoFilePath{
    if (self.requestType == TTRequestTypeDownload) {
        if (_resumeDataInfoFilePath.length > 0) {
            return _resumeDataInfoFilePath;
        }else{
            _resumeDataInfoFilePath = [TTNetworkUtils resumeDataInfoFilePathWithRequestIdentifer:_resumeDataInfoFilePath];
            return _resumeDataInfoFilePath;
        }
    }else{
        return nil;
    }
}

- (void)clearAllBlocks{
    _successBlock = nil;
    _failureBlock = nil;
    
    _uploadProgressBlock = nil;
    _uploadSuccessBlock = nil;
    _uploadFailureBlock = nil;
    
    _downloadProgressBlock = nil;
    _downloadSuccessBlock = nil;
    _downloadFailureBlock= nil;
}

#pragma mark - ============== Override Methods ==============
- (NSString *)description{
    if ([TTNetworkConfig sharedConfig].debugMode) {
        switch (self.requestType) {
            case TTRequestTypeOrdinary:
                return [NSString stringWithFormat:@"\n{\n   <%@: %p>\n   type:            oridnary request\n   method:          %@\n   url:             %@\n   parameters:      %@\n   loadCache:       %@\n   cacheDuration:   %@ seconds\n   requestIdentifer:%@\n   task:            %@\n}" ,NSStringFromClass([self class]),self,_method,_requestUrl,_parameters,_loadCache?@"YES":@"NO",[NSNumber numberWithInteger:_cacheDuration],_requestIdentifer,_task];
                break;
                
            case TTRequestTypeUpload:
                return [NSString stringWithFormat:@"\n{\n   <%@: %p>\n   type:            upload request\n   method:          %@\n   url:             %@\n   parameters:      %@\n   images:          %@\n    requestIdentifer:%@\n   task:            %@\n}" ,NSStringFromClass([self class]),self,_method,_requestUrl,_parameters,_uploadImages,_requestIdentifer,_task];
                break;
                
            case TTRequestTypeDownload:
                return [NSString stringWithFormat:@"\n{\n   <%@: %p>\n   type:            download request\n   method:          %@\n   url:             %@\n   parameters:      %@\n   target path:     %@\n    requestIdentifer:%@\n   task:            %@\n}" ,NSStringFromClass([self class]),self,_method,_requestUrl,_parameters,_downloadFilePath,_requestIdentifer,_task];
                break;
                
            default:
                [NSString stringWithFormat:@"\n  request type:unkown request type\n  request object:%@",self];
                break;
        }
    }else{
        return [NSString stringWithFormat:@"<%@: %p>" ,NSStringFromClass([self class]),self];
    }
}

@end
