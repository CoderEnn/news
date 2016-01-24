//
//  ZDChannelDataCell.m
//  网易新闻
//
//  Created by zz on 16/1/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZDChannelDataCell.h"
#import "UIImageView+WebCache.h"
#import "ZDChannelDataModel.h"

#define kCellHEIGHT 80

@interface ZDChannelDataCell ()

@property(nonatomic ,strong)UIImageView *iconView;
@property(nonatomic ,strong)UILabel *titleLabel;
@property(nonatomic ,strong)UILabel *digestLabel;
@property(nonatomic ,strong)UILabel *replayLabel;
@property(nonatomic ,strong)UIView *bottomLine;

@end
@implementation ZDChannelDataCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor lightGrayColor];
        
        self.iconView = [[UIImageView alloc] init];
        
        self.iconView.backgroundColor = [UIColor orangeColor];
        
        self.titleLabel = [[UILabel alloc] init];
        
        self.digestLabel = [[UILabel alloc] init];
        
        self.replayLabel = [[UILabel alloc] init];
        
        UIView *bottomLine = [[UIView alloc]init];
        bottomLine.backgroundColor = [UIColor blackColor];
        self.bottomLine = bottomLine;
        
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.digestLabel];
        [self.contentView addSubview:self.replayLabel];
        [self.contentView addSubview:bottomLine];
        
    }
    return self;
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat imageX = 8;
    CGFloat imageW = 100;
    CGFloat imageH = 64;
    
    self.iconView.frame = CGRectMake(imageX, imageX, imageW, imageH);
    
    self.iconView.frame = CGRectMake(imageX, imageX, imageW, imageH);
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(imageW + 2*imageX, imageX , kWidth - imageW - 3*imageX, self.titleLabel.bounds.size.height);
    
    self.digestLabel.frame = CGRectMake(imageW + 2*imageX, self.titleLabel.bounds.size.height +2*imageX +1, kWidth - imageW - 3*imageX, 36);
    
    [self.replayLabel sizeToFit];
    self.replayLabel.frame = CGRectMake(kWidth - self.replayLabel.bounds.size.width - imageX, imageW - self.replayLabel.bounds.size.height - 3*imageX,self.replayLabel.bounds.size.width , self.replayLabel.bounds.size.height);
    
    self.bottomLine.frame = CGRectMake(0, 79, kWidth, 1);
    
}
-(void)setChannelModel:(ZDChannelDataModel *)channelModel{
    
    _channelModel = channelModel;
    
    NSURL *url = [NSURL URLWithString:channelModel.imgsrc];
    
    [self.iconView sd_setImageWithURL:url];
    
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.text = channelModel.title;
    
    self.digestLabel.font = [UIFont systemFontOfSize:14];
    self.digestLabel.text = channelModel.digest;
    self.digestLabel.numberOfLines = 2;
    
    self.replayLabel.font = [UIFont systemFontOfSize:10];
    self.replayLabel.text = [NSString stringWithFormat:@"跟帖数:%@",channelModel.replyCount];
}


@end
