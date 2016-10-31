//
//  JZItemCollectionCell.h
//  保利悠悦荟
//
//  Created by yangyun on 15/2/3.
//  Copyright (c) 2015年 qiushengsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZItemCollectionCell : UICollectionViewCell
{
    UILabel *_nameLB;
    
    
    NSDictionary *_dic;
}
@property(nonatomic,strong)UIButton *imageV;
- (void)setViewDataWithDic:(NSDictionary*)dic;
- (void)setViewWithDic:(NSDictionary*)dic;
@end
