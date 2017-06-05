//
//  LogInVC.m
//  Islamic
//
//  Created by webappsApp on 20/10/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import "LogInVC.h"
#import "RegisterVC.h"
#define ACCEPTABLE_CHARECTERSMOB @"0123456789+"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import "EASplashScreen.h"
#import "ForgotVC.h"

@interface LogInVC ()<EASplashScreenDelegate>{
    NSString *errorMessage;
}


@end

@implementation LogInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    URL=@"http://59.163.89.107:8023/islamicMobileApp";
    // Do any additional setup after loading the view.
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"FirstLogin"]) {
        [self splashAttach];
        ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerVC"];
        obj.URL=URL;
        [self.navigationController pushViewController:obj animated:NO];
        
    }
    [self splashAttach];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    URL=@"http://59.163.89.107:8023/islamicMobileApp";
}

-(void)splashAttach{
    EASplashScreen *splashScreen = [[EASplashScreen alloc] initWithSplashScreenImage:[UIImage imageNamed:@"splash1.jpg"] amountOfSlides:10];
    splashScreen.delegate = self;
    splashScreen.view.frame = self.view.bounds;
    [self.view addSubview:splashScreen.view];
    
    
    [UIView animateWithDuration: 0.2
                          delay: 2.5
                        options: UIViewAnimationTransitionCurlDown
                     animations: ^{splashScreen.view.alpha = 0.0;
                     }
                     completion: ^ (BOOL finished) {
                         [splashScreen.view removeFromSuperview];
                         
                         
                         NSLog(@"end splash");
                     }
     ];
    
}

-(void)hideSplash:(id)object
{
    UIImageView *animatedImageview = (UIImageView *)object;
    [animatedImageview removeFromSuperview];
}



- (IBAction)logInClick:(id)sender {
    NSString *mobNo=self.mobTxtFld.text;
    NSString *psw=self.pswTxtFld.text;
    
    [self.mobTxtFld resignFirstResponder];
    [self.pswTxtFld resignFirstResponder];
    
    if (mobNo.length==0 || psw.length==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"mobileNumber/password cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if (mobNo.length>10) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Enter Proper mobileNumber" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else {
        NSURL *scriptUrl = [NSURL URLWithString:@"http://www.apple.com/in/"];
        NSData *testdata = [NSData dataWithContentsOfURL:scriptUrl];
        if (testdata){
            mobNo=@"705093133";
            // for all users allowing to inside
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:mobNo forKey:@"MobNumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerVC"];
            obj.URL=URL;
            [self.navigationController pushViewController:obj animated:YES];
            
                       
            //https://myapplication-18895.firebaseio.com/
//            //NSLog(@"Device is connected to the internet");
//            NSString *urlstrng=[NSString stringWithFormat:@"%@/Login.jsp?MobileNo=%@&Pwd=%@",URL,mobNo,psw];
//            
//            //            [[NSUserDefaults standardUserDefaults] setObject:urlink forKey:@"UrlLink"];
//            //            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            
//            urlstrng = [urlstrng stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSURL *url=[NSURL URLWithString:urlstrng];
//            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//            [request setTimeoutInterval:18000];
//            // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//            __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.labelText = @"Loading";
//            
//            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                
//                // NSLog(@"Data is: %@",data);
//                [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
//                hud = nil;
//                if (connectionError==nil) {
//                    
//                    NSString* newStr1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                    NSLog(@"string from Api: %@",newStr1);
//                    NSDictionary *jsonData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                    NSArray *dataArray =[jsonData objectForKey:@"login"];
//                    if (dataArray.count > 0) {
//                        NSDictionary *finalDict = [dataArray objectAtIndex:0];
//                        
//                        NSLog(@"%@",[finalDict objectForKey:@"status"]);
//                        if ([[finalDict objectForKey:@"status"] isEqualToString:@"login successfully"]) {
//                            // we neeed to aad success link to navigate
//                            
//                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLogin"];
//                            [[NSUserDefaults standardUserDefaults] synchronize];
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:mobNo forKey:@"MobNumber"];
//                            [[NSUserDefaults standardUserDefaults] synchronize];
//                            
//                            ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerVC"];
//                            obj.URL=URL;
//                            [self.navigationController pushViewController:obj animated:YES];
//                            
//                        }
//                        else if ([[finalDict objectForKey:@"status"] isEqualToString:[finalDict objectForKey:@"status"]]) {
//                            // we neeed to aad success link to navigate
//                            
//                            errorMessage=[NSString stringWithFormat:@"%@",[finalDict objectForKey:@"status"]];
//                            [self errorAlert];
//                            
//                            
//                        }
//                        else {
//                            errorMessage=[NSString stringWithFormat:@"%@ \n Please try again..!!!",[finalDict objectForKey:@"status"]];
//                            // we neeed to aad success link to navigate
//                            [self errorAlert];
//                            
//                        }
//                        
//                    }
//                    
//                }
//                else {
//                    
//                    errorMessage=[NSString stringWithFormat:@"Server Connection Error..!!!"];
//                    [self errorAlert];
//                    [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
//                    hud = nil;
//                }
//            }];
        }
        else{
            NSLog(@"Device is not connected to the internet");
            
            errorMessage=[NSString stringWithFormat:@"Device is not connected to the internet..!!!"];
            [self errorAlert];
        }
    }    
    
    
}
- (IBAction)regNowClick:(id)sender {
    RegisterVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
    obj.URL=URL;
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (IBAction)getPswClick:(id)sender {
    ForgotVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotVC"];
    obj.URL=URL;
    [self.navigationController pushViewController:obj animated:YES];
    
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
    
    
    if (textField.tag==201) {                //mobile number text field
        if([string length]>0)
        {
            if([textField.text length]<10){
                NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERSMOB] invertedSet];
                
                NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                
                return [string isEqualToString:filtered];
            }
            
            return  NO;
        }
    }
    if(textField.tag==202){             //mail id text field
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
    
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.mobTxtFld.text=nil;
    self.pswTxtFld.text=nil;
    
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
