
//
//  ViewController.m
//  Islamic
//
//  Created by webappsApp on 20/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import "ViewController.h"
#import "NamazTimingVC.h"
#import "QuranVC.h"
#import "NabawiVC.h"
#import "DuaVC.h"
#import "WallpapersVC.h"
#import "RulesVC.h"
#import "HtmlVC.h"
#import "GuideVC.h"
#import "CompassVC.h"
#import "RegisterVC.h"
#import "MBProgressHUD.h"
#import "DataUtility.h"
#import "LogInVC.h"


#import "ContextMenuCell.h"
#import "YALContextMenuTableView.h"
#import "YALNavigationBar.h"
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define TRUE 0



@interface ViewController ()<YALContextMenuTableViewDelegate,NSURLConnectionDelegate>{
    NSString *urlString;
    NSString *quranStatus,*hadithStatus,*meccaStatus,*duaStatus,*wallpapersStatus,*quiblaStatus,*timingStatus;
    NSString *selectedCategory,*selectedPackage;
    NSString *errorMessage;
    int i;
    
}
@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;
@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self initiateMenuOptions];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    
        // set custom navigationBar with a bigger height
        [self.navigationController setValue:[[YALNavigationBar alloc]init] forKeyPath:@"navigationBar"];
        [self.navigationController setNavigationBarHidden:NO];
        self.navigationItem.hidesBackButton = YES;
      NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"AmericanTypewriter" size:20.0],NSFontAttributeName,[UIColor whiteColor],UITextAttributeTextColor, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = size;
        self.navigationItem.title=@"ISLAMIC";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:15.0/255.0 green:108.0/255.0 blue:51.0/255.0 alpha:1];
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
        UIButton *lftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lftbtn setFrame:CGRectMake(0.0f, 0.0f, 40.0f,40.0f)];
        [lftbtn setImage:[UIImage imageNamed:@"logo_128px.jpg"] forState:UIControlStateNormal];
        UIBarButtonItem *eng_lftbtn = [[UIBarButtonItem alloc] initWithCustomView:lftbtn];
        self.navigationItem.leftBarButtonItem = eng_lftbtn;
    
    UIButton *rtbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rtbtn setFrame:CGRectMake(self.view.frame.size.width-50, 0.0f, 40.0f,40.0f)];
   [rtbtn addTarget:self action:@selector(presentMenuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [rtbtn setImage:[UIImage imageNamed:@"menu-button@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *eng_rtbtn = [[UIBarButtonItem alloc] initWithCustomView:rtbtn];
    self.navigationItem.rightBarButtonItem = eng_rtbtn;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg2.jpg"] drawInRect:self.view.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
       
}

-(void)viewWillAppear:(BOOL)animated{
    //[self nextTime];
    [self categoryvalidate];
}

-(void)categoryvalidate{
    
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.apple.com/in/"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data){
    
            NSString *mobNo=[[NSUserDefaults standardUserDefaults] objectForKey:@"MobNumber"];
          // NSString *urlString = [NSString stringWithFormat:@"http://www.json-generator.com/api/json/get/cdZEoICqXm?indent=2"];
            NSString *urlString = [NSString stringWithFormat:@"%@/checkcharging.jsp?mobileno=%@",self.URL,mobNo];
    
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setTimeoutInterval:18000];
            // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            //[self.view addSubview: activity];
        
        
      // [{"category":"quaranQS","chargestatus":"0"},{"category":"Hadith","chargestatus":"0"},{"category":"Dua","chargestatus":"0"},{"category":"LiveMecca","chargestatus":"0"},{"category":"Qibla","chargestatus":"2"},{"category":"Wallpaper","chargestatus":"1"}]
        
            categoryArray= [[NSMutableArray alloc]init];
    
    
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                NSLog(@"%@",data);
                if (connectionError==nil) {
                    NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                    NSLog(@"string from Api:%@end",str);
                    if ([str isEqualToString:@"Requested Mobile Number is NOT Subscriber"]) {
                        NSLog(@"Mobile number is Not registered");
                    }
                    else{
                    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
                    NSMutableArray *jsonarray=[NSJSONSerialization JSONObjectWithData:jsonData options:
                                               NSJSONReadingMutableContainers error:nil];
                    
                    [jsonarray enumerateObjectsUsingBlock:^(NSDictionary *objDictionary1, NSUInteger idx, BOOL *stop) {
                        DataUtility *objSongsData = [[DataUtility alloc]init];
                        objSongsData.category = [objDictionary1 objectForKey:@"category"];
                        objSongsData.chargestatus = [objDictionary1 objectForKey:@"chargestatus"];
                        
                        [categoryArray addObject:objSongsData];
                        
                        
                    }];
                    NSLog(@"Array: %@",categoryArray);
                    if(categoryArray.count > 0){
                   DataUtility *objSongData = [categoryArray objectAtIndex:0];
                    quranStatus=[NSString stringWithFormat:@"%@",objSongData.chargestatus];
                    
                    objSongData = [categoryArray objectAtIndex:1];
                    hadithStatus=[NSString stringWithFormat:@"%@",objSongData.chargestatus];
                    
                    objSongData = [categoryArray objectAtIndex:2];
                    duaStatus=[NSString stringWithFormat:@"%@",objSongData.chargestatus];
                    
                    objSongData = [categoryArray objectAtIndex:3];
                    meccaStatus=[NSString stringWithFormat:@"%@",objSongData.chargestatus];
                    
                    objSongData = [categoryArray objectAtIndex:4];
                    quiblaStatus=[NSString stringWithFormat:@"%@",objSongData.chargestatus];
                    
                    objSongData = [categoryArray objectAtIndex:5];
                    wallpapersStatus=[NSString stringWithFormat:@"%@",objSongData.chargestatus];
                    
                    objSongData = [categoryArray objectAtIndex:6];
                    timingStatus=[NSString stringWithFormat:@"%@",objSongData.chargestatus];
                    NSLog(@"Next Time %@",timingStatus);
                    self.lblTime.text = timingStatus;
                    
                        NSLog(@"quranStatus: %@ \n hadithStatus: %@ \n  duaStatus: %@ \n meccaStatus: %@  \n quiblaStatus: %@ \n wallpapersStatus: %@ \n timingStatus: %@",quranStatus,hadithStatus,duaStatus,meccaStatus,quiblaStatus,wallpapersStatus,timingStatus);
                }
               
                    }
                }
            }];
            
    
    }
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //should be called after rotation animation completed
    [self.contextMenuTableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.contextMenuTableView updateAlongsideRotation];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
    
}

