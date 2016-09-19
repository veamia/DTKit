//
//  DTWebViewController.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTWebViewController.h"
#import <WebKit/WebKit.h>
#import "NSString+Expand.h"
#import "UIView+Frame.h"
#import "DTKitMacro.h"
#import "DTButton.h"

@interface DTWebViewController ()
<UIWebViewDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *fakeProgressTimer;
@property (nonatomic, assign) BOOL webViewIsLoading;

@end

@implementation DTWebViewController

- (void)dealloc
{
    _webView.delegate = nil;
    _webView = nil;
    _wkWebView.navigationDelegate = nil;
    _wkWebView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *fileURL = self.isLocal ? [NSURL fileURLWithPath:self.urlString] :
    [NSURL URLWithString:self.urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL];
    
    if([WKWebView class]) {
        [self.view addSubview:self.wkWebView];
        [self.wkWebView loadRequest:request];
    } else {
        [self.view addSubview:self.webView];
        [self.webView loadRequest:request];
    }
    [self.view addSubview:self.progressView];
    
    if (self.isCanClose) {
        DTButton *leftBtn = (DTButton *)self.customNaviBar.leftView;
        leftBtn.stateNormal.image = dtImageByName(@"return");
        [leftBtn setTarget:self action:@selector(dismissViewController)];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(![WKWebView class]) return;
    
    [self.wkWebView addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(![WKWebView class]) return;
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

// kvo 接收
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self.progressView setAlpha:1.0f];
    BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
    [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
    
    if(self.wkWebView.estimatedProgress >= 1.0f) {
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

#pragma mark -
#pragma mark - event
- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Fake Progress Bar Control (UIWebView)

- (void)fakeProgressViewStartLoading {
    [self.progressView setProgress:0.05f animated:NO];
    [self.progressView setAlpha:1.0f];
    
    if(!self.fakeProgressTimer) {
        self.fakeProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(fakeProgressTimerDidFire:) userInfo:nil repeats:YES];
    }
}

- (void)fakeProgressBarStopLoading {
    if(self.fakeProgressTimer) {
        [self.fakeProgressTimer invalidate];
    }
    
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

- (void)fakeProgressTimerDidFire:(id)sender {
    CGFloat increment = 0.005/(self.progressView.progress + 0.2);
    if([self.webView isLoading]) {
        CGFloat progress = (self.progressView.progress < 0.75f) ? self.progressView.progress + increment : self.progressView.progress + 0.0005;
        if(self.progressView.progress < 0.95) {
            [self.progressView setProgress:progress animated:YES];
        }
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    self.webViewIsLoading = YES;
    [self fakeProgressViewStartLoading];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(!self.webView.isLoading) {
        self.webViewIsLoading = NO;
        [self fakeProgressBarStopLoading];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if(!self.webView.isLoading) {
        self.webViewIsLoading = NO;
        [self fakeProgressBarStopLoading];
    }
}

#pragma mark -
#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    if ([url.scheme.lowercaseString isEqualToString:@"tel"]) {
        NSString *phoneNumber = url.resourceSpecifier;
        [phoneNumber takeTelephone];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%@", error);
}

#pragma mark -
#pragma mark - getter

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.customNaviBar.height, dtScreenWidth, dtScreenHeight-self.customNaviBar.height)];
        _webView.delegate = self;
        [_webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_webView setMultipleTouchEnabled:YES];
        [_webView setAutoresizesSubviews:YES];
        [_webView setScalesPageToFit:YES];
        [_webView.scrollView setAlwaysBounceVertical:YES];
    }
    return _webView;
}

- (WKWebView *)wkWebView
{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.customNaviBar.height, dtScreenWidth, dtScreenHeight-self.customNaviBar.height)];
        _wkWebView.navigationDelegate = self;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        [_wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_wkWebView setMultipleTouchEnabled:YES];
        [_wkWebView setAutoresizesSubviews:YES];
        [_wkWebView.scrollView setAlwaysBounceVertical:YES];
    }
    return _wkWebView;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.customNaviBar.height, dtScreenWidth, 1)];
        _progressView.trackTintColor = [UIColor clearColor];
        [_progressView setProgress:0.05 animated:YES];
    }
    return _progressView;
}

@end
