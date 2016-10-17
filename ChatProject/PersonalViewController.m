//
//  PersonalViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/27.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PersonalViewController.h"
#import "SignViewController.h"
#import "NameViewController.h"
#import "MyErweimaViewController.h"
#import "MyAddressViewController.h"
#import "UIImageView+WebCache.h"
#import "InputAddressViewController.h"
#import <RongIMKit/RongIMKit.h>

#define CellIdentifier @"CellIdentifier"

@interface PersonalViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, SignDelegate, NameDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, InputAddressDelegate>{
    // view
    UITableView *mTableView;
    UIView *BackView;
    UIPickerView *addressPickView;
    UIImage *headImage;
    
    // data
    NSString *nameValue;
    NSString *sexValue;
    NSString *sexId;
    NSString *addressValue;
    NSString *signValue;
    NSMutableArray *provinceArray;
    NSMutableArray *cityArray;
    NSString *provinceCode;
    NSString *cityCode;
    NSString *provinceId;
    NSString *cityId;
    NSString *provinceTxt;
    NSString *cityTxt;
}

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"个人信息"];
    [self addLeftButton:@"left"];
    
    nameValue = [Toolkit getStringValueByKey:@"NickName"];
    sexValue = [Toolkit getStringValueByKey:@"Sex"];
    signValue = [Toolkit getStringValueByKey:@"Sign"];
    addressValue = [Toolkit getStringValueByKey:@"Address"];
    
    //[self initAddressData];
    
    [self initView];
}

#pragma mark - 自定义方法
-(void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.tableFooterView = [[UIView alloc] init];
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:mTableView];
    
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

-(void)cancelSelect:(UIButton * )sender
{
    [BackView removeFromSuperview];
    [addressPickView removeFromSuperview];
}

-(void)sureForSelect:(UIButton *)sender
{
    addressValue = [NSString stringWithFormat:@"%@ %@",provinceTxt, cityTxt];
    [BackView removeFromSuperview];
    [addressPickView removeFromSuperview];
    [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:7 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        NSArray *itemArray = dict[@"data"];
        for (int i = 0; i < itemArray.count; i++) {
            [cityArray addObject:itemArray[i]];
        }
        if (cityArray.count > 0) {
            cityCode = cityArray[0][@"Code"];
            cityId = cityArray[0][@"Id"];
            cityTxt = cityArray[0][@"Name"];
        }
        [addressPickView selectRow:0 inComponent:1 animated:true];
        [addressPickView reloadComponent:1];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 70;
    }else if (indexPath.row == 5){
        return 20;
    }else if (indexPath.row == 4){
        return 0;
    }else{
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    for (UIView *itemView in cell.contentView.subviews) {
        [itemView removeFromSuperview];
    }
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // photoLbl
        UILabel *photoLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, (CGRectGetMaxY(cell.frame) - 21) / 2, 40, 21)];
        photoLbl.text = @"头像";
        [cell.contentView addSubview:photoLbl];
        // photoIv
        UIImageView *photoIv = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 55, 7.5, 55, 55)];
        photoIv.layer.masksToBounds = true;
        photoIv.layer.cornerRadius = 6;
        if (headImage == nil) {
            [photoIv sd_setImageWithURL:[NSURL URLWithString:[Toolkit getStringValueByKey:@"PhotoPath"]] placeholderImage:[UIImage imageNamed:@"default_photo"]];
        }else{
            photoIv.image = headImage;
        }
        [cell.contentView addSubview:photoIv];
    }else if (indexPath.row == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // nameLbl
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 50)];
        nameLbl.textAlignment = NSTextAlignmentLeft;
        nameLbl.text = @"名字";
        [cell.contentView addSubview:nameLbl];
        // nameShowLbl
        UILabel *nameShowLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 200, 0, 200, 50)];
        nameShowLbl.font = [UIFont systemFontOfSize:16];
        nameShowLbl.text = nameValue == nil || [nameValue isEqual:@""] ? @"未填写" : nameValue;
        nameShowLbl.textAlignment = NSTextAlignmentRight;
        nameShowLbl.textColor = [UIColor grayColor];
        [cell.contentView addSubview:nameShowLbl];
    }else if (indexPath.row == 2){
        // wechatNoLbl
        UILabel *wechatNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 50)];
        wechatNoLbl.textAlignment = NSTextAlignmentLeft;
        wechatNoLbl.text = @"IPIC";
        [cell.contentView addSubview:wechatNoLbl];
        // wechatNoShowLbl
        UILabel *wechatNoShowLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 200, 0, 200, 45)];
        wechatNoShowLbl.font = [UIFont systemFontOfSize:16];
        wechatNoShowLbl.text = [Toolkit getStringValueByKey:@"Phone"];
        wechatNoShowLbl.textAlignment = NSTextAlignmentRight;
        wechatNoShowLbl.textColor = [UIColor grayColor];
        [cell.contentView addSubview:wechatNoShowLbl];
    }else if (indexPath.row == 3){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // qrCodeLbl
        UILabel *qrCodeLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
        qrCodeLbl.textAlignment = NSTextAlignmentLeft;
        qrCodeLbl.text = @"我的二维码";
        [cell.contentView addSubview:qrCodeLbl];
        // erweimaIv
        UIImageView *erweimaIv = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 28 - 20, (CGRectGetHeight(cell.frame) - 20) / 2, 20, 20)];
        erweimaIv.image = [UIImage imageNamed:@"erweima"];
        [cell.contentView addSubview:erweimaIv];
    }
