//
//  PlayerVC.m
//  Islamic
//
//  Created by webappsApp on 23/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import "PlayerVC.h"
#import "DataUtility.h"
#import "MBProgressHUD.h"

@interface PlayerVC (){
    DataUtility *currentSongData;
}

@end

@implementation PlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title =@"Player";
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg2.jpg"] drawInRect:self.view.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    UIButton *rtbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rtbtn setFrame:CGRectMake(self.view.frame.size.width-50, 0.0f, 40.0f,40.0f)];
    //[rtbtn addTarget:self action:@selector(presentMenuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [rtbtn setImage:[UIImage imageNamed:@"logo_128px.jpg"] forState:UIControlStateNormal];
    UIBarButtonItem *eng_rtbtn = [[UIBarButtonItem alloc] initWithCustomView:rtbtn];
    self.navigationItem.rightBarButtonItem = eng_rtbtn;
    // Do any additional setup after loading the view.
    NSLog(@"selected Value:%d",self.selectedValue);
    if (self.player.playing) {
        [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];
    }
    else {
        [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"playplayer.png"] forState:UIControlStateNormal];
    }
    
    [self refreshSongData];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player stop];
    if (self.player.playing) {
        [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];
    }
    else {
        [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"playplayer.png"] forState:UIControlStateNormal];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    if (self.player.playing) {
        [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];
    }
    else {
        [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"playplayer.png"] forState:UIControlStateNormal];
    }
    
}
- (IBAction)playerBtnClick:(id)sender {
    if (self.player.playing) {
        [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"playplayer.png"] forState:UIControlStateNormal];
        [self.player pause];
    }
    else {
        [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];
        [self.player play];
    }
    
}
- (IBAction)seekAudioPlayer:(id)sender {
    self.player.currentTime=self.circleSlider.value;
}
- (void)refreshSongData {
    currentSongData = [self.listSongsArray objectAtIndex:self.selectedValue];
    self.songNameLbl.text = currentSongData.songname;
    //self.tuneIdLbl.text = currentSongData.tuneid;
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading data";
    
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.apple.com/in/"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data){
        NSLog(@"Device is connected to the internet");
        NSString *mobNo=[[NSUserDefaults standardUserDefaults] objectForKey:@"MobNumber"];
        NSString *urlString = [NSString stringWithFormat:@"%@/songPlay.jsp?username=sk&password=sk123&mobno=%@&tuneid=%@",self.URL,mobNo,currentSongData.tuneid];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:urlString];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:18000];
        // NSOperationQueue *queue=[[NSOperationQueue alloc]init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
            hud = nil;
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if (dict==nil) {
                NSString *string =[NSString stringWithFormat:@"Tune ID:%@ song not available",currentSongData.tuneid];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Server" message:string delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                return;
            }
            else{
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[dict objectForKey:@"mp3"] options:0];
                [self performSelectorOnMainThread:@selector(playAudioWith:) withObject:decodedData waitUntilDone:YES];
            }
        }];
    }
    else{
        NSLog(@"Device is not connected to the internet");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Device is not connected to the internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
        hud = nil;
    }
}

- (void)playAudioWith:(NSData *)data {
    
    self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    self.player.numberOfLoops =0;
    self.player.delegate=self;
    [self.player prepareToPlay];
    [self.player play];
    if (self.player.playing) {
        [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];
    }
    else {
        [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"playplayer.png"] forState:UIControlStateNormal];
    }
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setCurrentAudioTime) userInfo:nil repeats:YES];
    self.timeDuration.text = [self timeFormat:self.player.duration];
    
    self.circleSlider.minimumValue = 0;
    self.circleSlider.maximumValue =self.player.duration;
    self.circleSlider.continuous = NO;
    
    self.elapsedTime.text=[self timeFormat:self.player.currentTime];
    NSLog(@"time elapsed:%@ /n duration:%@",self.elapsedTime.text,self.timeDuration.text);
}


-(NSString*)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = (int)lroundf(seconds);
    int roundedMinutes = (int)lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%d:%02d",
                      roundedMinutes, roundedSeconds];
    return time;
}

- (void)setCurrentAudioTime {
    
    self.circleSlider.value=self.player.currentTime;
    self.elapsedTime.text = [self timeFormat:self.circleSlider.value];
    NSLog(@"%@",self.elapsedTime.text);
    if ([self.elapsedTime.text  isEqualToString:@"0:00"]) {
        [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"playplayer.png"] forState:UIControlStateNormal];
    }
}

- (NSTimeInterval)getCurrentAudioTime {
    return [self.player currentTime];
}

- (float)getAudioDuration {
    return [self.player duration];
}
- (IBAction)priviousPlay:(id)sender {
    if (self.selectedValue>0) {
        self.selectedValue--;
        [self refreshSongData];
    }
}
- (IBAction)nextPlay:(id)sender {
    NSLog(@"%d --- %lu",self.selectedValue,self.listSongsArray.count-1);
    if(self.selectedValue<self.listSongsArray.count-1) {
        self.selectedValue++;
        [self refreshSongData];
}
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
