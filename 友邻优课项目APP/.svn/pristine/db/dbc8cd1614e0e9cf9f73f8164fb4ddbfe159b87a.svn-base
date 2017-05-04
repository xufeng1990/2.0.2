
/**
 * 缓存相关的业务（获取占用空间、清理缓存 etc,.）
 */

'use strict'
import {
    NativeModules
} from 'react-native'

var YLYKCacheNativeModule  = NativeModules.YLYKCacheNativeModule ;


export default {
  getDownloadCacheSize:YLYKCacheNativeModule.getDownloadCacheSize,//获得下载的
  getCacheSize:YLYKCacheNativeModule.getCacheSize,//获得缓存
  getTotalCacheSize:YLYKCacheNativeModule.getTotalCacheSize,//总缓存
  clearCache:YLYKCacheNativeModule.clearCache,//除缓存
}
