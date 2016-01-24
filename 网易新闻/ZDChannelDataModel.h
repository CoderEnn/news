//
//  ZDChannelDataModel.h
//  网易新闻
//
//  Created by zz on 16/1/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDChannelDataModel : NSObject
@property (copy, nonatomic) NSString *imgsrc;
@property (copy, nonatomic) NSNumber *replyCount;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *digest;
+(instancetype)channelDataWithDict:(NSDictionary *)dict;
@end
