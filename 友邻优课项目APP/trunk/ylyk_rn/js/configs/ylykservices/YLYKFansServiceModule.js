'use strict'
/**
 * 粉丝信息
 */
import {
    NativeModules
} from 'react-native'

var YLYKFansServiceModule = NativeModules.YLYKFansServiceModule;

export default {
    getFansList: YLYKFansServiceModule.getFansList // 粉丝列表
}