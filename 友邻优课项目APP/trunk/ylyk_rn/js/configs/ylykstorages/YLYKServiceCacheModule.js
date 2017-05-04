
/**
 * 获得本地数据缓存方法
 */
'use strict'

import {
    NativeModules
} from 'react-native'

var YLYKServiceCacheModule = NativeModules.YLYKServiceCacheModule;


export default {
    getCacheAlbumList: YLYKServiceCacheModule.getCacheAlbumList,//获得专辑列表缓存
    getCacheNoteList: YLYKServiceCacheModule.getCacheNoteList,//获得新的列表缓存
    getCacheBannerList: YLYKServiceCacheModule.getCacheBannerList,//获得轮播图列表缓存
    getCacheAlbumById: YLYKServiceCacheModule.getCacheAlbumById,//根据专辑id获得缓存
    getCacheCourseList: YLYKServiceCacheModule.getCacheCourseList,//获得课程列表缓存
    getAuthorization: YLYKServiceCacheModule.getAuthorization,//获得验证缓存
}