#pragma mark - IBAction

- (void)presentMenuButtonTapped{
    // init YALContextMenuTableView tableView
    if (!self.contextMenuTableView) {
        self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
        self.contextMenuTableView.animationDuration = 0.15;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuTableView.yalDelegate = self;
        
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
    }
    
    // it is better to use this method only for proper animation
    [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
}

#pragma mark - Local methods

- (void)initiateMenuOptions {
    self.menuTitles = @[@"",
                        @"Dua",
                        @"Hajj guides",
                        @"Islamic Advices",
                        @"Wallpapers",
                        @"Women in Islam",
                        @"LogOut",
                        @"UnSubscribe"];
    
    self.menuIcons = @[[UIImage imageNamed:@"Icnclose"],
                       [UIImage imageNamed:@"Dua"],
                       [UIImage imageNamed:@"Guide"],
                       [UIImage imageNamed:@"Advice"],
                       [UIImage imageNamed:@"Wallpapers"],
                       [UIImage imageNamed:@"Women"],
                       [UIImage imageNamed:@"Logouticon"],
                       [UIImage imageNamed:@"Unsubscribe"]];
}


#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Menu dismissed with indexpath = %@", indexPath);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView dismisWithIndexPath:indexPath];
    
    NSLog(@"Selected:%ld",indexPath.row);
    selectedIndex=[NSMutableString stringWithFormat:@"%ld",indexPath.row];
    [self navigationActions];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(YALContextMenuTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myzonebg.png"]];
        cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
        cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
    }
    
    return cell;
}


