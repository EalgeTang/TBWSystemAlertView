//
//  TBWSystemAlertView.m
//  TBWSystemAlert
//
//  Created by mxl on 16/11/10.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "TBWSystemAlertView.h"
#import <objc/runtime.h>
#define VERSION_GREAT_THAN_IOS_8 ([[UIDevice currentDevice].systemVersion floatValue]>=8.0)
@interface TBWSystemAlertView ()<UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIAlertController *alertContriller;
@property (nonatomic, strong) UIAlertView *alertView;

@property (nonatomic, strong) UIActionSheet *sheetView;

/**存储button title 的数组*/
@property (nonatomic, copy) NSMutableArray *buttonTitleArr;

@property (nonatomic, copy) NSString *sureButtonString;
@property (nonatomic, copy) NSString *cancleButtonString;
@property (nonatomic, copy) NSString *destructiveButtonString;
@end
@implementation TBWSystemAlertView

static void * const AssociatedStorageKey = (void *)&AssociatedStorageKey;
#pragma mark -  set / get method

- (NSMutableArray *)buttonTitleArr
{
    if (!_buttonTitleArr)
    {
        _buttonTitleArr = [NSMutableArray array];
    }
    return _buttonTitleArr;
}

#pragma mark - 
+ (instancetype)ShowTBWSheetWithTitle:(NSString *)title
                              message:(NSString *)message
                presentViewController:(UIViewController *)vc
                   sureButtonComplete:(buttonClickComplete)sureComplete
                 cancleButtonComplete:(buttonClickComplete)cancleComplete
{
    TBWSystemAlertView *sheet = [TBWSystemAlertView showTBWAlertViewWithTitle:title presentedViewController:vc alertType:TBWSystemAlertTypeSheet message:message destructiveButtonTitle:nil sureButtonTitle:@"确定" cancleButtonTitle:@"取消" otherButtonTitles:nil];
    sheet.sureButtonComplete = sureComplete;
    sheet.cancleButtonComplete = cancleComplete;
    return sheet;
}
#pragma mark -
/**
 * 创建一个自带确定 和取消按钮的alert
 * @param sureComplete 确定按钮回调
 * @param cancleComplete 取消按钮回调
 */
+ (instancetype)showTBWSysAlertWithTitle:(NSString *)title
                                 message:(NSString *)message
                 presentedViewController:(UIViewController *)vc
                      sureButtonComplete:(buttonClickComplete)sureComplete
                    cancleButtonComplete:(buttonClickComplete)cancleComplete
{
    TBWSystemAlertView *alert = [TBWSystemAlertView showTBWAlertViewWithTitle:title presentedViewController:vc alertType:TBWSystemAlertTypeAlert message:message destructiveButtonTitle:nil sureButtonTitle:@"确定" cancleButtonTitle:@"取消" otherButtonTitles:nil];
    alert.sureButtonComplete = sureComplete;
    alert.cancleButtonComplete = cancleComplete;
    
    return alert;
}

/**
 * 创建一个只有button的alert
 */
+ (instancetype)showTBWSystemAlertWithTitle:(NSString *)title
                            message:(NSString *)message
            presentedViewController:(UIViewController *)vc
                        buttonTitle:(NSString *)buttonTitle
                     buttonComplete:(buttonClickCompleteIndex)complete
{
    TBWSystemAlertView *alert = [TBWSystemAlertView showTBWSystemAlertWithTitle:title message:message presentedViewController:vc];
    alert.buttonClickIndex = complete;
    
    return alert;
}

/**
 * 创建一个只有标题和消息的alert 并展示
 */
