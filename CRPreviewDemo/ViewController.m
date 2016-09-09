//
//  ViewController.m
//  CRPreviewDemo
//
//  Created by renchang on 16/9/9.
//  Copyright © 2016年 常宣任. All rights reserved.
//

#import "ViewController.h"
#import "CRPreview.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *images;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _images = @[
                [UIImage imageNamed:@"lady_01.jpg"],
                [UIImage imageNamed:@"lady_02.jpg"],
                [UIImage imageNamed:@"lady_03.jpg"]
                ];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake((self.view.frame.size.width-128)/2, 150, 128,80)];
    [button setBackgroundImage:[UIImage imageNamed:@"lady_00.jpg"] forState:UIControlStateNormal];
    [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [button addTarget:self action:@selector(oneImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    for (int i = 0; i < _images.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        CGFloat space = (self.view.frame.size.width-85*[_images count])/([_images count]+1);
        [button setFrame:CGRectMake(space+i*(85+space), 300, 85, 75)];
        [button setBackgroundImage:_images[i] forState:UIControlStateNormal];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [button addTarget:self action:@selector(multiImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)oneImageAction:(UIButton *)sender {
    // 预览单个图片方法
    CRPreview *preview = [[CRPreview alloc] initWithImage:sender.currentBackgroundImage];
    [preview show];
}

- (void)multiImageAction:(UIButton *)sender {
    // 预览一组图片方法
    CRPreview *preview = [[CRPreview alloc] initWithImages:_images atIndex:sender.tag];
    [preview show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

