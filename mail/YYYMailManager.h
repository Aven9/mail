//
//  YYYMailManager.h
//  mail
//
//  Created by 杨杨杨 on 2017/9/15.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYYMail.h"
#import "YYYUser.h"
@interface YYYMailManager : NSObject
/** 当前获取的信 */
@property (strong, nonatomic)YYYMail * currentMail;
/** 单例 */
+(YYYMailManager *)shardedManager;
/** 写一封信 */
-(void)sendMail:(NSString *)content;
-(void)sendMail:(NSString *)content success:(YYYVoidBlock)block;
+(void)sendMail:(NSString *)content success:(YYYVoidBlock)block;
/** 获取一封信 */
-(void)getMail:(void (^)(YYYMail * mail))block;
+(void)getMail:(void (^)(YYYMail * mail))block;
/** 回信 */
-(void)backMail:(NSString *)content;
-(void)backMail:(NSString *)content success:(YYYVoidBlock)block;
+(void)backMail:(NSString *)content success:(YYYVoidBlock)block;
+(void)backMail:(NSString *)content success:(YYYVoidBlock)block mail:(YYYMail *)mail;
/** 拒绝收信 */
- (void)refuse;
- (void)refuseWithBlock:(YYYVoidBlock)block;
+ (void)refuseWithBlock:(YYYVoidBlock)block;
/** 查询自己写过的信 */
- (void)fetchMailsWritten:(void(^)(NSArray * mailsArray))block;
+ (void)fetchMailsWritten:(void(^)(NSArray * mailsArray))block;
/** 查询自己回过的信 */
- (void)fetchMailsReplied:(void (^)(NSArray *))block;
+(void)fetchMailsReplied:(void (^)(NSArray *))block;
@end
