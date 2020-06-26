//
//  ChatInputBoardView.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/15.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "ChatInputBoardView.h"
#import "UIView+ZBExtension.h"
#import "UITextView+ZBPlaceHolder.h"
@interface ChatInputBoardView()
//当前的编辑状态
@property(nonatomic,assign)BJXChatKeyBoardStatus keyBoardStatus;

@property(nonatomic,assign)CGFloat changeTime;
@property(nonatomic,assign)CGFloat keyBoardHieght;//键盘的高度
//当前点击的按钮  左侧按钮   表情按钮  添加按钮
@property(nonatomic,strong)UILabel *textCountLabel;
//输入框背景 输入框
@property(nonatomic,strong) UITextView   *mTextView;
//输入框的高度
@property(nonatomic,assign) CGFloat   textH;
//输入框的高度
@property(nonatomic,assign)CGFloat textHieght;
@property(nonatomic,assign)BOOL issue;

@end
@implementation ChatInputBoardView
- (void)dealloc{
     NSLog(@"释放%s",__func__);
}

-(instancetype)init{
    if(self = [super init]){
        self.backgroundColor = [UIColor colorWithRed:(245)/255.0 green:(245)/255.0 blue:(245)/255.0 alpha:(1)];
       
        self.frame = CGRectMake(0, MAIN_SCREEN_HEIGHT-ChatKeyBoardInputViewH-safeAreaBottomHeight, MAIN_SCREEN_WIDTH, ChatKeyBoardInputViewH);
        
        _keyBoardStatus = BJXChatKeyBoardStatusDefault;
        _keyBoardHieght = 0;
        _changeTime = 0.25;
       //_maxFontNum=200;
        _isBanned=NO;
        _textH = ChatTextHeight;
    
        
        //添加按钮
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.bounds = CGRectMake(0, 0,ChatBtnSize+22, ChatBtnSize);
        _sendBtn.right = MAIN_SCREEN_WIDTH - ChatBtnDistence;
        _sendBtn.bottom  = self.height - ChatBBottomDistence;
        _sendBtn.selected = NO;
        [self addSubview:_sendBtn];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        _sendBtn.backgroundColor=[UIColor colorWithRed:(255)/255.0 green:(68)/255.0 blue:(0)/255.0 alpha:(1)];
        _sendBtn.selected = NO;
        _textCountLabel=[[UILabel alloc]init];
        _textCountLabel.bounds = CGRectMake(0, 0, ChatBtnSize+25, 15);
        _textCountLabel.top=self.top-8;
        _textCountLabel.right=MAIN_SCREEN_WIDTH - ChatBtnDistence;
        _textCountLabel.text=[NSString stringWithFormat:@"0/%ld",_maxFontNum];
        _textCountLabel.textColor=[UIColor colorWithRed:(153)/255.0 green:(153)/255.0 blue:(153)/255.0 alpha:(1)];
        _textCountLabel.font=[UIFont systemFontOfSize:12];
        _textCountLabel.hidden=YES;
         [self addSubview:_textCountLabel];
        
        _mTextView = [[UITextView alloc]init];
        _mTextView.frame = CGRectMake(16, 8,ChatTextWidth, ChatTextHeight);
        _mTextView.textContainerInset = UIEdgeInsetsMake(7.5, 5, 5, 0);
        _mTextView.delegate = self;
        [self addSubview:_mTextView];
        _mTextView.backgroundColor = [UIColor whiteColor];
        _mTextView.returnKeyType = UIReturnKeySend;
        _mTextView.font = [UIFont systemFontOfSize:15];
        _mTextView.showsHorizontalScrollIndicator = NO;
        _mTextView.showsVerticalScrollIndicator = NO;
        _mTextView.enablesReturnKeyAutomatically = YES;
        _mTextView.scrollEnabled = NO;
        // 添加一个全局禁言遮罩
//        _allBannedLabel = [[ChatRoomRoleLabel alloc]init];
//        _allBannedLabel.frame = _mTextView.frame;
//        _allBannedLabel.backgroundColor = [UIColor whiteColor];
//        _allBannedLabel.textInsets =  UIEdgeInsetsMake(7.5, 5, 5, 0);
//        _allBannedLabel.textColor = SBE_UI_COLOR(204, 204, 204, 1);
//        _allBannedLabel.text = @"全员禁言";
//        _allBannedLabel.font = [UIFont systemFontOfSize:15];
//        [self addSubview:_allBannedLabel];
        //键盘显示 回收的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}
- (void)setContent:(NSString *)content{
    _content=content;
    _mTextView.text=content;
}
- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder=placeHolder;
    _mTextView.BJX_placeHolder=placeHolder;
    _mTextView.placeHolderFontSize=13;
}
- (void)setIsBanned:(BOOL)isBanned{
    _isBanned=isBanned;
    if (isBanned==YES) {
        _mTextView.editable=NO;
        _sendBtn.backgroundColor=[UIColor colorWithRed:(204)/255.0 green:(204)/255.0 blue:(204)/255.0 alpha:(1)];
    }else{
        _mTextView.editable=YES;
        _sendBtn.backgroundColor=[UIColor colorWithRed:(255)/255.0 green:(68)/255.0 blue:(0)/255.0 alpha:(1)];;
    }
}
- (void)setMaxFontNum:(NSInteger)maxFontNum{
    _maxFontNum=maxFontNum;
    _textCountLabel.text=[NSString stringWithFormat:@"0/%ld",maxFontNum];
}
- (void)becomeFirstResponder{
    self.hidden=NO;
    [_mTextView becomeFirstResponder];
}
//键盘显示监听事件
- (void)keyboardWillChange:(NSNotification *)noti{
    
    _changeTime  = [[noti userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    if(noti.name == UIKeyboardWillHideNotification){
        if (self.issue==YES) {
            self.hidden=YES;
        }
        height = safeAreaBottomHeight;
    }else{
        self.keyBoardStatus = BJXChatKeyBoardStatusEdit;
        self.sendBtn.selected = NO;
        if(height==safeAreaBottomHeight || height==0){
            height = _keyBoardHieght;
        }
    }
    
    self.keyBoardHieght = height;
}

//弹起的高度
-(void)setKeyBoardHieght:(CGFloat)keyBoardHieght{
    
    if(keyBoardHieght == _keyBoardHieght)return;
    
    _keyBoardHieght = keyBoardHieght;
    [self setNewSizeWithController];

    [UIView animateWithDuration:_changeTime animations:^{
        if(self.keyBoardStatus == BJXChatKeyBoardStatusDefault){
            self.bottom = MAIN_SCREEN_HEIGHT-safeAreaBottomHeight;
        }else{
            self.bottom = MAIN_SCREEN_HEIGHT-self.keyBoardHieght;
        }
    } completion:nil];
    
}

//设置默认状态
-(void)setKeyBoardStatus:(BJXChatKeyBoardStatus)keyBoardStatus{
    _keyBoardStatus = keyBoardStatus;
    
    if(_keyBoardStatus == BJXChatKeyBoardStatusDefault){
        self.sendBtn.selected = NO;
        self.mTextView.hidden = NO;
    }
}
//视图归位 设置默认状态 设置弹起的高度
-(void)setChatKeyBoardInputViewEndEditing{
    if (self.issue==YES) {
        self.hidden=YES;
    }
    self.keyBoardStatus = BJXChatKeyBoardStatusDefault;
    [self endEditing:YES];
    self.keyBoardHieght = 0.0;
}
//设置所有控件新的尺寸位置
-(void)setNewSizeWithBootm:(CGFloat)height{
   
    [self setNewSizeWithController];
    
    [UIView animateWithDuration:0.25 animations:^{
        if (height>ChatTextHeight) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.textCountLabel.hidden=NO;
            });
        }else{
            self.textCountLabel.hidden=YES;
        }
        
        self.mTextView.height = height;
        self.height = 8 + 8 +self.mTextView.height;
        
        self.mTextView.top = 8;
        self.textCountLabel.top = 8;
        self.sendBtn.bottom = self.height-ChatBBottomDistence;
        
        if(self.keyBoardStatus == BJXChatKeyBoardStatusDefault ){
            self.bottom = MAIN_SCREEN_HEIGHT-safeAreaBottomHeight;
        }else{
            self.bottom = MAIN_SCREEN_HEIGHT-self.keyBoardHieght;
        }
        
    } completion:^(BOOL finished) {
        [self.mTextView.superview layoutIfNeeded];
    }];
}

