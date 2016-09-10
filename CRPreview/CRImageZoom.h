//
//  CRImageZoom.h
//  CRImageZoomDemo
//
//  Created by Jonren on 16/9/9.
//  Copyright © 2016年 常宣任. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CRImageZoom : UIView

/**
 *  当单击当前图片时，需要该block向组件CRPreview传递隐藏组件的消息
 */
@property (nonatomic, copy) void (^dismissBlock)(BOOL result);


/**
 *  预览组件单个图片预览功能组件
 *
 *  @param image 该组件需要操作的单个图片
 *
 *  @return 初始化
 */
- (id)initWithImage:(UIImage *)image;



@end
