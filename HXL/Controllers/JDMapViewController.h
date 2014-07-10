//
//  JDMapViewController.h
//  HXL
//
//  Created by Roc on 14-7-10.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "JDHXLParentViewController.h"
#import "GeocodeAnnotation.h"

@interface JDMapViewController : JDHXLParentViewController<MAMapViewDelegate, AMapSearchDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) NSString *hotelTitle;
@property (nonatomic, strong) NSString *hotelSubTitle;
@property (nonatomic) double lon;
@property (nonatomic) double lat;

@end
