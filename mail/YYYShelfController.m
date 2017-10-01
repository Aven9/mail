//
//  YYYShelfController.m
//  mail
//
//  Created by 杨杨杨 on 2017/9/27.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "YYYShelfController.h"
#import "YYYShelfCell.h"
#import "YYYUser.h"
#import "YYYMailView.h"

@interface YYYShelfController ()
@property(strong,nonatomic)NSMutableArray *dataArr;
@property(weak, nonatomic)NSArray * sendArray;
@property(weak, nonatomic)NSArray * replyArray;
@end

@implementation YYYShelfController
#pragma mark - 懒加载
-(NSArray *)sendArray{
    if(_sendArray==nil){
        _sendArray=[YYYUser shardedUser].sendMailsArray;
    }
    return _sendArray;
}
-(NSArray *)replyArray{
    if(_replyArray==nil){
        _replyArray=[YYYUser shardedUser].repliedMailsArray;
    }
    return _replyArray;
}
static NSString * const reuseIdentifier = @"shelf_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ShelfCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
}
//- (instancetype)init
//{
//    UICollectionViewFlowLayout * flowLayout=[[UICollectionViewFlowLayout alloc] init];
//    flowLayout.itemSize=CGSizeMake(100, 100);
//    self = [super initWithCollectionViewLayout:flowLayout];
//    
//    return self;
//}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==0) {
        return self.sendArray.count;
    }else{
        return self.replyArray.count;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YYYMailView * view;
    if(indexPath.section==0){
        view=[[YYYMailView alloc] initWithFrame:CGRectMake(100, 300, self.view.frame.size.width-200, 100) mail:self.sendArray[indexPath.row]];
    }else{
        view=[[YYYMailView alloc] initWithFrame:CGRectMake(100, 300, self.view.frame.size.width-200, 100) mail:self.replyArray[indexPath.row]];
    }
    [self.view addSubview:view];
    [view animate];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     YYYShelfCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.imageV.image = [UIImage imageNamed:@"button_mushroom"];
    cell.name.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}



@end