-(void)navigationActions{
    
    if ([selectedIndex isEqualToString:@"1"]) {
        
        
        [self duaOver];
//        if ([duaStatus isEqualToString:@"0"]) {
//             [self duaOver];
//        }
//        else if ([duaStatus isEqualToString:@"1"]) {
//            selectedCategory=@"Dua";
//            
//            [self alertCreate];
//            
//        }
//        else if([duaStatus isEqualToString:@"2"]){
//            [self queAlertCreate];
//            
//        }
//        else {
//            [self failAlertCreate];
//            
//        }
        
        
    }
    if ([selectedIndex isEqualToString:@"2"]) {
        [self guideOver];
        
        
    }
    if ([selectedIndex isEqualToString:@"3"]) {
        [self adviceOver];
        
    }
    if ([selectedIndex isEqualToString:@"4"]) {
        
        [self wallpapersOver];
        
//        if ([wallpapersStatus isEqualToString:@"0"]) {
//            [self wallpapersOver];
//        }
//        else if ([wallpapersStatus isEqualToString:@"1"]) {
//            selectedCategory=@"Wallpaper";
//            
//            [self alertCreate];
//        }
//        else if([wallpapersStatus isEqualToString:@"2"]){
//            [self queAlertCreate];
//            
//            
//        }
//        else {
//            [self failAlertCreate];
//            
//        }
        
    }
    if ([selectedIndex isEqualToString:@"5"]) {
        [self womenInISOver];
        
    }
    if ([selectedIndex isEqualToString:@"6"]) {
        [self unsubsciption];
        
    }
    if ([selectedIndex isEqualToString:@"7"]) {
        
        [self unsubscribeClick];
        
    }
    
}
-(void)rulesOver{
    RulesVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"RulesVC"];
    obj.selectedStrng = @"Ramadan Rules";
    obj.URL=self.URL;
    [self.navigationController pushViewController:obj animated:YES];
        
}
-(void)compassOver{
    
    CompassVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"CompassVC"];
    obj.selectedStrng = @"Compass";
    obj.URL=self.URL;
    [self.navigationController pushViewController:obj animated:YES];
    
}
-(void)duaOver{
   
    DuaVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"DuaVC"];
    obj.selectedStrng = @"Dua";
    obj.URL=self.URL;
    [self.navigationController pushViewController:obj animated:YES];
    
}
-(void)guideOver{
    GuideVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"GuideVC"];
    obj.selectedStrng = @"Guide";
    obj.URL=self.URL;
    [self.navigationController pushViewController:obj animated:YES];
    
} 
-(void)womenInISOver{
        HtmlVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"HtmlVC"];
    obj.selectedStrng = @"Women In Islamic";
    obj.URL=self.URL;
    [self.navigationController pushViewController:obj animated:YES];
    
}
-(void)adviceOver{
    HtmlVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"HtmlVC"];
    obj.selectedStrng = @"Islamic Advice";
    obj.URL=self.URL;
    [self.navigationController pushViewController:obj animated:YES];
    
}
-(void)wallpapersOver{
    WallpapersVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"WallpapersVC"];
    obj.selectedStrng = @"Wallpapers";
    obj.URL=self.URL;
    [self.navigationController pushViewController:obj animated:YES];
    
}
-(void)unsubscribeClick{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Islamic" message:@"Really you want to delete the account from list" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm",nil];
    alert.tag=201;
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    
    
}
- (IBAction)namazTimingClick:(id)sender {
    NamazTimingVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"NamazTimingVC"];
    obj.selectedStrng = @"Namaaz Rules";
    obj.URL=self.URL;
    [self.navigationController pushViewController:obj animated:YES];
        
        
}
- (IBAction)quaranClick:(id)sender {
    
    [self duaOver];
    
//    if ([quranStatus isEqualToString:@"0"]) {
//         [self quranOver];
//    
//    }
//    else if([quranStatus isEqualToString:@"1"]){
//        
//        selectedCategory=@"quaranQS";
//        [self alertCreate];
//        
//    }
//    else if([quranStatus isEqualToString:@"2"]){
//        [self queAlertCreate];
//        
//    }
//    else {
//        [self failAlertCreate];
//        
//    }
    
    
}
-(void)quranOver{
    
    QuranVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"QuranVC"];
    obj.selectedStrng = @"Quran";
    obj.URL=self.URL;
    [self.navigationController pushViewController:obj animated:YES];
    
}
- (IBAction)nabawiClick:(id)sender {
    
       
    if ([hadithStatus isEqualToString:@"0"]) {
        [self nabaviOver];
        
    }
    else if([hadithStatus isEqualToString:@"1"]){
        selectedCategory=@"Hadith";
        [self alertCreate];
        
    }
    else if([hadithStatus isEqualToString:@"2"]){
        [self queAlertCreate];
       
        
    }
    else {
        [self failAlertCreate];
        
    }
    
        
}
-(void)nabaviOver{
    NabawiVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"NabawiVC"];
    obj.selectedStrng = @"Hadith";
    obj.URL=self.URL;
    [self.navigationController pushViewController:obj animated:YES];
    
}
- (IBAction)rulesClick:(id)sender {
    
    [self guideOver];
        
}
- (IBAction)quiblaClick:(id)sender {
    
    
    [self compassOver];
//    if ([quiblaStatus isEqualToString:@"0"]) {
//        [self compassOver];
//    }
//    else if([quiblaStatus isEqualToString:@"1"]){
//       
//        selectedCategory=@"Qibla";
//        
//        [self alertCreate];
//        
//    }
//    else if([quiblaStatus isEqualToString:@"2"]){
//        [self queAlertCreate];
//        
//    }
//    else {
//        [self failAlertCreate];
//        
//    }

    
}
- (IBAction)meccaClick:(id)sender {
    
    
    [self meccaVideoOver];
//    if ([meccaStatus isEqualToString:@"0"]) {
//        [self meccaVideoOver];
//        
//    }
//    else if ([meccaStatus isEqualToString:@"1"]) {
//        selectedCategory=@"LiveMecca";
//        [self alertCreate];
//        
//    }
//    else if([meccaStatus isEqualToString:@"2"]){
//        [self queAlertCreate];
//    }
//    else {
//        [self failAlertCreate];
//    }
    
       
}

