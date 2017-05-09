//
//  NamazTimingVC.h
//  Islamic
//
//  Created by webappsApp on 20/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NamazTimingVC : UIViewController


@property (nonatomic,strong) NSString *selectedStrng;
@property(nonatomic,strong) NSString *URL;

@property (weak, nonatomic) IBOutlet UIWebView *timeWeb;


@end
