'use strict'
/**
 * 小答应信息
 */
import {
    NativeModules
} from 'react-native'

var YLYKXdyServiceModule = NativeModules.YLYKXdyServiceModule;

export default {
    getXdyById: YLYKXdyServiceModule.getXdyById //根据小答应id获得信息
}