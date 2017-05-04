/**
 * //获取版本号
 */

'use strict'
import {
  NativeModules,
  Platform
} from 'react-native'

var YLYKApplicationNativeModule = NativeModules.YLYKApplicationNativeModule;


export default {
  /**
   * 获取版本号
   */
  getVersion: YLYKApplicationNativeModule.getVersion,
  /**
   * 获取build号
   */
  getBuild: YLYKApplicationNativeModule.getBuild,
  /**
   * 是否在reciew
   */
  getReviewVersion: Platform.OS === 'ios' ? YLYKApplicationNativeModule.getReviewVersion : undefined,
  /**
   * 查询手机总空间大小
   */
  getTotalDiskSize: YLYKApplicationNativeModule.getTotalDiskSize,
  /**
   * 查询手机剩余空间
   */
  freeDiskSpaceInBytes: YLYKApplicationNativeModule.freeDiskSpaceInBytes,
}
