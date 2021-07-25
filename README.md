# BubbleViewDemo

### How to use

use it like this:

```
    BubbleView *bubble = [[BubbleView alloc] initWithOrigin:CGPointMake(100.f, 200.f)];
    bubble.contentSize = CGSizeMake(150, 80.f);
    bubble.corner = UIRectCornerBottomRight;
    bubble.offPoint = CGPointMake(30, -30);
    bubble.fillColor = [UIColor whiteColor];
    bubble.lineColor = [UIColor purpleColor];
    bubble.lineWidth = 1.f;
    bubble.cornerRadius = WBRectCornerRadiusMake(5, 5, 5, 5);
    [self.view addSubview:bubble];
    
    bubble.backgroundColor = [UIColor whiteColor];
    
    bubble draw];

```

### eg:

![gif](https://gitee.com/wangyingbo/PrivateImages/raw/master/2020//1.gif)



<!--

![top](https://gitee.com/wangyingbo/PrivateImages/raw/master/2021//20210722123636.png)

![right](https://gitee.com/wangyingbo/PrivateImages/raw/master/2021//20210722123935.png)

![bottom](https://gitee.com/wangyingbo/PrivateImages/raw/master/2021//20210722123652.png)

![left](https://gitee.com/wangyingbo/PrivateImages/raw/master/2021//20210722123701.png)

-->

