//
//  RegisterVC.m
//  Islamic
//
//  Created by webappsApp on 17/08/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import "RegisterVC.h"
#define ACCEPTABLE_CHARECTERSMOB @"0123456789+"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import "LogInVC.h"
#import "OtpVC.h"


@interface RegisterVC (){
NSString *errorMessage;
NSString *reglink;
NSString *OTPstring;
}

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // for splash screen animation
   // [self addPickerView];
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    
}

-(void)addPickerView{
    pickerArray = [[NSArray alloc] initWithObjects:@"MALE",@"FEMALE", nil];
    myTextField = [[UITextField alloc]initWithFrame:
                   CGRectMake(10, 50, 300, 30)];
    myTextField.borderStyle = UITextBorderStyleRoundedRect;
    myTextField.textAlignment = UITextAlignmentCenter;
    myTextField.delegate = self;
    [self.view addSubview:myTextField];
    [myTextField setPlaceholder:@"Select a Subject"];
    myPickerView = [[UIPickerView alloc]init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0,self.view.frame.size.height-myPickerView.frame.size.height-50, 320, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects: 
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    myTextField.inputView = myPickerView;
    myTextField.inputAccessoryView = toolBar;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        //[self dateChanged:nil];
    }
}
#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    [myTextField setText:[pickerArray objectAtIndex:row]];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

- (IBAction)regClick:(id)sender {
    NSString *uName=self.uNameTxtFld.text;
    NSString *mob=self.mobTxtFld.text;
    NSString *gender=self.genderTxtFld.text;
    NSString *age=self.ageTxtFld.text;
    NSString *city=self.cityTxtFld.text;
    NSString *psw=self.pswTxtFld.text;
    [self.uNameTxtFld resignFirstResponder];
    [self.mobTxtFld resignFirstResponder];
    [self.genderTxtFld resignFirstResponder];
    [self.ageTxtFld resignFirstResponder];
    [self.cityTxtFld resignFirstResponder];
    [self.pswTxtFld resignFirstResponder];
    
    if (mob.length==0 || uName.length==0 || gender.length==0 || age.length==0 || city.length==0 || psw.length==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"mobileNumber/username/password/gender/city/age cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (mob.length!=9) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"mobileNumber must be 9-digit" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else{
        NSURL *scriptUrl = [NSURL URLWithString:@"http://www.apple.com/in/"];
        NSData *testdata = [NSData dataWithContentsOfURL:scriptUrl];
        if (testdata){
            //NSLog(@"Device is connected to the internet");
            
            reglink=[NSString stringWithFormat:@"%@/register.jsp?Name=%@&MobileNo=%@&City=%@&Gender=%@&Age=%@&Pwd=%@&reqthrough=iOS",self.URL,uName,mob,city,gender,age,psw];
            
            [self backToLogin];
            
//            int OTP = arc4random_uniform(900000) + 100000; //Generates Number lenghth is 6
//            NSLog(@"%d",OTP);
//            OTPstring = [NSMutableString stringWithFormat:@"%i",OTP];
//            [[NSUserDefaults standardUserDefaults] setObject:OTPstring forKey:@"OTPNumber"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            NSString *urlString = [NSString stringWithFormat:@"http://59.163.89.111:8050/smsbroker/alertsms.php?user=wifijava&pass=javawifi&to=93%@&from=ISLAMIC&msg=Dear customer,OTP:%@ to complete your ISLAMIC APP registration.&msgopt=0&priority=1",mob,OTPstring];
//            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSURL *url = [NSURL URLWithString:urlString];
//            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//            //[self showWaitingIndicator];
//            [request setTimeoutInterval:1000];
//            // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                NSLog(@"%@",data);
//                if (connectionError==nil) {
//                    NSString* newStr1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                    NSLog(@"%@",newStr1);
//                    if([newStr1 isEqualToString:@"\nMessage Submitted."]){
//                    
//                    OtpVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"OtpVC"];
//                    obj.regLink = reglink;
//                    obj.URL=self.URL;
//                    obj.otpValue=OTPstring;
//                    obj.mobNo=mob;
//                    [self.navigationController pushViewController:obj animated:YES];
//                        
//                    }
//                    else{
//                        errorMessage=newStr1;
//                        [self errorAlert];
//                    }
//                }
//                else{
//                    
//                    errorMessage=@"Try Again....!";
//                    [self errorAlert];
//                }
//            }];
//            
            
            
        }
        else{
            NSLog(@"Device is not connected to the internet");
            
            errorMessage=[NSString stringWithFormat:@"Device is not connected to the internet..!!!"];
            [self errorAlert];
        }
    }
    
//    else{
//        errorMessage=[NSString stringWithFormat:@"Please enter a valid mobile number\n It must be start with (70) or (71)..!!!"];
//        [self errorAlert];
//        
//    }
}


-(void)errorAlert{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Islamic" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField.tag==101){                //user textfield
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"^[a-z0-9-_\\.@]*$"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:nil];
        NSArray* matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        if ([matches count] == 0) {
            return NO;
        }
        return YES;
    }
    if (textField.tag==102) {                //mobile number text field
        if([string length]>0)
        {
            if([textField.text length]<9){
                NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERSMOB] invertedSet];
                
                NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                
                return [string isEqualToString:filtered];
            }
            
            return  NO;
        }
    }
    if(textField.tag==103){             //mail id text field
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"^[a-z0-9-_\\.@]*$"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:nil];
        NSArray* matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        if ([matches count] == 0) {
            return NO;
        }
        return YES;
    }
    if(textField.tag==104){         // city text field
        if([string length]>0)
        {
            if([textField.text length]<2){
                NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERSMOB] invertedSet];
                
                NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                
                return [string isEqualToString:filtered];
            }
            
            return  NO;
        }
    }
    if(textField.tag==105){          // music genre text field
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"^[a-z0-9-_\\.]*$"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:nil];
        NSArray* matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        if ([matches count] == 0) {
            return NO;
        }
        return YES;
    }
    if(textField.tag==106){          // music genre text field
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"^[a-z0-9-_\\.]*$"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:nil];
        NSArray* matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        if ([matches count] == 0) {
            return NO;
        }
        return YES;
    }
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.mobTxtFld.text=nil;
    self.uNameTxtFld.text=nil;
    self.genderTxtFld.text=nil;
    self.ageTxtFld.text=nil;
    self.cityTxtFld.text=nil;
    self.pswTxtFld.text=nil;
    
}

- (IBAction)backClick:(id)sender {
    [self backToLogin];
    
    
}
-(void)backToLogin{
    __block LogInVC *objVC;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[LogInVC class]]) {
            objVC=(LogInVC *)obj;
        }
    }];
    [self.navigationController popToViewController:objVC animated:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
