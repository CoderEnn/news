//
//  ViewController.m
//  网易新闻
//
//  Created by zz on 16/1/20.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ViewController.h"
#import "ZDTitleCollectionView.h"
#import "ZDChannelCollectionView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//先添加观察者
    UICollectionViewFlowLayout *flow1 = [[UICollectionViewFlowLayout alloc]init];
    
    flow1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    flow1.itemSize = CGSizeMake(kWidth, kHeitht-55);
    
    flow1.minimumLineSpacing = 0;
    flow1.minimumInteritemSpacing = 0;
    
    ZDChannelCollectionView *channelView = [[ZDChannelCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow1];
    
    [self.view addSubview:channelView];
    
    
    //在发送通知
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 设置 内间距
    flow.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    ZDTitleCollectionView *titleView = [[ZDTitleCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    
    [self.view addSubview:titleView];

    

    
    
    
    
    
}



@end
