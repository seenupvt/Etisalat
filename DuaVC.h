//
//  DuaVC.h
//  Islamic
//
//  Created by webappsApp on 20/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface DuaVC : UIViewController<AVAudioPlayerDelegate>
{
    NSMutableArray *songsArray,*textArray;
    NSMutableString *selectedIndex;
    
}

@property (nonatomic,strong) NSString *selectedStrng;
@property(nonatomic,strong) NSString *URL;
@property(nonatomic,strong) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UISegmentedControl *duaSegment;




@end
