//
//  InformationViewModel.m
//  Mars
//
//  Created by zhaoqin on 5/10/16.
//  Copyright © 2016 Muggins_. All rights reserved.
//

#import "InformationViewModel.h"
#import "NetworkFetcher+Account.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import "UIImageView+AFNetworking.h"


@interface InformationViewModel ()

@property (nonatomic, strong) AccountDao *accountDao;
@property (nonatomic, strong) Account *account;

@end

@implementation InformationViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _successObject = [RACSubject subject];
        _failureObject = [RACSubject subject];
        _errorObject = [RACSubject subject];
        _accountDao = [[DatabaseManager sharedInstance] accountDao];
        [self initInfo];
    }
    return self;
}

- (void)initInfo {
    if ([_accountDao isExist]) {
        _account = [_accountDao fetchAccount];
        _nickname = _account.nickname;
        _phone = _account.phone;
        _sex = _account.sex;
        _age = _account.age;
        _province = _account.province;
        _city = _account.city;
        _district = _account.district;
        _school = _account.degree;
        [self fetchAvatarFromHome];
    }
}

- (void)commitInfo {
    
    [NetworkFetcher accountUploadInfoWithAvatar:_avatarImage nickname:_nickname phone:_phone sex:_sex age:_age province:_province city:_city district:_district school:_school token:_account.token success:^(NSDictionary *response) {
        
        if ([response[@"code"] isEqualToString:@"200"]) {
            
            [self saveImage:_avatarImage withName:@"avatar.png"];
            [_successObject sendNext:@"修改成功"];
            
        } else {
            [_failureObject sendNext:response[@"msg"]];
        }
        
    } failure:^(NSString *error) {
        [_errorObject sendNext:@"网络异常"];
    }];
}


- (void)signOut {
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    [accountDao deleteAccount];
    [accountDao save];
    
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"avatar.png"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        return;
    }else {
        [fileManager removeItemAtPath:uniquePath error:nil];
    }
}

#pragma mark - 保存图片至沙盒（提交后保存到沙盒,下次直接去沙盒取）
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

- (void)fetchAvatarFromHome {
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.png"];
    _avatarImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
}


@end
