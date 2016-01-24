//
//  titleModel.h
//  网易新闻
//
//  Created by zz on 16/1/20.
//  Copyright © 2016年 zz. All rights reserved.
//       tid = T1370583240249;
//tname = "\U539f\U521b";

#import <Foundation/Foundation.h>

@interface titleModel : NSObject
@property (copy, nonatomic) NSString *tid;
@property (copy, nonatomic) NSString *tname;
+(instancetype)titleWithDict:(NSDictionary *)dict;
@end
