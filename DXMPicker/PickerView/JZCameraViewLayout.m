//
//  JZCameraViewLayout.m
//  JeezIPMS
//
//  Created by jeez on 16/1/13.
//  Copyright © 2016年 jeez. All rights reserved.
//

#import "JZCameraViewLayout.h"
#define ImageWH 65.0
@implementation JZCameraViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.0f);//头部视图的框架大小
        
        self.footerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.0f);//尾部视图的框架大小
        
        self.itemSize = CGSizeMake(ImageWH, ImageWH);//每个cell的大小
        
        self.minimumLineSpacing = 10.0f;//每行的最小间距
        
        self.minimumInteritemSpacing = 10.0f;//每列的最小间距
        
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//网格视图的/上/左/下/右,的边距
    }
    
    return self;
}


@end
