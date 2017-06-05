//
//  MeccaLiveVC.h
//  Etisalat
//
//  Created by webappsApp on 26/05/17.
//  Copyright © 2017 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface MeccaLiveVC : UIViewController<YTPlayerViewDelegate>
@property (weak, nonatomic) IBOutlet YTPlayerView *youtubeVideo;
@property(nonatomic,strong) NSString *URL;
@property (nonatomic,strong) NSString *selectedStrng;

@end
