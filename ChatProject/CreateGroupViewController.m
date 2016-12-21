//
//  CreateGroupViewController.m
//  ChatProject
//
//  Created by Rain on 12/18/16.
//  Copyright © 2016 zykj. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "ChatRoomViewController.h"

@interface CreateGroupViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    NSString *currentTeamId;
    UIImageView *groupIv;
    NSData *imageData;
    UITextField *groupNameTxt;
}

@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"完善信息"];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"确定"];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

-(void)clickRightButton:(UIButton *)sender{
    
    if (imageData == nil) {
        [Toolkit showErrorWithStatus:@"请选择一张群图片"];
        return;
    }
    
    if ([groupNameTxt.text isEqual:@""]) {
        [Toolkit showErrorWithStatus:@"请填写群组名称"];
        return;
    }
    
    [Toolkit showWithStatus:@"请稍等..."];
    NSString *imagebase64= [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"uploadPhotoCallBack:"];
    [dataprovider upLoadPhoto:[Toolkit getStringValueByKey:@"Id"] andImgData:imagebase64 andImgName:@"PhotoName.png"];
}

-(void)uploadPhotoCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        [Toolkit showWithStatus:@"加载中..."];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"createGroupCallBack:"];
        [dataProvider createGroup:[Toolkit getUserID] andIdList:@"0" andImagePath:dict[@"date"][@"ImageName"] andTeamName:groupNameTxt.text];
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"error"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
}

-(void)createGroupCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        currentTeamId = [NSString stringWithFormat:@"%@",dict[@"data"][@"TeamId"]];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"yaoqingCallBack:"];
        [dataProvider yaoQing:self.selectFriendStr andTeamId:currentTeamId];
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"error"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
}

-(void)yaoqingCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        // 刷新会话列表页面
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"getGroupFunc" object:nil];
        
        //显示聊天会话界面
        ChatRoomViewController *chat = [[ChatRoomViewController alloc] init];
        chat.iFlag = @"5";
        chat.conversationType = ConversationType_GROUP;
        chat.targetId = currentTeamId;
        chat.title = groupNameTxt.text;
        [self.navigationController pushViewController:chat animated:YES];
    }
}

// UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *smallImage = [self scaleFromImage:image andSize:CGSizeMake(500, 500)];
    imageData = UIImagePNGRepresentation(smallImage);
    groupIv.image = smallImage;
//    [self changeHeadImage:imageData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *)scaleFromImage:(UIImage *)image andSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)clickImageEvent{
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
}

-(void)initView{
    // groupIv
    groupIv = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100 ) / 2, Header_Height + 20, 100, 100)];
    groupIv.image = [UIImage imageNamed:@"users32"];
    [self.view addSubview:groupIv];
    groupIv.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageEvent)];
    [groupIv addGestureRecognizer:tap];
    
    // groupNameLbl
    UILabel *groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(groupIv.frame) + 40, 85, 21)];
    groupNameLbl.text = @"群组名称：";
    [self.view addSubview:groupNameLbl];
    // groupNameTxt
    groupNameTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(groupNameLbl.frame) + 5, CGRectGetMaxY(groupIv.frame) + 40, SCREEN_WIDTH - CGRectGetMaxX(groupNameLbl.frame) - 5, 21)];
    groupNameTxt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    groupNameTxt.placeholder = @"请输入群组名称";
    [self.view addSubview:groupNameTxt];
}

@end
