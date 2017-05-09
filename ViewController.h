//
//  ViewController.h
//  Islamic
//
//  Created by webappsApp on 20/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <MediaPlayer/MediaPlayer.h>

static NSString *const menuCellIdentifier = @"rotationCell";
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
   
    NSMutableString *selectedIndex;
    NSMutableArray *categoryArray;
}

@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayer;
@property(nonatomic,strong) NSString *URL;

@end

