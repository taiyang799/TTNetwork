//
//  TTNetworkCacheInfo.h
//  TTNetworking
//
//  Created by tw on 2018/1/15.
//  Copyright © 2018年 tw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTNetworkCacheInfo : NSObject<NSSecureCoding>

@property (nonatomic, readwrite, strong) NSDate *creationDate;
@property (nonatomic, readwrite, strong) NSNumber *cacheDuration;
@property (nonatomic, readwrite, copy) NSString *appVersionStr;
@property (nonatomic, readwrite, copy) NSString *requestIdentifer;

@end
