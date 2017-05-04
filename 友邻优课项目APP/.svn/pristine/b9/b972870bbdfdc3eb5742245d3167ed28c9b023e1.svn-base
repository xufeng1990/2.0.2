/*
 * 网络请求接口
 */

import React, {Component} from 'react';
import {
    NativeModules,
    Platform,
} from 'react-native';
var isIos = Platform.OS === 'ios';
export default {
    //网络请求接口
    loginServer: NativeModules.BridgeNative,
    loginHomeServer: NativeModules.CourseViewController,
    service: NativeModules.NativeNetwork,
    //通用请求接口
    publicService: isIos ? NativeModules.NativeNetwork : NativeModules.YLRequestModule,
    storage: NativeModules.Storage,
}