+ (instancetype)showTBWSystemAlertWithTitle:(NSString *)title
                                    message:(NSString *)message
                    presentedViewController:(UIViewController *)vc
{
    TBWSystemAlertView *alert = [TBWSystemAlertView showTBWAlertViewWithTitle:title
                                                      presentedViewController:vc
                                                                    alertType:TBWSystemAlertTypeAlert
                                                                      message:message
                                                       destructiveButtonTitle:nil
                                                              sureButtonTitle:nil
                                                            cancleButtonTitle:nil
                                                            otherButtonTitles:nil];
    return alert;
}
/**
 * 创建并展示 TBWSystemAlertView
 * @param title  and message 与系统alert 相同
 * @param destructiveButtonTitle 红色警示btn 标题
 * @param alertType  指定弹窗的样式,是alert 还是sheet
 * @param sureButtonTitle 确定按钮标题
 * @param cancleButtonTitle 取消按钮标题
 * @param otherText 添加的其他按钮标题.
 * return self;
 
 */
+ (instancetype)showTBWAlertViewWithTitle:(NSString *)title
                  presentedViewController:(UIViewController *)vc
                                alertType:(TBWSystemAlertType)alertType
                                  message:(NSString *)message
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                          sureButtonTitle:(NSString *)sureButtonTitle
                        cancleButtonTitle:(NSString *)cancleButtonTitle
                        otherButtonTitles:(NSString *)otherText,...
{

    TBWSystemAlertView *alert = [[TBWSystemAlertView alloc] initWithTitle:title
                                                                alertType:alertType
                                                                  message:message
                                                   destructiveButtonTitle:destructiveButtonTitle
                                                          sureButtonTitle:sureButtonTitle
                                                        cancleButtonTitle:nil otherButtonTitles:nil];
    NSMutableArray *otherTitles = [NSMutableArray array];
    va_list argList;
    if (otherText)
    {
        [otherTitles addObject: otherText];
        id arg;
        va_start(argList, otherText);
        while ((arg = va_arg(argList, id)))
        {
            [otherTitles addObject: arg];
        }
        va_end(argList);
    }
    [otherTitles addObject:cancleButtonTitle];
    
    [otherTitles enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == otherTitles.count - 1)
        {
            [alert addButtonWithTitleForTBWSystemAlertView:str isCancleButton:YES];
        }
        else
        {
            [alert addButtonWithTitleForTBWSystemAlertView:str isCancleButton:NO];
        }
    }];
    [alert showWithPresentedViewController:vc];
    return alert;
}

/**基础方法*/
- (id)initWithTitle:(NSString *)title
          alertType:(TBWSystemAlertType)alertType
            message:(NSString *)message
