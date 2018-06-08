# CRPreview
超级简单易用的图片多功能全屏预览组件，包括类似微信朋友圈和QQ空间的图片显示类型，暂不支持服务器图片加载。

#### 一、哪些功能？
1. 单张图片全屏预览
2. 一组图片全屏预览
3. 缩放
4. 双击相应位置放大到设置的最大比例，再次双击回到原比例，单击则隐藏。
5. 翻页页码PageNumberType显示分两种状态，pageControl格式和页码“n/m”格式 ，需要调用的时候自己设置PageNumberTypeControl或者PageNumberTypeCode。
6. 保存到本地

#### 二、演示
##### 1. pageControl格式 及 基础演示
![Markdown](http://upload-images.jianshu.io/upload_images/2847515-e98ce405f084bb27.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![Markdown](http://upload-images.jianshu.io/upload_images/2847515-47e0cc4f993e4616.gif?imageMogr2/auto-orient/strip)
##### 2. 页码“n/m”格式
![Markdown](http://upload-images.jianshu.io/upload_images/2847515-bf7947a38408d537.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![Markdown](http://upload-images.jianshu.io/upload_images/2847515-d9a53f4a308141a2.gif?imageMogr2/auto-orient/strip)

#### 三、如何使用？
```
#import "CRPreview.h"
    
    // 预览单个图片方法 (需要图片image)
    CRPreview *preview = [[CRPreview alloc] initWithImage:image];
    [preview show];
    
    // 预览一组图片方法（需要图片数组_images）
    CRPreview *preview = [[CRPreview alloc] initWithImages:_images atIndex:0];
    preview.pageNumberType = PageNumberTypeCode; // 默认是PageNumberTypeControl样式
    [preview show];
```

#### 四、注意事项
1. 由于时间有限，笔者还未添加加载网络图片的方法，不过后期会添加上去。
2. 暂未添加显示及隐藏的动画效果，以及双击放大时位置可能有微小的bug，待修复，欢迎提供更好的思路帮助解决。
3. 多多交流，共同提高，接受指正，有好的功能添加建议请告诉笔者，笔者一定感激不尽，笔者博客:[Jonrencxr](http://www.jianshu.com/users/eb0c003c8cc8/latest_articles)，QQ号：1262078574。
4. 喜欢的，支持点赞就是给我最大的安慰。
