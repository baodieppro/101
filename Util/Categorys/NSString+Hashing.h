

#import <Foundation/Foundation.h>
@interface NSString (NSString_Hashing)

//MD5加密
- (NSString *_Nullable)MD5Hash;
- (nullable NSString *)stringByAddingPercentEncodingWithAllowedCharactersUrl;
+ (NSString *)UrlEncodeUTF8String:(NSString *)urlString;
+ (NSString *)encryptionDisplayMessageWith:(NSString *)content WithFirstIndex:(NSInteger)findex;
-(NSString *)setReplacingString:(NSString *)urlString;
//url汉字处理
+(NSString *)URLDecodedString:(NSString *) str;

@end