-(void)meccaVideoOver{
    
    urlString=[NSString stringWithFormat:@"%@/Video/MakkahLive1-Segment1.mp4",self.URL];
    [self playVideo];
    
}
-(void)alertCreate{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Islamic" message:@"****Paid category****\n Please choose below package for access all paid categories..!!!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Day Subscription(2 AFN)",@"Week Subscription(10 AFN)",@"Month Subscription(30 AFN)",nil];
    alert.tag=301;
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    
}

-(void)queAlertCreate{
    errorMessage=[NSString stringWithFormat:@"Your request is under 'waiting process' due to low balance \n Please recharge your account,Service will be activate..!!!"];
    [self errorAlert];
    
}

-(void)failAlertCreate{
    errorMessage=[NSString stringWithFormat:@"The account is invalid or unknown for the requested operation..!!!"];
    [self errorAlert];
    
}
- (IBAction)serviceClick:(id)sender {
    //NSString *urlString=[NSString stringWithFormat:@"http://59.163.89.112/talkapis/securesms.php?campaignName=wifitest&languageType=english&groupName=RoshSec1&message=testing"];
    
     //http://203.174.27.21:6543/bulksmsmobapp/?campaignName=wifitest&languageType=english&groupName=RoshanSec&message=testing
    
    
    NSString *myRequestString = [[NSString alloc] initWithFormat:@"campaignName=wifitest&languageType=english&groupName=RoshanSec&message=testing"];
    
    NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://203.174.27.21:6543/bulksmsmobapp/?"];
    NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString:urlString]];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: myRequestData];
    NSURLResponse *response;
    NSError *err;
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:nil error:&err];
    NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
    NSLog(@"responseData: %@ \n return data: %@", content,returnData);
    
    NSString* responseString = [[NSString alloc] initWithData:returnData encoding:NSNonLossyASCIIStringEncoding];
    NSLog(@"responseData: %@", responseString);
    
    
        NSDictionary *jsonData =[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"Json data: %@",jsonData);
        
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Islamic" message:@"Post method" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        
    
        
}

