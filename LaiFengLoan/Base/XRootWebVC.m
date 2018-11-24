//
//  XRootWebVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/28.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XRootWebVC.h"
#import <WebKit/WebKit.h>

@interface XRootWebVC ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate>
{
    UIView *lineview;
    UIButton *leftBTN;
    UIButton *rightBTN;
    UIView *buttomView;
    UIImageView *buttonImage2;
    UIImageView *buttonImage;
    NSString *isSigned;
}
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *item;

@end

@implementation XRootWebVC

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebViewWithURL:self.url];
}

- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"btn_back"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn sizeToFit];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        btn.frame = CGRectMake(0, 0, 30, 40);
        _backItem.customView = btn;
    }
    return _backItem;
}
//点击返回的方法
- (void)backNative{
    [self.webView goBack];
}

-(void)setBackNavigationBarItem{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.userInteractionEnabled = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 104, 44);
    button.tag = 9999;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    [button setTitle:@"" forState:UIControlStateNormal];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:XColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"XX"] forState:UIControlStateNormal];
//    button.imageEdgeInsets = UIEdgeInsetsMake(0, -AdaptationWidth(28), 0, AdaptationWidth(38));
    button.titleEdgeInsets = UIEdgeInsetsMake(0, AdaptationWidth(28), 0, -AdaptationWidth(28));
    [button addTarget:self action:@selector(BarbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
//    lineview = [[UIView alloc] initWithFrame:CGRectMake(36, (button.frame.size.height- AdaptationWidth(16)) / 2, 0.5 , AdaptationWidth(16))];
//    lineview.backgroundColor  = XColorWithRGB(233, 233, 235);
//    [button addSubview:lineview];
    self.item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = self.item;
}

-(void)BarbuttonClick{
    
   
        [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void) createWebViewWithURL:(NSString *)url{
//    NSLog(@"==========%@不要空格",url);
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressTintColor = [UIColor grayColor];
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(AdaptationWidth(2));
    }];
    
    WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize =10;
    config.preferences.javaScriptEnabled =YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically =NO;
    config.userContentController = [[WKUserContentController alloc] init];
    config.processPool = [[WKProcessPool alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    NSMutableString *javascript = [NSMutableString string];
//    [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
//    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    /**网页*/
    [self.webView.configuration.userContentController addUserScript:noneSelectScript];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    //js端代码实现实例:
        //window.webkit.messageHandlers.triggerAppMethod.postMessage({body: 'goodsId=1212'});
        
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(50));
    }];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
     
 
    [self createButtomView];
   
    
   
}

#pragma mark - WKScriptMessageHandler
//实现js注入方法的协议方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //找到对应js端的方法名,获取messge.body
//    NSLog(@"111111%@",message);
//    NSLog(@"222222%@",message.body);
//    NSLog(@"333333%@",message.frameInfo.request);
//    NSLog(@"444444%@",message.frameInfo.request.URL);
//    NSLog(@"555555%@",message.name);
    
}
// 接收到服务器跳转请求之后调用
//
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//    NSLog(@"waawaw");
//}
//// 在收到响应后，决定是否跳转
//
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//
//    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
//
//    //允许跳转
//
//    decisionHandler(WKNavigationResponsePolicyAllow);
//
//    //不允许跳转
//
//    //decisionHandler(WKNavigationResponsePolicyCancel);
//
//}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    lineview.frame = CGRectMake(36, 14, 0.5, 16);
    self.navigationItem.leftBarButtonItems = @[self.item];

    if ([webView canGoBack]) {
        [UIView animateWithDuration:0.3 animations:^{
            
        }];
        buttonImage.image = [UIImage imageNamed:@"btn_bk"];
        leftBTN.enabled = YES;
    }else{
        buttonImage.image = [UIImage imageNamed:@"icon_entre2"];
        leftBTN.enabled = NO;
        
    }
    if ([webView canGoForward]) {
        buttonImage2.image = [UIImage imageNamed:@"btn_forword"];
        rightBTN.enabled = YES;
    }else{
        buttonImage2.image = [UIImage imageNamed:@"icon_entre"];
        rightBTN.enabled = NO;
    }
    
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    NSLog(@"%@",navigationAction.request.URL);
//    标签带有 target='_blank' 时
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
//在navigationDelegate中拦截，手动openURL才能跳转至AppStore
- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler{
    WKNavigationActionPolicy policy =WKNavigationActionPolicyAllow;
    NSString *str = [NSString stringWithFormat:@"%@",navigationAction.request.URL];
    if ([str rangeOfString:@"tel://"].location !=NSNotFound && [[UIApplication sharedApplication] openURL:navigationAction.request.URL]) {

        policy =WKNavigationActionPolicyCancel;
    }
    if ([[navigationAction.request.URL host] isEqualToString:@"itunes.apple.com"] &&[[UIApplication sharedApplication] openURL:navigationAction.request.URL]){
        policy =WKNavigationActionPolicyCancel;
    }
    if([[navigationAction.request.URL scheme] isEqualToString:@"itms-services"] &&[[UIApplication sharedApplication] openURL:navigationAction.request.URL]){
        policy =WKNavigationActionPolicyCancel;
        
    }
    decisionHandler(policy);
   
}

