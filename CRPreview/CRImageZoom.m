//
//  CRImageZoom.m
//  CRImageZoomDemo
//
//  Created by Jonren on 16/9/9.
//  Copyright © 2016年 常宣任. All rights reserved.
//

#import "CRImageZoom.h"

static CGFloat const MaximumZoomScale = 3.0; // 图片最大缩放比例
static CGFloat const MinimumZoomScale = 1.0; // 图片最小缩放比例


@interface CRImageZoom () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation CRImageZoom

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _image = image;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.scrollView];
    [_scrollView addSubview:self.imageView];
    
    UITapGestureRecognizer *onceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onceTapHandle:)];
    onceTap.numberOfTapsRequired = 1;    // 点击次数
    onceTap.numberOfTouchesRequired = 1; // 触摸手指数
    [self addGestureRecognizer:onceTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandle:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTap];
    
    // 避免单双击的响应冲突
    [onceTap requireGestureRecognizerToFail:doubleTap];
}


#pragma mark - get

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = MaximumZoomScale;
        _scrollView.minimumZoomScale = MinimumZoomScale;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGSize imageSize = _image.size;
        CGFloat height = (ScreenWidth * imageSize.height) / imageSize.width;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-height)/2, ScreenWidth, height)];
        _imageView.image = _image;
    }
    return _imageView;
}

- (UIView *)currentView {
    return [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
}

- (CGPoint)centerPointInView:(UIScrollView *)scrollView {
    CGFloat xcenter = scrollView.center.x, ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height? scrollView.contentSize.height/2 : ycenter;
    return CGPointMake(xcenter, ycenter);
}


#pragma mark - UIscrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 操作图片时，需要对center重新定义以达到正确显示位置
    CGPoint centerPoint = [self centerPointInView:scrollView];
    [_imageView setCenter:centerPoint];
}


#pragma mark - touch

- (void)onceTapHandle:(UITapGestureRecognizer *)sender {
    _dismissBlock(YES);
}

- (void)doubleTapHandle:(UITapGestureRecognizer *)sender {
    if (_scrollView.zoomScale == MinimumZoomScale) {
        [_scrollView setZoomScale:MaximumZoomScale];
        CGPoint tapPoint = [sender locationInView:_scrollView];
        CGPoint centerPoint = _scrollView.center;
        CGPoint point = CGPointMake(tapPoint.x-centerPoint.x, tapPoint.y-centerPoint.y);
        [_scrollView setContentOffset:point];
        return;
    }
    [_scrollView setZoomScale:MinimumZoomScale];
}


@end
