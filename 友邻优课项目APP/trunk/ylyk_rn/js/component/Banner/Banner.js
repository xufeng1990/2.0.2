CachedImage//  "banner"
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, {Component} from 'react';
import {
    Text,
    View,
    Image,
    TextInput,
    ScrollView,
    ListView,
    StyleSheet,
    TouchableOpacity,
    TouchableHighlight,
    TouchableWithoutFeedback,
    Alert,
    Platform,
    NativeModules,
    NativeEventEmitter
} from 'react-native';
//configs
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js';
import YLYKStorages from '../../configs/ylykbridges/YLYKStorages.js';
import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js';
import g_AppValue from '../../configs/AppGlobal.js';
//pages
import BannerTypeReDdirect from './BannerTypeReDdirect.js';
import AlbumDetails from '../../pages/Course/AlbumDetails/AlbumDetails.js';
//组件
import Swiper from 'react-native-swiper';
import ViewPager from 'react-native-viewpager';
import CachedImage from 'react-native-cached-image';

const CACHE_KEY = "__CACHE_HOME_2_BANNERS";
var count = 0;

//登陆监听
var LoginEvents = NativeModules.LoginEvent;
const myLoginEvent = new NativeEventEmitter(LoginEvents);
var loginSubscription;
//退出登录成功
var LogoutEvents = NativeModules.LogoutEvent;
const myLogoutEvent = new NativeEventEmitter(LogoutEvents);
var logoutSubscription;

//支付成功
var PaySuccessEvents = NativeModules.PayEvent;
const myPaySuccessEvents = new NativeEventEmitter(PaySuccessEvents);
var paySuccessSubscription;
export default class Banner extends Component {
    _currentPage = 0;
    _MayAdsArray = [];
    constructor(props) {
        super(props);
        this.HaveAds = true,
            this.isLoop = true,
            this.state = {
                //有广告
                HaveAds: true,
                isLoop: true,
                bannerData: this._MayAdsArray
            };
    }
    componentWillMount() {
        let that = this;
        YLYKStorages.$keyValueStorage.getItem(CACHE_KEY).then(function (data) {
            that._MayAdsArray = JSON.parse(data);
            that.setState({
                HaveAds: this._MayAdsArray.length > 0,
                isLoop: this._MayAdsArray.length > 1,
                bannerData: this._MayAdsArray
            });
        });
        //登陆成功监听
        this.loginSubscription = myLoginEvent.addListener('LoginSuccess', (reminder) => {
            this._getBannerData();
        });
        this.logoutSubscription = myLogoutEvent.addListener('LogoutSuccess', (reminder) => {
            if (reminder.LogoutSuccess) {
                this._getBannerData();
            }
        })
        this.paySuccessSubscription = myPaySuccessEvents.addListener('PayEvent', (reminder) => {
            if (reminder.PaySuccess) {
                this._getBannerData();
            }
        })
    }
    // view卸载
    componentWillUnmount() {
        //
        this.loginSubscription && this.loginSubscription.remove();
        this.logoutSubscription && this.logoutSubscription.remove();
        this.paySuccessSubscription && this.paySuccessSubscription.remove();
    }
    // 加载完成
    componentDidMount() {
        this._getBannerData();
    }
    _getBannerData() {
        YLYKServices.$banner.getBannerList()
            .then((data) => {
                // console.log('banner数据' + data)
                var adsArray = JSON.parse(data);
                this._MayAdsArray = [];
                for (var i = 0; i < adsArray.length; i++) {
                    this._MayAdsArray.push(adsArray[i]);
                }
                this.setState({bannerData: this._MayAdsArray});
                  YLYKStorages.$keyValueStorage.setItem(CACHE_KEY, data);
            }).catch((err) => {
            console.warn('数据err', err);
        });
    }
    _goToPage(data, i) {
        if (data[i].type_id === 1 || data[i].type_id === '1') {
              YLYKNatives.$player.openPlayerController(data[i].redirect_to, false, '[]');

        }
        else if (data[i].type_id === 2 || data[i].type_id === '2') {
            YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
            this.props.navigator.push({
                component: AlbumDetails,
                params: {
                    album: data[i].redirect_to,
                }
            })
        }
        else if (data[i].type_id === 12 || data[i].type_id === '12') {
            YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
            this.props.navigator.push({
                component: BannerTypeReDdirect,
                params: {
                    url: data[i].redirect_to,
                }
            })
        }
        else if (data[i].type_id === 11 || data[i].type_id === '11') {
            return;
        }
    }

