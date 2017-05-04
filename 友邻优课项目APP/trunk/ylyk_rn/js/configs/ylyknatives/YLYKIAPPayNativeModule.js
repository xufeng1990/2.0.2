/**
 * //退出登录
 */

'use strict'
import {
  NativeModules,
  Platform
} from 'react-native'

var YLYKIAPPayNativeModule = NativeModules.YLYKIAPPayNativeModule;


export default {
  onIAPPay: Platform.OS === 'ios' ? YLYKIAPPayNativeModule.onIAPPay :undefined
}
