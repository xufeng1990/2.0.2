
/**
 * YLYKDialogNativeModule（（Anrdoid独占）
 */

'use strict'
import {
    NativeModules,
    Platform
} from 'react-native'

var YLYKDialogNativeModule = NativeModules.YLYKDialogNativeModule;


export default {
    /**
     * 显示dialog
     */
    showDialog: Platform.OS === 'ios' ? undefined :  (YLYKDialogNativeModule ? YLYKDialogNativeModule.showDialog:undefined),
}
