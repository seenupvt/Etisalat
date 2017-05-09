//
//  MKAnnotationSub.h
//  mapkit
//
//  Created by SureshDokula on 10/25/14.
//  Copyright (c) 2014 LPtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MKAnnotationSub:NSObject<MKAnnotation>

-(id)initWithCordinate:(CLLocationCoordinate2D)cordinates tittle:(NSString*)ttle andSubTittle:(NSString*)sub;
@property (nonatomic,strong) NSString *strtitle;
@property (nonatomic,strong) NSString *strSubtitle;

@end
