'use strict'
import {NativeModules, Platform, DeviceEventEmitter} from 'react-native';
import g_AppValue from './AppGlobal.js';

/*
 所有跟原生交互的方法都在这，原生那有什么注释不清晰的，直接看这里的注释就知道是什么事件了
 */
//登陆跳转
export async function goToLoginView(message) {
    if (Platform.OS == 'ios') {
        return await NativeModules.CourseViewController.openPlayerController(message)
    } else {
        NativeModules.IntentModule.tartActivityFromJS("com.zhuomogroup.ylyk.activity.YLLoginActivity", "")
    }
}
//退出登陆
export function goToLoginOutView() {
    NativeModules.BridgeNative.logout();
}
//跳转播放页面
export function goToPlayerView(massage, is, is2) {
    is2 = JSON.stringify(is2)
    if (Platform.OS === 'ios') {
        is = JSON.stringify(is)
        NativeModules.CourseViewController.openPlayerController(massage, is, is2);
    } else {
        NativeModules.IntentModule.startAudioPlay(massage, is, is2);
    }
}
//加载菊花圈
export function loadingViewAddToView() {
    if (Platform.OS == 'ios') {
        NativeModules.loadingViewAddToView();
    }
}
//隐藏菊花圈
export function hideLoadingView() {
    if (Platform.OS == 'ios') {
        NativeModules.hideLoadingView();
    }
}
//隐藏tabbar
export function hideTabBar(res) {
    if (Platform.OS === 'ios') {
        NativeModules.BridgeNative.showOrHideTabbar(res);
    } else {
        NativeModules.IntentModule.showOrHideTabbar(res);
    }
}
export async function androidIsHaveBar() {
    return await NativeModules.IntentModule.androidIsHaveBar();
}
//获取版本号 - build
export async function getBuild() {
    if (Platform.OS === 'ios') {
        return await NativeModules.BridgeNative.getBuild();
    } else {
        return await NativeModules.SettingModule.getVersionCode();
    }
}
// 获取版本号 -2.0.2
export async function getVersion() {
    if (Platform.OS === 'ios') {
        return await NativeModules.BridgeNative.getVersion();
    } else {
        return await NativeModules.SettingModule.getVersionName();
    }
}
//打开 修改手机 页面
export async function mobilePhone(phoneNum) {
    if (Platform.OS === 'ios') {
        return await NativeModules.BridgeNative.changeBandPhoneNumber();
    } else {
        return await NativeModules.IntentModule.startActivityFromJS("com.zhuomogroup.ylyk.activity.YLTelephoneChangeActivity", "{}")
    }
}
//获取缓存大小
export async function getCacheSize() {
    if (Platform.OS === 'ios') {
        return await NativeModules.BridgeNative.getCacheSize();
    } else {
        var cacheSize = await NativeModules.SettingModule.getCacheSize();
        return cacheSize;
    }
}
//获取总的存储空间
export async function getTotalMemery() {
    if (Platform.OS === 'ios') {
        return await NativeModules.BridgeNative.getTotalDiskSize();
    } else {
    }
}
//获取可用空间大小
export async function getEableMemery() {
    if (Platform.OS === 'ios') {
        return await NativeModules.BridgeNative.freeDiskSpaceInBytes()
    } else {
    }
}
//清理缓存
export function clearCache() {
    if (Platform.OS === 'ios') {
        NativeModules.BridgeNative.clearCache();
    } else {
        NativeModules.SettingModule.clearCache();
    }
}
//获取下载队列
export async function getDownloadList(courseList) {
    let data = JSON.stringify(courseList);
    if (Platform.OS === 'ios') {
        var list = await NativeModules.DownloadManager.getDownloadList();
        return list;
    } else {
        var list = await NativeModules.DownLoad.getDownloadList();
        return list;
    }
}
//删除下载
export async function deleteDownload(courseIdList) {
    let data = JSON.stringify(courseIdList);
    if (Platform.OS === 'ios') {
        return await NativeModules.DownloadManager.deleteDownload(data, true);
    } else {
        return await NativeModules.DownLoad.deleteDownload(data, true);
    }
}
//开始下载
export async function startDownload(courseList) {
    let data = JSON.stringify(courseList);
    if (Platform.OS === 'ios') {
        return await NativeModules.DownloadManager.startDownload(data);
    } else {
        return await NativeModules.DownLoad.startDownload(data);
    }
}
//暂停下载
export function pauseDownload(courseList) {
    let data = JSON.stringify(courseList);
    if (Platform.OS === 'ios') {
        return NativeModules.DownloadManager.pauseDownload(data);
    } else {
        return NativeModules.DownLoad.pauseDownload(data);
    }
}
//获取个人信息
export async function getUserInfo() {
    if (Platform.OS === 'ios') {
        return await NativeModules.BridgeNative.getUserInfo();
    } else {
        return await NativeModules.Storage.getItem("USER_INFO");
    }
}
//打开微信
export function openWX() {
    if (Platform.OS === 'ios') {
        NativeModules.BridgeNative.openWXApp();
    } else {
        return NativeModules.IntentModule.openWXApp();
    }
}
//咨询小答应
export function goToQiYu() {
    NativeModules.BridgeNative.goToQiyu();
}
//保存图片
export async function saveImage(str) {
    return await NativeModules.Storage.saveImage(str);
}
//搜索
export function searchView() {
    NativeModules.BridgeNative.goToSearchView();
}
//日历
export function canlderView() {

    NativeModules.BridgeNative.goToCalendar();
}
//学习轨迹
export function goToListenTraceWithStartTime(start_time) {

    NativeModules.BridgeNative.goToListenTraceWithStartTime(start_time);
}
//支付
export async function goToPay(payment) {
    let meg = {
        goods_id: payment.goodsId,
        count: payment.count,
        channel: payment.channel
    }
    return await NativeModules.BridgeNative.goToPay(meg);
}
//支付
export function goToIAPPay() {
    return NativeModules.IAPPay.onIAPPay();
}
/**
 * 获取指定日期的学习时长
 * @param  {Number} startTime [description]
 * @param  {Number} endTime   [description]
 * @return {Promise}           [description]
 */
export async function getLearnTimeWithStartTime(startTime, endTime) {
    return await NativeModules.BridgeNative.getLearnTimeWithStartTime(startTime + "", endTime + "");
}

//获取AppStore审核中版本号

export async function getReviewVersion() {
    return await NativeModules.BridgeNative.getReviewVersion();
}
//原生打开的页面返回原生
export function NoteListViewController() {
    if (Platform.OS === "ios") {
        return NativeModules.NoteListViewController.popToViewController();
    } else {
        return NativeModules.IntentModule.closeMine();
    }
}
export async function isExistPlayedTrace() {
    return await NativeModules.BridgeNative.isExistPlayedTrace();
}
