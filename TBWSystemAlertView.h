//
//  TBWSystemAlertView.h
//  TBWSystemAlert
//
//  Created by mxl on 16/11/10.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, TBWSystemAlertType) {
    TBWSystemAlertTypeAlert,
    TBWSystemAlertTypeSheet,
};

@class TBWSystemAlertView;

typedef void(^buttonClickComplete)(void);
typedef void(^buttonClickCompleteIndex)(NSInteger buttonIndex, TBWSystemAlertView *alert);

@interface TBWSystemAlertView : NSObject

/**alert类型*/
@property (nonatomic, assign) TBWSystemAlertType alertType;

/**确定按钮点击回调*/
@property (nonatomic, copy) buttonClickComplete sureButtonComplete;

/**取消按钮点击回调*/
@property (nonatomic, copy) buttonClickComplete cancleButtonComplete;
/**警示按钮点击回调*/
@property (nonatomic, copy) buttonClickComplete destructiveButtonComplete;
/**按钮点击回调,参数带button的index*/
@property (nonatomic, copy) buttonClickCompleteIndex buttonClickIndex;

#pragma mark -- sheet 

/**
 * 创建一个自带确定按钮和取消按钮的sheet
 * @param sureComplete 确定按钮回调
 * @param cancleComplete 取消按钮回调
 */
+ (instancetype)ShowTBWSheetWithTitle:(NSString *)title
                              message:(NSString *)message
                presentViewController:(UIViewController *)vc
                   sureButtonComplete:(buttonClickComplete)sureComplete
                 cancleButtonComplete:(buttonClickComplete)cancleComplete;

#pragma mark -- 创建 /展示 alert

/**
 * 创建一个只有标题和消息的alert 并展示
 * @param vc 需要在哪个viewController上展示
 */
+ (instancetype)showTBWSystemAlertWithTitle:(NSString *)title
                                    message:(NSString *)message
                    presentedViewController:(UIViewController *)vc;

/**
 * 创建一个只有button的alert
 */
+ (instancetype)showTBWSystemAlertWithTitle:(NSString *)title
                            message:(NSString *)message
            presentedViewController:(UIViewController *)vc
                        buttonTitle:(NSString *)buttonTitle
                     buttonComplete:(buttonClickCompleteIndex)complete;

/**
 * 创建一个自带确定 和取消按钮的alert
 * @param sureComplete 确定按钮回调
 * @param cancleComplete 取消按钮回调
 */
+ (instancetype)showTBWSysAlertWithTitle:(NSString *)title
                         message:(NSString *)message
         presentedViewController:(UIViewController *)vc
              sureButtonComplete:(buttonClickComplete)sureComplete
            cancleButtonComplete:(buttonClickComplete)cancleComplete;


#pragma mark --
/**
 * TBWSystemAlert的初始化方法 不展示
 * @param title  and message      与系统alert 相同
 * @param destructiveButtonTitle  红色警示btn 标题
 * @param alertType               指定弹窗的样式,是alert 还是sheet
 * @param sureButtonTitle         确定按钮标题
 * @param cancleButtonTitle       取消按钮标题
 * @param otherText               添加的其他按钮标题.
 * @return self;
 */
- (instancetype)initWithTitle:(NSString *)title
          alertType:(TBWSystemAlertType)alertType
            message:(NSString *)message
destructiveButtonTitle:(NSString *)destructiveButtonTitle
    sureButtonTitle:(NSString *)sureButtonTitle
  cancleButtonTitle:(NSString *)cancleButtonTitle
  otherButtonTitles:(NSString *)otherText,...;

/**
 * 创建并展示 TBWSystemAlertView
 * @param title  and message        与系统alert 相同
 * @param destructiveButtonTitle    红色警示btn 标题
 * @param alertType                 指定弹窗的样式,是alert 还是sheet
 * @param sureButtonTitle           确定按钮标题
 * @param cancleButtonTitle         取消按钮标题
 * @param otherText                 添加的其他按钮标题.
 * @param vc                        要被展示在哪个viewController上
 * return self;
 
 */
+ (instancetype)showTBWAlertViewWithTitle:(NSString *)title
                  presentedViewController:(UIViewController *)vc
                                alertType:(TBWSystemAlertType)alertType
                                  message:(NSString *)message
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                          sureButtonTitle:(NSString *)sureButtonTitle
                        cancleButtonTitle:(NSString *)cancleButtonTitle
                        otherButtonTitles:(NSString *)otherText,...;

/**
 * 展示alert
 * @param viewController  需要在哪个viewController上展示
 *
 */
- (void)showWithPresentedViewController:(UIViewController *)viewController;

#pragma mark --

/**
 * 添加按钮
 * @param title  按钮标题
 * @return 按钮索引
 */
- (NSInteger)addButtonWithTitleForTBWSystemAlertView:(NSString *)title;

#pragma mark -- 按钮点击回调
/**
 * 确定按钮回调
 */
- (void)onSureButtonClickComplete:(buttonClickComplete)complete;

/**
 * 取消按钮回调
 */
- (void)onCancleButtonClickComplete:(buttonClickComplete)complete;

/**
 * 警示按钮回调
 */
- (void)onDestructiveButtonClickComplete:(buttonClickComplete)complete;

/**
 * 按钮的点击回调
 * @param  complete 回调block,  (点击button的Index, self)
 * return nil
 */
- (void)onButtonClickWithButtonIndex:(buttonClickCompleteIndex)complete;

@end