    _goToPages(data) {
        if (data.type_id === 1 || data.type_id === '1') {
            YLYKNatives.$player.openPlayerController(data.redirect_to, false, '[]');

        }
        else if (data.type_id === 2 || data.type_id === '2') {
              YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
            this.props.navigator.push({
                component: AlbumDetails,
                params: {
                    album: data.redirect_to,
                }
            })
        }
        else if (data.type_id === 12 || data.type_id === '12') {
              YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
            this.props.navigator.push({
                component: BannerTypeReDdirect,
                params: {
                    url: data.redirect_to,
                }
            })

        }
        else if (data[i].type_id === 11 || data[i].type_id === '11') {
            return;
        }
    }
    _renderPageIOS(data) {
        return data.map((value, i) => {
            return (
                <View style={{flex: 1}}>
                    <TouchableHighlight onPress={() => {this._goToPage(data,i)}}>
                        <CachedImage defaultSource={require('../../imgs/169.png')} source={{uri:value.banner_url}}
                                     style={styles.bannerView}/>
                    </TouchableHighlight>
                </View>
            );
        })
    }
    _renderpageAndroid(data) {
        return (
            <View style={{
                flex: 1
            }}>
                <TouchableHighlight onPress={() => {this._goToPages(data)}}>
                    <CachedImage defaultSource={require('../../imgs/169.png')} source={{uri:data.banner_url}}
                                 style={styles.bannerView}/>
                </TouchableHighlight>
            </View>
        )
    }
    _renderAdView(adData, data) {
        if (this.HaveAds && Platform.OS == 'ios') {
            return (
                <Swiper height={165 * g_AppValue.precent}
                        loop={this.isLoop}
                        autoPlay={this.isLoop}
                        scrollsToTop={true}>
                    {this._renderPageIOS(adData)}
                </Swiper>
            );
        }
        if (this.HaveAds && Platform.OS == 'android') {
            return (
                <ViewPager
                    ref={(viewpager) => {this.viewpager = viewpager}}
                    style={{height: 165 *g_AppValue.precent,width: g_AppValue.screenWidth}}
                    dataSource={data}
                    renderPage={this._renderpageAndroid.bind(this)}
                    isLoop={this.isLoop}
                    onChangePage={this._onChangePage.bind(this)}
                    autoPlay={this.isLoop}/>);
        }
    }
    _onChangePage(page) {
        this._currentPage = page;
        //console.log("currentPage: " + page);
    }
    _forAds() {
        var MayAdsArray = this.state.bannerData;
        if (MayAdsArray.length == 0) {
            this.HaveAds = false;
            return [];
        } else {
            this.HaveAds = true
        };
        if (MayAdsArray.length == 1) {
            this.isLoop = false
        } else {
            this.isLoop = true
        };
        return MayAdsArray;
    }
    // render
    render() {
        var adData = this._forAds();
        var dataSource = new ViewPager.DataSource({
            pageHasChanged: (p1, p2) => p1 !== p2
        });
        var data = dataSource.cloneWithPages(adData);
        return (
            <View>
                {this._renderAdView(adData, data)}
            </View>
        );
    }
    // 自定义方法区域
    // your method
}
var styles = StyleSheet.create({
    bannerView: {
        height: 165 * g_AppValue.precent,
        width: g_AppValue.screenWidth,
        resizeMode: 'stretch'
    }
})
