//
//  CameraView.h
//  JeezIPMS
//
//  Created by jeez on 15/12/30.
//  Copyright © 2015年 jeez. All rights reserved.
//

#import <UIKit/UIKit.h>
//文本框类
#import "JZTextView.h"
@protocol CameraViewDelegate <NSObject>
@optional
//执行拍照代理事件
- (void)clickCollectionViewCellCamera;
//执行删除照片代理事件
- (void)deleteRowsAtIndexPaths:(NSDictionary *)dict;
@end

@interface CameraView : UIView


//添加拍照
@property(nonatomic,strong) UICollectionView *cameraCollectionV;
//图片集合
@property(nonatomic,strong)NSArray *collectionAr;
//标题
@property(nonatomic,strong)UILabel *titleLB;
//上分割线
@property(nonatomic,strong)UILabel *linedown;
//中分割线
@property(nonatomic,strong)UILabel *linemiddle;
//下分割线
@property(nonatomic,strong)UILabel *lineup;
//文本输入框
@property(nonatomic,strong)JZTextView *textView;

//初始化实例方法
- (id)initWithFrame:(CGRect)frame Delegate:(id<CameraViewDelegate>)delegate;

//添加备注输入框
- (void)addNoteTextViewWithFrame:(CGRect)rect;

//代理属性
@property(nonatomic,weak)id<CameraViewDelegate> delegate;


@end
