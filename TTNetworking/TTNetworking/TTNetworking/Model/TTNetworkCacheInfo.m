//
//  TTNetworkCacheInfo.m
//  TTNetworking
//
//  Created by tw on 2018/1/15.
//  Copyright © 2018年 tw. All rights reserved.
//

#import "TTNetworkCacheInfo.h"

@implementation TTNetworkCacheInfo

+ (BOOL)supportsSecureCoding{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.cacheDuration forKey:NSStringFromSelector(@selector(cacheDuration))];
    [aCoder encodeObject:self.creationDate forKey:NSStringFromSelector(@selector(creationDate))];
    [aCoder encodeObject:self.appVersionStr forKey:NSStringFromSelector(@selector(appVersionStr))];
    [aCoder encodeObject:self.requestIdentifer forKey:NSStringFromSelector(@selector(requestIdentifer))];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.cacheDuration = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(cacheDuration))];
        self.creationDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(creationDate))];
        self.appVersionStr = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(appVersionStr))];
        self.requestIdentifer = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(requestIdentifer))];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"{cacheDuration:%@},{creationDate:%@},{appVersion:%@},{requestIdentifer:%@}", _cacheDuration, _creationDate, _appVersionStr, _requestIdentifer];
}

@end
