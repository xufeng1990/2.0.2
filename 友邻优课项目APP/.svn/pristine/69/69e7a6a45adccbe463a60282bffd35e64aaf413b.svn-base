//  AlbumDetailsTab
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, {Component, PropTypes} from 'react';
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
    DeviceEventEmitter,
    NativeModules,
    NativeEventEmitter,
} from 'react-native';
//common
import Util from '../../common/util.js';
//configs
import g_AppValue from '../../configs/AppGlobal.js';
import  YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js';

//pages
import Pay from '../../pages/Pay/pay.js';



// 类
//
var Bridges = NativeModules.BridgeEvents;
const myEvent = new NativeEventEmitter(Bridges);
var subscription;
//登陆监听
var LoginEvents = NativeModules.LoginEvent;
const myLoginEvent = new NativeEventEmitter(LoginEvents);
var loginSubscription;
//退出登录成功
var LogoutEvents = NativeModules.LogoutEvent;
const myLogoutEvent = new NativeEventEmitter(LogoutEvents);
var logoutSubscription;
export default class MyThumbTab extends Component {
    constructor(props) {
        super(props);
        this.state = {
            isPlayingOrPause: 0,
            noLogin: false,
            hideNoVip1: false,
            isExistPlayedTrace: 1,
        }
    }
    static   propTypes = {
        goToPage: React.PropTypes.func,//跳转对应的tab方法
        activeTab: React.PropTypes.number,//当前被选中的下标
        tabs: React.PropTypes.array,//所有tabs集合
        tabNames: React.PropTypes.array,//保存tab名称
        tabIconNames: React.PropTypes.array,//tab图标
        goBack: React.PropTypes.func,
        goToPlayerView: PropTypes.func,
    }
    componentDidMount() {
        YLYKNatives.$player.isPlayingOrPause()
            .then((data) => {
                this.setState({isPlayingOrPause: data.isPlayingOrPause})
            }).catch((err) => {
            // console.log('错误' + err)
        })
    }
    componentWillMount() {
            YLYKNatives.$player.isExistPlayedTrace()
            .then((data) => {
                this.setState({isExistPlayedTrace: data})
            })
        this._getUserID();
        //登陆成功监听
        this.loginSubscription = myLoginEvent.addListener('LoginSuccess', (reminder) => {
            this._getUserID();
        });
        this.logoutSubscription = myLogoutEvent.addListener('LogoutSuccess', (reminder) => {
            //console.log('新注销成功' + reminder.LogoutSuccess )
            if (reminder.LogoutSuccess) {
                this._getUserID();
            }
        })
        //监听播放git
        this.subscription = myEvent.addListener('playOrPauseToRN', (reminder) => {
                //console.log( '播放状态'+ reminder.isPlayingOrPause);
                this.setState({isPlayingOrPause: reminder.isPlayingOrPause, isExistPlayedTrace: 1})
            }
        );
    }
    componentWillUnmount() {
        this.logoutSubscription && this.logoutSubscription.remove();
        this.loginSubscription && this.loginSubscription.remove();
        this.subscription && this.subscription.remove();
    }
    _getUserID() {
      YLYKNatives.$oauth.getUserInfo().then((data) => {
            var resultData = JSON.parse(data);
            if (data == 0 || data == '0') {
                this.setState({
                    noLogin: false,
                })
            } else {
                this.setState({noLogin: true,})
                let isVip = Util.isVip(resultData)
                if (isVip == false) {
                    this.setState({
                        hideNoVip1: false,
                    })
                } else {
                    this.setState({
                        hideNoVip1: true,
                    })
                }
            }
        }).catch((err) => {
            // console.log('albunShow获取userID失败' + err)
        })
    }
    _noLoginView() {
        Util.AppToast('请先登录');
    }
    goToQiView() {
       YLYKNatives.$qiyu.goToQiyu();
    }
    goToPayView() {
          YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        this.props.navigator.push({
            component: Pay,
        })
    }
    _alertHome() {
        Util.alertDialog({
            msg: '成为友邻学员即可收听此课程',
            oneBtn: '立即入学',
            okBtn: '咨询阿树老师',
            cancelBtn: '取消',
            okFun: () => {
                this.goToQiView()
            },
            oneFun: () => {
                this.goToPayView()
            },
        })
    }
    renderTabOption(tab, i) {
        let color = this.props.activeTab == i ? "#B41930" : "#5a5a5a";
        let viewColor = this.props.activeTab == i ? "#B41930" : "#ffffff";// 判断i是否是当前选中的tab，设置不同的颜色
        return (
            <TouchableOpacity activeOpacity={1} onPress={()=>this.props.goToPage(i)} style={styles.tab}>
                <View style={[styles.tabItem,{borderBottomColor:viewColor}]}>
                    <Text style={{color: color,fontSize:18 * g_AppValue.precent}}>
                        {this.props.tabNames[i]}
                    </Text>
                </View>
            </TouchableOpacity>
        );
    }
    render() {
        return (
            <View style={styles.tabs}>
                <TouchableOpacity activeOpacity={1} style={{ marginLeft:12* g_AppValue.precent,}}
                                  onPress={this.props.goBack}>
                    <Image style={styles.backButton} source={require('../../pages/Course/images/back1.png')}/>
                </TouchableOpacity>
                {this.props.tabs.map((tab, i) => this.renderTabOption(tab, i))}
                <TouchableOpacity activeOpacity={1} style={{ marginLeft:25* g_AppValue.precent,}}
                                  onPress={ this.state.noLogin == false ? ()=>{this._noLoginView()} : this.state.hideNoVip1 == false ? ()=>{this._alertHome()} :  this.props.goToPlayerView}>
                    <Image style={styles.backButtonplay}
                           source={this.state.isExistPlayedTrace == 1 ? this.state.isPlayingOrPause == 0 ? require('../../imgs/play1.png')  :  require ('../../imgs/play.gif') : null }/>
                </TouchableOpacity>
            </View>
        );
    }
}
var styles = StyleSheet.create({
    tabs: {
        flexDirection: 'row',
        height: Platform.OS == 'ios' ? 43 * g_AppValue.precent : 44 * g_AppValue.precent,
        backgroundColor: '#ffffff',
        alignItems: 'center',
    },
    tab: {
        width: 120 * g_AppValue.precent,
        //  backgroundColor:'yellow',
        marginLeft: 30 * g_AppValue.precent,
    },
    tabItem: {
        width: 120 * g_AppValue.precent,
        height: Platform.OS === 'ios' ? 43 * g_AppValue.precent : 44 * g_AppValue.precent,
        alignItems: 'center',
        justifyContent: 'center',
        borderBottomWidth: 1 * g_AppValue.precent,
        // backgroundColor:'green',
    },
    backButton: {
        width: 10 * g_AppValue.precent,
        height: 18 * g_AppValue.precent,
    },
    backButtonplay: {
        width: 18 * g_AppValue.precent,
        height: 18 * g_AppValue.precent,
    },
})
