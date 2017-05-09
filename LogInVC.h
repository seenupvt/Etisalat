//
//  LogInVC.h
//  Islamic
//
//  Created by webappsApp on 20/10/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInVC : UIViewController{
    NSString *URL;
}

@property (weak, nonatomic) IBOutlet UITextField *mobTxtFld;

@property (weak, nonatomic) IBOutlet UITextField *pswTxtFld;
@end
