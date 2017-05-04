
/**
 * 摇一摇反馈
 */

'use strict'
import {
    NativeModules
} from 'react-native'

var YLYKBugoutNativeModule  = NativeModules.YLYKBugoutNativeModule ;


export default {
  openOrCloseBugoutFeedBack:YLYKBugoutNativeModule.openOrCloseBugoutFeedBack,//控制开关
  bugoutFeedbackState:YLYKBugoutNativeModule.bugoutFeedbackState,

}
