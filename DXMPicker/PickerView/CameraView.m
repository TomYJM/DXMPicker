//
//  CameraView.m
//  JeezIPMS
//
//  Created by jeez on 15/12/30.
//  Copyright © 2015年 jeez. All rights reserved.
//

#import "CameraView.h"
#import "PickerView.h"
#import "JZItemCollectionCell.h"
#import "JZCameraViewLayout.h"
#define TextViewHight 50
#define titleLBHight 30
#define INTERVAL 5
#define JZWGap 10
#define JZHGap 15
#define HightText 50
#define WToHscale  182/320.0
#define ImageWH 65.0
#define LINEHIGHT 0.5
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Hight [UIScreen mainScreen].bounds.size.hight

#define FONTNAME @"Helvetica"
#define FONTSIZE 15

 NSString *const reuseCell  = @"Reusecell";

@interface CameraView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,JZTextViewDelegate,UITextViewDelegate> {
    float baseHight;
    JZCameraViewLayout *_flowLayout;
    NSIndexPath *_indexpath;
}
@end

@implementation CameraView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        //上分割线
        CGRect rectup = CGRectMake(0, 0, Screen_Width, 0.5);
        self.lineup = [self labelToLineWithColor:[self ColorJeezToLineWithalpha:1.0] Frame:rectup];
        [self addSubview:self.lineup];
        //标题
        self.titleLB = [self labelWithTitleColor:[self colorsetMsgContent] title:@"请上传照片" frame:CGRectMake(10, 0, Screen_Width-20, 30) fontSize:15];
        [self addSubview:self.titleLB];

        //中分割线
        CGRect rectmiddle = CGRectMake(10, 30, Screen_Width-20, 0.5);
        self.linemiddle = [self labelToLineWithColor:[self ColorJeezToLineWithalpha:1.0] Frame:rectmiddle];
        [self addSubview:self.linemiddle];
        
        _flowLayout = [[JZCameraViewLayout alloc]init];
        NSInteger J = (Screen_Width-10)/ImageWH;
        self.cameraCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 35, J * ImageWH, self.frame.size.height-45) collectionViewLayout:_flowLayout];
        self.cameraCollectionV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.cameraCollectionV.backgroundColor = [UIColor clearColor];
        self.cameraCollectionV.allowsSelection = YES;
        self.cameraCollectionV.delegate = self;
        self.cameraCollectionV.dataSource = self;
        self.cameraCollectionV.scrollEnabled = NO;
        self.collectionAr = @[[NSDictionary dictionaryWithObjects:@[@"1",@"1",@"0"]
                                                          forKeys:@[@"imageName",@"ligImgName",@"index"]]];
        [self addSubview:self.cameraCollectionV];
        [self.cameraCollectionV registerClass:[JZItemCollectionCell class] forCellWithReuseIdentifier:reuseCell];
        
        //下分割线
        CGRect rectline = CGRectMake(0, self.frame.size.height-0.5, Screen_Width, 0.5);
        self.linedown = [self labelToLineWithColor:[self ColorJeezToLineWithalpha:1.0] Frame:rectline];
        self.linedown.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.linedown];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame Delegate:(id<CameraViewDelegate>)delegate {
    self = [self initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}
- (UIColor *)ColorJeezToLineWithalpha:(CGFloat)scale {
    UIColor *color = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    return color;
}
//消息内容文字灰色颜色
- (UIColor *)colorsetMsgContent {
    return [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
}
- (UILabel *)labelToLineWithColor:(UIColor *)color Frame:(CGRect)frame {
    UILabel *linelabel = [[UILabel alloc]initWithFrame:frame];
    [linelabel setBackgroundColor:color];
    return linelabel;
}
- (UILabel *)labelWithTitleColor:(UIColor *)color title:(NSString *)title frame:(CGRect)frame fontSize:(CGFloat)fontsize {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    [label setTextColor:color];
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:FONTNAME size:fontsize];
    label.text = title;
    return label;
}
#pragma mark - Customer
- (void)addNoteTextViewWithFrame:(CGRect)rect {
    [self.linemiddle setHidden:YES];
    [self.titleLB removeFromSuperview];
    self.textView = [[JZTextView alloc]initWithFrame:CGRectMake(8, INTERVAL, self.frame.size.width-18, TextViewHight) Delegate:self WithPlaceholder:@"请备注异常出场情况、改价原因..."];
    self.textView.delegate = self;
    [self addSubview:self.textView];
    self.cameraCollectionV.frame = CGRectMake(self.cameraCollectionV.frame.origin.x, CGRectGetMaxY(self.textView.frame)+INTERVAL*3, self.cameraCollectionV.frame.size.width, self.cameraCollectionV.frame.size.height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(self.cameraCollectionV.frame)+JZWGap);
    self.linedown.frame = CGRectMake(self.linedown.frame.origin.x, self.frame.size.height-LINEHIGHT, self.linedown.frame.size.width, self.linedown.frame.size.height);
}
//点击collectionviewcell
- (void)tempClick:(NSInteger)index {
    if (index == self.collectionAr.count - 1) {
        //拍照
        if ([self.delegate respondsToSelector:@selector(clickCollectionViewCellCamera)]) {
            [self.delegate clickCollectionViewCellCamera];
        }
    }else {
        //阅读照片
        NSMutableArray *mar = [NSMutableArray array];
        for (NSDictionary *dic in self.collectionAr) {
            if ([dic objectForKey:@"Image"])
                [mar addObject:dic];
        }
        PickerView *pickerView = [PickerView initWithFrame:CGRectMake(0, 0, Screen_Width, [UIScreen mainScreen].bounds.size.height) WithDataSurce:mar SelectNum:index];
        [pickerView show];
    }
}
//长按删除
- (void)cellLongPress:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:self.cameraCollectionV];
        _indexpath = [self.cameraCollectionV indexPathForItemAtPoint:location];
        JZItemCollectionCell *cell = (JZItemCollectionCell *)recognizer.view;
        NSDictionary *dic = [self.collectionAr objectAtIndex:_indexpath.row];
        if (dic[@"Image"]) {
            //这里把cell做为第一响应(cell默认是无法成为responder,需要重写canBecomeFirstResponder方法)
            [cell becomeFirstResponder];
            [[[UIAlertView alloc]initWithTitle:@"您确定要删除它吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
        }
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionAr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.collectionAr objectAtIndex:indexPath.row];
    JZItemCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCell forIndexPath:indexPath];
    cell.imageV.frame = CGRectMake(5, 5, 55, 55);
    if (!dic[@"Image"])
    {
        [cell setViewWithDic:dic];
    }
    else
    {
        [cell.imageV.layer setMasksToBounds:YES];
        [cell.imageV.layer setCornerRadius:5];
        [cell setViewDataWithDic:dic];
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        [cell addGestureRecognizer:longPressGesture];
    }
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self tempClick:indexPath.item];
}
#pragma mark -UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ImageWH, ImageWH);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            NSMutableArray *MAr = [NSMutableArray arrayWithArray:self.collectionAr];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:MAr[_indexpath.row] copyItems:YES];
            [dic setValue:[NSNumber numberWithInteger:_indexpath.row] forKey:@"Index"];
            
            if ([self.delegate respondsToSelector:@selector(deleteRowsAtIndexPaths:)]) {
                [self.delegate deleteRowsAtIndexPaths:dic];
            }
            
            [MAr removeObjectAtIndex:_indexpath.row];
            self.collectionAr = [MAr mutableCopy];
            NSArray* indexPathAy = [[NSArray alloc]initWithObjects:_indexpath, nil];
            NSInteger J = (Screen_Width-110)/ImageWH;
            float hitg = (MAr.count/J)*ImageWH;
            if (MAr.count%J != 0) {
                hitg = (MAr.count/J +1)*ImageWH;
            }
            [self.cameraCollectionV deleteItemsAtIndexPaths:indexPathAy];
            self.cameraCollectionV.frame = CGRectMake(self.cameraCollectionV.frame.origin.x, self.cameraCollectionV.frame.origin.y, self.cameraCollectionV.frame.size.width, hitg);
            [self.cameraCollectionV reloadData];
        }
            break;
        default:
            break;
    }
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
