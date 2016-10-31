//
//  JZTextView.m
//  JeezIPMS
//
//  Created by jeez on 16/2/26.
//  Copyright © 2016年 jeez. All rights reserved.
//

#import "JZTextView.h"
#define JZWGap 10
#define JZHGap 15
#define FONTNAME @"Helvetica"
#define FONTSIZE 15
@implementation JZTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [self labelWithTitleColor:[[self colorsetMsgContent] colorWithAlphaComponent:0.6] title:self.placeholder frame:CGRectMake(3, 6, self.frame.size.width, JZWGap*2) fontSize:FONTSIZE];
        [self addSubview:_textLabel];
        self.returnKeyType = UIReturnKeyDone;
        self.font = [UIFont fontWithName:FONTNAME size:FONTSIZE];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
//        [self addObserver:self.delegate forKeyPath:UITextViewTextDidChangeNotification options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
//消息内容文字灰色颜色
- (UIColor *)colorsetMsgContent {
    return [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
}
- (UILabel *)labelWithTitleColor:(UIColor *)color title:(NSString *)title frame:(CGRect)frame fontSize:(CGFloat)fontsize {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    [label setTextColor:color];
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:FONTNAME size:fontsize];
    label.text = title;
    return label;
}
//初始化
- (id)initWithFrame:(CGRect)frame Delegate:(id<JZTextViewDelegate>)JZdelegate WithPlaceholder:(NSString *)placeholder {
    self = [self initWithFrame:frame];
    if (self) {
        self.placeholder = placeholder;
         _textLabel.text = self.placeholder;
    }
    return self;
}
- (void)textViewTextDidChangeNotification:(NSNotification *)notification {
    if (self.text.length > 0) {
        _textLabel.text = @"";
    }else
        _textLabel.text = self.placeholder;
}
@end
