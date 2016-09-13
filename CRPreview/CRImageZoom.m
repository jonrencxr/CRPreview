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
    
    // 单击
    UITapGestureRecognizer *onceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onceTapHandle:)];
    onceTap.numberOfTapsRequired = 1;    // 点击次数
    onceTap.numberOfTouchesRequired = 1; // 触摸手指数
    [self addGestureRecognizer:onceTap];
    
    // 双击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandle:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTap];
    
    // 避免单双击的响应冲突
    [onceTap requireGestureRecognizerToFail:doubleTap];
    
    // 长按处理
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandle:)];
    longPress.minimumPressDuration = 1.0;
    [self addGestureRecognizer:longPress];
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

- (UIAlertController *)alertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveImage:_image];
    }];
    UIAlertAction *cancerAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:saveAction];
    [alertController addAction:cancerAction];
    return alertController;
}

- (UIViewController *)presentedViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *result = rootVC;
    if (result.presentedViewController) {
        result = result.presentedViewController;
    }
    NSLog(@"当前ViewController：%@", result);
    return result;
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


#pragma mark - action

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

- (void)longPressHandle:(UILongPressGestureRecognizer *)sender {
    // 只允许长按开始的时候响应
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.presentedViewController presentViewController:self.alertController animated:YES completion:nil];
    }
}

- (void)saveImage:(UIImage *)image {
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [self showAlertWithMessage:@"已保存到系统相册"];
    }else {
        [self showAlertWithMessage:@"图片保存失败，请稍后再试"];
    }
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self.presentedViewController presentViewController:alertController animated:NO completion:nil];
    // 设置延迟消失
    [self performSelector:@selector(hiddenAlertController:) withObject:alertController afterDelay:1.5f];
}

- (void)hiddenAlertController:(UIAlertController *)alertController {
    if (alertController) {
        [alertController dismissViewControllerAnimated:NO completion:nil];
    }
}


@end
