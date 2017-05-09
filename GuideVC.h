//
//  GuideVC.h
//  Islamic
//
//  Created by webappsApp on 24/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideVC : UIViewController
@property (nonatomic,strong) NSString *selectedStrng;
@property(nonatomic,strong) NSString *URL;
@property (weak, nonatomic) IBOutlet UISegmentedControl *guideSegment;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIWebView *guideWeb;


@end
