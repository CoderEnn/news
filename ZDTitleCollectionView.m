//
//  ZDTitleCollectionView.m
//  网易新闻

// 如果需要动态改变cell的大小,需要实现 UICollectionViewDelegateFlowLayout 的代理方法.
// UICollectionViewDelegateFlowLayout 决定 cell 的尺寸.
//  Copyright © 2016年 zz. All rights reserved.
//@"http://127.0.0.1/topic_news.json"

#import "ZDTitleCollectionView.h"
#import "titleModel.h"
#import "ZDTitleCell.h"
static NSString *ID = @"title";
@interface ZDTitleCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSMutableArray *titles;
@end
@implementation ZDTitleCollectionView

-(NSMutableArray *)titles{

    if (_titles == nil) {
        
        _titles = [NSMutableArray array];
    }
    return _titles;
}

//这个方法会被系统自动调用，最多两次
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{

    self = [super initWithFrame:frame collectionViewLayout:layout];

    if (self) {
        
        self.backgroundColor = [UIColor yellowColor];
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[ZDTitleCell class] forCellWithReuseIdentifier:ID];
        
        self.showsHorizontalScrollIndicator = NO;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadDataWithUrlStr:@"http://127.0.0.1/topic_news.json"];
        });
        
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollToPosition:) name:@"scrollToIndexPath" object:nil];
    return self;
    
}
-(void)scrollToPosition:(NSNotification *)userfo{

    [self reloadData]; // iOS 7.0 之后的关于 UIScorllView(UITableView 和 UICollectionView) 的滚动,需要添加刷新数据的操作,因为系统默认会计算一个值.
    NSIndexPath *indexPath = userfo.object;
    
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone   animated:NO];
    
    [self selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];

}
//加载数据
-(void)loadDataWithUrlStr:(NSString *)urlStr{

    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
  
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSArray *dataArr = dataDict[@"tList"];
        
        [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dict = obj;
            titleModel *title = [titleModel titleWithDict:dict];
            [self.titles addObject:title];
//            NSLog(@"%@",title.tname);
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            注意同步！！！
            [[NSNotificationCenter defaultCenter]postNotificationName:@"data" object:self.titles];
            
            [self reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            
        });
        
    }]resume];
    

}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 20, kWidth, 35);
}
#pragma UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.titles.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ZDTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
  
    titleModel *title = self.titles[indexPath.item];
    cell.title = title;

    return cell;
}
#pragma UICollectionViewDelegate
//最终选中只有一个，cell.selected 只有一个为YES
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    //send notification
   [[NSNotificationCenter defaultCenter]postNotificationName:@"selecte" object:indexPath];
    
    //自身滚动到中间位置
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    ZDTitleCell *cell = (ZDTitleCell *)[collectionView cellForItemAtIndexPath:indexPath];

    titleModel *title = self.titles[indexPath.item];
    
 
    
    cell.title = title;
    
    
}
//非选中状态
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{

    ZDTitleCell *cell = (ZDTitleCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    titleModel *title = self.titles[indexPath.item];
    
    cell.title = title;
}
#pragma UICollectionViewFlowLayout
// 如果需要动态改变cell的大小,需要实现 UICollectionViewDelegateFlowLayout 的代理方法.
// UICollectionViewDelegateFlowLayout 决定 cell 的尺寸.
// 动态设置 每一个 cell 的尺寸,对应于 UITableView 返回行高的方法.没一次调用 cellForItemAtIndexPath方法之前都会先调用这个方法,确定cell尺寸之后再绘制.
// 实现这个方法之后, layout.itemSize 就会失效.
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    titleModel *title  = self.titles[indexPath.item];
    UILabel *tlabel = [[UILabel alloc]init];
    tlabel.text = title.tname;
    tlabel.font = [UIFont systemFontOfSize:18];
    [tlabel sizeToFit];
    
    return tlabel.frame.size;
}

@end
