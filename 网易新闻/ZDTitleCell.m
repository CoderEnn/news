//
//  ZDTitleCell.m
//  网易新闻
//
//  Created by zz on 16/1/20.
//    self.tLabel.center = self.center;//unuseful .相对于父容器的坐标center

// UICollectionViewCell 的布局:
// 1. 内部 UI 控件的布局自己写.
// 2. 本身的布局是 UICollectionViewFlowlayout 决定.
//

#import "ZDTitleCell.h"
#import "NSArray+Log.h"
@interface ZDTitleCell ()
@property (strong, nonatomic) UILabel *tLabel;
@end
@implementation ZDTitleCell
-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        UILabel *tLabel = [[UILabel alloc]init];
        self.tLabel = tLabel;
        [self.contentView addSubview:tLabel];
        // self.tLabel.backgroundColor = [UIColor redColor];
        self.tLabel.textAlignment = NSTextAlignmentCenter;
        self.tLabel.font  = [UIFont systemFontOfSize:18];
        
    }
    return self;
}
-(void)layoutSubviews{


    
    [super layoutSubviews];

    [self.tLabel sizeToFit];
    self.tLabel.frame = CGRectMake((self.contentView.bounds.size.width - self.tLabel.bounds.size.width)/2 , (self.contentView.bounds.size.height - self.tLabel.bounds.size.height)/2, self.tLabel.bounds.size.width, self.tLabel.bounds.size.height);
    
    
//    self.tLabel.frame = CGRectMake(0, 0, 80, 40);
//    self.tLabel.bounds = self.bounds;
//    self.tLabel.center = self.center;//unuseful .相对于父容器的坐标center
//    NSLog(@"%@",NSStringFromCGPoint(self.center) );
//    self.tLabel.backgroundColor = [UIColor redColor];
}
-(void)setTitle:(titleModel *)title{

    _title = title;
    self.tLabel.text = title.tname;
    
    if (self.selected) {
        self.tLabel.textColor = [UIColor redColor];
        self.tLabel.font  = [UIFont systemFontOfSize:18];
        [self.tLabel sizeToFit];
        self.tLabel.frame = CGRectMake((self.contentView.bounds.size.width - self.tLabel.bounds.size.width)/2 , (self.contentView.bounds.size.height - self.tLabel.bounds.size.height)/2, self.tLabel.bounds.size.width, self.tLabel.bounds.size.height);
    }else{
        self.tLabel.textColor = [UIColor blackColor];
        self.tLabel.font  = [UIFont systemFontOfSize:14];
        [self.tLabel sizeToFit];
        self.tLabel.frame = CGRectMake((self.contentView.bounds.size.width - self.tLabel.bounds.size.width)/2 , (self.contentView.bounds.size.height - self.tLabel.bounds.size.height)/2, self.tLabel.bounds.size.width, self.tLabel.bounds.size.height);
    }
}
@end
