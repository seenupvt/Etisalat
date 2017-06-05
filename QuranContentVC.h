//
//  QuranContentVC.h
//  Islamic
//
//  Created by webappsApp on 23/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface QuranContentVC : UIViewController<AVAudioPlayerDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableString *selectedIndex;
    int indexToShow;
    NSArray *textArray;
    
}
@property (nonatomic,strong) NSString *selectedStrng;
@property(nonatomic,strong) NSString *URL;
@property (weak, nonatomic) IBOutlet UILabel *contentNameLbl;
@property(nonatomic,strong) AVAudioPlayer *player;
@property(nonatomic,strong) NSArray *listSongsArray;
@property(nonatomic) int selectedValue;
@property BOOL scrubbing;
- (void)refreshSongData;
@property (weak, nonatomic) IBOutlet UIImageView *quranQsImageVw;
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *prvBtn;
@property (weak, nonatomic) IBOutlet UIButton *nxtBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UITableView *textTable;


@end
