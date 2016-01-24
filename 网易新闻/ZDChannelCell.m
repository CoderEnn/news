//
//  ZDChannelCell.m
//  网易新闻
//
//  Created by zz on 16/1/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZDChannelCell.h"
#import "ZDChanenlDataView.h"
@interface ZDChannelCell ()
@property (strong, nonatomic) ZDChanenlDataView *dataView;
@end
@implementation ZDChannelCell

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        
        ZDChanenlDataView *dataView = [[ZDChanenlDataView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeitht)];
        [self.contentView addSubview:dataView];
        self.dataView = dataView;

    }
    return self;
}
//先调用这个方法
-(void)setTitleModel:(titleModel *)titleModel{

    _titleModel = titleModel;
    
    self.dataView.titleModel = titleModel;
}
////再调用这个方法
//-(void)layoutSubviews{
//
////    self.dataView.bounds = self.contentView.bounds;
//    self.dataView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
//    
//}
@end
