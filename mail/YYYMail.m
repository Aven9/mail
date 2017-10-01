//
//  YYYMail.m
//  mail
//
//  Created by 杨杨杨 on 2017/9/15.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "YYYMail.h"
#import "YYYUser.h"
#import <BmobSDK/Bmob.h>
@implementation YYYMail
//懒加载
typedef NS_ENUM(NSUInteger, YYYFindType) {
    YYYFindTypeOwner,
    YYYFindTypeReplyer
};
-(NSMutableArray<NSDictionary *> *)contentArray{
    if (nil==_contentArray) {
        _contentArray=[NSMutableArray array];
    }
    return _contentArray;
}

#pragma mark -  BmobObject 相关两个方法
//根据 信 创建一个BmobObject
- (BmobObject *)BmobObject{
    BmobObject * obj=[BmobObject objectWithClassName:@"mail"];
    [obj setObject:self.contentArray forKey:@"contentArray"];
    [obj setObject:self.userId forKey:@"userId"];
    [obj setObject:@(self.opened) forKey:@"opened"];
    
    return obj;
}
//根据BmobObject初始化一封信
+ (YYYMail *)mailWithBmobObject:(BmobObject *)obj{
    YYYMail * mail=[[YYYMail alloc] init];
    mail.contentArray=[obj objectForKey:@"contentArray"];
    mail.userId=[obj objectForKey:@"userId"];
    mail.replyUserId=[obj objectForKey:@"replyUserId"];
    mail.opened=[[obj objectForKey:@"opened"] boolValue];
    mail.obj=obj;
    return mail;
}
//设置信为被打开
-(void)open{
    if (self.isOpened==NO) {
        [self.obj setObject:@(YES) forKey:@"opened"];
        [self.obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"信更新成功为被打开成功");
            }else{
                NSLog(@"%@",error);
            }
        }];
    }
}
//发送 信 时候的初始化方法
+(YYYMail *)mailWithContent:(NSString *)content{
    return [[self alloc] initWithContent:content];
    
}
- (NSDictionary *)mailContentToDictionaryWithContent:(NSString *)content replyType:(YYYMailType)mailType{
    
    return @{@"content":content,@"type":@(mailType)};
}
- (instancetype)initWithContent:(NSString *)content{
    self = [super init];
    if (self) {
        
        [self.contentArray addObject:[self mailContentToDictionaryWithContent:content replyType:YYYMailTypeOwner]];
        self.userId=[YYYUser shardedUser].userId;
    }
    return self;
}
//上传 信 到网络上
- (void)sendSelf{
    [self sendSelfWhenFinished:nil];
}
- (void)sendSelfWhenFinished:(YYYVoidBlock)block{
    BmobObject * obj=[self BmobObject];
    
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            if(block)
            {
                block();
            }
            NSLog(@"发信成功");
            [[YYYUser shardedUser].sendMailsArray addObject:self];
        }
        else{
            NSLog(@"%@",error);
        }
    }];
    
}
//从网络上获取一个mail
+ (void)getMailWhenFinished:(void (^)(YYYMail *mail))block{
    BmobQuery * query=[BmobQuery queryWithClassName:@"mail"];
    query.limit=5;
    
    [query orderByAscending:@"updatedAt"];
    [query whereKey:@"opened" equalTo:@(NO)];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if (block) {
            if (array.count>0)
            {
                YYYMail * mail=[YYYMail mailWithBmobObject:array[arc4random()%array.count]];
                [mail open];
                block(mail);
            }
            else
                NSLog(@"一封信都没有");
        }
    }];
}
//回信的更新数据
- (void)backSelfWithContent:(NSString *)content{
    [self backSelfWithContent:content finished:nil];
}
- (void)backSelfWithContent:(NSString *)content finished:(YYYVoidBlock)block{
    //添加到数组里面去
    [self.contentArray addObject:[self mailContentToDictionaryWithContent:content replyType:YYYMailTypeReplyer]];
    self.replyUserId=[YYYUser shardedUser].userId;
    [self.obj setObject:self.replyUserId forKey:@"replyUserId"];
    
    [self.obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if(error)
        {
            NSLog(@"%@",error);
            return ;
        }
        NSLog(@"回信成功");
        [[YYYUser shardedUser].repliedMailsArray addObject:self];
        if (block) {
            block();
        }
    }];
}
//拒收这封信
- (void)refuse{
    [self refuseWithBlock:nil];
}
- (void)refuseWithBlock:(YYYVoidBlock)block{
    [self.obj setObject:@(NO) forKey:@"opened"];
    NSLog(@"信设置被关闭");
    [self.obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"信更新成功");
            if(block)
                block();
        }else{
            NSLog(@"%@",error);
        }
    }];
}
//查询自己写过的信
+ (void)fetchMailsWritten:(void(^)(NSArray * mailsArray))block{
    [self queryFindMailsWhereKey:YYYFindTypeOwner finished:block];
}
+ (void)fetchMailsReplied:(void (^)(NSArray * mailsArray))block{
    [self queryFindMailsWhereKey:YYYFindTypeReplyer finished:block];
}
+ (void)queryFindMailsWhereKey:(YYYFindType)type finished:(void (^)(NSArray * mailsArray))block{
    BmobQuery * query=[BmobQuery queryWithClassName:@"mail"];
    
    [query whereKey:YYYFindTypeOwner==type?@"userId":@"replyUserId" equalTo:[YYYUser shardedUser].userId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if (block) {
            NSMutableArray * mArray=[NSMutableArray arrayWithCapacity:1];
            for (BmobObject * obj in array) {
                [mArray addObject:[self mailWithBmobObject:obj]];
            }
            block(mArray);
        }
    }];
}
@end
