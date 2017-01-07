//
//  TaipeiData.m
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/14.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

#import "TaipeiData.h"
#import "TaipeiTrackRubbishTruck-Swift.h"


@interface TaipeiData()

@end
@implementation TaipeiData

@synthesize someProperty;
+(TaipeiData *)sharedManger{
    static TaipeiData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager =[[self alloc]init];
    });
    return sharedMyManager;
}
-(id)init {
    if (self = [super init]){
        someProperty = @"Default Property Value";
    }
    return self;
}
-(void)checkInternet{
    
}
-(void)creatDownLoadTask:(NSString *)url success:(void(^)(NSDictionary *responseData,NSURLResponse *response))success
                 failure:(void(^)(NSError *error))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    if (error) {
        
        failure(error);
            NSLog(@"Error: %@", error);
    } else {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *responseArray = responseObject;
                /* do something with responseArray */
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
            success(responseObject,response);
            }            
        }
    }];
    [dataTask resume];
}
@end