// JS端调用prompt函数时，会触发此方法,要求输入一段文本,在原生输入得到文本内容后，通过completionHandler回调给JS
// 拦截提示框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
     {
         textField.textColor = [UIColor redColor];
     }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                      {
                          completionHandler([[alert.textFields lastObject] text]);
                      }]];
    [self presentViewController:alert animated:YES completion:NULL];
}
// 拦截警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alert animated:YES completion:NULL];
}
// 拦截确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

//kvo观察者方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]&&object == _webView) {
        self.title = self.webView.title;//标题
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_webView.estimatedProgress animated:YES];
        if (_webView.estimatedProgress == 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.equalTo(self.view);
                    make.height.equalTo(@(0));
                }];
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)createButtomView{
    buttomView = [[UIView alloc]init];
    buttomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttomView];
    
    leftBTN = [[UIButton alloc]init];
    [leftBTN setBackgroundColor:[UIColor clearColor]];
    leftBTN.tag = 6666;
    [leftBTN addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:leftBTN];
    
    buttonImage = [[UIImageView alloc]init];
    buttonImage.image = [UIImage imageNamed:@"icon_entre2"];
    [leftBTN addSubview:buttonImage];
    
    UIView *lineView  = [[UIView alloc]init];
    lineView.backgroundColor = XColorWithRGB(233, 233, 235);
    [buttomView addSubview:lineView];

    rightBTN = [[UIButton alloc]init];
    [rightBTN setBackgroundColor:[UIColor clearColor]];
    rightBTN.tag = 7777;
    [rightBTN addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:rightBTN];
    
    buttonImage2 = [[UIImageView alloc]init];
    buttonImage2.image = [UIImage imageNamed:@"icon_entre"];
    [rightBTN addSubview:buttonImage2];
    
    [leftBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(buttomView);
        make.width.mas_equalTo(ScreenWidth / 2);
    }];
    [buttonImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(leftBTN);
        make.height.mas_equalTo(AdaptationWidth(28));
        make.width.mas_equalTo(AdaptationWidth(28));
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(buttomView);
        make.height.mas_equalTo(AdaptationWidth(28));
        make.width.mas_equalTo(0.5);
    }];
    [rightBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(buttomView);
        make.width.mas_equalTo(ScreenWidth / 2);
    }];
    [buttonImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(rightBTN);
        make.height.mas_equalTo(AdaptationWidth(28));
        make.width.mas_equalTo(AdaptationWidth(28));
    }];
    [buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(AdaptationWidth(50));
    }];
}

-(void)btnOnClick:(UIButton *)button{
    switch (button.tag) {
        case 6666:{
            [self.webView goBack];
        }
            break;
        case 7777:{
            [self.webView goForward];
        }
            break;
            
        default:
            break;
    }
}

//移除观察者
-(void)dealloc{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_webView setNavigationDelegate:nil];
    [_webView setUIDelegate:nil];
}

@end
