//
//  TTNetworkProtocol.h
//  TTNetworking
//
//  Created by tw on 2018/1/16.
//  Copyright © 2018年 tw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTNetworkRequestModel;

@protocol TTNetworkProtocol <NSObject>

@required

- (void)handleRequestFinished:(TTNetworkRequestModel *)requestModel;

@end
