/**
 * Created by 艺术家 on 2017/3/9.
 * page: webview
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
    WebView,
    TouchableOpacity,
    ScrollView,
    TouchableHighlight,
    DeviceEventEmitter,
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
import g_AppValue from '../../configs/AppGlobal.js';
//component
import Header from "../../component/HeaderBar/HeaderBar.js";
import Loading from "../../component/Loading/Loading.js";
//pages
import PaySuccess from "./PaySuccess.js"
//组件
import ActionSheet from '@yfuks/react-native-action-sheet';
import DateTimePicker from 'react-native-modal-datetime-picker';
import ProgressBar from 'react-native-progress/Circle';

export default class Pay extends Component {
    constructor(props) {
        super(props);
        this.state = {
            checked: 0,
            isReview: false,
        }
        this.channel = ["WX_APP", "ALI_APP"];
        this.goodsId = 37;
        this.count = 1
    }

    //渲染前加载数据
    componentWillMount() {

        if (Platform.OS === 'ios') {
            YLYKNatives.$application.getReviewVersion()
                .then((res) => {
                    if (res && res.isReview) {
                        this.setState({
                            isReview: res.isReview
                        })
                    }
                })
        }

    }

    componentWillUnmount() {
        var hide = [1, 2];
        DeviceEventEmitter.emit('showNoteTabBar', hide);
    }

    //返回
    _backFun = () => {
        this.props.navigator.pop();
    };

    _checkItem(key) {
        this.setState({
            checked: key
        })
    }

    //支付
    _goToPay() {
        if (this.state.isReview) {
            YLYKNatives.$IAPPay.onIAPPay();
            return;
        }

        YLYKNatives.$wechat.goToPay({
            goodsId: this.goodsId + "",
            count: this.count + "",
            channel: this.channel[this.state.checked]
        }).then((mesg) => {
            if (mesg.is_succeed) {
                YLYKNatives.$oauth.getUserInfo().then((userInfo) => {
                    if (!userInfo.id) {
                        userInfo = JSON.parse(userInfo)
                    }
                    this.props.navigator.push({
                        component: PaySuccess,
                        params: {
                            userInfo: userInfo
                        }
                    })
                })
            } else {
                g_AppValue.PaySuccess = false;
            }
        })
    }

    render() {
        let current = this.state.current,
            next = this.state.next,
            title = this.state.title,
            avatar = this.state.avatar;
        return (
            <View style={[styles.primary]}>
                <Header backFun={this._backFun} title={"报名"} />
                <ScrollView showsVerticalScrollIndicator={false}
                    style={[styles.bgGrey]}>
                    <View style={pageStyles.top}>
                        <View style={[styles.row, { alignItems: "center" }]}>
                            <Text style={[styles.text24, styles.textBlack, { lineHeight: 36 }]} >￥</Text>
                            <Text style={[pageStyles.price, styles.textBlack]}>{this.state.isReview ? '1598' : '1198'}</Text>
                        </View>
                        <View style={[styles.row, styles.primary, pageStyles.desc, styles.alignCenter]} >
                            <Text style={[styles.text15, styles.textBlack, styles.textGrey]}>
                                {"友邻优课学员资格"}
                            </Text>
                            <Text style={[styles.text15, styles.textBlack, styles.textGrey,]}></Text>
                            <Text style={[styles.textBlack, styles.textRed, styles.text16]}>365</Text>
                            <Text style={[styles.textBlack, styles.textGrey, styles.text16]} >天</Text>
                        </View>
                        {/*{this.state.isReview ?*/}
                        {/*<View style={[styles.row, pageStyles.items,]}>*/}
                        {/*<View style={[pageStyles.iconItem, styles.alignCenter]}>*/}
                        {/*<Image source={require('./imgs/news.png')} style={[pageStyles.icons]}></Image>*/}
                        {/*<Text style={[styles.textCenter, styles.textBlack, styles.text11]}>经济学人杂志</Text>*/}
                        {/*</View>*/}
                        {/*<View style={[pageStyles.iconItem, styles.alignCenter]}>*/}
                        {/*<Image source={require('./imgs/ear.png')} style={[pageStyles.icons]}></Image>*/}
                        {/*<Text style={[styles.textCenter, styles.textBlack, styles.text11]}>无线耳机</Text>*/}
                        {/*</View>*/}
                        {/*<View style={[pageStyles.iconItem, styles.alignCenter]}>*/}
                        {/*<Image source={require('./imgs/note.png')} style={[pageStyles.icons]}></Image>*/}
                        {/*<Text style={[styles.textCenter, styles.textBlack, styles.text11]}>高逼格笔记本</Text>*/}
                        {/*</View>*/}
                        {/*</View> : null*/}
                        {/*}*/}

                        <View style={[styles.row, pageStyles.items]}>
                            <View style={[pageStyles.iconItem, styles.alignCenter]}>
                                <Image source={require('./imgs/news.png')} style={[pageStyles.icons]}></Image>
                                <Text style={[styles.textCenter, styles.textBlack, styles.text11]}>每日新闻解读</Text>
                            </View>
                            <View style={[pageStyles.iconItem, styles.alignCenter]}>
                                <Image source={require('./imgs/xdy.png')} style={[pageStyles.icons]}></Image>
                                <Text style={[styles.textCenter, styles.textBlack, styles.text11]}>专属学习管家</Text>
                            </View>
                            <View style={[pageStyles.iconItem, styles.alignCenter]}>
                                <Image source={require('./imgs/library.png')} style={[pageStyles.icons]}></Image>
                                <Text style={[styles.textCenter, styles.textBlack, styles.text11]}>经典素材讲解</Text>
                            </View>
                            <View style={[pageStyles.iconItem, styles.alignCenter]}>
                                <Image source={require('./imgs/wechat.png')} style={[pageStyles.icons]}></Image>
                                <Text style={[styles.textCenter, styles.textBlack, styles.text11]}>社群活动</Text>
                            </View>
                        </View>
                    </View>

                    {this.state.isReview ? null : <View style={[styles.section, pageStyles.bottomCells]}>
                        <Cell tag={"微信"} content={""} cellPull={true} isWechat={true}
                            cellFun={() => { this._checkItem(0) }} isChecked={this.state.checked == 0} />
                        {/*<Cell tag={"支付宝"} content={""} cellPull={true} cellLast={false} isChecked={this.state.checked == 1}*/}
                        {/*cellFun={() => { this._checkItem(1) }} />*/}
                    </View>
                    }
                    <View style={[styles.alignCenter, { marginBottom: 20 }]}>
                        <TouchableOpacity activeOpacity={1} style={pageStyles.btn} onPress={() => { this._goToPay() }} >
                            <View style={[styles.row, styles.alignCenter]}>
                                <Text style={[{ color: "#fff" }, styles.text18]}>立即支付</Text>
                            </View>
                        </TouchableOpacity>
                    </View>
                </ScrollView>
            </View>
        )
    }
}

