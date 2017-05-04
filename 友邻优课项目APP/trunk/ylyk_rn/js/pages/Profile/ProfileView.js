//  ProfileView
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
    NativeModules,
    DeviceEventEmitter,
    NativeEventEmitter,
    Platform
} from 'react-native';
//common
import Icon from "../../common/Icon.js";
import Util from "../../common/util.js";
//configs

import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js';
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js';
import g_AppValue from '../../configs/AppGlobal.js';
//component
import Cell from "../../component/Cells/Cell.js";
//pages
import MyThumb from './MyThumb/MyThumb.js';
import DownloadManager from "../DownloadManager/DownloadManager.js";
import MeEdit from "../MeEdit/MeEdit.js";
import MeWechat from "../MeEdit/MeWechat.js";
import VipState from "./VipState.js"
import Pay from "../Pay/pay.js";
import MeXdy from "./MeXdy.js";
//组件
import Toast, {DURATION} from 'react-native-easy-toast';



var LoginEvents = NativeModules.LoginEvent;
const myLoginEvent = new NativeEventEmitter(LoginEvents);
var loginSubscription;

export default class ProfileView extends Component {
    // 构造函数
    constructor(props) {
        super(props);
        this.state = {
            id: 0,
            wechat: "",
            uMoney: 0,
            userInfo: {},
            loginStatus: false
        };

        this.isVip = false;
        this.refreshProfileView = this.refreshProfileView.bind(this);
        this.getUserInfo = this.getUserInfo.bind(this);
    }

    componentWillMount() {
        this.getUserInfo();
        loginSubscription = myLoginEvent.addListener('LoginSuccess', (reminder) => {
            this.refreshProfileView();
            this.getUserInfo();
        });
    }

    componentWillReceiveProps() {

    }

    _upData() {
        let _this = this;
      YLYKNatives.$oauth.getUserInfo()
        .then((userInfo) => {
            if (userInfo && userInfo.info) {
                _this.setState({wechat: userInfo.info.wechat, userInfo: userInfo, id: userInfo.id})
            };
        })
    }

    // view卸载
    componentWillUnmount() {
        this.ProfileView && this.ProfileView.remove();
        this.refreshData && this.refreshData.remove();
    }

    //登陆状态刷新
    refreshProfileView() {
      YLYKNatives.$oauth.getUserID()
        .then((userID) => {
            if (userID == '0') {
                this.setState({loginStatus: false})
            } else {
                this.setState({loginStatus: true})
            }

        }).catch((err) => {})
    }

    getUserInfo() {
      YLYKNatives.$oauth.getUserInfo()
        .then((userInfo) => {
            userInfo = JSON.parse(userInfo);
            if (userInfo && userInfo.info) {
                this.setState({
                  wechat: userInfo.info.wechat,
                  userInfo: userInfo,
                   id: userInfo.id,
                   uMoney: userInfo.stat.umoney,
                   loginStatus: this.props.loginStatus
                 });

                this.isVip = Util.isVip(userInfo);
            }
        })
    }

    componentDidMount() {
        this.refreshProfileView();

        this.refreshData = DeviceEventEmitter.addListener('refreshData', this.getUserInfo)
        this.ProfileView = DeviceEventEmitter.addListener('refreshProfileView', this.refreshProfileView);
    }

    _myThumbView() {
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        const navigator = this.props.navigator;
        this.props.navigator.push({
            component: MyThumb,
            params: {
                user_id: this.props.user_id,
                navigator: navigator,
                isVip: this.props.isVip
            }
        })
    }

    //非会员的提示框
    noVip(msg) {
        Util.alertDialog({
            msg: msg,
            oneBtn: '立即入学',
            okBtn: '咨询阿树老师',
            cancelBtn: '取消',
            okFun: () => {
                this.goToQiView()
            },
            oneFun: () => {
                this.goToPayView()
            }
        })
    }

    //打开七鱼
    goToQiView() {
        YLYKNatives.$qiyu.goToQiyu();
    }

    //打开支付
    goToPayView() {
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        this.props.navigator.push({component: Pay})
    }

    //下载管理页面
    _myDownloadView() {
        if (!this.isVip) {
            this.noVip("成为友邻学员即可下载任意课程");
        } else {
            YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
            const navigator = this.props.navigator;
            this.props.navigator.push({
                component: DownloadManager,
                params: {
                    navigator: navigator
                }
            })
        }
    }

    //修改微信
    _inputWechat() {
      YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        let _this = this;
        this.props.navigator.push({
            component: MeWechat,
            params: {
                wechat: _this.state.wechat,
                isPublic: this.state.userInfo.info.is_public,
                //在修改昵称页面调用此方法
                setWechat: function(wechat, isPublic) {
                    _this.setState({wechat: wechat});
                    //此处更新个人信息
                    _this._updateWechat(wechat, isPublic);
                }
            }
        });
    }

    //更新微信
    _updateWechat(wechat, isPublic) {
        let newInfo = {};
        newInfo.wechat = wechat;
        newInfo.is_public = isPublic;
      YLYKServices.$user.updateUser(this.state.id + "", newInfo);
    }

