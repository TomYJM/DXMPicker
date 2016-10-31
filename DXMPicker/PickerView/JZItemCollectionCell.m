//
//  JZItemCollectionCell.m
//  保利悠悦荟
//
//  Created by yangyun on 15/2/3.
//  Copyright (c) 2015年 qiushengsheng. All rights reserved.
//

#import "JZItemCollectionCell.h"

@implementation JZItemCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:backView];
        backView.center = self.contentView.center;
        
        _imageV = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageV.contentMode = UIViewContentModeCenter;
        _imageV.tag = 100;
        [_imageV setUserInteractionEnabled:NO];
        [backView addSubview:_imageV];
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted)
    {
        [_imageV setHighlighted:YES];
    }
    else
    {
        [_imageV setHighlighted:NO];
    }
}
- (void)setViewWithDic:(NSDictionary*)dic
{
    _dic = dic;
    
    [_imageV setImage:[UIImage imageNamed:dic[@"imageName"]] forState:UIControlStateNormal];
    [_imageV setImage:[UIImage imageNamed:dic[@"ligImgName"]] forState:UIControlStateHighlighted];
}
- (void)setViewDataWithDic:(NSDictionary*)dic
{
    _dic = dic;
    [_imageV setImage:dic[@"Image"] forState:UIControlStateNormal];
    [_imageV setImage:dic[@"Image"] forState:UIControlStateHighlighted];
}

@end



