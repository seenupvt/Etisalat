
//
//  OtpVC.m
//  Islamic
//
//  Created by webappsApp on 03/11/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import "OtpVC.h"
#import "RegisterVC.h"
#import "LogInVC.h"
#define ACCEPTABLE_CHARECTERSMOB @"0123456789+"
#import "MBProgressHUD.h"

@interface OtpVC ()
{
    NSString *errorMessage;
    NSString *urlstrng;
    int hittingCount;
}
@end

@implementation OtpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    hittingCount=0;
    self.chancesLbl.hidden=YES;
    
    // Do any additional setup after loading the view.
}
- (IBAction)confirmClick:(id)sender {
    NSString *otp=self.otpTxtFld.text;
    [self.otpTxtFld resignFirstResponder];
    
    if (otp.length==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter OTP value" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else{
    NSString *OTP=[[NSUserDefaults standardUserDefaults] objectForKey:@"OTPNumber"];    
    if ([OTP isEqualToString:otp]) {
        
        [self backToLogin];
        
//    urlstrng=[NSString stringWithFormat:@"%@",self.regLink];
//    urlstrng = [urlstrng stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url=[NSURL URLWithString:urlstrng];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setTimeoutInterval:18000];
//    // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"Loading";
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        // NSLog(@"Data is: %@",data);
//        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
//        hud = nil;
//        if (connectionError==nil) {
//            
//            NSString* newStr1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"string from Api: %@",newStr1);
//            NSDictionary *jsonData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            NSArray *dataArray =[jsonData objectForKey:@"register"];
//            if (dataArray.count > 0) {
//                NSDictionary *finalDict = [dataArray objectAtIndex:0];
//                
//                NSLog(@"%@",[finalDict objectForKey:@"status"]);
//                if ([[finalDict objectForKey:@"status"] isEqualToString:@"Registration Success"]) {
//                    // we neeed to aad success link to navigate
//                    
//                    [self backToLogin];
//                }
//                else if ([[finalDict objectForKey:@"status"] isEqualToString:@"Request for registration is already done"]) {
//                    // we neeed to aad success link to navigate
//                    
//                    errorMessage=[NSString stringWithFormat:@"Number Is Already Registered, Please use other number to access the application..!!!"];
//                    [self errorAlert];
//                    [self backToLogin];
//                    
//                    
//                }
//                else {
//                    errorMessage=[NSString stringWithFormat:@"%@ \n Please try again..!!!",[finalDict objectForKey:@"status"]];
//                    // we neeed to aad success link to navigate
//                    [self errorAlert];
//                    [self backToLogin];
//                }
//                
//            }
//            
//        }
//        else {
//            
//            errorMessage=[NSString stringWithFormat:@"Server Connection Error..!!!"];
//            [self errorAlert];
//            [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
//            hud = nil;
//        }
//    }];
    }
    else{
        errorMessage=[NSString stringWithFormat:@"Please check Correct OTP value..!!!"];
        [self errorAlert];
        
    }
}
}

- (IBAction)resendOtpClick:(id)sender {
    if (hittingCount<3) {
    NSString *OTP=[[NSUserDefaults standardUserDefaults] objectForKey:@"OTPNumber"];
    NSString *urlString = [NSString stringWithFormat:@"http://59.163.89.111:8050/smsbroker/alertsms.php?user=wifijava&pass=javawifi&to=93%@&from=ISLAMIC&msg=Dear customer,OTP:%@ to complete your ISLAMIC APP registration.&msgopt=0&priority=1",self.mobNo,OTP];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //[self showWaitingIndicator];
    [request setTimeoutInterval:1000];
    // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%@",data);
        if (connectionError==nil) {
            NSString* newStr1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",newStr1);
            if([newStr1 isEqualToString:@"\nMessage Submitted."]){
                
               errorMessage=@"OTP sent successfully";
                [self errorAlert];
                
            }
            else{
                errorMessage=newStr1;
                [self errorAlert];
            }
        }
        else{
            
            errorMessage=@"Try Again....!";
            [self errorAlert];
        }
    }];
}
    else{
        errorMessage=@"Please try again some time...!";
        [self errorAlert];
        [self backToReg];
        
        
    }
    hittingCount++;
    NSString *str=[NSString stringWithFormat:@"U have : %d attempts more",3-hittingCount];
    self.chancesLbl.hidden=NO;
    self.chancesLbl.text=str;
    
}

- (IBAction)backClick:(id)sender {
    [self backToReg];
    
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
-(void)backToReg{
    __block RegisterVC *objVC;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[RegisterVC class]]) {
            objVC=(RegisterVC *)obj;
        }
    }];
    [self.navigationController popToViewController:objVC animated:YES];
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
    
    if (textField.tag==301) {                //mobile number text field
        if([string length]>0)
        {
            if([textField.text length]<6){
                NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERSMOB] invertedSet];
                
                NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                
                return [string isEqualToString:filtered];
            }
            
            return  NO;
        }
    }
    
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.otpTxtFld.text=nil;
        
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
