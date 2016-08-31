//
//  ViewController.m
//  lianxi1
//
//  Created by 小九投资 on 16/8/29.
//  Copyright © 2016年 小九投资. All rights reserved.
//

#import "ViewController.h"
#import "RedView.h"

#define MaxY 100.0 //最大的y偏移距离
#define LastX 275.0 //最后的定位x
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ViewController

- (UIView *)leftV {
    if (!_leftV) {
        _leftV = [[UIView alloc] initWithFrame:self.view.bounds];
        _leftV.backgroundColor = [UIColor greenColor];
    }
    return _leftV;
}

- (UIView *)rightV {
    if (!_rightV) {
        _rightV = [[UIView alloc] initWithFrame:self.view.bounds];
        _rightV.backgroundColor = [UIColor blueColor];
    }
    return _rightV;
}

- (UIView *)mainV {
    if (!_mainV) {
        _mainV = [[UIView alloc] initWithFrame:self.view.bounds];
        _mainV.backgroundColor = [UIColor redColor];
    }
    return _mainV;
}


//抽屉效果
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.leftV];
    [self.view addSubview:self.rightV];
    [self.view addSubview:self.mainV];
    
    //设置mainV滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.mainV addGestureRecognizer:pan];
    
    //给控制器view添加点击恢复手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)tap {
    [UIView animateWithDuration:0.2 animations:^{
        self.mainV.frame = self.view.bounds;
    }];
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    
    CGPoint nowP = [pan translationInView:self.mainV];
//    NSLog(@"滑动了 %@",NSStringFromCGPoint(nowP));
    
    //设置mainV的frame
    self.mainV.frame = [self getFrame:nowP.x];
    
    //判断显示
    if (self.mainV.frame.origin.x > 0) {
        self.rightV.hidden = YES;
    } else {
        self.rightV.hidden = NO;
    }
    
    //当手指松开做判断
    CGFloat target = 0;
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (self.mainV.frame.origin.x > ScreenWidth * 0.5) {
            //当前View的x有没有大于屏幕宽度的一半,大于就是在右侧
            target = LastX;
        } else if (CGRectGetMaxX(self.mainV.frame) < ScreenWidth * 0.5) {
            //当前View的最大的x有没有小于屏幕宽度的一半,小于就是在左侧
            target = -LastX;
        }
        
        //计算frame
        CGFloat offset = target - self.mainV.frame.origin.x;
        [UIView animateWithDuration:0.2 animations:^{
            self.mainV.frame = [self getFrame:offset];
        }];
    }
    
    //复位
    [pan setTranslation:CGPointZero inView:self.mainV];
}

//x方向移动，y下移一定距离，height同时减少一定距离
- (CGRect)getFrame:(CGFloat)offset {
    CGRect frame = self.mainV.frame;
    
    //x方向
    frame.origin.x += offset;
    
    //y方向
    CGFloat y = fabs(frame.origin.x * MaxY/ScreenWidth);
    frame.origin.y = y;
    
    //height
    frame.size.height = ScreenHeight - 2 * frame.origin.y;
    
    
    return frame;
}

@end
