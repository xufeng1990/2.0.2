/**
 * //学习轨迹相关的业务
 */

'use strict'
import {
    NativeModules
} from 'react-native'

const YLYKUserTraceNativeModule  = NativeModules.YLYKUserTraceNativeModule;

export default {
  openCalendarViewController:YLYKUserTraceNativeModule.openCalendarViewController,//打开日历
  goToCalendar:YLYKUserTraceNativeModule.goToCalendar,//打开日历
  goToListenTraceWithStartTime:YLYKUserTraceNativeModule.goToListenTraceWithStartTime,// 打开学习轨迹
  getLearnTimeWithStartTime:YLYKUserTraceNativeModule.getLearnTimeWithStartTime,//取学习时间
}
