/**
 * //七鱼相关的业务
 */

'use strict'
import {
    NativeModules
} from 'react-native'

var YLYKQiyuNativeModule  = NativeModules.YLYKQiyuNativeModule;


export default {
  goToQiyu:YLYKQiyuNativeModule.goToQiyu,//七鱼
}
