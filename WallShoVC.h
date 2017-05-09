//
//  WallShoVC.h
//  Islamic
//
//  Created by webappsApp on 24/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallShoVC : UIViewController{
    int indexToShow;
    NSMutableArray *imgArray;
}

@property(strong,nonatomic) NSString *selectedStrng;
@property (weak, nonatomic) IBOutlet UIImageView *wallShowImage;
@property(nonatomic,strong) NSArray *wallArrays;


@end
