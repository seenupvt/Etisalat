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
    
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.contentSize=self.quranQsImageVw.frame.size;
    self.scrollView.delegate=self;
    self.quranQsImageVw.center=self.scrollView.center;
    //CGSizeMake(1280, 960);
    
    //* swipe images in imageView *//
    
//    UISwipeGestureRecognizer *gestureRight;
//    UISwipeGestureRecognizer *gestureLeft;
//    gestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self      action:@selector(swipeRight:)];
//    gestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
//    [gestureLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    [[self view] addGestureRecognizer:gestureRight];
//    [[self view] addGestureRecognizer:gestureLeft];
    
    //self.contentNameLbl.text=[NSString stringWithFormat:@"%@",[self.listSongsArray objectAtIndex:self.selectedValue]];
    [self refreshSongData];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.quranQsImageVw;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}


- (void)refreshSongData {
    //self.tuneIdLbl.text = currentSongData.tuneid;
    [self loadImage];
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading data";
    
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.apple.com/in/"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data){
        NSLog(@"Device is connected to the internet");
        NSString *mobNo=[[NSUserDefaults standardUserDefaults] objectForKey:@"MobNumber"];
        NSString *urlString = [NSString stringWithFormat:@"%@/songPlay.jsp?username=sk&password=sk123&mobno=%@&tuneid=%@",self.URL,mobNo,currentSongData1.tuneid];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *imgURL = [NSString stringWithFormat:@"%@%@/%@",self.URL,currentSongData1.imagepath,currentSongData1.imagename];
        NSLog(@"%@",imgURL);
        //NSString *imgURL = @"http://59.163.89.120:8080/islamicMobileApp/opt/mahantesh/Quran/QuranSuras/Images/1al-faatiHah.jpg";
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        
        //set your image on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.quranQsImageVw setImage:[UIImage imageWithData:data]];
        });
    });
}

- (void)playAudioWith:(NSData *)data {
    
    self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    self.player.numberOfLoops =0;
    self.player.delegate=self;
    [self.player prepareToPlay];
    [self.player play];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player stop];
       
}

//- (void)swipeRight:(UISwipeGestureRecognizer *)gesture{
//    if ((gesture.state == UIGestureRecognizerStateChanged) ||
//        (gesture.state == UIGestureRecognizerStateEnded)) {
//        
//        if ((indexToShow-1) < 0) {
//            indexToShow = (int)self.listSongsArray.count-1;
//        }
//        [self loadImage];
//        //self.wallShowImage.image = [UIImage imageNamed:[imgArray objectAtIndex:indexToShow]];
//        indexToShow--;
//    }
//}
//
//- (void)swipeLeft:(UISwipeGestureRecognizer *)gesture
//{
//    if ((gesture.state == UIGestureRecognizerStateChanged) ||
//        (gesture.state == UIGestureRecognizerStateEnded)) {
//        
//        if ((indexToShow+1) > self.listSongsArray.count-1 ) {
//            indexToShow = 0;
//        }
//        [self loadImage];
//        //self.wallShowImage.image = [UIImage imageNamed:[imgArray objectAtIndex:indexToShow]];
//        indexToShow++;
//    }
//}

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
