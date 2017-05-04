'use strict'
/**
 * 老师信息
 */
import {
    NativeModules
} from 'react-native'

var YLYKTeacherServiceModule = NativeModules.YLYKTeacherServiceModule;

export default {
    getTeacherById: YLYKTeacherServiceModule.getTeacherById,//根据老师id获得信息
    getTeacherList: YLYKTeacherServiceModule.getTeacherList,//获得老师列表
}