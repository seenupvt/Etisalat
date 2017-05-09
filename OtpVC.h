//
//  OtpVC.h
//  Islamic
//
//  Created by webappsApp on 03/11/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtpVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *otpTxtFld;
@property(nonatomic,strong) NSString *URL;
@property(nonatomic,strong) NSString *regLink;
@property(nonatomic,strong) NSString *otpValue;
@property(nonatomic,strong) NSString *mobNo;
@property (weak, nonatomic) IBOutlet UILabel *chancesLbl;


@end