destructiveButtonTitle:(NSString *)destructiveButtonTitle
    sureButtonTitle:(NSString *)sureButtonTitle
  cancleButtonTitle:(NSString *)cancleButtonTitle
  otherButtonTitles:(NSString *)otherText,...
{
    if (self = [super init])
    {
        _alertType = alertType;
        objc_setAssociatedObject(self, AssociatedStorageKey, self, OBJC_ASSOCIATION_RETAIN);
        NSMutableArray *otherTitles = [NSMutableArray array];
        va_list argList;
        if (otherText)
        {
            [otherTitles addObject: otherText];
            id arg;
            va_start(argList, otherText);
            while ((arg = va_arg(argList, id)))
            {
                [otherTitles addObject: arg];
            }
            va_end(argList);
        }
        
        if (destructiveButtonTitle)
        {
            _destructiveButtonString = destructiveButtonTitle;
            [self.buttonTitleArr addObject:destructiveButtonTitle];
        }
        if (sureButtonTitle)
        {
            _sureButtonString = sureButtonTitle;
            [self.buttonTitleArr addObject:sureButtonTitle];
        }
        [self.buttonTitleArr addObjectsFromArray:otherTitles];
        // 保证cancle 在最后一位
        if (cancleButtonTitle)
        {
            _cancleButtonString = cancleButtonTitle;
            [self.buttonTitleArr addObject:cancleButtonTitle];
        }

        if (VERSION_GREAT_THAN_IOS_8) {
            // 如果是iOS 8 0之后的.
            _alertContriller = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:alertType == TBWSystemAlertTypeAlert ?UIAlertControllerStyleAlert:UIAlertControllerStyleActionSheet];
            if (destructiveButtonTitle)
            {
                //警示btn
                UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:destructiveButtonTitle
                                                                            style:UIAlertActionStyleDestructive
                                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                                              if (_destructiveButtonComplete)
                                                                              {
                                                                                  _destructiveButtonComplete();
                                                                              }
                                                                              
                                                                              [self setButtonIndexCompleteWithTitle:destructiveButtonTitle];
                }];
                [_alertContriller addAction:destructiveButton];

            }
            if (sureButtonTitle)
            {
                UIAlertAction *sureButton = [UIAlertAction actionWithTitle:sureButtonTitle
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                                         if (_sureButtonComplete)
                                                                         {
                                                                             _sureButtonComplete();
                                                                         }
                                                                       [self setButtonIndexCompleteWithTitle:sureButtonTitle];
                                                                       
                    
                }];
                [_alertContriller addAction:sureButton];
            }
            __weak __typeof(self) weakSelf = self;
            for (NSString *text in otherTitles)
            {
                UIAlertAction *action = [UIAlertAction actionWithTitle:text
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   
                                                                   [weakSelf.buttonTitleArr enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
                                                                       
                                                                       if ([str isEqualToString:text] && weakSelf.buttonClickIndex)
                                                                       {
                                                                           weakSelf.buttonClickIndex(idx, weakSelf);
                                                                       }
                                                                   }];
                                                               }];
                
                [_alertContriller addAction:action];
            }
            if (cancleButtonTitle)
            {
                UIAlertAction *cancleButton = [UIAlertAction actionWithTitle:cancleButtonTitle
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                                           if (_cancleButtonComplete
                                                                               )
                                                                           {
                                                                               _cancleButtonComplete();
                                                                           }
                                                                         
                                                                         [self setButtonIndexCompleteWithTitle:cancleButtonTitle];
                }];
                [_alertContriller addAction:cancleButton];
            }

        }
        else
        {
        
            if (_alertType == TBWSystemAlertTypeAlert)
            {
                _alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:cancleButtonTitle
                                              otherButtonTitles:sureButtonTitle, nil];
                if (destructiveButtonTitle)
                {
                    [_alertView addButtonWithTitle:destructiveButtonTitle];
                }
            }
            else
            {
                _sheetView = [[UIActionSheet alloc] initWithTitle:title
                                                         delegate:self
                                                cancelButtonTitle:cancleButtonTitle
                                           destructiveButtonTitle:destructiveButtonTitle
                                                otherButtonTitles:sureButtonTitle, nil];
                
            }
        
        }
    
    }

    return self;
}

/**展示alert*/
- (void)showWithPresentedViewController:(UIViewController *)viewController
{
    if (viewController)
    {
        if (VERSION_GREAT_THAN_IOS_8)
        {
            [viewController presentViewController:_alertContriller animated:YES completion:nil];
        }
        else
        {
            if (_alertType == TBWSystemAlertTypeAlert)
            {
                [_alertView show];
            }
            else
            {
                [_sheetView showInView:viewController.view];
            }
        }
    }
}

#pragma mark - 

- (NSInteger)addButtonWithTitleForTBWSystemAlertView:(NSString *)title
{
    [self.buttonTitleArr addObject:title];
    if (VERSION_GREAT_THAN_IOS_8)
    {
         __weak __typeof(self) weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            if (_buttonClickIndex) {
                weakSelf.buttonClickIndex(weakSelf.buttonTitleArr.count - 1, weakSelf);
                
            }
        }];
        [_alertContriller addAction:action];
    }
    else
    {
        // ios 8 以下
        if (_alertType == TBWSystemAlertTypeAlert)
        {
            [_alertView addButtonWithTitle:title];
        }
        else
        {
            [_sheetView addButtonWithTitle:title];
        }
    }
    return self.buttonTitleArr.count - 1;
}
#pragma mark -  按钮回调
/**
 * 确定按钮回调
 */
- (void)onSureButtonClickComplete:(buttonClickComplete)complete
{
    self.sureButtonComplete = complete;
}

/**
 * 取消按钮回调
 */
- (void)onCancleButtonClickComplete:(buttonClickComplete)complete
{
    self.cancleButtonComplete = complete;
}

/**
 * 警示按钮回调
 */
