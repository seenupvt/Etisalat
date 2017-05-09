//
//  NabawiVC.m
//  Islamic
//
//  Created by webappsApp on 20/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import "NabawiVC.h"
#import "MBProgressHUD.h"
#import "CustomCell.h"
#import "DataUtility.h"
#import "PlayerVC.h"

@interface NabawiVC (){
    UIImageView *imageVw;
    UIWebView *textVw;
}

@end

@implementation NabawiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title =self.selectedStrng;
    
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
    
    self.nabawiTbl.delegate=self;
    self.nabawiTbl.dataSource=self;
    self.nabawiTbl.frame=CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height/1.3);
    
    if (self.nabawiSegment.selectedSegmentIndex==0) {
        [self.nabawiTbl setHidden:NO];
        [self tableLoadOver];
        
     }
}
-(void)tableLoadOver{
    
    songsArray= [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading data";
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.apple.com/in/"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data){
        NSLog(@"Device is connected to the internet");
        NSString *mobNo=[[NSUserDefaults standardUserDefaults] objectForKey:@"MobNumber"];
        NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/hadith.jsp?username=sk&password=sk123&mobno=%@",self.URL,mobNo];
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:urlString];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:18000];
        [request setHTTPMethod:@"GET"];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        songsArray= [[NSMutableArray alloc]init];
        // Do any additional setup after loading the view.
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSLog(@"Data is: %@",data);
            if (connectionError==nil){
                NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableArray *jsonarray=[NSJSONSerialization JSONObjectWithData:jsonData options:
                                           NSJSONReadingMutableContainers error:nil];
                
                [jsonarray enumerateObjectsUsingBlock:^(NSDictionary *objDictionary1, NSUInteger idx, BOOL *stop) {
                    
                    DataUtility *objSongsData = [[DataUtility alloc]init];
                    objSongsData.tuneid = [objDictionary1 objectForKey:@"tuneid"];
                    objSongsData.songname = [objDictionary1 objectForKey:@"songname"];
                    [songsArray addObject:objSongsData];
                    [self.nabawiTbl reloadData];
                }];
                NSLog(@"Array: %@",songsArray);
                [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
                hud = nil;
            }
            else {
                [self.nabawiTbl reloadData];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Server" message:@"List of songs are not available!!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
                hud = nil;
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

-(void)seeratViewLoad{
    
    UIImage *img=[UIImage imageNamed:@"Seerat Nabawi.png"];
    imageVw=[[UIImageView alloc] initWithFrame:CGRectMake(0, 150, 100, 100)];
    imageVw.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    imageVw.frame=CGRectMake((self.view.frame.size.width/2)-(imageVw.frame.size.width/2), 150, 100, 100);
    imageVw.image=img;
    [self.view addSubview:imageVw];
    textVw=[[UIWebView alloc]initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, self.view.frame.size.height*2/3)];
    textVw.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    textVw.backgroundColor=[UIColor clearColor];
    [self.view addSubview:textVw];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"SeeratNabawee" ofType:@"htm"]isDirectory:NO];
    [textVw loadRequest:[NSURLRequest requestWithURL:url]];
    
        
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (songsArray.count> 0){
        NSLog(@"%ld",songsArray.count);
        return songsArray.count;
    }
    else
        return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
        static NSString *strIndentifier = @"CustomCell";
        CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:strIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndentifier];
        }
        DataUtility *objSongData = [songsArray objectAtIndex:indexPath.row];
        //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"myzonebg.png"]];
      cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"textBreak.jpg"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        cell.songnameLbl.text=[NSString stringWithFormat:@"Hadith-%@",objSongData.songname];
        cell.play.tag = 8000+indexPath.row;
        
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor clearColor]];
        
        NSLog(@"%ld",(long)indexPath.row);
    
}
- (IBAction)playSongBtnClick:(id)sender {
    PlayerVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"PlayerVC"];
    //    EFBasicViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"EFBasicViewController"];
    obj.listSongsArray=songsArray;
    obj.URL=self.URL;
    obj.selectedValue=(int)[sender tag] - 8000;    
    [self.navigationController pushViewController:obj animated:YES];
    
    
}

- (IBAction)segmentChange:(id)sender {
    if (self.nabawiSegment.selectedSegmentIndex==0) {
        [imageVw setHidden:YES];
        [textVw setHidden:YES];
        [self.nabawiTbl setHidden:NO];
        imageVw.frame=CGRectMake(self.view.frame.size.width*3, 0, 100, 100);
        textVw.frame=CGRectMake(self.view.frame.size.width*3, 0, 100, 100);
        [self tableLoadOver];
        
    }
    if (self.nabawiSegment.selectedSegmentIndex==1){
        [self.nabawiTbl setHidden:YES];
        [imageVw setHidden:NO];
        [textVw setHidden:NO];
        [self seeratViewLoad];
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
