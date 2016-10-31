//
//  PickerView.m
//  JeezIPMS
//
//  Created by jeez on 15/12/31.
//  Copyright © 2015年 jeez. All rights reserved.
//

#import "PickerView.h"
#import "PhotoView.h"

@interface PickerView ()<PhotoViewDelegate>

@end

@implementation PickerView
{
    UILabel *pageLabel;
    NSMutableArray *subViewArray;
    NSInteger _index;
}
+ (PickerView *)initWithFrame:(CGRect)frame WithDataSurce:(NSArray *)dataAy SelectNum:(NSInteger)selectNum {
    PickerView *pickerView = [[self alloc]initWithFrame:frame];
    pickerView.dataAr = dataAy;
    pickerView.currentPageNum = selectNum;
    //根据参数初始化
    [pickerView initsubViews];
    return pickerView;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
        subViewArray = [NSMutableArray array];
        _index = 0;
        //滚动视图
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        [self.scrollView setBackgroundColor:[UIColor clearColor]];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.tag = 100;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        //底部分页控件视图
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-100, self.bounds.size.width, 60)];
        [UIColor colorWithWhite:0 alpha:0.2];
        [self addSubview:bottomView];
        
        pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(bottomView.bounds.size.width-55, 20, 40, 20)];
        pageLabel.font = [UIFont systemFontOfSize:15.0];
        pageLabel.textColor = [UIColor whiteColor];
        [bottomView addSubview:pageLabel];
        
        //分页控件
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-100)/2.0,self.frame.size.height-22,100,18)];
        [self.pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        [self.pageControl setHidden:YES];
        [self.pageControl setPageIndicatorTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6]];
        [self addSubview:self.pageControl];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismiss)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)initsubViews {
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    for (int i = 0; i < self.dataAr.count; i++) {
        NSDictionary *dic = [self.dataAr objectAtIndex:i];
        CGRect frame = CGRectMake(i*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        PhotoView *photoView = [[PhotoView alloc] initWithFrame:frame withPhotoUrl:nil dictionary:dic];
        photoView.delegate = self;
        [self.scrollView addSubview:photoView];
        
        [subViewArray addObject:photoView];
        
    }
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width*self.dataAr.count, self.frame.size.height);
    
    self.pageControl.numberOfPages = [self.dataAr count] > 1 ? [self.dataAr count] : 0 ;
    self.pageControl.currentPage = self.currentPageNum;
    pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.pageControl.currentPage+1,self.dataAr.count];
    //默认显示点击的图片
    [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width*self.currentPageNum,0,self.frame.size.width,self.frame.size.height) animated:NO];
}
#pragma mark - Animated Mthod
- (void)animatedIn {
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut {
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - show or hide self
- (void)show {
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    [self animatedIn];
}

- (void)dismiss {
    [self animatedOut];
}
- (void)tapDismiss
{
    [self animatedOut];
}
#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 100) {
        CGPoint point = scrollView.contentOffset;
        if (_index != (NSInteger)point.x/self.scrollView.frame.size.width) {
            PhotoView *photoView = subViewArray[_index];
            [photoView.scrollView setZoomScale:1.0 animated:YES];
            _index = (NSInteger)point.x/self.scrollView.frame.size.width;
        }
        self.pageControl.currentPage = (NSInteger)point.x/self.scrollView.frame.size.width;
        pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.pageControl.currentPage+1,self.dataAr.count];
    }
}
#pragma mark - PhotoViewDelegate
-(void)tapHiddenPhotoView{
    [self animatedOut];
}
@end
