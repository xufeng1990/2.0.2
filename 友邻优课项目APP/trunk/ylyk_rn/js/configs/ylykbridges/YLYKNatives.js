

'use strict'

import {
    Platform
} from 'react-native'
import YLYKCacheNativeModule from '../ylyknatives/YLYKCacheNativeModule.js'
import YLYKDialogNativeModule from '../ylyknatives/YLYKDialogNativeModule.js'
import YLYKDownloadNativeModule from '../ylyknatives/YLYKDownloadNativeModule.js'
import YLYKLoadingNativeModule from '../ylyknatives/YLYKLoadingNativeModule.js'
import YLYKLoginNativeModule from '../ylyknatives/YLYKLoginNativeModule.js'
import YLYKPlayerNativeModule from '../ylyknatives/YLYKPlayerNativeModule.js'
import YLYKQiyuNativeModule from '../ylyknatives/YLYKQiyuNativeModule.js'
import YLYKSearchNativeModule from '../ylyknatives/YLYKSearchNativeModule.js'
import YLYKUserTraceNativeModule from '../ylyknatives/YLYKUserTraceNativeModule.js'
import YLYKWechatNativeModule from '../ylyknatives/YLYKWechatNativeModule.js'
import YLYKApplicationNativeModule from '../ylyknatives/YLYKApplicationNativeModule.js'
import YLYKTabbarNativeModule from '../ylyknatives/YLYKTabbarNativeModule.js'
import YLYKOAuthModule from '../ylyknatives/YLYKOAuthModule.js'
import YLYKIAPPayNativeModule from '../ylyknatives/YLYKIAPPayNativeModule.js'
import YLYKBugoutNativeModule from '../ylyknatives/YLYKBugoutNativeModule.js'
import YLYKImagePickerModule from '../ylyknatives/YLYKImagePickerModule.js'
import YLYLScreenChangeNativeModule from '../ylyknatives/YLYLScreenChangeNativeModule.js'
import YLYKListenedAlbumNativeModule from '../ylyknatives/YLYKListenedAlbumNativeModule.js'


export default {
    /**
     * 缓存相关的业务（获取占用空间、清理缓存 etc,.）
     */
    $cache: YLYKCacheNativeModule,

    /**
     * YLYKDialogNativeModule（（Anrdoid独占）
     */
    $dialog: Platform.OS === 'ios' ? undefined : YLYKDialogNativeModule,
    /**
     * Android独有
     */
    $loading: YLYKLoadingNativeModule,
    /**
     * //登陆
     */
    $login: YLYKLoginNativeModule,
    /**
     * //播放器相关的业务
     */
    $player: YLYKPlayerNativeModule,
    /**
     * //七鱼相关的业务
     */
    $qiyu: YLYKQiyuNativeModule,
    /**
     * //搜索相关的业务
     */
    $search: YLYKSearchNativeModule,

    /**
     * //学习轨迹相关的业务
     */
    $userTrace: YLYKUserTraceNativeModule,

    /**
     * // 微信相关的业务（打开微信 etc,.）
     */

    $wechat: YLYKWechatNativeModule,
    /**
     * //下载相关的业务
     */
    $download: YLYKDownloadNativeModule,

    /**
     * //获取版本号
     */
    $application: YLYKApplicationNativeModule,

    /**
     * //隐藏tabbar
     */
    $showOrHideTabbar: YLYKTabbarNativeModule,

    /**
    * 验证控制 退出登录等
    */
    $oauth: YLYKOAuthModule,

    $IAPPay: YLYKIAPPayNativeModule,
    /**
    * 摇一摇反馈
    */
   $shake:YLYKBugoutNativeModule,
   /**
   * 上传头像
   */
  $photo:YLYKImagePickerModule,
  /**
  * 获取横竖屏
  */
 $screen:YLYLScreenChangeNativeModule,
 /**
 * 最近听过的专辑
 */
$listenedAlbum:YLYKListenedAlbumNativeModule,
}
