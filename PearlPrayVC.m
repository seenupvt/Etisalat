
//
//  PearlPrayVC.m
//  Etisalat
//
//  Created by webappsApp on 19/05/17.
//  Copyright © 2017 Wifi. All rights reserved.
//

#import "PearlPrayVC.h"
#import "CustomCell.h"

@interface PearlPrayVC (){
    
    NSMutableParagraphStyle *paragraphStyle;
    NSDictionary *ats;
}


@end

@implementation PearlPrayVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title =@"Perl Beads";
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg2.jpg"] drawInRect:self.view.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
   
    NSString * result = NULL;
    NSError *err = nil;
    NSStringEncoding encoding;
   
   
    NSURL * urlToRequest = [[NSURL  alloc] initWithString:@"http://59.163.89.107:8023/islamicMobileApp/opt/mahantesh/Quran/QuranSuras/text/11002.txt"];//like "http://www.example.org/abc.txt"
    if(urlToRequest)
    {
        result = [[NSString alloc ] initWithContentsOfURL: urlToRequest encoding:NSUTF16StringEncoding error:&err];

    }
    
    if(!err){
        NSLog(@"Result::%@",result);
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    
    //http://59.163.89.107:8023/islamicMobileApp/opt/mahantesh/Quran/QuranSuras/text/1004.txt
    NSString *path = [[NSBundle mainBundle] pathForResource:@"2 Al-Baqara" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Content: %@",content);

    
    songsArray = [content componentsSeparatedByString:@"\n"];
    if(songsArray.count>0){
    //NSLog(@"Array of Items: %@",items);
//    NSString *decode= [NSString stringWithFormat:@"%@",[songsArray objectAtIndex:25]];
//    NSLog(@"Items:%@",decode);
    self.tableVw.delegate=self;
    self.tableVw.dataSource=self;
    self.tableVw.estimatedRowHeight = 44.0;
    self.tableVw.rowHeight = UITableViewAutomaticDimension;
    [self.tableVw reloadData];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (songsArray.count> 0){
        return songsArray.count;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(songsArray.count>0){
    
    static NSString *strIndentifier = @"CustomCell";
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:strIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndentifier];
    }
    cell.txtVw.textColor=[UIColor blueColor];
    //cell.txtVw.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.jpg"]];
    //[cell.txtVw setFont:[UIFont fontWithName:@"Helvetica Neue" size:20.0f]];
    
    NSString *decode= [NSString stringWithFormat:@"%@",[songsArray objectAtIndex:indexPath.row]];
    cell.txtVw.text=decode;
      
    
    //cell.txtVw.attributedText = [[NSAttributedString alloc] initWithString:decode attributes:ats];
    return cell;
    }
    return 0;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor clearColor]];
    
    
    
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
