//  "NewClass"
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
    WebView,
    Platform,
    NativeEventEmitter,
    DeviceEventEmitter,

} from 'react-native';
import g_AppValue from '../../configs/AppGlobal.js';
import Icon from '../../common/Icon.js';
import *as RnNativeModules from '../../configs/RnNativeModules.js';
// 类
export default class BannerTypeReDdirect extends Component {
    // 构造函数
    constructor(props) {
        super(props);
        this.state = {
            // your code
        };
    }
    // 加载完成
    componentDidMount() {
        //
    }
    // view卸载
    componentWillUnmount() {
        DeviceEventEmitter.emit('showCourseTabBar', '1');
    }
    _goBack() {
        RnNativeModules.hideTabBar('show');
        this.props.navigator.pop();
    }
    // render
    render() {
        //console.log('链接地址' + this.props.url)
        return (
            <View style={styles.container}>
                <View style={styles.headerView}>
                    <View style={styles.headerContentView}>
                        <TouchableOpacity onPress={()=>{this._goBack()}}>
                            <Text style={styles.backButtom}>{Icon.back}</Text>
                        </TouchableOpacity>
                        <Text style={styles.headerTitle}></Text>
                    </View>
                </View>
                <WebView
                    automaticallyAdjustContentInsets={false}
                    style={styles.webView}
                    javaScriptEnabled={true}
                    domStorageEnabled={true}
                    scalesPageToFit={false}
                    source={{uri:this.props.url}}
                />
            </View>
        );
    }
}
var styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#ffffff',
    },
    webView: {
        width: g_AppValue.screenWidth,
        height: g_AppValue.screenHeight,
    },
    headerView: {
        width: g_AppValue.screenWidth,
        height: Platform.OS == 'ios' ? 64 * g_AppValue.precent : 44 * g_AppValue.precent,
        backgroundColor: '#ffffff',
    },
    headerContentView: {
        width: g_AppValue.screenWidth,
        height: 24 * g_AppValue.precent,
        //  backgroundColor:'yellow',
        marginTop: Platform.OS == 'ios' ? 31 * g_AppValue.precent : 11 * g_AppValue.precent,
    },
    headerTitle: {
        fontSize: 18 * g_AppValue.precent,
        color: '#5a5a5a',
    },
    backButtom: {
        marginTop: Platform.OS == 'ios' ? 0 : 3 * g_AppValue.precent,
        fontSize: 18 * g_AppValue.precent,
        fontFamily: 'iconFont',
        marginLeft: 12 * g_AppValue.precent,
        //backgroundColor:'black',
    },
})
