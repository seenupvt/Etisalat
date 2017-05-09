//
//  HtmlVC.m
//  Islamic
//
//  Created by webappsApp on 23/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import "HtmlVC.h"

@interface HtmlVC (){
       NSString *httpPageURL;
    NSURL *url;
}


@end

@implementation HtmlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title =self.selectedStrng;
    
    UIGraphicsBeginImageContext(self.view.frame.size);    
    [[UIImage imageNamed:@"bg2.jpg"] drawInRect:self.view.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    UIButton *rtbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rtbtn setFrame:CGRectMake(self.view.frame.size.width-50, 0.0f, 40.0f,40.0f)];
    //[rtbtn addTarget:self action:@selector(presentMenuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [rtbtn setImage:[UIImage imageNamed:@"logo_128px.jpg"] forState:UIControlStateNormal];
    UIBarButtonItem *eng_rtbtn = [[UIBarButtonItem alloc] initWithCustomView:rtbtn];
    self.navigationItem.rightBarButtonItem = eng_rtbtn;    
    
    if ([self.selectedStrng isEqualToString:@"Islamic Advice"]) {
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"IslamicAdvice" ofType:@"htm"]isDirectory:NO];
               [self.htmlWeb loadRequest:[NSURLRequest requestWithURL:url]];
    }
    if ([self.selectedStrng isEqualToString:@"Women In Islamic"]) {
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"WomenInIslam" ofType:@"htm"]isDirectory:NO];
        [self.htmlWeb loadRequest:[NSURLRequest requestWithURL:url]];
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
