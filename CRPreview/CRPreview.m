//
//  CRPreview.m
//  CRImageZoomDemo
//
//  Created by Jonren on 16/9/9.
//  Copyright © 2016年 常宣任. All rights reserved.
//

#import "CRPreview.h"
#import "CRImageZoom.h"

static CGFloat const PageSpace = 0.0f; // 页面间距，暂时设为1，后期优化

static double const PaginationShowSeconds = 2.0; // 设置分页延迟隐藏时间


@interface CRPreview () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *paginationLabel;
@property (nonatomic, strong) NSArray *images;

@end

@implementation CRPreview

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        [self setImages:@[image] atIndex:0];
    }
    return self;
}

- (id)initWithImages:(NSArray *)images atIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        [self setImages:images atIndex:index];
    }
    return self;
}

- (void)setImages:(NSArray *)images atIndex:(NSInteger)index {
    // 全屏显示图片时隐藏系统状态栏，提高用户体验
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor blackColor];
    _images = images;
    _currentIndex = index;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addSubview:self.scrollView];
    if ([_images count] > 1) {
        if (self.pageNumberType == PageNumberTypeControl) {
            [self addSubview:self.pageControl];
        }else if (self.pageNumberType == PageNumberTypeCode) {
            [[self currentControllerView] addSubview:self.paginationLabel];
            [self hiddenPaginationLabel];
        }
    }
    
    for (int i = 0; i < [_images count]; i ++) {
        CRImageZoom *zoom = [[CRImageZoom alloc] initWithImage:_images[i]];
        zoom.frame = CGRectMake(i*ScreenWidth, 0, ScreenWidth, ScreenHeight);
        [zoom setDismissBlock:^(BOOL result) {
            [self dismiss];
        }];
        [_scrollView addSubview:zoom];
    }
}

- (void)show {
    [[self currentControllerView] addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
    if (_paginationLabel) {
        [_paginationLabel removeFromSuperview];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)hiddenPaginationLabel {
    dispatch_time_t time_t = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(PaginationShowSeconds * NSEC_PER_SEC));
    dispatch_after(time_t, dispatch_get_main_queue(), ^{
        _paginationLabel.hidden = YES;
    });
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

- (UILabel *)paginationLabel {
    if (!_paginationLabel) {
        _paginationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 46)];
        _paginationLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _paginationLabel.textAlignment = NSTextAlignmentCenter;
        _paginationLabel.textColor = [UIColor whiteColor];
        _paginationLabel.font = [UIFont systemFontOfSize:15];
        _paginationLabel.text = [NSString stringWithFormat:@"%zd/%zd", _currentIndex+1, [_images count]];
    }
    return _paginationLabel;
}

- (UIView *)currentControllerView {
    return [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
}

- (NSInteger)updatedPageNumberByOffsetX:(CGFloat)offsetX {
    CGFloat currentPage = _currentIndex;
    CGFloat minOffset = (currentPage-0.5)*ScreenWidth;
    CGFloat maxOffset = (currentPage+0.5)*ScreenWidth;
    NSInteger index = 0;
    if (offsetX < minOffset) { // 显示前一页
        index = (_currentIndex-1)>=0?(_currentIndex-1):0;
    }
    else if (offsetX > maxOffset) { // 显示后一页
        index = (_currentIndex+1)<=([_images count]-1)?(_currentIndex+1):([_images count]-1);
    }
    else {
        index = _currentIndex; // 显示当前页
    }
    return index;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentIndex = scrollView.contentOffset.x / ScreenWidth;
    
    if (self.pageNumberType == PageNumberTypeControl) {
        _pageControl.currentPage = _currentIndex;
    }
    else if (self.pageNumberType == PageNumberTypeCode) {
        [self hiddenPaginationLabel];
        _paginationLabel.text = [NSString stringWithFormat:@"%zd/%zd", _currentIndex+1, [_images count]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"currentPage:%zd", _currentIndex);
    NSLog(@"offset:%f", scrollView.contentOffset.x);
    
    NSInteger index = [self updatedPageNumberByOffsetX:scrollView.contentOffset.x];
    
    if (self.pageNumberType == PageNumberTypeControl) {
        _pageControl.currentPage = index;
    }
    else if (self.pageNumberType == PageNumberTypeCode) {
        _paginationLabel.hidden = NO;
        _paginationLabel.text = [NSString stringWithFormat:@"%zd/%zd", index+1, [_images count]];
    }
}



@end
