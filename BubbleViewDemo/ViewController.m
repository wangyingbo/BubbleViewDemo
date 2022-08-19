//
//  ViewController.m
//  BubbleViewDemo
//
//  Created by 王迎博 on 2021/7/20.
//  Copyright © 2021 王颖博. All rights reserved.
//

#import "ViewController.h"
#import "BubbleView.h"
#import "YBVCContentView.h"

@interface ViewController ()
@property (nonatomic, strong) YBVCContentView *contentView;
@property (nonatomic, weak) BubbleView *bubble;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    YBVCContentView *contentView = [[YBVCContentView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    [self initBubble];
}

#pragma mark - bubble

- (void)initBubble {
    BubbleView *bubble = [[BubbleView alloc] initWithAnchorPoint:CGPointMake([UIScreen mainScreen].bounds.size.width/2, 200.f)];
    bubble.contentSize = CGSizeMake(150.f, 80.f);
    bubble.corner = UIRectCornerBottomLeft;
    //corner和edge是互斥的，corner要比edge灵活。如果设置了corner就不要设置edge。反之亦然。
    //bubble.edge = UIRectEdgeBottom;
    bubble.offPoint = CGPointMake(100.f, 20.f);
    bubble.fillColor = [UIColor yellowColor];
    bubble.lineColor = [UIColor purpleColor];
    bubble.lineWidth = 2.5f;
    bubble.cornerRadius = WBRectCornerRadiusMake(15.f, 15.f, 15.f, 15.f);
    bubble.angleCurve = YES;
    bubble.curveCotrol = 5.f;
    [self.contentView addSubview:bubble];
    [bubble draw];
    self.bubble = bubble;
    
    //bubble.contentView.userInteractionEnabled = NO;
    [bubble addTarget:self action:@selector(bubbleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //测试改变尖角指向的点
        [self anchorCenterPoint];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //测试动态更改bubble的大小
        [self showTip];
        [self anchorCenterPoint];
    });
}

/// 改变尖角指向的点
- (void)anchorCenterPoint {
    [self.bubble angleAnchorToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
}

/// 动态设置bubble属性
- (void)showTip {
    //可以给contentView添加子控件。动态更改contentView的size布局。
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250.f, 0)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:16.f];
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = [UIColor darkTextColor];
    tipLabel.text = @"this is a bubble tip, please try it! \n \n 一个可以指定尖角出现在任意边的任意位置的气泡view，尖角的位置和大小可以灵活定义，试试吧!";
    [self.bubble.contentView addSubview:tipLabel];
    [tipLabel sizeToFit];
    
    //动态修改bubble，修改后需调用-draw方法
    self.bubble.contentSize = CGSizeMake(CGRectGetWidth(tipLabel.frame)+20.f, CGRectGetHeight(tipLabel.frame)+20.f);
    self.bubble.corner = UIRectCornerTopLeft;
    self.bubble.offPoint = CGPointMake(self.bubble.contentSize.width/2, -25.f);
    self.bubble.angleCurve = NO;
    self.bubble.bubbleLayer.shadowColor = [UIColor purpleColor].CGColor;
    self.bubble.bubbleLayer.shadowRadius = 4.f;
    self.bubble.bubbleLayer.shadowOpacity = .25f;
    self.bubble.bubbleLayer.shadowOffset = CGSizeMake(0.f, -2.f);
    [self.bubble draw];
    
    tipLabel.center = CGPointMake(CGRectGetWidth(self.bubble.contentView.frame)/2, CGRectGetHeight(self.bubble.contentView.frame)/2);
    
    tipLabel.userInteractionEnabled = YES;//tipLabel添加手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelGes:)];
    [tipLabel addGestureRecognizer:tapGes];
}

#pragma mark - action

/// 需要bubble.contentView.userInteractionEnabled = NO;
/// @param sender sender description
- (void)bubbleAction:(id)sender {
    NSLog(@"....yb....");
}

/// 需要tipLabel.userInteractionEnabled = YES
/// @param sender sender description
- (void)labelGes:(id)sender {
    NSLog(@"----label----");
}

@end
