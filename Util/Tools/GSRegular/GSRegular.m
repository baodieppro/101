//
//  GSRegular.m
//  爷爷网
//
//  Created by 巩小鹏 on 2019/5/6.
//  Copyright © 2019 GrandqaNet. All rights reserved.
//

#import "GSRegular.h"

@implementation GSRegular
    //邮箱
+ (BOOL) justEmail:(NSString *)email
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:email];
    }
    
    
    //手机号码验证
+ (BOOL) justMobile:(NSString *)mobile
    {
        //手机号以13， 15，18 ,17开头，八个 \d 数字字符
//        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$";
        NSString *phoneRegex = @"^(13[0-9]|14[5-9]|15[0-3,5-9]|16[2,5,6,7]|17[0-8]|18[0-9]|19[1,3,5,8,9])\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        return [phoneTest evaluateWithObject:mobile];
    }


/**
 * 手机号码格式验证
 */
+(BOOL)isTelphoneNumber:(NSString *)telNum{
    
    telNum = [telNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([telNum length] != 11) {
        return NO;
    }
    
    /**
     * 中国移动：China Mobile
     *13[4-9],147,148,15[0-2,7-9],165,170[3,5,6],172,178,18[2-4,7-8],19[5,8]
     */
    NSString *CM_NUM = @"^((13[4-9])|(14[7-8])|(15[0-2,7-9])|(165)|(178)|(18[2-4,7-8])|(19[5,8]))\\d{8}|(170[3,5,6])\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,146,155,156,166,167,170[4,7,8,9],171,175,176,185,186
     */
    NSString *CU_NUM = @"^((13[0-2])|(14[5,6])|(15[5-6])|(16[6-7])|(17[1,5,6])|(18[5,6]))\\d{8}|(170[4,7-9])\\d{7}$";
    
    /**
     * 中国电信：China Telecom
     * 133,149,153,162,170[0,1,2],173,174[0-5],177,180,181,189,19[1,3,9]
     */
    NSString *CT_NUM = @"^((133)|(149)|(153)|(162)|(17[3,7])|(18[0,1,9])|(19[1,3,9]))\\d{8}|((170[0-2])|(174[0-5]))\\d{7}$";
    
    NSPredicate *pred_CM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM_NUM];
    NSPredicate *pred_CU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU_NUM];
    NSPredicate *pred_CT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT_NUM];
    BOOL isMatch_CM = [pred_CM evaluateWithObject:telNum];
    BOOL isMatch_CU = [pred_CU evaluateWithObject:telNum];
    BOOL isMatch_CT = [pred_CT evaluateWithObject:telNum];
    if (isMatch_CM || isMatch_CT || isMatch_CU) {
        return YES;
    }
    
    return NO;
}
    //车牌号验证
+ (BOOL) justCarNo:(NSString *)carNo
    {
        NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
        NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
        //    NSLog(@"carTest is %@",carTest);
        return [carTest evaluateWithObject:carNo];
    }
    
    
    //车型
+ (BOOL) justCarType:(NSString *)CarType
    {
        NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
        NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
        return [carTest evaluateWithObject:CarType];
    }
    
    
    //用户名
+ (BOOL) justUserName:(NSString *)name
    {
        NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
        NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
        BOOL B = [userNamePredicate evaluateWithObject:name];
        return B;
    }
    
    
    //密码
+ (BOOL) justPassword:(NSString *)passWord
    {
        NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
        return [passWordPredicate evaluateWithObject:passWord];
    }
    
    
    //昵称
+ (BOOL) justNickname:(NSString *)nickname
    {
        NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
        return [passWordPredicate evaluateWithObject:nickname];
    }
    
    
    //身份证号
+ (BOOL) justIdentityCard: (NSString *)identityCard
    {
        BOOL flag;
        if (identityCard.length <= 0) {
            flag = NO;
            return flag;
        }
        NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        return [identityCardPredicate evaluateWithObject:identityCard];
    }
    
    //^[\u4e00-\u9fa5]{0,}$
    //汉字
+ (BOOL) justChineseCharacter:(NSString *)Chinese
    {
        NSString *ChineseCharacterRegex = @"^[\u4e00-\u9fa5]{0,}$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ChineseCharacterRegex];
        return [passWordPredicate evaluateWithObject:Chinese];
    }
    //网址URL
    
    
+ (BOOL) justURlSite:(NSString *)urlSite
    {
        //    NSString *urlSiteRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        NSString *urlSiteRegex = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-,!+#]*)?";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlSiteRegex];
        return [passWordPredicate evaluateWithObject:urlSite];
    }
    //IP
+ (BOOL) justIP:(NSString *)ip
    {
        NSString *IP = @"^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",IP];
        return [passWordPredicate evaluateWithObject:ip];
    }
    //匹配流量ID
+ (BOOL) justFromID:(NSString *)fid
    {
        NSString *IP = @"(from=)(([a-zA-Z0-9])*)";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",IP];
        return [passWordPredicate evaluateWithObject:fid];
    }
    
    //自定义 正则匹配
+ (BOOL) justWithInitRegularly:(NSString *)Regularly Str:(NSString *)str
    {
        //    NSString *IP = @"(from=)(([a-zA-Z0-9])*)";
        //    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regularly];
        //    return [passWordPredicate evaluateWithObject:str];
        //根据正则表达式设定OC规则
        
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:Regularly options:NSRegularExpressionCaseInsensitive error:nil];
        
        //获取匹配结果
        
        NSArray *results = [regular matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        
        NSLog(@"%@",results);
        
        //遍历结果
        
        for (NSTextCheckingResult *result in results) {
            
            NSLog(@"%@ %@",NSStringFromRange(result.range),[str substringWithRange:result.range]);
            if (result.range.length > 0) {
                return YES;
            }
        }
        return NO;
        
    }

+ (BOOL)checkIsChinese:(NSString *)string{
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}

@end
