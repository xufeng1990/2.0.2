/**
 * //播放器相关的业务
 */

'use strict'
import {NativeModules, Platform} from 'react-native'

var YLYKPlayerNativeModule = NativeModules.YLYKPlayerNativeModule;

export default {
    isExistPlayedTrace : YLYKPlayerNativeModule.isExistPlayedTrace, // 是否存在播放记录,也是控制右上 gif
    isPlayingOrPause : YLYKPlayerNativeModule.isPlayingOrPause, //是否暂停和播放,也是控制右上 gif

    /**
     *
     * @param {Number}
     * @param {Boolean}
     * @param {Array}
     * @type {[type]}
     */
    openPlayerController : (courseId, isFromNative, arrCourseList) => {
        return YLYKPlayerNativeModule.openPlayerController(courseId + "", isFromNative, JSON.stringify(arrCourseList));
    },

    closeMine: Platform.OS === 'ios' ? undefined : YLYKPlayerNativeModule.closeMine,
}
