//
//  DataUtility.h
//  Islamic
//
//  Created by webappsApp on 23/05/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtility : NSObject{
    NSString*title;
    NSString*link;
    NSString*image;
}
@property(nonatomic, copy)NSString*title;
@property(nonatomic, copy)NSString*link;
@property(nonatomic, copy)NSString*image;
@property(nonatomic,copy) NSString *imageLink;
@property (nonatomic, strong) NSString *quranName;
@property (nonatomic, strong) NSString *tuneid;
@property (nonatomic, strong) NSString *songname;
@property (nonatomic,strong) NSString *txtName;
@property (nonatomic,strong) NSString *txtPath;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *chargestatus;

@end
