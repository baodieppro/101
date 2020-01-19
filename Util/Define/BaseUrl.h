//
//  BaseUrl.h
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/6/19.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#ifndef BaseUrl_h
#define BaseUrl_h

#define HEADERS_token(str) [NSString stringWithFormat:@"Bearer %@",str]


//以下为举例宏
//主要的url宏
#define URL_Tag_  3

//HTTPS请求地址
#define URLHTTPSDEBUG URL_Tag_

//正式环境
#if URLHTTPSDEBUG == 1
#define __kBase_Https_Url__    [HostTool fl_serverHost]

//测试环境
#elif URLHTTPSDEBUG == 2
#define __kBase_Https_Url__    @"http://192.168.100.16:81"

//海外环境
#elif URLHTTPSDEBUG == 3
#define __kBase_Https_Url__    @"https://service.test.qiyiyeye.com"

//思文测试环境
#elif URLHTTPSDEBUG == 4
#define __kBase_Https_Url__    @"http://192.168.100.16:81"

#endif
//============================================ API =====================================================
#define URLHTTPSDEBUG URL_Tag_

#if URLHTTPSDEBUG == 3

#define __Api_customer__    @"api/customer"//!<消费端

#define __Api_merchant__    @"api/merchant" //!<商户端

#elif URLHTTPSDEBUG == 2

#define __Api_customer__    @"8810"//!<消费端

#define __Api_merchant__    @"8802" //!<商户端

#elif URLHTTPSDEBUG == 4

#define __Api_customer__    @"api/customer"//!<消费端

#define __Api_merchant__    @"api/merchant" //!<商户端
#endif
//============================================ API customer =====================================================

#define __API_Register_post__                       @"auth/register"//!<注册

#define __API_smsCode_post__                        @"smsCode" //!<验证码

#define __API_password_post__                       @"auth/password" //!<修改密码

#define __API_login_post__                          @"auth/login" //!<登录

#define __API_IndustryList_get__                    @"industry/list?enabled=true"//!<行业

#define __API_country_get__                         @"geo/list/country" //!<国家

#define __API_province_get__                        @"geo/list/province" //!<省

#define __API_city_get__                            @"geo/list/city" //!<市

#define __API_county_get__                          @"geo/list/county" //!<区

#define __API_Apply_get__                           @"merchantApply" //!<get 请求申请详情

#define __API_Apply_NO_AUDIT_post__                  @"trader/merchantApply" //!<商户申请（不用审核）

#define __API_trader_get__                           @"trader" //!<获取商家信息

#define __API_quantity_post__                        @"order/quantity" //!<订单-[待发货|未付款|已发货]数量

#define __API_agentApply__                           @"agentApply"//代理申请 （get:代理申请详情 post：申请代理）

#define __API_Wxqrcode_post__                        @"rs/kettle/web/wxqrcode/create"//获取二维码

#define __API_new_Wxqrcode_post__                    @"wx/create"//获取二维码

#define __API_traderCorp__                           @"traderCorp"//（get：获工商信息 post：提交工商信息）

#define __API_bankAccount_post__                     @"bankAccount"//（get：获工银行卡信息 post：创建银行卡 put:修改银行卡）

#define __API_bankAccount__                          @"bankAccount/banklist"//（get：获工银行卡信息 ）

#define __API_bankAccount_DEL_                       @"bankAccount/del"//（del：删除银行卡信息 ）

#define __API_bankAccount_put_                       @"bankAccount/binding"//（put：绑定银行卡信息 ）

#define __API_auth_profile__                         @"auth/profile"//（get：获取用户信息  put:修改用户信息）

#define __API_merchantProducts__                     @"merchantProducts"//(get：商户商品列表查询<在售中> post:添加商品到商户货架（上架） )

#define __API_merchantProducts_get__                 @"merchantProducts/del"//(get：从货架移除商品（下架）)

#define __API_supplierProducts_get__                 @"supplierProducts"//(get：供应商商品列表查询<仓库中>)

#define __API_traderAssets_get__                     @"traderAssets"//(get：获取总收益)

#define __API_returnOrder_get__                      @"returnOrder/%@"//(get：退换货详情)


//========================= API merchant =======================


#endif /* BaseUrl_h */
