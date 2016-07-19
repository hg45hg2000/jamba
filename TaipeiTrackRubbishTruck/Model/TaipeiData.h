//
//  TaipeiData.h
//  TaipeiTrackRubbishTruck
//
//  Created by CENGLIN on 2016/5/14.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


@interface TaipeiData : NSObject{
    NSString *someProperty;
}
@property(nonatomic,retain)NSString *someProperty;

+(TaipeiData *)sharedManger;
-(void)creatDownLoadTask:(NSString *)url success:(void(^)(NSDictionary *responseData,NSURLResponse *response))success
                  failure:(void(^)(NSError *error))failure;
@end
