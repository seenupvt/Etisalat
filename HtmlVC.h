//
//  HtmlVC.h
//  Islamic
//
//  Created by webappsApp on 23/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HtmlVC : UIViewController
@property (nonatomic,strong) NSString *selectedStrng;
@property(nonatomic,strong) NSString *URL;

@property (weak, nonatomic) IBOutlet UITextView *htmlText;
@property (weak, nonatomic) IBOutlet UIWebView *htmlWeb;

@end
