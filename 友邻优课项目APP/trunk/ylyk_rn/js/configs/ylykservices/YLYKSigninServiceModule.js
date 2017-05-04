'use strict'
/**
 * 打卡记录
 */

import {
    NativeModules
} from 'react-native'

var YLYKSigninServiceModule = NativeModules.YLYKSigninServiceModule;

export default {
    createSignin: YLYKSigninServiceModule.createSignin,// 创建打卡
    getSigninCalendar: YLYKSigninServiceModule.getSigninCalendar // 获得打卡记录
}