//
//  JZTextView.h
//  JeezIPMS
//
//  Created by jeez on 16/2/26.
//  Copyright © 2016年 jeez. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JZTextViewDelegate <NSObject>


@end


@interface JZTextView : UITextView {
    UILabel *_textLabel;
}
@property(nonatomic,copy) NSString *placeholder;

//初始化
- (id)initWithFrame:(CGRect)frame Delegate:(id<JZTextViewDelegate>)JZdelegate WithPlaceholder:(NSString *)placeholder;



@end
