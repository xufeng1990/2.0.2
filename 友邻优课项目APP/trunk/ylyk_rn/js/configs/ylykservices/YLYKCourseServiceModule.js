'use strict'
/**
 * 课程信息
 */
import {
    NativeModules
} from 'react-native'

var YLYKCourseServiceModule = NativeModules.YLYKCourseServiceModule;

export default {
    getCourseList: YLYKCourseServiceModule.getCourseList,//获得课程列表
    getCourseById: YLYKCourseServiceModule.getCourseById,//根据id获得课程信息
    likeCourse: YLYKCourseServiceModule.likeCourse,// 点赞课程
    unlikeCourse: YLYKCourseServiceModule.unlikeCourse,//取消点赞
}