//设置键盘和表单位置
-(void)setNewSizeWithController{
    
    CGFloat changeTextViewH = fabs(_textH - ChatTextHeight);
    if(self.mTextView.hidden == YES) changeTextViewH = 0;
    CGFloat changeH = _keyBoardHieght + changeTextViewH;
    
    if(safeAreaBottomHeight!=0 && _keyBoardHieght!=0){
        changeH -= safeAreaBottomHeight;
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(chatKeyInputBoardHeight:changeTime:)]){
        [_delegate chatKeyInputBoardHeight:changeH changeTime:_changeTime];
    }
}

//拦截发送按钮
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if(text.length==0){
        [self textViewDidChange:self.mTextView];
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [self startSendMessage];
        return NO;
    }
    //控制文本输入内容
    if (range.location>=self.maxFontNum){
        //控制输入文本的长度
        return  NO;
    }
    return YES;
}

//开始发送消息
-(void)startSendMessage{
    NSString *message = [_mTextView.attributedText string];
    NSString *newMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(message.length==0){
        
    }
    else if(_delegate && [_delegate respondsToSelector:@selector(chatKeyInputBoardView:messageText:)]){
        [_delegate chatKeyInputBoardView:self messageText:newMessage];
    }
    
    //_mTextView.text = @"";
    _mTextView.contentSize = CGSizeMake(_mTextView.contentSize.width, 30);
    [_mTextView setContentOffset:CGPointZero animated:YES];
    [_mTextView scrollRangeToVisible:_mTextView.selectedRange];
  
    _textH = ChatTextHeight;
    [self setNewSizeWithBootm:_textH];
    [self setChatKeyBoardInputViewEndEditing];
}

