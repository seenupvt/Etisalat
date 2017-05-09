//
//  WallShoVC.m
//  Islamic
//
//  Created by webappsApp on 24/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import "WallShoVC.h"
#import "DataUtility.h"

@interface WallShoVC (){
    DataUtility *currentImageData;
}

@end

@implementation WallShoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    //self.navigationItem.title =self.selectedStrng;
    
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
    
    NSLog(@"Image selected:%@",self.selectedStrng);
   // self.wallArrays=[[NSMutableArray alloc]init];
    //    self.bigImageView.layer.cornerRadius=65;
    //    self.bigImageView.layer.masksToBounds=YES;
    NSLog(@"image name:%@",self.selectedStrng);
    indexToShow = [self.selectedStrng intValue];
    NSLog(@"indextoshow:%d",indexToShow);
    UISwipeGestureRecognizer *gestureRight;
    UISwipeGestureRecognizer *gestureLeft;
    gestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self      action:@selector(swipeRight:)];
    gestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [gestureLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:gestureRight];
    [[self view] addGestureRecognizer:gestureLeft];
    [self WallLoaded];
    //self.wallShowImage.image = [UIImage imageNamed:[imgArray objectAtIndex:indexToShow]];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gesture{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        if ((indexToShow) < 0) {
            indexToShow = (int)self.wallArrays.count-1;
            [self WallLoaded];
            indexToShow--;
        }
        else{
        [self WallLoaded];
        //self.wallShowImage.image = [UIImage imageNamed:[imgArray objectAtIndex:indexToShow]];
        indexToShow--;
        }
    }
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        if ((indexToShow) >= self.wallArrays.count-1) {
            indexToShow = 0;
            [self WallLoaded];
            indexToShow++;
        }
        else{
             [self WallLoaded];
            indexToShow++;
        }
        
    }
}


-(void)WallLoaded{
    currentImageData= [self.wallArrays objectAtIndex:indexToShow];
    NSLog(@"Image selected  Wallshow…..%@, %@----%d", currentImageData.title, currentImageData.link,indexToShow);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *imgURL =[NSString stringWithFormat:@"%@",currentImageData.link];
        NSLog(@"%@",imgURL);
        //NSString *imgURL = @"http://59.163.89.120:8080/islamicMobileApp/opt/mahantesh/Quran/QuranSuras/Images/1al-faatiHah.jpg";
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        
        //set your image on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.wallShowImage setImage:[UIImage imageWithData:data]];
        });
    });
    
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
