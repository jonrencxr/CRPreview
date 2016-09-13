# CRPreview
#### 超级简单易用的图片多功能全屏预览组件，包括类似微信朋友圈和QQ空间的图片显示类型，暂不支持服务器图片加载。

## 哪些功能？
#### 1. 单张图片全屏预览
#### 2. 一组图片全屏预览
#### 3. 缩放
#### 4. 双击相应位置放大到设置的最大比例，再次双击回到原比例，单击则隐藏。
#### 5. 翻页页码PageNumberType显示分两种状态，pageControl格式和页码“n/m”格式 ，需要调用的时候自己设置PageNumberTypeControl或者PageNumberTypeCode。
#### 6. 保存到本地

## 演示
#### pageControl格式 及 基础演示
![Markdown](http://i2.buimg.com/574358/34c36a9a70e3ef27.jpg)
![Markdown](http://i2.buimg.com/574358/6fe6f22518e9c889.gif)
#### 页码“n/m”格式
![Markdown](http://i2.buimg.com/574358/e12c172e1a6f7de6.jpg)
![Markdown](http://i4.piimg.com/574358/c1e7f1b0958d8f2b.gif)

## 如何使用？
    #import "CRPreview.h"
    
    // 预览单个图片方法 (需要图片image)
    CRPreview *preview = [[CRPreview alloc] initWithImage:image];
    [preview show];
    
    // 预览一组图片方法（需要图片数组_images）
    CRPreview *preview = [[CRPreview alloc] initWithImages:_images atIndex:0];
    preview.pageNumberType = PageNumberTypeCode; // 默认是PageNumberTypeControl样式
    [preview show];

## 注意事项
#### 1. 由于时间有限，笔者还未添加加载网络图片的方法，不过后期会添加上去。
#### 2. 暂未添加显示及隐藏的动画效果，以及双击放大时位置可能有微小的bug，待修复，欢迎提供更好的思路帮助解决。
#### 3. 多多交流，共同提高，接受指正，有好的功能添加建议请告诉笔者，笔者一定感激不尽，笔者博客http://www.jianshu.com/users/eb0c003c8cc8/latest_articles，QQ号：1262078574。
#### 4. 喜欢的，支持点赞就是给我最大的安慰。