- (IBAction)serviceGet:(id)sender {
    NSString *urlString=[NSString stringWithFormat:@"https://certificatechain.io/ "];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:30000];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    // Do any additional setup after loading the view.
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"Data is: %@",data);
        if (connectionError==nil){
            NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Islamic" message:@"Get method" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        }
    }];
}



-(void)playVideo{
    NSURL *url = [NSURL URLWithString:urlString];
    self.moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayer];
    [self.moviePlayer.moviePlayer play];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    self.moviePlayer.wantsFullScreenLayout=YES;
    self.moviePlayer.view.transform = CGAffineTransformIdentity;
    self.moviePlayer.view.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
   
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerViewController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
    if ([player  respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==201) {
        if (buttonIndex==1) {            
            
            [self UnSubscribeToReg];
        }
    }
    //days=daily,days=weekly,days=monthly.
    if (alertView.tag==301) {
        if (buttonIndex==1) {
            
            selectedPackage=@"daily";
            
            //[self chargingProcees];
            
            
        }
        else if (buttonIndex==2) {
            i=0;
            selectedPackage=@"weekly";
            
            //[self chargingProcees];
            
        }
        else if (buttonIndex==3) {
            selectedPackage=@"monthly";
            
          // [self chargingProcees];
            
        }
    }
    
}


