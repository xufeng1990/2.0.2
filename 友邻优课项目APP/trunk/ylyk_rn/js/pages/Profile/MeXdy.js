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
    ScrollView,
    DeviceEventEmitter,
    TouchableHighlight,
    Clipboard
} from 'react-native';
//common
import styles from "../../common/styles.js";
import Util from "../../common/util.js";
import Enums from "../../common/enums.js";
import Icon from "../../common/Icon.js";
//configs
import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js';
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js';
import YLYKStorages from '../../configs/ylykbridges/YLYKStorages.js';
//component
import Cell from "../../component/Cells/Cell.js";
import Header from "../../component/HeaderBar/HeaderBar.js";
//组件
import ActionSheet from '@yfuks/react-native-action-sheet';
import DateTimePicker from 'react-native-modal-datetime-picker';

export default class MeXdy extends Component {
    constructor(props) {
        super(props);
        this.state = {
            avatar: "",
            wechat: "",
            name: ""
        }
    }

    componentWillUnmount() {
        DeviceEventEmitter.emit('showProfileTabBar', '1');
    }

    componentWillMount() {
          YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        this.setState({
            avatar: Enums.baseUrl + "xdy/" + this.props.userInfo.xdy_id + "/avatar"
        })
        YLYKServices.$xdy.getXdyById(this.props.userInfo.xdy_id + "").then((xdyInfo) => {
            xdyInfo = JSON.parse(xdyInfo);
            this.setState({
                wechat: xdyInfo.wechat,
                name: xdyInfo.name
            })
        })
    }

    _copyWechat() {
        Util.alert({
            msg: "微信号" + this.state.wechat + "已复制到粘贴板，请到微信添加朋友页面粘贴并搜索",
            okBtn: "打开微信",
            cancelBtn: "取消",
            okFun: () => {
                Util.openWx(this.state.wechat);
            }
        })
    }

    //返回
    _backFun = () => {
          YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
        this.props.navigator.pop();
    };

    render() {
        let cellsData = this.state,
            headerHeight = Platform.OS === 'ios' ? 64 : 44,
            viewHeight = Dimensions.get("window").height - headerHeight;
        return (
            <View style={styles.bgWhite} >
                <Header backFun={this._backFun} title={"学习管家"} />
                <View style={[styles.gbWhite, pageStyles.page]} >
                    <Text style={[styles.textBlack, styles.text18, styles.textCenter]}>你的学习管家</Text>
                    <Image source={{ uri: this.state.avatar }}
                        style={[pageStyles.avatar]} />
                    <Text style={[styles.text16, styles.textBlack, styles.textCenter]} >{this.state.name}</Text>
                    <View style={[styles.row, { alignItems: "center", marginTop: 10, }]} >
                        <View style={[pageStyles.lineLeft]} ></View>
                        <Text style={[styles.text15, styles.textGrey, styles.textCenter]} >{"微信号" + this.state.wechat}</Text>
                        <View style={[pageStyles.lineRight]} ></View>
                    </View>
                    <TouchableOpacity activeOpacity={1} style={pageStyles.btn} onPress={() => { this._copyWechat() }} >
                        <View style={[styles.row, styles.alignCenter]}>
                            <Text style={[{ color: "#fff" }, styles.icon, styles.text13]} >{Icon.wechat}</Text>
                            <Text style={[{ color: "#fff" }, styles.text14]} > 加好友</Text>
                        </View>
                    </TouchableOpacity>
                </View>
            </View>
        )
    }
}

var pageStyles = StyleSheet.create({
    page: {
        paddingVertical: 60,
        height: Dimensions.get('window').height - 44,
        alignItems: "center"
    },
    avatar: {
        height: 136,
        width: 136,
        borderRadius: 68,
        marginTop: 50,
        marginBottom: 30
    },
    lineLeft: {
        height: 1,
        width: 140,
        marginRight: 10,
        backgroundColor: "#d8d8d8",
        marginTop: 5
    },
    lineRight: {
        height: 1,
        width: 140,
        marginLeft: 10,
        backgroundColor: "#d8d8d8",
        marginTop: 5
    },
    btn: {
        backgroundColor: '#b41930',
        width: 130,
        height: 35,
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 19,
        color: "#fff",
        marginTop: 50
    },
})
