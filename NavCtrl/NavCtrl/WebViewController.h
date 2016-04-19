//
//  WebViewController.h
//  NavCtrl
//
//  Created by Clyfford Millet on 4/18/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString * url;
@property(strong,nonatomic) WKWebView *webView;

@end
