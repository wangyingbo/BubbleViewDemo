//
//  ViewController.m
//  BubbleViewDemo
//
//  Created by 王迎博 on 2021/7/20.
//  Copyright © 2021 王颖博. All rights reserved.
//

#import "ViewController.h"
#import "BubbleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BubbleView *bubble = [[BubbleView alloc] initWithOrigin:CGPointMake(100.f, 200.f)];
    bubble.contentSize = CGSizeMake(150, 80.f);
    bubble.corner = UIRectCornerBottomRight;
    bubble.offPoint = CGPointMake(30, -30);
    bubble.fillColor = [UIColor clearColor];
    bubble.lineColor = [UIColor purpleColor];
    bubble.lineWidth = 1.f;
    bubble.cornerRadius = WBRectCornerRadiusMake(5, 5, 5, 5);
    [self.view addSubview:bubble];
    
    bubble.backgroundColor = [UIColor greenColor];
    bubble.contentView.backgroundColor = [UIColor clearColor];
    
    
    [bubble draw];
    
}


@end
