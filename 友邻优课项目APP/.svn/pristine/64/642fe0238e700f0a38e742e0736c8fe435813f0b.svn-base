/**
 * 用户信息请求
 */
'use strict'
import {
    NativeModules
} from 'react-native'

var YLYKUserServiceModule = NativeModules.YLYKUserServiceModule;

export default {
  getUserHotList:YLYKUserServiceModule.getUserHotList,//获取推荐用户列表
  getUserById:YLYKUserServiceModule.getUserById,//获取指定用户的信息
  updateUser:YLYKUserServiceModule.updateUser,//修改指定用户的信息
  updateUserAvatar:YLYKUserServiceModule.updateUserAvatar,//获取指定用户的头像
  updateUserMobilephone:YLYKUserServiceModule.updateUserMobilephone,//验证码:修改指定用户的绑定手机
  updateUserMobilephoneWithCaptcha:YLYKUserServiceModule.updateUserMobilephoneWithCaptcha,//修改指定用户的绑定手机
  updateUserDealer:YLYKUserServiceModule.updateUserDealer,//修改指定用户的代言人
  getUserTraceById:YLYKUserServiceModule.getUserTraceById,//获取指定用户的收听记录
  getUserTaskById:YLYKUserServiceModule.getUserTaskById,//获取指定用户的任务
}
