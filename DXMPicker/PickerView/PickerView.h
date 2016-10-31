//
//  PickerView.h
//  JeezIPMS
//
//  Created by jeez on 15/12/31.
//  Copyright © 2015年 jeez. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PickerView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSArray *dataAr;
@property (nonatomic,assign) NSInteger currentPageNum;
//创建实例
+ (PickerView *)initWithFrame:(CGRect)frame WithDataSurce:(NSArray *)dataAy SelectNum:(NSInteger)selectNum;

//展示界面
- (void)show;

//消失界面
- (void)dismiss;


@end
