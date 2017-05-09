//
//  CustomCell.h
//  Islamic
//
//  Created by webappsApp on 23/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *songnameLbl;
@property (weak, nonatomic) IBOutlet UIButton *play;

@property (weak, nonatomic) IBOutlet UILabel *quranLbl;
@property (weak, nonatomic) IBOutlet UILabel *duaLbl;
@property (weak, nonatomic) IBOutlet UIButton *duaPlay;

@property (weak, nonatomic) IBOutlet UILabel *alertLbl;

@end