-(void)chargingProcees{
    
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.apple.com/in/"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data){
        __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading data";
        NSLog(@"Wecome ue hittging once");
        
        NSString *mobNo=[[NSUserDefaults standardUserDefaults] objectForKey:@"MobNumber"];
        
        NSString *myRequestString = [[NSString alloc] initWithFormat:@"mobileno=%@&category=%@&days=%@&reqthrough=iOS",mobNo,selectedCategory,selectedPackage];
        
        NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
        NSString *urlString = [[NSString alloc] initWithFormat:@"%@/charging.jsp?",self.URL];
        NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString:urlString]];
        
        [request setHTTPMethod: @"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [request setHTTPBody: myRequestData];
        NSURLResponse *response;
        NSError *err;
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
        NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
        NSLog(@"responseData: %@ \n return data: %@", content,returnData);
        
        NSString* responseString = [[NSString alloc] initWithData:returnData encoding:NSNonLossyASCIIStringEncoding];
        NSLog(@"responseData: %@", responseString);
        if ([content isEqualToString:@"Requested Mobile Number is NOT Subscriber"]) {
            [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
            hud = nil;
            NSLog(@"Mobile number is Not registered");
        }
        else{
            [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
            hud = nil;
            NSDictionary *jsonData =[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"Json data: %@",jsonData);
            
            NSArray *dataArray =[jsonData objectForKey:@"charging"];
            if (dataArray.count > 0) {
                
                
                NSDictionary *finalDict = [dataArray objectAtIndex:0];
                
                NSLog(@"Charging status is: %@",[finalDict objectForKey:@"status"]);
                
                // Here writing code based on responce
                
                if ([[finalDict objectForKey:@"status"] isEqualToString:@"Charging Successful"]) {
                    NSLog(@"Ur activated category:%@ \n for %@",selectedCategory,selectedPackage);
                    
                    [self chargingSuccessNavigation];
                    
                }
                
                else {
                    errorMessage=[NSString stringWithFormat:@"%@",[finalDict objectForKey:@"status"]];
                    [self errorAlert];
                    [self categoryvalidate];
                    
                }
                
            }
            
            else {
                
                errorMessage=[NSString stringWithFormat:@"Server Connection Error..!!!"];
                [self errorAlert];
                
            }
            
        }
    }
    else{
        NSLog(@"Device is not connected to the internet");
        errorMessage=[NSString stringWithFormat:@"Device is not connected to the internet..!!!"];
        [self errorAlert];
    }
    
}

-(void)errorAlert{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Islamic" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

-(void)chargingSuccessNavigation{
    
    if([selectedCategory isEqualToString:@"quaranQS"]){
        [self quranOver];
    }
    else if ([selectedCategory isEqualToString:@"Hadith"]){
        [self nabaviOver];
        
    }
    else  if ([selectedCategory isEqualToString:@"LiveMecca"]){
        [self meccaVideoOver];
        
    }
    else  if ([selectedCategory isEqualToString:@"Dua"]){
        [self duaOver];
        
    }
    else  if ([selectedCategory isEqualToString:@"Wallpaper"]){
        [self wallpapersOver];
        
    }
    else  if ([selectedCategory isEqualToString:@"Qibla"]){
        [self compassOver];
        
    }
}

-(void)UnSubscribeToReg{
    
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.apple.com/in/"];
    NSData *testdata = [NSData dataWithContentsOfURL:scriptUrl];
    if (testdata){
        
        [self unsubsciption];
        
//        //NSLog(@"Device is connected to the internet");
//        NSString *mobNo=[[NSUserDefaults standardUserDefaults] objectForKey:@"MobNumber"];
//        NSString *urlstrng=[NSString stringWithFormat:@"%@/deregister.jsp?mobileno=%@",self.URL,mobNo];
//        urlstrng = [urlstrng stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *url=[NSURL URLWithString:urlstrng];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//        [request setTimeoutInterval:18000];
//        // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//        __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.labelText = @"Loading";
//        
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            
//            // NSLog(@"Data is: %@",data);
//            [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
//            hud = nil;
//            if (connectionError==nil) {
//                
//                NSString* newStr1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                 NSLog(@"string from Api: %@",newStr1);
//                NSDictionary *jsonData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                NSArray *dataArray =[jsonData objectForKey:@"deregister"];
//                if (dataArray.count >0 ) {
//                   
//                NSDictionary *finalDict = [dataArray objectAtIndex:0];
//                
//                NSLog(@"%@",[finalDict objectForKey:@"status"]);
//                
//               if ([[finalDict objectForKey:@"status"] isEqualToString:@"DeRegistration Success"] ||[[finalDict objectForKey:@"status"] isEqualToString:@"Requested for DeRegistration is already done"] || [[finalDict objectForKey:@"status"] isEqualToString:@"Requested Mobile Number is NOT Subscriber"] || [[finalDict objectForKey:@"status"] isEqualToString:@"Mobile Number Format Wrong"]) {
//                    // we neeed to aad success link to navigate
//                    
//                    errorMessage=[NSString stringWithFormat:@"%@",[finalDict objectForKey:@"status"]];
//                    [self errorAlert];
//                    [self unsubsciption];
//                    
//                }
//                else {
//                    errorMessage=[NSString stringWithFormat:@"%@",[finalDict objectForKey:@"status"]];
//                    [self errorAlert];
//                    
//                }
//                
//                }
//                
//                
//            }
//            else {
//                errorMessage=[NSString stringWithFormat:@"Server Connection Error..!!!"];
//                [self errorAlert];
//                [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
//                hud = nil;
//            }
//        }];
    }
    else{
        NSLog(@"Device is not connected to the internet");
        errorMessage=[NSString stringWithFormat:@"Device is not connected to the internet..!!!"];
        [self errorAlert];
    }
}


-(void)unsubsciption{
    __block LogInVC *objVC;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[LogInVC class]]) {
            objVC=(LogInVC *)obj;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstLogin"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MobNumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    [self.navigationController popToViewController:objVC animated:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
