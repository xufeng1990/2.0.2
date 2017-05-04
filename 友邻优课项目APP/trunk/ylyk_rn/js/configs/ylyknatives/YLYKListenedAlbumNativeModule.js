'use strict'
/**
 * 最近听过的专辑
 */
import {
    NativeModules
} from 'react-native'

var YLYKListenedAlbumNativeModule = NativeModules.YLYKListenedAlbumNativeModule;

export default {
    getListenAlbumList: YLYKListenedAlbumNativeModule.getListenAlbumList,

}