- (void)onDestructiveButtonClickComplete:(buttonClickComplete)complete
{
    self.destructiveButtonComplete = complete;
}

/**
 * 按钮的点击回调
 * @param  complete 回调block,  (点击button的Index, self)
 * return nil
 */
- (void)onButtonClickWithButtonIndex:(buttonClickCompleteIndex)complete
{
    self.buttonClickIndex = complete;
}

#pragma mark -  private method

- (void)setButtonIndexCompleteWithTitle:(NSString *)title
{
    __weak __typeof(self) weakSelf = self;
    [weakSelf.buttonTitleArr enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([text isEqualToString:title] && _buttonClickIndex)
        {
            weakSelf.buttonClickIndex(idx, weakSelf);
            *stop = YES;
        }
    }];
}

- (NSInteger)addButtonWithTitleForTBWSystemAlertView:(NSString *)title isCancleButton:(BOOL)isCancle
{
    [self.buttonTitleArr addObject:title];
    if (VERSION_GREAT_THAN_IOS_8)
    {
        __weak __typeof(self) weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            if (_buttonClickIndex)
            {
                weakSelf.buttonClickIndex(weakSelf.buttonTitleArr.count - 1, weakSelf);
                
            }
                                                           
            if (isCancle && _cancleButtonComplete)
            {
                weakSelf.cancleButtonComplete();
            }
        }];
        [_alertContriller addAction:action];
    }
    else
    {
        // ios 8 以下
        if (_alertType == TBWSystemAlertTypeAlert)
        {
            [_alertView addButtonWithTitle:title];
        }
        else
        {
            [_sheetView addButtonWithTitle:title];
        }
    }
    return self.buttonTitleArr.count - 1;
}
#pragma mark - UIAlertView/ sheet delegate

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
     __weak __typeof(self) weakSelf = self;
    [self.buttonTitleArr enumerateObjectsUsingBlock:^(NSString * str, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([str isEqualToString:weakSelf.sureButtonString] && weakSelf.sureButtonComplete && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:weakSelf.sureButtonString] )
        {
            weakSelf.sureButtonComplete();
            *stop = YES;
        }
        if ([str isEqualToString:weakSelf.cancleButtonString] && weakSelf.cancleButtonComplete && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:weakSelf.cancleButtonString])
        {
            weakSelf.cancleButtonComplete();
            *stop = YES;
        }
        if ([str isEqualToString:weakSelf.destructiveButtonString] && weakSelf.destructiveButtonComplete && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:weakSelf.destructiveButtonString])
        {
            weakSelf.destructiveButtonComplete();
            *stop = YES;
        }
    }];
    
    //传递点击btn 的index
    if (self.buttonClickIndex)
    {
        self.buttonClickIndex(buttonIndex, self);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    __weak __typeof(self) weakSelf = self;
    [self.buttonTitleArr enumerateObjectsUsingBlock:^(NSString * str, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([str isEqualToString:weakSelf.sureButtonString] && weakSelf.sureButtonComplete && [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:weakSelf.sureButtonString] )
        {
            weakSelf.sureButtonComplete();
            *stop = YES;
        }
        if ([str isEqualToString:weakSelf.cancleButtonString] && weakSelf.cancleButtonComplete && [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:weakSelf.cancleButtonString])
        {
            weakSelf.cancleButtonComplete();
            *stop = YES;
        }
        if ([str isEqualToString:weakSelf.destructiveButtonString] && weakSelf.destructiveButtonComplete && [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:weakSelf.destructiveButtonString])
        {
            weakSelf.destructiveButtonComplete();
            *stop = YES;
        }
    }];
    //传递点击btn 的index
    if (self.buttonClickIndex)
    {
        self.buttonClickIndex(buttonIndex, self);
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    objc_setAssociatedObject(self, AssociatedStorageKey, nil, OBJC_ASSOCIATION_RETAIN);
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    objc_setAssociatedObject(self, AssociatedStorageKey, nil, OBJC_ASSOCIATION_RETAIN);
}

- (void)dealloc
{
   // [super dealloc];
}

@end
