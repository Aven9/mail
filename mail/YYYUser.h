//
//  YYYUser.h
//  mail
//
//  Created by 杨杨杨 on 2017/9/15.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//


#import "YYYMail.h"
@import Foundation;

@interface YYYUser : NSObject

@property (copy, nonatomic)NSString * userId;

@property (strong, nonatomic)NSMutableArray <YYYMail *>* sendMailsArray;

@property (strong, nonatomic)NSMutableArray <YYYMail *>* repliedMailsArray;
+(YYYUser *)shardedUser;
@end

