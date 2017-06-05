//
//  PearlPrayVC.h
//  Etisalat
//
//  Created by webappsApp on 19/05/17.
//  Copyright © 2017 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PearlPrayVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *songsArray;
    NSMutableString *selectedIndex;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableVw;
@property (weak, nonatomic) IBOutlet UITextView *txtVw;
@property (nonatomic,strong) NSString *selectedStrng;
@property(nonatomic,strong) NSString *URL;
@end
