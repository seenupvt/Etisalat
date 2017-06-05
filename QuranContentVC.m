//
//  QuranContentVC.m
//  Islamic
//
//  Created by webappsApp on 23/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import "QuranContentVC.h"
#import "DataUtility.h"
#import "MBProgressHUD.h"
#import "CustomCell.h"

@interface QuranContentVC (){
    DataUtility *currentSongData1;
}

@end

@implementation QuranContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    currentSongData1 = [self.listSongsArray objectAtIndex:self.selectedValue];
    self.navigationItem.title =currentSongData1.songname;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg2.jpg"] drawInRect:self.view.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    NSLog(@"selectedvalue:%d",self.selectedValue);
    indexToShow=self.selectedValue;
    
    UIButton *rtbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rtbtn setFrame:CGRectMake(self.view.frame.size.width-50, 0.0f, 40.0f,40.0f)];
    //[rtbtn addTarget:self action:@selector(presentMenuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [rtbtn setImage:[UIImage imageNamed:@"logo_128px.jpg"] forState:UIControlStateNormal];
    UIBarButtonItem *eng_rtbtn = [[UIBarButtonItem alloc] initWithCustomView:rtbtn];
    self.navigationItem.rightBarButtonItem = eng_rtbtn;
    
    self.contentNameLbl.text=[NSString stringWithFormat:@"%@",[self.listSongsArray objectAtIndex:self.selectedValue]];
    
    
}

- (void)refreshSongData {
    //self.tuneIdLbl.text = currentSongData.tuneid;
    currentSongData1 = [self.listSongsArray objectAtIndex:self.selectedValue];
    indexToShow=self.selectedValue;
    self.navigationItem.title =currentSongData1.songname;
    [self loadImage];
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading data";
   
    
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.apple.com/in/"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data){
        NSLog(@"Device is connected to the internet");
        NSString *mobNo=[[NSUserDefaults standardUserDefaults] objectForKey:@"MobNumber"];
        NSString *urlString = [NSString stringWithFormat:@"%@/songPlay.jsp?username=sk&password=sk123&mobno=705093133&tuneid=%@",self.URL,currentSongData1.tuneid];
        NSLog(@"%@",urlString);
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
                NSString *string =[NSString stringWithFormat:@"Tune ID:%@ song not available",currentSongData1.tuneid];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Server" message:string delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                return;
            }
            else{
                
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[dict objectForKey:@"mp3"] options:0];
                [self performSelectorOnMainThread:@selector(playAudioWith:) withObject:decodedData waitUntilDone:YES];
                 [self loadImage];
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

-(void)loadImage{
    NSLog(@"Selected index show:%d",indexToShow);
    currentSongData1 = [self.listSongsArray objectAtIndex:indexToShow];
    NSString * result = NULL;
    NSError *err = nil;
           // http://59.163.89.107:8023/islamicMobileApp/opt/mahantesh/Quran/QuranSuras/text/1002.txt,self.URL
      
        NSString *txtURL = [NSString stringWithFormat:@"%@%@%@",self.URL,currentSongData1.txtPath,currentSongData1.txtName];
        NSURL * urlToRequest = [NSURL   URLWithString:txtURL];//like "http://www.example.org/abc.txt"
            if(urlToRequest)
        {
            result = [NSString stringWithContentsOfURL: urlToRequest   encoding:NSUTF16StringEncoding error:&err];
            if(!err){
                
                textArray = [result componentsSeparatedByString:@"\n"];
                NSLog(@"Result::%@",textArray);
                if(textArray.count>0){
                self.textTable.delegate=self;
                self.textTable.dataSource=self;
                self.textTable.estimatedRowHeight = 44.0;
                self.textTable.rowHeight = UITableViewAutomaticDimension;
                [self.textTable reloadData];
                    
                
                }
              
            }
            if (err) {
                NSLog(@"Error results::%@",err);
            }
        }
    
    }


- (void) scrollTableView {
    
    float w = 1;
    
    CGPoint scrollPoint = self.textTable.contentOffset;
    scrollPoint.y = scrollPoint.y + w;
    if (scrollPoint.y >= self.textTable.contentSize.height - (self.textTable.frame.size.height - 100)  || scrollPoint.x <= -self.textTable.frame.size.height + 924) {
        w *= -1;
    }
    [self.textTable setContentOffset: scrollPoint animated: NO];
}
- (void)playAudioWith:(NSData *)data {
    
    self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    self.player.numberOfLoops =0;
    self.player.delegate=self;
    [self.player prepareToPlay];
    [self.player play];
   int minutesDuration=[self timeFormat:self.player.duration];
    NSLog(@"Time duration: %d",minutesDuration);
    
    int secDuration=(int)self.player.duration;
    NSLog(@"Time duration in sec: %d",secDuration);
    int x=(int)(secDuration/(2*textArray.count));
    NSLog(@"Array : %ld Duration in Sec: %d Time interval : %d",textArray.count,secDuration,x);
    [NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(scrollTableView) userInfo:nil repeats:YES];
    
    if (self.player.playing) {
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];
        
    }
    else {
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"playplayer.png"] forState:UIControlStateNormal];
        
    }
}
- (float)getAudioDuration {
    return [self.player duration];
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


- (IBAction)playerBtnClick:(id)sender {
    if (self.player.playing) {
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"playplayer.png"] forState:UIControlStateNormal];
        [self.player pause];
    }
    else {
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];
        [self.player play];
    }
    
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
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player stop];
    if (self.player.playing) {
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];
    }
    else {
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"playplayer.png"] forState:UIControlStateNormal];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self refreshSongData];
    if (self.player.playing) {
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];
    }
    else {
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"playplayer.png"] forState:UIControlStateNormal];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (textArray.count> 0){
        return textArray.count;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (textArray.count> 0){
    
    static NSString *strIndentifier = @"CustomCell";
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:strIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndentifier];
    }
    //cell.textView.textColor=[UIColor blueColor];
//        cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"textBreak.jpg"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        
    NSString *decode= [NSString stringWithFormat:@"%@",[textArray objectAtIndex:indexPath.row]];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = 20.f;
        paragraphStyle.lineSpacing = 20.f;
        paragraphStyle.minimumLineHeight = 20.f;
        paragraphStyle.maximumLineHeight = 40.f;
        
        UIFont *font = [UIFont fontWithName:@"AmericanTypewriter" size:22.f];
        UIColor *color = [UIColor colorWithRed:15.0/255.0 green:108.0/255.0 blue:51.0/255.0 alpha:1];
        
        cell.textView.attributedText = [[NSAttributedString alloc] initWithString:
                                        decode attributes:
                                        @{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font,NSForegroundColorAttributeName:color}];
    //cell.textView.text=decode;
    
    
    //cell.txtVw.attributedText = [[NSAttributedString alloc] initWithString:decode attributes:ats];
    return cell;
    }
    return 0;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor clearColor]];
    
    
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
   
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
