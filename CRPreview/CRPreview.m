//
//  CRPreview.m
//  CRImageZoomDemo
//
//  Created by Jonren on 16/9/9.
//  Copyright © 2016年 常宣任. All rights reserved.
//

#import "CRPreview.h"
#import "CRImageZoom.h"

static CGFloat PageSpace = 0.0f; // 页面间距，暂时设为1，后期优化

@interface CRPreview () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *images;

@end

@implementation CRPreview

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor blackColor];
        _images = @[image];
        _currentIndex = 0;
    }
    return self;
}

- (id)initWithImages:(NSArray *)images atIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor blackColor];
        _images = [images copy];
        _currentIndex = index;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addSubview:self.scrollView];
    if ([_images count] > 1) {
        [self addSubview:self.pageControl];
    }

    for (int i = 0; i < [_images count]; i ++) {
        CRImageZoom *zoom = [[CRImageZoom alloc] initWithImage:_images[i]];
        zoom.frame = CGRectMake(i*ScreenWidth, 0, ScreenWidth, ScreenHeight);
        [zoom setDismissBlock:^(BOOL result) {
            [self removeFromSuperview];
        }];
        [_scrollView addSubview:zoom];
    }
}

- (void)show {
    [[self currentView] addSubview:self];
}


#pragma mark - get

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-PageSpace/2, 0, ScreenWidth+PageSpace, ScreenHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake([_images count]*(ScreenWidth+PageSpace), ScreenHeight);
        [_scrollView setContentOffset:CGPointMake(_currentIndex*(ScreenWidth+PageSpace), 0)];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, ScreenHeight - 55, ScreenWidth, 30)];
        _pageControl.numberOfPages = [_images count];
        _pageControl.currentPage = _currentIndex;
    }
    return _pageControl;
}

- (UIView *)currentView {
    return [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
}


#pragma mark - UIscrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = scrollView.contentOffset.x / ScreenWidth;
    _pageControl.currentPage = currentPage;
}


@end
