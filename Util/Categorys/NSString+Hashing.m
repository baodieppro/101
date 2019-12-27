

#import "NSString+Hashing.h"
#import <CommonCrypto/CommonDigest.h>
#import "GSRegular.h"
@implementation NSString (NSString_Hashing)

- (NSString *)MD5Hash
{
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, strlen(cStr), result);
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]];
}
- (nullable NSString *)stringByAddingPercentEncodingWithAllowedCharactersUrl{
    NSString *charactersToEscape = @"`#%^{}\"[]|\\<> ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
       return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];;
}
+(NSString *)UrlEncodeUTF8String:(NSString *)urlString{
    NSString *encodedUrlString;
    //            NSString * comUrlStr;
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)
    {
        encodedUrlString = [encodedUrlString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        encodedUrlString = [encodedUrlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        encodedUrlString = [urlString stringByAddingPercentEncodingWithAllowedCharactersUrl];
        
    }else{
        encodedUrlString = [urlString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        encodedUrlString = [encodedUrlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        encodedUrlString = [encodedUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    GSLog(@"encodedUrlString %@",encodedUrlString);
    return encodedUrlString;
}
+ (NSString *)encryptionDisplayMessageWith:(NSString *)content WithFirstIndex:(NSInteger)findex
{
    if (kStringIsEmpty(content)) {
        return @"";
    }
    if (findex <= 0) {
        findex = 2;
    }else if (findex + findex > content.length) {
        findex --;
    }
    return [NSString stringWithFormat:@"%@****%@",[content substringToIndex:findex],[content substringFromIndex:content.length - findex]];
   
}
-(NSString *)setReplacingString:(NSString *)urlString{
    NSString *encodedUrlString;
    //            NSString * comUrlStr;
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)
    {
        encodedUrlString = [encodedUrlString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        encodedUrlString = [encodedUrlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        encodedUrlString = [encodedUrlString stringByReplacingOccurrencesOfString:@" " withString:@""];

    }else{
        encodedUrlString = [urlString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        encodedUrlString = [encodedUrlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        encodedUrlString = [encodedUrlString stringByReplacingOccurrencesOfString:@" " withString:@""];

    }
    
    GSLog(@"encodedUrlString %@",encodedUrlString);
    return encodedUrlString;
}

+(NSString *)URLDecodedString:(NSString *) str{
    NSString *headImgURL;
    if ([GSRegular checkIsChinese:str]) {
        headImgURL = [NSString UrlEncodeUTF8String:str];
    }else{
        headImgURL = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    }
    
    return headImgURL;
}

@end