//    else if (indexPath.row == 4){
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        // addressLbl
//        UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
//        addressLbl.textAlignment = NSTextAlignmentLeft;
//        addressLbl.font = [UIFont systemFontOfSize:16];
//        addressLbl.text = @"我的地址";
//        [cell.contentView addSubview:addressLbl];
//    }
    else if(indexPath.row == 5){
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    }else if (indexPath.row == 6){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // sexLbl
        UILabel *sexLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 50)];
        sexLbl.textAlignment = NSTextAlignmentLeft;
        sexLbl.text = @"性别";
        [cell.contentView addSubview:sexLbl];
        // sexShowLbl
        UILabel *sexShowLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 200, 0, 200, 50)];
        sexShowLbl.font = [UIFont systemFontOfSize:16];
        sexShowLbl.text = sexValue == nil || [sexValue isEqual:@""] ? @"未填写" : sexValue;
        sexShowLbl.textAlignment = NSTextAlignmentRight;
        sexShowLbl.textColor = [UIColor grayColor];
        [cell.contentView addSubview:sexShowLbl];
    }else if (indexPath.row == 7){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // cityLbl
        UILabel *cityLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 50)];
        cityLbl.textAlignment = NSTextAlignmentLeft;
        cityLbl.text = @"地区";
        [cell.contentView addSubview:cityLbl];
        // cityShowLbl
        UILabel *cityShowLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 200, 0, 200, 50)];
        cityShowLbl.font = [UIFont systemFontOfSize:16];
        cityShowLbl.text = addressValue == nil || [addressValue isEqual:@""] ? @"未填写" : addressValue;
        cityShowLbl.textAlignment = NSTextAlignmentRight;
        cityShowLbl.textColor = [UIColor grayColor];
        [cell.contentView addSubview:cityShowLbl];
    }else if (indexPath.row == 8){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // signLbl
        UILabel *signLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 50)];
        signLbl.textAlignment = NSTextAlignmentLeft;
        signLbl.text = @"个性签名";
        [cell.contentView addSubview:signLbl];
        // signShowLbl
        UILabel *signShowLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 200, 0, 200, 50)];
        signShowLbl.text = signValue == nil || [signValue isEqual:@""] ? @"未填写" : signValue;
        signShowLbl.numberOfLines = 0;
        signShowLbl.font = [UIFont systemFontOfSize:16];
        signShowLbl.textAlignment = NSTextAlignmentRight;
        signShowLbl.textColor = [UIColor grayColor];
        [cell.contentView addSubview:signShowLbl];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = false;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row == 0) {
        [Toolkit actionSheetViewSecond:self andTitle:nil andMsg:nil andCancelButtonTitle:@"取消" andOtherButtonTitle:[NSArray arrayWithObjects:@"拍照", @"从手机相册选择", nil] handler:^(int buttonIndex, UIAlertAction *alertView) {
            if (buttonIndex == 1) {
                // 拍照
                UIImagePickerController *mImagePick = [[UIImagePickerController alloc] init];
                mImagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
                mImagePick.delegate = self;
                mImagePick.allowsEditing = YES;
                [self presentViewController:mImagePick animated:YES completion:nil];
            }else if (buttonIndex == 2){
                // 从相册中选取
                UIImagePickerController *mImagePick = [[UIImagePickerController alloc] init];
                mImagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                mImagePick.delegate = self;
                mImagePick.allowsEditing = YES;
                [self presentViewController:mImagePick animated:YES completion:nil];
            }
        }];
    }else if (indexPath.row == 1) {
        NameViewController *nameVC = [[NameViewController alloc] init];
        nameVC.delegate = self;
        nameVC.nameStr = nameValue;
        [self.navigationController pushViewController:nameVC animated:true];
    }else if (indexPath.row == 3){
        MyErweimaViewController *myErweimaVC = [[MyErweimaViewController alloc] init];
        [self.navigationController pushViewController:myErweimaVC animated:true];
    }else if (indexPath.row == 4){
        MyAddressViewController *myAddressVC = [[MyAddressViewController alloc] init];
        [self.navigationController pushViewController:myAddressVC animated:true];
    }else if (indexPath.row == 6) {
        [Toolkit actionSheetViewSecond:self andTitle:@"选择性别" andMsg:nil andCancelButtonTitle:@"取消" andOtherButtonTitle:[NSArray arrayWithObjects:@"男", @"女", nil] handler:^(int buttonIndex, UIAlertAction *alertView) {
            NSLog(@"%d",buttonIndex);
            sexId = [NSString stringWithFormat:@"%d",buttonIndex];
            if (buttonIndex == 1) {
                sexValue = @"男";
            }else if (buttonIndex == 2){
                sexValue = @"女";
            }
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"UpdateSexCallBack:"];
            [dataProvider editUserInfo:[Toolkit getStringValueByKey:@"Id"] andNickName:[Toolkit getStringValueByKey:@"NickName"] andSex:[NSString stringWithFormat:@"%d",buttonIndex] andHomeAreaId:[Toolkit getStringValueByKey:@"Address"] andDescription:[Toolkit getStringValueByKey:@"Sign"]];
        }];
    }else if (indexPath.row == 7){
        InputAddressViewController *inputAddressVC = [[InputAddressViewController alloc] init];
        inputAddressVC.delegate = self;
        inputAddressVC.addressStr = addressValue;
        [self.navigationController pushViewController:inputAddressVC animated:true];
        
        
//        [self.view addSubview:BackView];
//        [self.view addSubview:addressPickView];
    }else if (indexPath.row == 8){
        SignViewController *signVC = [[SignViewController alloc] init];
        signVC.delegate = self;
        signVC.signStr = signValue;
        [self.navigationController pushViewController:signVC animated:true];
    }
}

