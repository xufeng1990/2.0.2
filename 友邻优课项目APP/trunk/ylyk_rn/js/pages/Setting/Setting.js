/**
 * Created by 艺术家 on 2017/3/9.
 * page: 个人资料
 */

import React, { Component } from 'react';
import {
    Text,
    View,
    Image,
    TextInput,
    StyleSheet,
    Alert,
    Dimensions,
    NativeModules,
    Platform,
    TouchableOpacity,
    DeviceEventEmitter,
    NativeEventEmitter
} from 'react-native';
//common
import styles from "../../common/styles.js";
import Util from "../../common/util.js";
import Enums from "../../common/enums.js";
import Icon from "../../common/Icon.js";
//configs
import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js'
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js'
import YLYKStorages from '../../configs/ylykbridges/YLYKStorages.js'
//component
import Cell from "../../component/Cells/Cell.js";
import Header from "../../component/HeaderBar/HeaderBar.js";
//pages
import About from "./About.js"
import Net from "./Net.js"
//组件
import ActionSheet from '@yfuks/react-native-action-sheet';
import DateTimePicker from 'react-native-modal-datetime-picker';

var LoginEvents = NativeModules.LoginEvent;
const myLoginEvent = new NativeEventEmitter(LoginEvents);
var loginSubscription;
var licenseUrl = 'http://m.youlinyouke.com/app/faq.html';

var LogoutEvents = NativeModules.LogoutEvent;
const myLogoutEvent = new NativeEventEmitter(LogoutEvents);
var logoutSubscription;

export default class Setting extends Component {
    constructor(props) {
        super(props);
        this.state = {
            id: 60,
            mobilePhone: "",
            cacheSize: "",
            userInfo: {},

        }
    }

    componentWillMount() {
        let userInfo = this.props.userInfo;

        YLYKNatives.$cache.getCacheSize().then((cacheSize) => {
            this.setState({
                cacheSize: cacheSize,
                mobilePhone: userInfo.mobilephone || "去绑定",
                userInfo: userInfo
            })
        })

        loginSubscription = myLoginEvent.addListener('LoginSuccess', (reminder) => {
            //  console.log(reminder.LoginSuccess + "loginsuccessphonenumber");
            this.setState({
                mobilePhone: reminder.LoginSuccess
            })
        });

    }

    componentDidMount() {
        DeviceEventEmitter.addListener('mobilephone', (data) => {
            alert(data)
        })

    }
    componentWillUnmount() {
        this.logoutSubscription && this.logoutSubscription.remove();
        DeviceEventEmitter.emit('showProfileTabBar', '1');
        // this.loginSubscription = this.loginSubscription.remove();
    }

    //返回
    _backFun = () => {
        this.props.navigator.pop();
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');

    };

    //修改手机
    _inputPhone() {
        YLYKNatives.$login.changeBandPhoneNumber();

    }

    //意见反馈
    _feedback() {
        Util.alert({
            msg: "请在需要反馈的页面摇一摇"
        })
    }

    //清理缓存
    _clearCache() {
        Util.alert({
            msg: "确定要清除缓存吗？",
            okFun: () => {
                YLYKNatives.$cache.clearCache();
                this.setState({
                    cacheSize: "0.00MB"
                })
            }
        })

    }

    //关于我们
    _about() {
        this.props.navigator.push({
            component: About,
        })
    }

    //注销登录
    _signOut() {

        Util.alert({
            msg: "注销后已下载的课程将被清空，确定要注销吗？",
            okFun: () => {
                YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
                YLYKNatives.$oauth.logout();
                logoutSubscription = myLogoutEvent.addListener('LogoutSuccess', (reminder) => {
                    //   console.log('新注销成功' + reminder.LogoutSuccess )
                    if (reminder.LogoutSuccess) {
                        DeviceEventEmitter.emit('refreshData', '1');
                        DeviceEventEmitter.emit('refresh', '1');
                        DeviceEventEmitter.emit('refreshProfileView');
                        this.props.navigator.pop();
                    }
                })
            }
        })

    }

    _faq() {
        this.props.navigator.push({
            component: Net,
            params: {
                url: licenseUrl,
            }
        })
    }

  

    render() {

        let cellsData = this.state;
        return (
            <View style={[styles.bgGrey, styles.primary]} >
                <Header backFun={this._backFun} title={"设置"} />
                <View style={[styles.bgWhite, styles.section]}>
                    <Cell tag={"绑定手机"} content={this.state.mobilePhone + ""} cellPull={true} cellLast={true}
                        cellFun={() => { this._inputPhone() }} />
                </View>

                <View style={[styles.bgWhite, styles.section]}>

                    <Cell tag={"摇一摇反馈"}  categoryNumber = {1} />
                    <Cell tag={"常见问题"} content={this.state.job}
                        cellPull={true} cellFun={() => { this._faq() }} />
                    <Cell tag={"清理缓存"} content={this.state.cacheSize} cellPull={true} cellLast={true}
                        cellFun={() => { this._clearCache() }} />
                </View>

                <View style={[styles.bgWhite, styles.section]}>
                    <Cell tag={"关于我们"} cellPull={true} cellLast={true}
                        cellFun={() => { this._about() }} />
                </View>

                <TouchableOpacity activeOpacity={1}
                    style={[styles.bgWhite, styles.section, styles.alignCenter, { height: 52 }]}
                    onPress={() => {
                        this._signOut();
                    }}
                >
                    <Text style={[styles.text16, styles.textCenter]} >
                        注销登录
                    </Text>
                </TouchableOpacity>
            </View>
        )
    }
}


var pageStyles = StyleSheet.create({
    topContainer: {
        height: 163,
        paddingTop: 10

    },
    courseName: {
        marginTop: 8,
    }
});
