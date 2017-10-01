//
//  YYYUser.m
//  mail
//
//  Created by 杨杨杨 on 2017/9/15.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "YYYUser.h"
#import "YYYMailManager.h"
@implementation YYYUser
+(void)load{
    [[self shardedUser] sendMailsArray];
    [[self shardedUser] repliedMailsArray];
}
+(YYYUser *)shardedUser{
    static YYYUser * user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user=[[YYYUser alloc] init];
        
    });
    return user;
}
-(NSMutableArray *)sendMailsArray{
    if (nil==_sendMailsArray) {
        _sendMailsArray=[NSMutableArray arrayWithCapacity:1];
        [YYYMailManager fetchMailsWritten:^(NSArray *mailsArray) {
            [_sendMailsArray addObjectsFromArray:mailsArray];
            NSLog(@"获取到了发送过的信");
        }];
    }
    return _sendMailsArray;
}
-(NSMutableArray *)repliedMailsArray{
    if (nil==_repliedMailsArray) {
        _repliedMailsArray=[NSMutableArray arrayWithCapacity:1];
        [YYYMailManager fetchMailsReplied:^(NSArray *mailsArray) {
            [_repliedMailsArray addObjectsFromArray:mailsArray];
            NSLog(@"获取到了回复过的信");
        }];
    }
    return _repliedMailsArray;
}
-(NSString *)userId{
    if(_userId==nil)
    {
        _userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        if (_userId==nil) {
            _userId=[NSString stringWithFormat:@"%zd",arc4random()];
            [[NSUserDefaults standardUserDefaults] setObject:_userId forKey:@"userId"];
        }
    }
    return _userId;
}
@end
