//
//  ZDChanenlDataView.m
//  网易新闻
//
//  Created by zz on 16/1/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZDChanenlDataView.h"
#import "ZDChannelDataModel.h"
#import "ZDChannelDataCell.h"
#import "AFNetworking.h"
@interface ZDChanenlDataView ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *news;

@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (assign, nonatomic) NSInteger startIndex;
@end
@implementation ZDChanenlDataView

-(UIActivityIndicatorView *)activityView{

    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        
//        _activityView.center = self.superview.center;
        _activityView.center = self.center;//要先确定self.frame是否存在
        
        NSLog(@"%@",NSStringFromCGPoint(self.center));
        
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        [self addSubview:_activityView];
    }
    return _activityView;
}
-(NSMutableArray *)news{
    
    if (_news == nil) {
        _news= [NSMutableArray array];
    }
    return _news;
}

//1
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.dataSource = self;
        self.delegate = self;
        
        // 去掉默认的cell分割线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return self;
}
//3
-(void)layoutSubviews{

    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, kWidth, kHeitht - 55);
    
//    [self.activityView startAnimating];//这个时候，self.frame已经存在了,但是不能放在这边

}
//2
-(void)setTitleModel:(titleModel *)titleModel{

    _titleModel = titleModel;
    
//
    self.startIndex = 10;
    
    // 加载对应的新闻数据之前,应该清空原来的数据源.
    [self.news removeAllObjects];
    
    // 刷新数据
    [self reloadData];
    
    // 显示菊花
    [self.activityView startAnimating];
    
    // 加载data
    [self loadChannelDataWithTid:titleModel.tid];
    
    //显示状态栏菊花
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
}
-(void)loadChannelDataWithTid:(NSString *)tid{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/%@/0-20.html",tid];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data && !error) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSArray *arr = dict[tid];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dict = obj;
            
            ZDChannelDataModel *Model = [ZDChannelDataModel channelDataWithDict:dict];
            
            [self.news addObject:Model];
            
        }];
            dispatch_async(dispatch_get_main_queue(), ^{
    
                [self.activityView stopAnimating];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    [self reloadData];
            });
        }
    }]resume];
    
}
// 加载更多数据.
// 一次加载多少数据量比较合适? --> 一个屏幕的数据.
// 加载时机问题? --> 当还剩下一个屏幕数据的时候,就准备加载下一个屏幕的数据.
// tid :新闻频道
// startIndex :从多少条数据开始加载
// index :本次加载的数量
// 1. 探究获得的数据,如何得到想要的数据模型.
// 2. 研究 0-10 是什么意思. 10-20? 20-20? 20-10?
// 20-10 是从第 20 条开始 取 10 条数据.
// 以 10 的整数倍开始. 10 的 整数倍前面加 0
-(void)getMoreDataForStartIndex:(NSInteger)startIndex ForIndex:(NSInteger)index WithTid:(NSString *)tid{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
        NSString *urlStr = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/%@/%ld-%ld.html",tid,startIndex,index];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        
        NSDictionary *dict = responseObject;
        NSArray *arr = dict[tid];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            NSDictionary *dict = obj;
            ZDChannelDataModel *dataModel = [ZDChannelDataModel channelDataWithDict:dict];
            [self.news addObject:dataModel];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSections{

    return 1;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.news.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == self.startIndex) {
        self.startIndex +=10;
        [self getMoreDataForStartIndex:self.startIndex ForIndex:10 WithTid:self.titleModel.tid];
    }
    
    static NSString *ID = @"data";
    ZDChannelDataCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZDChannelDataCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    ZDChannelDataModel *model = self.news[indexPath.item];
    cell.channelModel = model;
//    cell.contentView.backgroundColor = [UIColor grayColor];
    
//    if (indexPath.row == ) {
//        <#statements#>
//    }
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
}

@end
