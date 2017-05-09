//
//  RulesVC.h
//  Islamic
//
//  Created by webappsApp on 20/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RulesVC : UIViewController
@property (nonatomic,strong) NSString *selectedStrng;
@property(nonatomic,strong) NSString *URL;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ruleSegment;

@property (weak, nonatomic) IBOutlet UITextView *textVw;
@property (weak, nonatomic) IBOutlet UIWebView *ruleHtml;

@end
