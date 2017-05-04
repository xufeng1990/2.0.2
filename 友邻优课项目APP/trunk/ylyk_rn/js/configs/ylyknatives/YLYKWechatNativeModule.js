/**
 * // 微信相关的业务（打开微信 etc,.）
 */

'use strict'
import {
    NativeModules
} from 'react-native'

var YLYKWechatNativeModule = NativeModules.YLYKWechatNativeModule;

export default {
  goToPay:YLYKWechatNativeModule.goToPay,//支付接口
  openWXApp:YLYKWechatNativeModule.openWXApp,// 打开微信
}
