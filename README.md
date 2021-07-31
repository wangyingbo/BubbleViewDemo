# BubbleViewDemo

### How to use

use it like this:

```
BubbleView *bubble = [[BubbleView alloc] initWithAnchorPoint:CGPointMake([UIScreen mainScreen].bounds.size.width/2, 200.f)];
bubble.contentSize = CGSizeMake(150.f, 80.f);
bubble.corner = UIRectCornerBottomLeft;
//corner和edge是互斥的，corner要比edge灵活。如果设置了corner就不要设置edge。反之亦然。
//bubble.edge = UIRectEdgeBottom;
bubble.offPoint = CGPointMake(100.f, 20.f);
bubble.fillColor = [UIColor whiteColor];
bubble.lineColor = [UIColor purpleColor];
bubble.lineWidth = 2.5f;
bubble.cornerRadius = WBRectCornerRadiusMake(15.f, 15.f, 15.f, 15.f);
bubble.angleCurve = YES;
bubble.curveCotrol = 5.f;
[self.view addSubview:bubble];
[bubble draw];

```

### eg:

![gif](https://gitee.com/wangyingbo/PrivateImages/raw/master/2020//1.gif)



<!--

![top](https://gitee.com/wangyingbo/PrivateImages/raw/master/2021//20210722123636.png)

![right](https://gitee.com/wangyingbo/PrivateImages/raw/master/2021//20210722123935.png)

![bottom](https://gitee.com/wangyingbo/PrivateImages/raw/master/2021//20210722123652.png)

![left](https://gitee.com/wangyingbo/PrivateImages/raw/master/2021//20210722123701.png)

-->

