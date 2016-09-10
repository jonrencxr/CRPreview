//
//  CRPreview.h
//  CRImageZoomDemo
//
//  Created by Jonren on 16/9/9.
//  Copyright © 2016年 常宣任. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRPreview : UIView

/**
 *  当前页，默认为0
 */
@property (nonatomic, assign) NSInteger currentIndex;


/**
 *  当确定调用的地方只有一张图片的时候就可以调用该方法，只浏览一张图片
 *
 *  @param image 按钮或者UIImageView的图片
 *
 *  @return 组件初始化
 */
- (id)initWithImage:(UIImage *)image;


/**
 *  如果不确定有几张图片需要预览，可以调用该方法，实现是滑动预览
 *
 *  @param images 一组图片
 *  @param index  需要组件默认显示的图片位置，默认为0
 *
 *  @return 组件初始化
 */
- (id)initWithImages:(NSArray *)images atIndex:(NSInteger)index;


/**
 *  组件初始化之后，调用该方法进行页面显示
 */
- (void)show;


@end