class Cell extends Component {
    constructor(props) {
        super(props);
        this.state = {
            isChecked: true,
            isWechat: this.props.isWechat
        };
    }

    render() {
        return (
            <TouchableHighlight activeOpacity={0.97}
                onPress={this.props.cellFun}>
                <View style={styles.bgWhite}>
                    <View style={[styles.cell, this.props.cellLast ? null : styles.cellBorder]}>
                        <View style={[pageStyles.payIcon, styles.alignCenter]} >
                            <Text style={[styles.text14, styles.textCenter, styles.icon, { color: "#fff" }]}>
                                {this.state.isWechat ? Icon.wechat : Icon.wechat}
                            </Text>
                        </View>
                        <View style={styles.primary} >
                            <Text style={[styles.textLeft, styles.text16]}>
                                {this.props.tag}
                            </Text>
                        </View>

                        <View style={[pageStyles.cellPull]}>
                            <Text style={[styles.text18, this.props.isChecked ? styles.textRed : styles.textGrey, styles.textCenter, styles.icon]}>
                                {this.props.isChecked ? Icon.checked : Icon.checkBox}
                            </Text>
                        </View>
                    </View>
                </View>
            </TouchableHighlight>
        )
    }
}

var pageStyles = StyleSheet.create({
    top: {
        paddingTop: 60,
        paddingBottom: 40,
        alignItems: "center",
        backgroundColor: "#fff",
        position: "relative",
        marginTop: 10
    },
    price: {
        fontSize: 36,
        lineHeight: 36
    },
    desc: {
        paddingVertical: 22,
        marginBottom: 40,
        marginTop: 50,
        borderTopWidth: StyleSheet.hairlineWidth,
        borderTopColor: "rgba(200,200,200,0.50)",
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: "rgba(200,200,200,0.50)",
        width: Dimensions.get("window").width - 100,

    },
    items: {
        height: 60,
        justifyContent: "space-between",
        width: Dimensions.get("window").width - 80,
    },
    icons: {
        height: 42,
        width: 48,
        marginBottom: 8,
    },
    payIcon: {
        height: 24,
        width: 24,
        marginRight: 10,
        backgroundColor: "#1fb922",
        borderRadius: 14
    },
    cellPull: {
        width: 24
    },
    bottomCells: {
        //   marginHorizontal: 12
    },
    btn: {
        backgroundColor: "#b41930",
        width: 175,
        height: 45,
        justifyContent: "center",
        alignItems: "center",
        borderRadius: 24,
        marginTop: 25
    },
})
