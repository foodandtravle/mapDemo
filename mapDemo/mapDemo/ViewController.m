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
    
    //显示Key
    [MAMapServices sharedServices].apiKey=@"6eeb79dc7c6c09fba0432494c4bb6ce4";
    
    _mapView=[[MAMapView alloc]initWithFrame:self.view.frame];
    _mapView.delegate=self;
    _mapView.zoomEnabled=YES;
    _mapView.showsUserLocation=YES;//打开定位
    [self.view addSubview:_mapView];
    
    //[_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];//地图是否跟随移动模式
    
    
    //搜索API
    //搜索searchAPIKey
    [AMapSearchServices sharedServices].apiKey=@"6eeb79dc7c6c09fba0432494c4bb6ce4";
    _search=[[AMapSearchAPI alloc]init];
    _search.delegate=self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIKeywordsSearchRequest *reqest=[[AMapPOIKeywordsSearchRequest alloc]init];
    reqest.keywords=@"昌宁大厦";
    reqest.city=@"北京";
    reqest.requireExtension=YES;//返回详细信息，较废流量
    [_search AMapPOIKeywordsSearch:reqest];//开始查询
    
}

//搜索POI函数回调
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    
    if (response.pois.count==0) {
        
        NSLog(@"搜索失败，无返回结果");
        return;
    }
    
    //通过AMapPlaceSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@",response.suggestion];//关键字建议列表和城市列表
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nname: %@", strPoi, p.name];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ %@", strCount, strSuggestion,strPoi];
    NSLog(@"Place:== %@", result);
    
    //搜索结束后添加一个大头针到该位置
    AMapPOI *p=response.pois.firstObject;
    AMapGeoPoint *point=p.location;
    MAPointAnnotation *addPointAnnotation=[[MAPointAnnotation alloc]init];
    addPointAnnotation.title=@"昌宁大厦";
    addPointAnnotation.subtitle=@"丰台区星火路1号";
    addPointAnnotation.coordinate=CLLocationCoordinate2DMake(point.latitude, point.longitude);
    [_mapView addAnnotation:addPointAnnotation];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    //初始化大头针
    if (!_pointAnnotation) {
        self.pointAnnotation=[[MAPointAnnotation alloc]init];
        self.pointAnnotation.title=@"昌宁大厦";
        self.pointAnnotation.subtitle=@"丰台区星火路1号";
        [_mapView addAnnotation:_pointAnnotation];
    }
}

/**
  *大头针
  *实现 <MAMapViewDelegate> 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式
  */
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
updatingLocation:(BOOL)updatingLocation{
    if(updatingLocation)
    {
        //当前坐标发生变化时，重新赋给大头针
        _pointAnnotation.coordinate=userLocation.coordinate;
        //取出当前位置的坐标
        //NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
