//
//  ViewController.m
//  lianxi1
//
//  Created by 小九投资 on 16/8/29.
//  Copyright © 2016年 小九投资. All rights reserved.
//

#import "ViewController.h"
#import "RedView.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet RedView *redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1.单击手势
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
    tap1.numberOfTapsRequired = 1;
    [self.redView addGestureRecognizer:tap1];
    
    //2.双击手势
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)];
    tap2.numberOfTapsRequired = 2;
    [self.redView addGestureRecognizer:tap2];
    
    //重要！！！没有检测到doubleTapGestureRecognizer 或者 检测doubleTapGestureRecognizer失败，singleTapGestureRecognizer才有效。设置上此属性，单击方法有延迟。
    [tap1 requireGestureRecognizerToFail:tap2];
    
    
    //3.长按手势
    UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longG:)];
    [self.redView addGestureRecognizer:longG];
    
    //4.拖动手势
    [self setTuodong];
    
    //5.捏合手势 拖动和捏合的point和scale都是相对最原始的位置而言的。因此使用一次要复位一次
    [self setNiehe];
    
    //6.旋转手势 如果想捏合的同时可以旋转则需设置代理
    [self setXuanzhuan];
    
}

//1.单击
- (void)tap1 {
    NSLog(@"单击了");
}

//2.双击
- (void)tap2 {
    NSLog(@"双击了");
}

//3.长按
- (void)longG:(UILongPressGestureRecognizer *)longG {
    if (longG.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始长按");
    } else if (longG.state == UIGestureRecognizerStateEnded) {
        NSLog(@"长按结束");
    }
    
}

//4.拖动手势
- (void)setTuodong {
    UIPanGestureRecognizer *pang = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.redView addGestureRecognizer:pang];
}
//4.拖动手势
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    //获取偏移量。最原始偏移量。从最左上角计算的
    CGPoint transP = [pan translationInView:self.redView];
//    NSLog(@"拖动:%@",NSStringFromCGPoint(transP));
    self.redView.transform = CGAffineTransformTranslate(self.redView.transform, transP.x, transP.y);
    //复位
    [pan setTranslation:CGPointZero inView:self.redView];
    
}


//5.捏合手势
- (void)setNiehe {
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pin:)];
    pin.delegate = self;
    [self.redView addGestureRecognizer:pin];
}
//5.捏合手势
- (void)pin:(UIPinchGestureRecognizer *)pin {
    
//    NSLog(@"捏合:%f",pin.scale);
    self.redView.transform = CGAffineTransformScale(self.redView.transform, pin.scale, pin.scale);
    
    //复位
    [pin setScale:1];
    
}


//6.旋转手势
- (void)setXuanzhuan {
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    rotation.delegate = self;
    [self.redView addGestureRecognizer:rotation];
}
//6.旋转手势
- (void)rotation:(UIRotationGestureRecognizer *)rotation {
    
//    NSLog(@"%f",rotation.rotation);
    self.redView.transform = CGAffineTransformRotate(self.redView.transform, rotation.rotation);
    
    //复位
    [rotation setRotation:0];
    
}

//设置捏合和旋转同时响应的代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
