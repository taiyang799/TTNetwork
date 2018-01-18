//
//  ViewController.m
//  TTNetworking
//
//  Created by tw on 2018/1/15.
//  Copyright © 2018年 tw. All rights reserved.
//

#import "ViewController.h"
#import "TTNetwork.h"

@interface ViewController ()

@end

@implementation ViewController{
    NSString *_url0;
    NSString *_url1;
    NSString *_url2;
    
    NSDictionary *_params_0;
    NSDictionary *_params_1;
    NSDictionary *_params_2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [TTNetworkConfig sharedConfig].baseUrl = @"http://v.juhe.cn";
    
    _url0 = @"toutiao/index";
    _params_0 = @{
                  @"key":@"0c604536ac4f8c45fb4b90178bab9285",
                  @"type":@"keji"
                  };
    
    _url1 = @"toutiao/index";
    _params_1 = @{
                  @"key":@"0c604536ac4f8c45fb4b90178bab9285",
                  @"type":@"top"
                  };
    
    _url2 = @"weixin/query";
    _params_2 = @{
                  @"key":@"d57d833a635f34ac809b61390369e4da"
                  };
}

- (IBAction)button1Click:(UIButton *)sender {
    NSLog(@"==============================================");
    [[TTNetworkManager sharedManager] sendPostRequest:_url1 parameters:_params_1 success:^(id responseObject) {
        NSLog(@"request succeed:======%@",responseObject);
    } failure:^(NSURLSessionTask *task, NSError *error, NSInteger statusCode) {
        NSLog(@"request fialed:%@",error);
    }];
}

@end
