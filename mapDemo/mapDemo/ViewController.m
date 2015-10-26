//
//  ViewController.m
//  mapDemo
//
//  Created by 张德强 on 15/10/26.
//  Copyright © 2015年 张德强. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [MAMapServices sharedServices].apiKey=@"6eeb79dc7c6c09fba0432494c4bb6ce4";
    
    _mapView=[[MAMapView alloc]initWithFrame:self.view.frame];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    
    _mapView.zoomEnabled=YES;
    _mapView.showsUserLocation=YES;//打开定位
    
    //[_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];//地图是否跟随移动模式
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (!_pointAnnotation) {
        self.pointAnnotation=[[MAPointAnnotation alloc]init];
        self.pointAnnotation.title=@"昌宁大厦";
        self.pointAnnotation.subtitle=@"丰台区星火路1号";
        [_mapView addAnnotation:_pointAnnotation];
    }
}

//实现 <MAMapViewDelegate> 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        static NSString *pointReuseIndentifier=@"pointReuseIndentifier";
        
        MAPinAnnotationView *annotationView=(MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        
        if (annotationView ==nil) {
            
            annotationView=[[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.canShowCallout=YES;//设置气泡可以弹出,默认是NO
        annotationView.animatesDrop=YES;//设置标注动画显示,默认是NO
        annotationView.draggable=YES;//设置标注可以拖动,默认是NO
        
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    
    return nil;
}

//定位方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //当前坐标发生变化时，重新赋给大头针
        _pointAnnotation.coordinate=userLocation.coordinate;
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
