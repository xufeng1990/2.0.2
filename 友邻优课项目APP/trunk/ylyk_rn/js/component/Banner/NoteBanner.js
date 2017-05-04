//  "banner"
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, {Component,} from 'react';
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
} from 'react-native';
import g_AppValue from '../../configs/AppGlobal.js';
import Swiper from 'react-native-swiper';
import ViewPager from 'react-native-viewpager';
const BannerList = NativeModules.NativeNetwork;
export default class NoteBanner extends Component {
    // 构造函数
    constructor(props) {
        super(props);
        this.HaveAds = true,
            this.isLoop = true,
            this.state = {
                //有广告
                HaveAds: true,
                isLoop: true,
                bannerData: [],
            };
    }
    // 加载完成
    componentDidMount() {
        // for (var i = 0; i < asdArr.length; i++) {
        //   var MayAdsArray = [];
        //   MayAdsArray.push(adsArr[i])
        //   console.log('1111' + MayAdsArray)
        // }
        // this.setState({
        //   data:MayAdsArray,
        // })
        //   BannerList.getBannerList()
        // .then((data)=> {
        //    var adsArray = JSON.parse(data);
        //    var MayAdsArray = [];
        //    for (var i = 0; i < adsArray.length; i++) {
        //      MayAdsArray.push(adsArray[i]);
        //    }
        //    console.log('mayads' +MayAdsArray)
        //    this.setState({bannerData:MayAdsArray})
        // }).catch((err)=> { console.warn('数据err', err);});
    }
    // view卸载
    componentWillUnmount() {
        //
    }
    // _goToPage(data){
    //   return data.map((value,index)=> {
    //     this.props.navigator.push({
    //       if (value.type_id === 2 || value.type_id === '2' ) {
    //         component:
    //       }
    //     })
    //   })
    // }
    _renderPageIOS(data) {
        return data.map((value, index) => {
            return (
                <View style={{flex:1}}>
                    <TouchableOpacity onPress={()=>{this._goToPage(data)}}>
                        <Image source={value.icon} style={styles.bannerView}/>
                    </TouchableOpacity>
                </View>
            );
        })
    }
    _renderpageAndroid(data) {
        //  {uri:value.banner_url}
        return (
            <View style={{flex:1}}>
                <TouchableHighlight>
                    <Image source={data.icon} style={styles.bannerView}/>
                </TouchableHighlight>
            </View>
        );
    }
    _renderAdView(adData, data) {
        if (this.HaveAds && Platform.OS == 'ios') {
            return (
                <Swiper
                    height={165*g_AppValue.precent}
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
                    style={{height:165*g_AppValue.precent,width:g_AppValue.screenWidth,}}
                    dataSource={data}
                    renderPage={this._renderpageAndroid.bind(this)}
                    isLoop={this.isLoop}
                    autoPlay={this.isLoop}
                />
            );
        }
    }
    _forAds() {
        // var MayAdsArray = this.state.bannerData;
        //  console.log("MayAdsArray"+ MayAdsArray[0].icon)
        //var MayAdsArray = [{icon: require('./1.png')}, {icon: require('./2.png')},];
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
        // return MayAdsArray.map((value,index) => {
        //
        //     return{
        //       uri:{uri:value}
        //     }
        //
        // })
        return MayAdsArray;
    }
    // render
    render() {
        var adData = this._forAds();
        var dataSource = new ViewPager.DataSource({pageHasChanged: (p1, p2) => p1 !== p2});
        var data = dataSource.cloneWithPages(adData);
        // console.log('mapData' + data)
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
