//
//  titleModel.m
//  网易新闻
//
//  Created by zz on 16/1/20.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "titleModel.h"

@implementation titleModel
+(instancetype)titleWithDict:(NSDictionary *)dict{

    titleModel *title = [[titleModel alloc]init];
    [title setValuesForKeysWithDictionary:dict];
    return title;
}
//当字典属性跟模型属性不匹配时，重写下面的方法，就不会造成程序奔溃
//不能调用父类方法
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
//不能调用父类方法,否则程序奔溃
//    [super setValue:value forUndefinedKey:key];
}
@end
