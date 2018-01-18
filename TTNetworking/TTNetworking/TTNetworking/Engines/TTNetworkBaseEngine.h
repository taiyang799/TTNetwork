//
//  TTNetworkBaseEngine.h
//  TTNetworking
//
//  Created by tw on 2018/1/16.
//  Copyright © 2018年 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTNetworkRequestModel.h"

@interface TTNetworkBaseEngine : NSObject

- (void)addCustomHeaders;

- (id)addDefaultParametersWithCustomParameters:(id)parameters;

- (void)requestDidSucceedWithRequestModel:(TTNetworkRequestModel *)requestModel;

@end
