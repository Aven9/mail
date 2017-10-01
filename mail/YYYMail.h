//
//  YYYMail.h
//  mail
//
//  Created by 杨杨杨 on 2017/9/15.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BmobObject;
@interface YYYMail : NSObject
/** 发出信封的用户 */
@property (copy, nonatomic)NSString * userId;

typedef NS_ENUM(NSUInteger, YYYMailType) {
    YYYMailTypeOwner,
    YYYMailTypeReplyer
};
/**
 
 * 信封内容
 * NSDictionary : "content" : NSString; "replyer": NSString
 */
@property (strong, nonatomic)NSMutableArray <NSDictionary *>* contentArray;
/** 信是否被打开过 */
@property (assign, nonatomic, getter=isOpened)BOOL opened;
/** 回复信的人的userId */
@property (copy, nonatomic)NSString * replyUserId;
/** 存储的一个obj */
@property (strong, nonatomic)BmobObject * obj;
//发送信时候的初始化方法
+(YYYMail *)mailWithContent:(NSString *)content;
- (instancetype)initWithContent:(NSString *)content;
//从网络上获取一个mail
+ (void)getMailWhenFinished:(void (^)(YYYMail *mail))block;
//上传信到网络上
- (void)sendSelf;
- (void)sendSelfWhenFinished:(YYYVoidBlock)block;
//回信的更新数据
- (void)backSelfWithContent:(NSString *)content;
- (void)backSelfWithContent:(NSString *)content finished:(YYYVoidBlock)block;
//拒绝收信
- (void)refuse;
- (void)refuseWithBlock:(YYYVoidBlock)block;
//查询自己写过的信
+ (void)fetchMailsWritten:(void(^)(NSArray * mailsArray))block;
//查询自己回过的信
+ (void)fetchMailsReplied:(void (^)(NSArray *))block;
@end
