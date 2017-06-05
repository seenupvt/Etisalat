//
//  RegisterVC.h
//  Islamic
//
//  Created by webappsApp on 17/08/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterVC : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    
      
    
}

@property (weak, nonatomic) IBOutlet UITextField *uNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *mobTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *genderTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *ageTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *cityTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *pswTxtFld;
@property(nonatomic,strong) NSString *URL;



@end
