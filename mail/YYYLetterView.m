//
//  YYYLetterView.m
//  mail
//
//  Created by 张文洁 on 2017/9/29.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "YYYLetterView.h"
#import "YYYMailManager.h"
#import "YYYMail.h"
@interface YYYLetterView()


@property (nonatomic, strong)YYYMail * mail;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIImageView *bacView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (assign, nonatomic)NSInteger count;
@end
@implementation YYYLetterView
- (IBAction)cencel:(id)sender {
    [self removeFromSuperview];
}

-(instancetype)initWithMail:(YYYMail *)mail{
    
    //信注册
    self=[[NSBundle mainBundle] loadNibNamed:@"LetterPaper" owner:nil options:nil].firstObject;
    self.mail=mail;
    self.leftButton.hidden=YES;
    [self.textView setText:self.mail.contentArray[0][@"content"]];
    self.sendButton.hidden=YES;
    return self;
}
-(void)layoutSubviews{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    CGFloat m=self.frame.size.height*44/585-20;

    if (m>0) {
        self.textView.frame=CGRectMake(15, (m+18)*78/44-m+20, self.frame.size.width-30, (m+20)*10);
        
        paragraphStyle.lineSpacing = m;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:18],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:self.textView.text attributes:attributes];
    }
    
    
        
    NSLog(@"%f",m);
    
    
    CGFloat w=self.frame.size.width;
    CGFloat h=self.frame.size.height;
    NSLog(@"%f %f",w,h);
    if (m>0) {
        [self.sendButton setFrame:CGRectMake(w*0.4, h*0.85, w*0.2, w*0.2)];
    }
    
    [super layoutSubviews];
}
- (IBAction)send:(id)sender {
    
    [YYYMailManager backMail:self.textView.text success:^{
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha=0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } mail:self.mail];
}
- (IBAction)rightButtonCilcked:(id)sender {
    self.count++;
    if (self.count==self.mail.contentArray.count) {
        self.rightButton.hidden=YES;
    }
    self.leftButton.hidden=NO;
    
    [self show];
}
- (IBAction)leftButtonClicked:(id)sender {
    
    self.count--;
    if (self.count==0) {
        self.leftButton.hidden=YES;
    }
    self.rightButton.hidden=NO;
    self.sendButton.hidden=YES;
    
    [self show];
}

-(void)show{
    [UIView animateWithDuration:0.25 animations:^{
        self.textView.alpha=0;
    } completion:^(BOOL finished) {
        if (self.count==self.mail.contentArray.count) {
            self.sendButton.hidden=NO;
            self.textView.text=@"";
        }else{
            self.sendButton.hidden=YES;
            [self.textView setText:self.mail.contentArray[self.count][@"content"]];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.textView.alpha=1;
        } completion:^(BOOL finished) {
            NSLog(@"更换完成");
        }];
        
    }];
}
@end
