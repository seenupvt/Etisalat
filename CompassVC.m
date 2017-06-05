//
//  CompassVC.m
//  Islamic
//
//  Created by webappsApp on 19/07/16.
//  Copyright © 2016 Wifi. All rights reserved.
//

#import "CompassVC.h"
#import "MKAnnotationSub.h"

@interface CompassVC ()
@end

@implementation CompassVC
double lat=21.4266700;
double lon=39.8261100;
//double Prelat=12.9716;
//double Prelon=77.5946;
double Prelat;
double Prelon;
CLLocationCoordinate2D  currentLocation;
CLLocationDirection     currentHeading;
CLLocationDirection     cityHeading;
#define toRad(X) (X*M_PI/180.0)
#define toDeg(X) (X*180.0/M_PI)
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title =self.selectedStrng;
    // Do any additional setup after loading the view.
    [self.mapView setMapType:MKMapTypeStandard];
    self.mapView.showsUserLocation=YES;
    [self.mapView setDelegate:self];
    MKAnnotationSub *an1 = [[MKAnnotationSub alloc] initWithCordinate:CLLocationCoordinate2DMake(lat,lon) tittle:@"Mecca" andSubTittle:@"Soudi Arabia"];
    [self.mapView addAnnotation:an1];
    
    [self.locationManager requestAlwaysAuthorization];
    
    
    currentHeading=0.0;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    Prelat = self.locationManager.location.coordinate.latitude;
    Prelon = self.locationManager.location.coordinate.longitude;
    NSLog(@"Latt; %f    Long  %f  ", Prelat,Prelon);
    
    CLLocationCoordinate2D coordinateArray[2];
    coordinateArray[0] = CLLocationCoordinate2DMake(lat, lon);
    coordinateArray[1] = CLLocationCoordinate2DMake(Prelat, Prelon);
    
    
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
 
    [self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]]; //If you want the route to be visible
    
    [self.mapView addOverlay:self.routeLine];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    
    if([CLLocationManager locationServicesEnabled]){
        [self.locationManager startUpdatingLocation];
    }
    [self.locationManager startUpdatingHeading];
    
    
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    currentLocation = newLocation.coordinate;
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        Prelat=currentLocation.coordinate.latitude;
        Prelon=currentLocation.coordinate.longitude;
       NSLog(@"Latt; %f    Long  %f  ", Prelat,Prelon);
        
    }
    
    [self updateHeadingDisplays];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location.");
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading{
    float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
    float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
    theAnimation.toValue=[NSNumber numberWithFloat:newRad];
    theAnimation.duration = 0.5f;
    [self.compass.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    self.compass.transform = CGAffineTransformMakeRotation(newRad);
    NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
    
    // if (newHeading.headingAccuracy < 0)
    //    return;
    
    
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    
    
    cityHeading = [self directionFrom:currentLocation ];
    
    
    currentHeading = theHeading;
    
    [self updateHeadingDisplays];
    
    
    
}
- (void)updateHeadingDisplays {
    // Animate Compass
    
    
    [UIView     animateWithDuration:0.6
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             CGAffineTransform headingRotation = CGAffineTransformRotate(CGAffineTransformIdentity, (CGFloat)toRad(cityHeading)-toRad(currentHeading));
                             
                             self.needle.transform = headingRotation;
                             
                             

                         }
                         completion:^(BOOL finished) {
                             
                         }];
    
    
    
}

-(CLLocationDirection) directionFrom: (CLLocationCoordinate2D) startPt  {
    
    double lat1 = toRad(startPt.latitude);
    double lat2 = toRad(21.4266700 );
    double lon1 = toRad(startPt.longitude);
    double lon2 = toRad(39.8261100);
    double dLon = (lon2-lon1);
    
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double brng = toDeg(atan2(y, x));
    
    brng = (brng+360);
    brng = (brng>360)? (brng-360) : brng;
    
    return brng;
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static  NSString *strconstatnt = @"mappin";
    static  NSString *strconstatnts = @"placemark";    
    if([annotation.title isEqualToString:@"Mecca"])
    {
        MKAnnotationView *placemark  = (MKAnnotationView*)[self.mapView viewForAnnotation:annotation];
        if(placemark==nil){
            placemark = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:strconstatnts];
        }
        [placemark setImage:[UIImage imageNamed:@"MeccaPin.png"]];
        return placemark;
    }
    else{
        MKAnnotationView *placemark  = (MKAnnotationView*)[self.mapView viewForAnnotation:annotation];
        if(placemark==nil){
            placemark = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:strconstatnts];
        }
        [placemark setImage:[UIImage imageNamed:@"device.png"]];
        return placemark;
    }
        return nil;
}


-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine)
    {
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 8;
            [self.routeLineView setLineDashPattern:
             [NSArray arrayWithObjects:[NSNumber numberWithInt:8],[NSNumber numberWithInt:2],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2], [NSNumber numberWithInt:1],[NSNumber numberWithInt:2], nil]];
        }
        
        return self.routeLineView;
    }
    
    return nil;
}

- (void)locationError:(NSError *)error {
   
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
