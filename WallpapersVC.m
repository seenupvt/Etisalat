//
//  WallpapersVC.m
//  Islamic
//
//  Created by webappsApp on 20/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import "WallpapersVC.h"
#import "DataUtility.h"
#import "WallShoVC.h"

@interface WallpapersVC ()

@end

@implementation WallpapersVC

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
    sections = [[NSMutableArray alloc] init];
    WallArray=[[NSMutableArray alloc]init];
    
    for(int s=0;s<1;s++) { // 4 sections
        NSMutableArray *section = [[NSMutableArray alloc] init];
        
        for(int i=1;i<10;i++) {// 12 items in each section
            DataUtility *item = [[ DataUtility alloc] init];
            item.link=[NSString stringWithFormat:@"%@/images/%d.jpg",self.URL,i];
            item.title=[NSString stringWithFormat:@"Item %d", i];
            item.image=[NSString stringWithFormat:@"s%d.jpg", i];
            //item.imageLink=[NSString stringWithFormat:@"%@/images/%d.jpg",self.URL,i];
            
            [section addObject:item];
            [WallArray addObject:item];
        }
        [sections addObject:section];
    }
// Do any additional setup after loading the view.
    self.wallTbl.delegate=self;
    self.wallTbl.dataSource=self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sections count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    NSMutableArray *sectionItems = [sections objectAtIndex:indexPath.section];
    int numRows = [sectionItems count]/2;
    return numRows * 85.0;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    NSString *sectionTitle = [NSString stringWithFormat:@"Section %d",section];
//    return sectionTitle;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static    NSString *hlCellID = @"hlCellID";
    
    UITableViewCell *hlcell = [tableView dequeueReusableCellWithIdentifier:hlCellID];
    if(hlcell == nil) {
        hlcell = [[UITableViewCell alloc]
                  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hlCellID];
        hlcell.accessoryType = UITableViewCellAccessoryNone;
        hlcell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    int section = indexPath.section;
    NSMutableArray *sectionItems = [sections objectAtIndex:section];
    
    int n = [sectionItems count];
    int i=0,i1=0;
    
    while(i<n){
        int yy = 4 +i1*(hlcell.frame.size.height*2.8);//130
        int j=0;
        for(j=0; j<3;j++){
            
            if (i>=n) break;
            DataUtility *item = [sectionItems objectAtIndex:i];
            CGRect rect  = CGRectMake(15+((hlcell.frame.size.width)/3)*j, yy, 90, 90);  //126
            UIButton *buttonImage=[[UIButton alloc] initWithFrame:rect];
            [buttonImage setFrame:rect];
            UIImage *buttonImageNormal=[UIImage imageNamed:item.image];
            [buttonImage setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
            [buttonImage setContentMode:UIViewContentModeCenter];
            NSString *tagValue = [NSString stringWithFormat:@"%d%d",indexPath.section+1, i];
            buttonImage.tag = [tagValue intValue];
            //NSLog(@tag….%d", button.tag);
            [buttonImage addTarget:self
                            action:@selector(buttonPressed:)forControlEvents:UIControlEventTouchUpInside];
            [hlcell.contentView addSubview:buttonImage];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(((hlcell.frame.size.width)/3)*j,yy+100, 100, 12)];//(hlcell.frame.size.height*j)-4
            label.text = item.title;
            label.textColor = [UIColor blackColor];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            label.font = [UIFont fontWithName:@"ArialMT" size:12];
            [hlcell.contentView addSubview:label];
            i++;
        }
        i1 = i1+1;
    }
    return hlcell;
}
-(IBAction)buttonPressed:(id)sender {
    int tagId = [sender tag];
    int divNum = 0;
    if(tagId<100)
        divNum=10;
    else
        divNum=100;
    int section = [sender tag]/divNum;
    section -=1;// we had incremented at tag assigning time
    int itemId = [sender tag]%divNum;
    NSLog(@"…section = %d, item = %d", section, itemId);
    NSMutableArray*sectionItems = [sections objectAtIndex:section];
    DataUtility  *item    = [sectionItems objectAtIndex:itemId];
    NSLog(@"Image selected…..%@, %@", item.title, item.link);
    WallShoVC *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"WallShoVC"];
    obj.selectedStrng=[NSString stringWithFormat:@"%d",itemId];
    obj.wallArrays=WallArray;
    [self.navigationController pushViewController:obj animated:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    //[self.wallTbl reloadData];
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
