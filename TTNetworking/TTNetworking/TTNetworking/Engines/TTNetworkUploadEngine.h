//
//  TTNetworkUploadEngine.h
//  TTNetworking
//
//  Created by tw on 2018/1/17.
//  Copyright © 2018年 tw. All rights reserved.
//

#import "TTNetworkBaseEngine.h"

@interface TTNetworkUploadEngine : TTNetworkBaseEngine

/**
 上传
 @param url request url
 @param ignoreBaseUrl ignoreBaseUrl
 @param parameters parameters
 @param images UIImage object array
 @param compressRatio 压缩比例
 @param name file name
 @param mimeType file type
 */
- (void)sendUploadImagesRequest:(NSString *_Nonnull)url
                  ignoreBaseUrl:(BOOL)ignoreBaseUrl
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> *_Nonnull)images
                  compressRatio:(float)compressRatio
                           name:(NSString *_Nonnull)name
                       mimeType:(NSString *_Nullable)mimeType
                       progress:(TTUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(TTUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(TTUploadFailureBlock _Nullable)uploadFailureBlock;

@end
