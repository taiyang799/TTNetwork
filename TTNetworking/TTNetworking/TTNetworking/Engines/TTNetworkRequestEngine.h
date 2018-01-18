//
//  TTNetworkRequestEngine.h
//  TTNetworking
//
//  Created by tw on 2018/1/16.
//  Copyright © 2018年 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTNetworkBaseEngine.h"

@interface TTNetworkRequestEngine : NSObject

- (void)sendRequest:(NSString *_Nonnull)url
             method:(TTRequestMethod)method
         parameters:(id _Nullable)parameters
          loadCache:(BOOL)loadCache
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(TTSuccessBlock _Nullable)successBlock
            failure:(TTFailureBlock _Nullable)failureBlock;

@end
