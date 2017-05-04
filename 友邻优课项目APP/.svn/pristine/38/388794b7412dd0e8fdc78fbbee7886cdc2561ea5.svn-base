/**
 * //下载相关的业务
 */

'use strict'
import {
    NativeModules
} from 'react-native'

var YLYKDownloadNativeModule   = NativeModules.YLYKDownloadNativeModule ;


export default {
  getDownloadList:YLYKDownloadNativeModule.getDownloadList,//获取下载列表
  startDownload: (str)=>{
  return  YLYKDownloadNativeModule.startDownload(JSON.stringify(str));
},
  //开始下载
  pauseDownload:(str)=>{
  return YLYKDownloadNativeModule.pauseDownload(JSON.stringify(str));
},//暂停
  deleteDownload:(str,isFromNative)=>{
  return YLYKDownloadNativeModule.deleteDownload(JSON.stringify(str),isFromNative);
},//删除
}
