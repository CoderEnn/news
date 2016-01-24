//
//  ZDChannelCollectionView.m
//  网易新闻
//
//  Created by zz on 16/1/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZDChannelCollectionView.h"
#import "ZDChannelCell.h"
static NSString *ID = @"channel";
@interface ZDChannelCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray *titles;
@end
@implementation ZDChannelCollectionView
-(NSMutableArray *)titles{

    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}
// layoutSubViews方法的调用时机: 当调用了 initWithFrame 之后,就会自动调用 layoutSubviews.
// 一般不需要展示的 UI空间,背景色设置成和父控件的背景色一样就OK了.
// 在初始化 UI 控件的时候,直接给一个 CGRectZero ,能够保证初始化的空间中不会有 frame.
// 自定义一个 tableView ,添加到 SHMainDataCollectionViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame =  CGRectMake(0, 55, kWidth, kHeitht - 55);
}
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{

    if ( self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[ZDChannelCell class] forCellWithReuseIdentifier:ID];
        
        // 取消滚动进度条
        self.showsHorizontalScrollIndicator = NO;
        
        // 取消弹簧效果
        self.bounces = NO;
        
        // 设置分页
        self.pagingEnabled = YES;
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(passTitles:) name:@"data" object:nil];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getIndex:) name:@"selecte" object:nil];

    }
    
    return self;
}
//-(void)layoutSubviews{
//
//    [super layoutSubviews];
//    self.frame = CGRectMake(0, 64, kWidth, kHeitht - 64);
//}
-(void)passTitles:(NSNotification*)userfo{

    self.titles = userfo.object;
    //下面的数据源方法比这个方法早调用，所以要重新刷新数据
    [self reloadData];
}
-(void)getIndex:(NSNotification *)usefo{

    NSIndexPath *indexPath = usefo.object;
//    [self selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];//selected
    
    // animated: YES ,会有动画效果,滚动中间所有的数据都会加载出来.
    // animated: NO ,不会有动画效果,只会加载滚动结束之后位置的数据.
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone   animated:NO];//scroll

}
-(void)dealloc
{
    // 移除通知观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// 每次移动 cell 的时候,就加载对应的新闻频道的数据.将 加载出来的数据传递给 tableView.
// 通知的使用注意2: 如果涉及到 UITableViewCell 或者 UICollectionViewCell ,有可能重用,一旦重用之后,通知就会变得混乱.
// 对于 定时器 (NSTimer) 添加在 UITableViewCell 或者 UICollectionViewCell 中的时候,也要注意 Cell 的重用问题导致的 定时器无法销毁.(定时器需要手动设置失效并且销毁.)
// 利用模型多层传值.
#pragma  mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.titles.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ZDChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.titleModel = self.titles[indexPath.item];
    cell.contentView.backgroundColor = [UIColor greenColor];
    
    return cell;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSInteger row = scrollView.contentOffset.x/kWidth;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"scrollToIndexPath" object:indexPath];
}

@end
