//
//  MyAddressViewController.m
//  ChatProject
//
//  Created by Rain on 16/7/4.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "MyAddressViewController.h"

@interface MyAddressViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>{
    UITextField *myAddressTxt;
    UITextView *myDetailAddressTv;
    UIView *BackView;
    UIPickerView *addressPickView;
    NSString *addressValue;
    
    NSMutableArray *provinceArray;
    NSMutableArray *cityArray;
    NSMutableArray *countyArray;
    NSString *provinceCode;
    NSString *cityCode;
    NSString *countyCode;
    NSString *provinceId;
    NSString *cityId;
    NSString *countyId;
    NSString *provinceTxt;
    NSString *cityTxt;
    NSString *countyTxt;
}

@end

@implementation MyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"我的地址"];
    [self addLeftButton:@"left"];
    
    [self initAddressData];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [myDetailAddressTv resignFirstResponder];
}

-(void)initView{
    // myAddressLbl
    UILabel *myAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, Header_Height + 20 + (45 - 21) / 2, 100, 21)];
    myAddressLbl.text = @"选择地区";
    [self.view addSubview:myAddressLbl];
    // myAddressTxt
    myAddressTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(myAddressLbl.frame), Header_Height + 20, SCREEN_WIDTH - CGRectGetMaxX(myAddressLbl.frame), 45)];
    myAddressTxt.font = [UIFont systemFontOfSize:15];
    myAddressTxt.placeholder = @"选择地区";
    myAddressTxt.text = @"山东省临沂市兰山区";
    [self.view addSubview:myAddressTxt];
    // myAddressBtn
    UIButton *myAddressBtn = [[UIButton alloc] initWithFrame:myAddressTxt.frame];
    [myAddressBtn addTarget:self action:@selector(clickMyAddressEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myAddressBtn];
    // lineView1
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(myAddressTxt.frame), SCREEN_WIDTH - 10, 0.5)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView1];
    // myDetailAddressLbl
    UILabel *myDetailAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView1.frame) + (45 - 21) / 2, 100, 21)];
    myDetailAddressLbl.text = @"详细地址";
    [self.view addSubview:myDetailAddressLbl];
    // myDetailAddressTv
    myDetailAddressTv = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(myDetailAddressLbl.frame), CGRectGetMaxY(lineView1.frame) + 5, SCREEN_WIDTH - CGRectGetMaxX(myDetailAddressLbl.frame), 60)];
    myDetailAddressTv.font = [UIFont systemFontOfSize:15];
    myDetailAddressTv.text = @"朗瑞大厦";
    [self.view addSubview:myDetailAddressTv];
    // lineView2
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(myDetailAddressTv.frame), SCREEN_WIDTH - 10, 0.5)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView2];
    
    BackView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 50)];
    [BackView setBackgroundColor:[UIColor whiteColor]];
    UIButton * btn_cancel=[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 50)];
    [btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [btn_cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_cancel addTarget:self action:@selector(cancelSelect:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * btn_sure=[[UIButton alloc] initWithFrame:CGRectMake(BackView.frame.size.width-70, 0, 60, 50)];
    [btn_sure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
    [btn_sure addTarget:self action:@selector(sureForSelect:) forControlEvents:UIControlEventTouchUpInside];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(0, BackView.frame.size.height-1, BackView.frame.size.width, 1)];
    fenge.backgroundColor=[UIColor grayColor];
    [BackView addSubview:btn_sure];
    [BackView addSubview:btn_cancel];
    [BackView addSubview:fenge];
    
    addressPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200)];
    addressPickView.delegate = self;
    addressPickView.dataSource = self;
    addressPickView.backgroundColor = [UIColor grayColor];
}

-(void)clickMyAddressEvent{
    [self.view addSubview:BackView];
    [self.view addSubview:addressPickView];
}

-(void)cancelSelect:(UIButton * )sender
{
    [BackView removeFromSuperview];
    [addressPickView removeFromSuperview];
}

-(void)sureForSelect:(UIButton *)sender
{
    addressValue = [NSString stringWithFormat:@"%@%@%@",provinceTxt, cityTxt, countyTxt];
    myAddressTxt.text = addressValue;
    [BackView removeFromSuperview];
    [addressPickView removeFromSuperview];
}

-(void)initAddressData{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getInitProvinceCallBack:"];
    [dataProvider getProvince];
}

-(void)getInitProvinceCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        provinceArray = [[NSMutableArray alloc] init];
        
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [provinceArray addObject:itemArray[i]];
        }
        if (provinceArray.count > 0) {
            provinceCode = provinceArray[0][@"Code"];
            provinceId = provinceArray[0][@"Id"];
            provinceTxt = provinceArray[0][@"Name"];
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"getInitCityCallBack:"];
            [dataProvider getCityByProvince:provinceCode];
        }
    }
}

-(void)getInitCityCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        cityArray = [[NSMutableArray alloc] init];
        countyArray = [[NSMutableArray alloc] init];
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [cityArray addObject:itemArray[i]];
        }
        if (cityArray.count > 0) {
            cityCode = cityArray[0][@"Code"];
            cityId = cityArray[0][@"Id"];
            cityTxt = cityArray[0][@"Name"];
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"getInitCountyCallBack:"];
            [dataProvider getCountyByCity:cityCode];
        }
        [addressPickView selectRow:0 inComponent:1 animated:true];
        [addressPickView reloadAllComponents];
    }
}

-(void)getInitCountyCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        countyArray = [[NSMutableArray alloc] init];
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [countyArray addObject:itemArray[i]];
        }
        if (countyArray.count > 0) {
            countyCode = countyArray[0][@"Code"];
            countyId = countyArray[0][@"Id"];
            countyTxt = countyArray[0][@"Name"];
        }
        [addressPickView selectRow:0 inComponent:2 animated:true];
        [addressPickView reloadAllComponents];
    }
}

#pragma mark - pickerView delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return provinceArray.count;
    }else if (component == 1){
        return cityArray.count;
    }else{
        return countyArray.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return provinceArray[row][@"Name"];
    }else if (component == 1){
        return cityArray[row][@"Name"];
    }else{
        return countyArray[row][@"Name"];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"%ld---%ld",(long)component,(long)row);
    if (component == 0) {
        provinceTxt = provinceArray[row][@"Name"];
        provinceCode = provinceArray[row][@"Code"];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getInitCityCallBack:"];
        [dataProvider getCityByProvince:provinceCode];
    }else if (component == 1){
        cityId = cityArray[row][@"Id"];
        cityCode = cityArray[row][@"Code"];
        cityTxt = cityArray[row][@"Name"];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getInitCountyCallBack:"];
        [dataProvider getCountyByCity:cityCode];
    }else{
        countyCode = countyArray[row][@"Code"];
        countyId = countyArray[row][@"Id"];
        countyTxt = countyArray[row][@"Name"];
    }
}

@end
