'use strict'
/**
 * 关注
 */
import {
    NativeModules
} from 'react-native'

var YLYKFolloweeServiceModule = NativeModules.YLYKFolloweeServiceModule;

export default {
    getFolloweeList: YLYKFolloweeServiceModule.getFolloweeList,//关注列表
    createFollowee: YLYKFolloweeServiceModule.createFollowee,//创建关注
    deleteFollowee: YLYKFolloweeServiceModule.deleteFollowee,//取消关注
}