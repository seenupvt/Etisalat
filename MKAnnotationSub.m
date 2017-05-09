//
//  MKAnnotationSub.m
//  mapkit
//
//  Created by SureshDokula on 10/25/14.
//  Copyright (c) 2014 LPtech. All rights reserved.
//

#import "MKAnnotationSub.h"

@implementation MKAnnotationSub
@synthesize strSubtitle,strtitle;
@synthesize coordinate =_coordinate;
@synthesize title =_title;
@synthesize subtitle =_subtitle;

-(id)initWithCordinate:(CLLocationCoordinate2D)cordinates tittle:(NSString*)ttle andSubTittle:(NSString*)sub
{
    self = [super init];
    if(self!=nil)
    {
        _coordinate = CLLocationCoordinate2DMake(cordinates.latitude, cordinates.longitude);
        _title = ttle;
        _subtitle= sub;
        
    }
    return self;
}

-(NSString*)title
{
    return  _title;
}

-(NSString*)subtitle
{
    return _subtitle;
}

-(CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}
@end