-(void)UpdateSexCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [Toolkit setUserDefaultValue:sexId andKey:@"SexId"];
        [Toolkit setUserDefaultValue:sexValue andKey:@"Sex"];
        [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:6 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"error"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *smallImage = [self scaleFromImage:image andSize:CGSizeMake(800, 800)];
    NSData *imageData = UIImagePNGRepresentation(smallImage);
    headImage = smallImage;
    [self changeHeadImage:imageData];
    [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *)scaleFromImage:(UIImage *)image andSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)changeHeadImage:(NSData *) data{
    [Toolkit showWithStatus:@"请稍等..."];
    NSString *imagebase64= [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"uploadPhotoCallBack:"];
    [dataprovider upLoadPhoto:[Toolkit getStringValueByKey:@"Id"] andImgData:imagebase64 andImgName:@"PhotoName.png"];
}

-(void)uploadPhotoCallBack:(id)dict{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        [Toolkit setUserDefaultValue:[NSString stringWithFormat:@"%@%@",Kimg_path,dict[@"date"][@"ImageName"]] andKey:@"PhotoPath"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setHeader" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initData" object:nil];
        RCUserInfo *userInfo = [RCIM sharedRCIM].currentUserInfo;
        userInfo.portraitUri = [NSString stringWithFormat:@"%@%@",Kimg_path,dict[@"date"][@"ImageName"]];
        [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:[Toolkit getStringValueByKey:@"Id"]];
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"date"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
}

#pragma mark - pickerView delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return provinceArray.count;
    }else{
        return cityArray.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return provinceArray[row][@"Name"];
    }else{
        return cityArray[row][@"Name"];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"%ld---%ld",(long)component,(long)row);
    if (component == 0) {
        provinceTxt = provinceArray[row][@"Name"];
        provinceCode = provinceArray[row][@"Code"];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getInitCityCallBack:"];
        [dataProvider getCityByProvince:provinceCode];
    }else{
        cityId = cityArray[row][@"Id"];
        cityCode = cityArray[row][@"Code"];
        cityTxt = cityArray[row][@"Name"];
    }
}

-(void)getSign:(NSString *)signStr{
    signValue = signStr;
    [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:8 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)getName:(NSString *)nameStr{
    nameValue = nameStr;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setHeader" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initData" object:nil];
    [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)getAddress:(NSString *)addressStr{
    addressValue = addressStr;
    [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:7 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
