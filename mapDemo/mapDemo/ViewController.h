//
//  ViewController.h
//  mapDemo
//
//  Created by 张德强 on 15/10/26.
//  Copyright © 2015年 张德强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface ViewController : UIViewController<MAMapViewDelegate,AMapSearchDelegate>

@property(nonatomic,strong)MAMapView *mapView;//地图承载视图

@property(nonatomic,strong)MAPointAnnotation *pointAnnotation;//大头针

@property(nonatomic,strong)AMapSearchAPI *search;//搜索

@property(nonatomic,strong)AMapGeoPoint *origin;//起点

@property(nonatomic,strong)AMapGeoPoint *destination;//终点

@end

