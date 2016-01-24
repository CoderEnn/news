//
//  ZDChannelDataModel.m
//  网易新闻
//
//  Created by zz on 16/1/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZDChannelDataModel.h"

@implementation ZDChannelDataModel

+(instancetype)channelDataWithDict:(NSDictionary *)dict{

    ZDChannelDataModel *channelModel = [[ZDChannelDataModel alloc]init];
    [channelModel setValuesForKeysWithDictionary:dict];
    return channelModel;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
@end