    //打开设置
    _goToSettingView() {
        this.props.navigator.push({component: MeEdit})
    }

    //打开同学权益
    _vipStateView() {
      YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        if (this.isVip) {
            this.props.navigator.push({
                component: VipState,
                params: {
                    userId: this.state.userInfo.id,
                    userState: this.state.userInfo.vip,
                    isVip: this.isVip
                }
            });
        } else {
            this.noVip("成为友邻同学即可享受同学权益");
        }
    }

    _openCalendarView() {
      YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
            YLYKNatives.$userTrace.openCalendarViewController();
    }

    //打开小答应
    _meXdy() {
      if (!this.isVip) {
          YLYKNatives.$qiyu.goToQiyu();
      }else {
        this.props.navigator.push({
            component: MeXdy,
            params: {
                userId: this.state.userInfo.id,
                userInfo: this.state.userInfo
            }
        })
      }

    }

    //跳转登录页面
    _goToLoginView() {
        YLYKNatives.$login.openLoginViewController()
        .then((res) => {
            DeviceEventEmitter.emit('refreshProfileView', '1');
              YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
        });
    }

    //优币商城
    _onPressUB() {
        Util.AppToast('优币商城尚未上线，敬请期待')
    }

    // render
    render() {
        return (
          <View>
            <View style={styles.container} >
              <Cell tag={"我的下载"} content={""} cellPull={true}
                cellFun={this.state.loginStatus == false ? () => { this._goToLoginView() } : () => { this._myDownloadView() }} />
              <Cell tag={"我赞过的"} content={""} cellPull={true}
                cellFun={this.state.loginStatus == false ? () => { this._goToLoginView() } : () => { this._myThumbView() }} />
              <Cell tag={"学习日历"} content={""} cellPull={true}
                cellFun={this.state.loginStatus == false ? () => { this._goToLoginView() } : () => { this._openCalendarView() }} />
              <Cell tag={"同学权益"} content={this.state.loginStatus == false ? 0 + "优币" : this.props.umoney + "优币"} cellPull={true}
                cellFun={this.state.loginStatus == false ? () => { this._goToLoginView() } : () => { this._vipStateView() }} />
              {/*
                      <Cell tag={"任务中心"} content={""} cellPull={true}
                          cellFun={this.state.loginStatus == false   ? ()=> {this._goToLoginView()}  : () => { this._goToSettingView() }} />*/}

              <Cell tag={"微信号"} content={this.state.loginStatus == false ? '' : this.state.wechat} cellPull={true}
                cellFun={this.state.loginStatus == false ? () => { this._goToLoginView() } : () => { this._inputWechat() }} />
              <Cell tag={"学习管家"} content={""} cellPull={true} cellLast={true}
                cellFun={this.state.loginStatus == false ? () => { this._goToLoginView() } : () => { this._meXdy() }} />
            </View>
            <Toast position={Platform.OS === 'ios' ? "center" : "top"} ref="toast" />
          </View>
        );
    }
    // <Cell tag={"优币商城"} content={ this.state.loginStatus == false ?  0 + "优币" : this.props.umoney  + "优币" } cellPull={true}
    //   cellFun={this.state.loginStatus == false  ? () => { this._goToLoginView() } : () => { this._onPressUB()}} />
    // 自定义方法区域
    // your method

}

var styles = StyleSheet.create({
    container: {
        ...Platform.select({
            ios: {
                marginBottom: 45 * g_AppValue.precent
            }
        }),
        flex: 1
    },
    praiseView: {
        width: g_AppValue.screenWidth,
        height: 56 * g_AppValue.precent,
        backgroundColor: '#ffffff',
        marginTop: 10 * g_AppValue.precent,
        alignItems: 'center',
        justifyContent: 'center'
    },
    newsTitleView: {
        width: g_AppValue.screenWidth,
        height: 18 * g_AppValue.precent,
        flexDirection: 'row'
    },
    newsTitle: {
        textAlign: 'center',
        fontSize: 16 * g_AppValue.precent,
        marginLeft: 12 * g_AppValue.precent
    },

    rightImage: {
        marginLeft: 278 * g_AppValue.precent,
        width: 7 * g_AppValue.precent,
        height: 18 * g_AppValue.precent
    },
    aLLRowView: {
        marginTop: 10 * g_AppValue.precent,
        width: g_AppValue.screenWidth
    },
    rowView: {
        width: g_AppValue.screenWidth,
        height: 56 * g_AppValue.precent,
        backgroundColor: '#ffffff',
        justifyContent: 'center'
    },
    lineView: {
        position: 'absolute',
        backgroundColor: '#c8c8c8',
        opacity: 0.5,
        width: 351 * g_AppValue.precent,
        height: 1 * g_AppValue.precent,
        top: 55 * g_AppValue.precent,
        left: 12 * g_AppValue.precent
    },
    coinView: {
        flex: 1,
        position: 'absolute',
        top: 21 * g_AppValue.precent,
        right: 31 * g_AppValue.precent,
        justifyContent: 'flex-end'
    },
    coinText: {
        fontSize: 14 * g_AppValue.precent,
        color: '#9a9b9c'
    }
});
