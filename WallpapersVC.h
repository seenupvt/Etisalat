//
//  WallpapersVC.h
//  Islamic
//
//  Created by webappsApp on 20/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallpapersVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray  *sections;
    NSMutableArray *WallArray;
}

@property(nonatomic,strong) NSString *selectedStrng;
@property(nonatomic,strong) NSString *URL;

@property (weak, nonatomic) IBOutlet UITableView *wallTbl;
@property (nonatomic, retain) NSMutableArray *sections;
-(IBAction)buttonPressed:(id)sender;

@end
