//  "NewClass"
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, { Component } from 'react';
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
    Alert
} from 'react-native';
//configs
import g_AppValue from '../../configs/AppGlobal.js';
import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js'
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js'
//pages
import Pay from '../Pay/pay.js';

export default class NoVipDetailsView extends Component {
    // 构造函数
    constructor(props) {
        super(props);
        this.state = {

            noLogin: false,//未登录

        };
    }

    // 加载完成
    componentDidMount() {
      YLYKNatives.$oauth.getUserInfo()
            .then((data) => {
                var resultData = JSON.parse(data);
                if (data == 0 || data == '0') {
                    this.setState({ noLogin: false });
                } else {
                    this.setState({ noLogin: true })
                }
            }).catch((err) => {
            })
    }

    // view卸载
    componentWillUnmount() {


    }

    //跳转小答应页面
    _goToQiyuView() {
        if (this.state.noLogin == false) {
            YLYKNatives.$login.openLoginViewController().then((res) => { });
        } else {
            YLYKNatives.$qiyu.goToQiyu();
        }

    }

    //跳转支付页面
    _goToPayView() {
        if (this.state.noLogin == false) {
           YLYKNatives.$login.openLoginViewController().then((res) => { })
        } else {
            this.props.navigator.push({ component: Pay });
        }

    }
    // render
    render() {
        return (

            <View style={styles.noVipDetailsView}>
                <View style={{ marginTop: 9 * g_AppValue.precent, flexDirection: 'row' }}>

                    <TouchableOpacity activeOpacity={1} onPress={() => this._goToQiyuView()}>
                        <View style={styles.consultingButtomView}>
                            <Text style={styles.consultingButtomText}>咨询阿树老师</Text>
                        </View>
                    </TouchableOpacity>

                    <TouchableOpacity activeOpacity={1} onPress={() => this._goToPayView()}>
                        <View style={styles.signButtomView}>
                            <Text style={styles.signButtomText}>立即报名</Text>
                        </View>
                    </TouchableOpacity>
                </View>
            </View>
        );
    }

    // 自定义方法区域
    // your method

}
var styles = StyleSheet.create({
    noVipDetailsView: {
        width: g_AppValue.screenWidth,
        height: 49 * g_AppValue.precent,
        //justifyContent:'center',
        backgroundColor: '#ffffff',
        flexDirection: 'row'
    },
    consultingButtomView: {
        marginLeft: 45 * g_AppValue.precent,
        width: 110 * g_AppValue.precent,
        height: 31 * g_AppValue.precent,
        backgroundColor: '#B41930',
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 30 * g_AppValue.precent
    },
    consultingButtomText: {
        fontSize: 14 * g_AppValue.precent,
        color: '#ffffff'
    },
    signButtomView: {
        marginLeft: 65 * g_AppValue.precent,
        width: 110 * g_AppValue.precent,
        height: 31 * g_AppValue.precent,
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 30 * g_AppValue.precent,
        borderWidth: 1,
        borderColor: '#B41930',
        backgroundColor: '#ffffff'
    },
    signButtomText: {
        color: '#B41930'
    }
})
