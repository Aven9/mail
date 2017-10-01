//
//  YYYMailManager.m
//  mail
//
//  Created by 杨杨杨 on 2017/9/15.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "YYYMailManager.h"

@implementation YYYMailManager
//单例
static YYYMailManager * manager;
+(void)load{
    [super load];
    [self shardedManager];
}
+(YYYMailManager *)shardedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[YYYMailManager alloc] init];
    });
    return manager;
}
//写信
-(void)sendMail:(NSString *)content{
    [self sendMail:content success:nil];
}
-(void)sendMail:(NSString *)content success:(YYYVoidBlock)block{
    YYYMail * mail=[YYYMail mailWithContent:content];
    [mail sendSelfWhenFinished:block];
}
+(void)sendMail:(NSString *)content success:(YYYVoidBlock)block{
    [manager sendMail:content success:block];
}
//获取信
-(void)getMail:(void (^)(YYYMail * content))block{
    [YYYMail getMailWhenFinished:^(YYYMail *mail) {
        self.currentMail=mail;
        block(mail);
    }];
}
+(void)getMail:(void (^)(YYYMail * mail))block{
    [manager getMail:block];
}
//回信
-(void)backMail:(NSString *)content{
    [self backMail:content success:nil];
}
-(void)backMail:(NSString *)content success:(YYYVoidBlock)block{
    [self.currentMail backSelfWithContent:content finished:block];
}
+(void)backMail:(NSString *)content success:(YYYVoidBlock)block{
    [manager backMail:content success:block];
}
+(void)backMail:(NSString *)content success:(YYYVoidBlock)block mail:(YYYMail *)mail{
    manager.currentMail=mail;
    [manager backMail:content success:block];
}
//拒收信
- (void)refuse{
    self.currentMail=nil;
    [self refuseWithBlock:nil];
}
- (void)refuseWithBlock:(YYYVoidBlock)block{
    [self.currentMail refuseWithBlock:block];
}
+(void)refuseWithBlock:(YYYVoidBlock)block{
    [manager refuseWithBlock:block];
}
// 查询自己写过的信
- (void)fetchMailsWritten:(void(^)(NSArray * mailsArray))block{
    [YYYMail fetchMailsWritten:block];
}
+ (void)fetchMailsWritten:(void (^)(NSArray *))block{
    [manager fetchMailsWritten:block];
}
// 查询自己回过的信
- (void)fetchMailsReplied:(void (^)(NSArray *))block{
    [YYYMail fetchMailsReplied:block];
}
+(void)fetchMailsReplied:(void (^)(NSArray *))block{
    [manager fetchMailsReplied:block];
}
@end
