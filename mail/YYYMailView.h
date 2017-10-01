//
//  YYYMailView.h
//  mail
//
//  Created by 杨杨杨 on 2017/9/27.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYYMail;
@interface YYYMailView : UIView
- (instancetype)initWithFrame:(CGRect)frame mail:(YYYMail *)mail;
-(void)animate;
@end
