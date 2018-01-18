//
//  TTNetworkDownloadResumeDataInfo.h
//  TTNetworking
//
//  Created by tw on 2018/1/16.
//  Copyright © 2018年 tw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTNetworkDownloadResumeDataInfo : NSObject<NSSecureCoding>

@property (nonatomic, readwrite, copy) NSString *resumeDataLength;
@property (nonatomic, readwrite, copy) NSString *totalDataLength;
@property (nonatomic, readwrite, copy) NSString *resumeDataRatio;

@end
