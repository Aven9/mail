//
//  YYYViewController.m
//  mail
//
//  Created by 杨杨杨 on 2017/9/27.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "YYYViewController.h"
#import "YYYMailManager.h"
#import "YYYMailView.h"
#import "YYYShelfController.h"
@interface YYYViewController ()
@property (weak, nonatomic) IBOutlet UIView *mailView;
@property (weak, nonatomic) IBOutlet UIButton *writeButton;

@end

@implementation YYYViewController
- (IBAction)mushroomClicked:(id)sender {
    UIViewController * vc= [[YYYShelfController alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mailView.alpha=0;
}
- (IBAction)writeLetter:(id)sender {
    [UIView animateWithDuration:1 animations:^{
        if (0==self.mailView.alpha) {
            self.mailView.alpha=1;
            [self.view bringSubviewToFront:self.mailView];
        }else{
            self.mailView.alpha=0;
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self reciveLetter];
}
-(void)reciveLetter{
    [YYYMailManager getMail:^(YYYMail *mail) {
        CGFloat w=100;
        YYYMailView * v=[[YYYMailView alloc] initWithFrame:CGRectMake(w, 200, self.view.frame.size.width-w*2, 100) mail:mail];
        v.alpha=0;
        [self.view addSubview:v];
        [UIView animateWithDuration:0.25 animations:^{
            v.alpha=1;
            
        } completion:^(BOOL finished) {
            [v animate];
        }];
    }];
}

@end