//监听输入框的操作 输入框高度动态变化
- (void)textViewDidChange:(UITextView *)textView{
    //获取到textView的最佳高度
    NSInteger height = ceilf([textView sizeThatFits:CGSizeMake(textView.width, MAXFLOAT)].height);

    if(height>ChatTextMaxHeight){
        height = ChatTextMaxHeight;
        textView.scrollEnabled = YES;
    }
    else if(height<ChatTextHeight){
        height = ChatTextHeight;
        textView.scrollEnabled = NO;
    }
    else{
        textView.scrollEnabled = NO;
    }

    if(_textH != height){
        _textH = height;
        [self setNewSizeWithBootm:height];
    }
    else{
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 2)];
    }
     //  NSInteger length = self.textView.text.length;
    NSString *toBeString = textView.text;
    // 获取键盘输入模式
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // zh-Hans代表简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
           //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
           // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.maxFontNum) {
                textView.text = [toBeString substringToIndex:self.maxFontNum];//超出限制则截取最大限制的文本
                self.textCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.maxFontNum,self.maxFontNum];
            } else {
                self.textCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",toBeString.length,self.maxFontNum];
            }
        }
    } else {// 中文输入法以外的直接统计
        if (toBeString.length > self.maxFontNum) {
            textView.text = [toBeString substringToIndex:self.maxFontNum];
            self.textCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.maxFontNum,self.maxFontNum];
        } else {
            self.textCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",toBeString.length,self.maxFontNum];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
