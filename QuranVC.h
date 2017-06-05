//
//  QuranVC.h
//  Islamic
//
//  Created by webappsApp on 20/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuranVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *songsArray;
    NSMutableString *selectedIndex;
    
}


@property (nonatomic,strong) NSString *selectedStrng;
@property(nonatomic,strong) NSString *URL;
@property (weak, nonatomic) IBOutlet UITableView *qurasTbl;

@end
