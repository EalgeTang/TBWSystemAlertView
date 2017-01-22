# TBWSystemAlertView
对 系统alertView 的一个适配封装, 能够根据系统版本自动适配使用UIAlertView / UIAlertController。
参照了系统的做法，将其类型分为两类。sheet/ alert。 
大部分情况下可能我们只是想要单纯的显示出一个提示框，而不需要其他额外的操作，那么我们可以向这样去使用这个类
[TBWSystemAlertView showTBWSystemAlertWithTitle:@"指纹验证成功" message:nil presentedViewController:self]。
亦或是我们需要是和系统一样带有确定，和取消按钮。但只是展示的title和内容与系统略有不同，而且我们也希望获取用户的点击事件以此再来做些操作的话，那么为了方便，你可以这么做

    [TBWSystemAlertView ShowTBWSheetWithTitle:@"提示"
                                      message:@"message" presentViewController:self
                           sureButtonComplete:^{
        NSLog(@"sure button is clicked");
    } cancleButtonComplete:^{
        NSLog(@"cancle button is clicked");
    }];
    
    当然我也提供有一个与系统类似的实例方法，与类方法，来方便你的更多个性化需求
    
        TBWSystemAlertView *alert = [[TBWSystemAlertView alloc] initWithTitle:@"title"
                                                                alertType:TBWSystemAlertTypeAlert
                                                                  message:@"this is a message"
                                                   destructiveButtonTitle:@"惊世狂"
                                                          sureButtonTitle:@"确定"
                                                        cancleButtonTitle:@"取消"
                                                        otherButtonTitles:@"111", @"222", @"333", nil];
        [alert showWithPresentedViewController:self];
                                                        
     而如果你需要调用相应按钮的点击事件，我也提供了各个按钮的回调方法。诸如这样：
     
         [alert onSureButtonClickComplete:^{
        NSLog(@"--sure 被传递过来了");
    }];
    
    你也可以根据button的index来确定button
    
        [alert onButtonClickWithButtonIndex:^(NSInteger buttonIndex, TBWSystemAlertView *alert) {
        NSLog(@"点击了第 %ld个按钮",buttonIndex);
    }];
    
    整体的使用上来说。是要比系统的来的更加方便。而且现在UIAlert 已经被系统弃用。而我们现在大部分项目还是需要向下兼容到iOS7 的，所以我觉得做一下系统弹窗的适配还是十分必要的
