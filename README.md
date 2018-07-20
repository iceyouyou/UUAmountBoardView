# UUAmountBoardView
用于iOS，通过使用UITableView结合Pop动画的方式，创建带有数字(金额)翻转效果的UI控件。

## 效果
![UUAmountBoardView](https://raw.githubusercontent.com/iceyouyou/UUAmountBoardView/master/extra/demo.gif)

## 使用方法
如果每个数字背景由图片创建，可使用带unitBgImage参数的init方法：
```objective-c
- (instancetype)initWithFrame:(CGRect)frame
                amountPattern:(NSString*)amountPattern
                     unitSize:(CGSize)unitSize
                  unitSpacing:(CGFloat)unitSpacing
                     textFont:(UIFont*)textFont
                    textColor:(UIColor*)textColor
                   textOffset:(CGPoint)textOffset
                  unitBgImage:(UIImage*)unitBgImage;	// 每个显示单位的背景图片
```
或者使用带unitBgViewMaker参数的init方法，通过指定一个UIView的构造Block，最大化定制背景内容：
```objective-c
- (instancetype)initWithFrame:(CGRect)frame
                amountPattern:(NSString*)amountPattern
                     unitSize:(CGSize)unitSize
                  unitSpacing:(CGFloat)unitSpacing
                     textFont:(UIFont*)textFont
                    textColor:(UIColor*)textColor
                   textOffset:(CGPoint)textOffset
              unitBgViewMaker:(void (^)(UIView *unitBgView))unitBgViewMaker;	// 构建每个数字单位背景View的回调
```
两种init方法中的参数说明如下：
```objective-c
/* 
 * frame: 仅x和y生效，Width和Height不生效，AmountBoardView会根据显示的位数及unitSize自动计算自身的宽高
 *        也可选用不带Frame的init方法，AmountBoardView支持AutoLayout布局。
 * amountPattern: 初始占位符
 * unitSize: 指定一个数字单位的Size
 * unitSpacing: 每个数字单位的间距
 * textFont: 显示内容的字体
 * textColor: 显示内容的字体颜色
 * textOffset: 显示内容的偏移量
 * unitBgImage: 每个显示单位的背景图片
 * unitBgViewMaker: 构建每个数字单位背景View的回调
 */
```
示例代码：
```objective-c
[[UUAmountBoardView alloc] initWithFrame:(CGRectMake(20.0f, 105.0f, 0.0f, 0.0f))
                           amountPattern:@"000,000"
                                unitSize:CGSizeMake(20.0f, 25.0f)
                             unitSpacing:4.0f
                                textFont:[UIFont systemFontOfSize:20.0f]
                               textColor:[UIColor blackColor]
                              textOffset:CGPointZero
                             unitBgImage:[UIImage imageNamed:@"unitBgImage"]];

[[UUAmountBoardView alloc] initWithFrame:(CGRectMake(20.0f, 105.0f, 0.0f, 0.0f))
                           amountPattern:@"000,000"
                                unitSize:CGSizeMake(20.0f, 25.0f)
                             unitSpacing:4.0f
                                textFont:[UIFont systemFontOfSize:20.0f]
                               textColor:[UIColor blackColor]
                              textOffset:CGPointZero
                         unitBgViewMaker:^(UIView *unitBgView) {
                             unitBgView.layer.borderWidth = 0.5f;
                             unitBgView.layer.borderColor = [UIColor redColor].CGColor;
                             unitBgView.layer.cornerRadius = 4.0f;
                         }];
```

## Compatibility
- Requires ARC.
- Supports iOS7+.

## Additional
使用[facebook/Pop](https://github.com/facebook/pop)来实现数字滑动的效果。

## License
`UUAmountBoardView` is available under the MIT license. See the [LICENSE](LICENSE) file for more info.