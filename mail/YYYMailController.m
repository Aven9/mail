//
//  YYYMailController.m
//  mail
//
//  Created by 杨杨杨 on 2017/9/27.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "YYYMailController.h"
#import "YYYMailManager.h"
@interface YYYMailController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation YYYMailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentTextView.text=@"";
}
- (IBAction)sendMail:(id)sender {
    
    [YYYMailManager sendMail:self.contentTextView.text success:^{
        [UIView animateWithDuration:0.5 animations:^{
            self.contentTextView.text=@"";
            self.view.superview.alpha=0;
        }];
    }];
}

@end
