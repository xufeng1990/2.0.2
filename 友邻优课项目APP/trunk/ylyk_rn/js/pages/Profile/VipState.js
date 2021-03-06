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
    DeviceEventEmitter
} from 'react-native';
//common
import styles from "../../common/styles.js";
import Util from "../../common/util.js";
import Enums from "../../common/enums.js";
import Icon from "../../common/Icon.js";
//configs
import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js';
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js';
//component
import Header from "../../component/HeaderBar/HeaderBar.js";
import Loading from "../../component/Loading/Loading.js";
//pages
import Pay from "../Pay/pay.js";
//组件
import ActionSheet from '@yfuks/react-native-action-sheet';
import DateTimePicker from 'react-native-modal-datetime-picker';
import ProgressBar from 'react-native-progress/Circle';


var grey = '#9a9b9c';

export default class VipStates extends Component {
    constructor(props) {
        super(props);
        this.state = {
            userState: "",
            current: "",
            next: "",
            title: "",
            endTime: "",
            isVip: false,
            isPermanent: false
        }
    }

    //渲染前加载数据
    componentWillMount() {
      this.showNoteTabBar =   DeviceEventEmitter.addListener('showNoteTabBar', (hide)=>{
          if (hide[0] == 1) {
            YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
          }
        });

        this.setState({
            userState: this.props.userState,
            current: this.props.userState.score,
            next: this.props.userState.next_level_score,
            title: this.props.userState.title,
            endTime: Util.dateFormat(this.props.userState.end_time),
            avatar: Enums.baseUrl + "user/" + this.props.userId + "/avatar",
            isVip: this.props.isVip,
        })
    }

    componentWillUnmount() {
        DeviceEventEmitter.emit('showProfileTabBar', '1');
        this.showNoteTabBar && this.showNoteTabBar.remove();
    }

    //返回
    _backFun = () => {
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
        this.props.navigator.pop();
    };

    render() {
        let current = this.state.current,
            next = this.state.next,
            title = this.state.title,
            avatar = this.state.avatar;

        return (
            <View>
                <Header backFun={this._backFun} title={"同学权益"} />
                <ScrollView showsVerticalScrollIndicator={false}
                    style={[styles.bgGrey, {height: Dimensions.get("window").height - 44, paddingBottom: 20}]}>
                    <Top style={[pageStyles.top]} current={current} next={next}
                        title={title} endTime={this.state.endTime} navigator={this.props.navigator}/>
                    <Body title={title} avatar={avatar} />
                </ScrollView>
            </View>
        )
    }
}

class Top extends Component {
    //去支付
    _goToPay() {
        let _this = this;
        YLYKNatives.$oauth.getUserInfo().then((userInfo) => {
            if (!userInfo.id) {
                userInfo = JSON.parse(userInfo);
            }
            if (userInfo) {
                if (!Util.isPermanent(userInfo)) {
                    _this.props.navigator.push({
                        component: Pay,
                    })
                } else {
                    Util.AppToast("你是尊贵的终身学员，无须续费")
                }
            }
        })
    }

    render() {
        let current = this.props.current,
            next = this.props.next,
            title = this.props.title,
            endTime = this.props.endTime;

        return (
            <View style={[styles.bgWhite, pageStyles.top]}>
                <ProgressBar style={[pageStyles.progressBar, {zIndex: 5}]} color={"#b41930"}
                    progress={current / next}
                    unfilledColor={"#c8c8c8"} borderWidth={0}
                    size={120} />
                <View style={[pageStyles.value,]}>
                    <Text style={[styles.textGrey, styles.text14, styles.textCenter]}>成长值</Text>
                    <Text style={[styles.textGrey, styles.text16, styles.textCenter]} >
                        <Text style={[styles.textBlack, styles.text18]}>{current}</Text>
                        {"/" + next}
                    </Text>
                    <Text style={[styles.textGrey, styles.text12, pageStyles.title, styles.textCenter]} >
                        {"当前等级：" + title}
                    </Text>
                    <Text style={[styles.textGrey, styles.text12, styles.textCenter]} >
                        {"会员到期时间" + endTime}
                        <Text onPress={() => { this._goToPay() }} style={[styles.textRed, styles.text12]}> 立即续费</Text>
                    </Text>
                </View>
            </View>
        )
    }
}

class Body extends Component {

    render() {
        let title = this.props.title,
            avatar = this.props.avatar,
            scale = getscale();

        //判断等级
        function getscale() {
            if (title == "普通同学") {
                return 1;
            } else if (title == "初级学霸") {
                return 2;
            } else if (title == "中级学霸") {
                return 3;
            } else if (title == "高级学霸") {
                return 4;
            } else if (title == "超级学霸") {
                return 5;
            } else {
                return 0;
            }
        }


        return (
            <View style={[styles.bgWhite, pageStyles.Body, styles.section]}>
                <View>
                    <View style={[pageStyles.titleCell, styles.row]}>
                        <Image style={[styles.avatarSmall, styles.avatarRoundSmall]}
                            source={scale < 1 ? require('./imgs/p-1.png') : (scale > 1 ? require('./imgs/p-2.png') : {uri: avatar})}></Image>
                        <View style={[pageStyles.VipDesc]} >
                            <Text style={[styles.text14, styles.textGrey]}>普通同学</Text>
                            <Text style={[styles.text11, styles.textGrey]}>入学即可成为普通同学</Text>
                        </View>
                    </View>

                    <View style={[pageStyles.vipContent, styles.row]}>
                        <View style={[pageStyles.iconItem]}>
                            <Image source={scale < 1 ? require('./imgs/p-11g.png') : require('./imgs/p-11.png')}
                                style={[pageStyles.icons]}></Image>
                            <Text style={[styles.textCenter, styles.textBlack, styles.text11]}>海量节目</Text>
                        </View>
                        <View style={[pageStyles.iconItem]}>
                            <Image source={scale < 1 ? require('./imgs/p-12g.png') : require('./imgs/p-12.png')}
                                style={[pageStyles.icons]}></Image>
                            <Text style={[styles.textCenter, styles.textBlack, styles.text11]}>学习管家</Text>
                        </View>
                        <View style={[pageStyles.iconItem]}>
                            <Image source={scale < 1 ? require('./imgs/p-13g.png') : require('./imgs/p-13.png')}
                                style={[pageStyles.icons]}></Image>
                            <Text style={[styles.textCenter, styles.textBlack, styles.text11]}>同城社群</Text>
                        </View>
                    </View>
                </View>

                <View style={[pageStyles.titleSection]}>
                    <View style={[pageStyles.titleCell, styles.row]}>
                        <Image source={scale < 2 ? require('./imgs/f-1.png') : (scale > 2 ? require('./imgs/f-2.png') : {uri: avatar})}
                            style={[styles.avatarSmall, styles.avatarRoundSmall]}></Image>
                        <View style={[pageStyles.VipDesc]} >
                            <Text style={[styles.text14, styles.textGrey]}>初级学霸</Text>
                            <Text style={[styles.text11, styles.textGrey]}>初级学霸</Text>
                        </View>
                    </View>
                    <View style={[pageStyles.vipContent, styles.row]}>
                        <View style={[pageStyles.iconItem]}>
                            <Image source={scale < 2 ? require('./imgs/p-21g.png') : require('./imgs/p-21.png')}
                                style={[pageStyles.icons]}></Image>
                            <Text style={[styles.textCenter, styles.textBlack, styles.text11]}>友邻研习班</Text>
                        </View>
                    </View>
                </View>

                <View style={[pageStyles.titleSection]}>
                    <View style={[pageStyles.titleCell, styles.row]}>
                        <Image style={[styles.avatarSmall, styles.avatarRoundSmall]}
                            source={scale < 3 ? require('./imgs/m-1.png') : (scale > 3 ? require('./imgs/m-2.png') : {uri: avatar})}></Image>
                        <View style={[pageStyles.VipDesc]} >
                            <Text style={[styles.text14, styles.textGrey]}>中级学霸</Text>
                            <Text style={[styles.text11, styles.textGrey]}>成长值达到630，升级中级学霸</Text>
                        </View>
                    </View>
                    <View style={[pageStyles.vipContent, styles.row]}>
                        <View style={[pageStyles.iconItem]}>
                            <Image source={scale < 3 ? require('./imgs/p-31g.png') : require('./imgs/p-31.png')}
                                style={[pageStyles.icons]}></Image>
                            <Text style={[styles.textCenter, styles.textBlack, styles.text11]}>优币1.5倍</Text>
                        </View>
                    </View>
                </View>

                <View style={[pageStyles.titleSection]}>
                    <View style={[pageStyles.titleCell, styles.row]}>
                        <Image style={[styles.avatarSmall, styles.avatarRoundSmall]}
                            source={scale < 4 ? require('./imgs/u-1.png') : (scale > 4 ? require('./imgs/u-2.png') : {uri: avatar})}></Image>
                        <View style={[pageStyles.VipDesc]} >
                            <Text style={[styles.text14, styles.textGrey]}>高级学霸</Text>
                            <Text style={[styles.text11, styles.textGrey]}>成长值达到3030，升级高级学霸</Text>
                        </View>
                    </View>
                    <View style={[pageStyles.vipContent, styles.row]}>
                        <View style={[pageStyles.iconItem]}>
                            <Image source={scale < 4 ? require('./imgs/p-31g.png') : require('./imgs/p-31.png')}
                                style={[pageStyles.icons]}></Image>
                            <Text style={[styles.textCenter, styles.textBlack, styles.text11]}>优币2倍</Text>
                        </View>
                        <View style={[pageStyles.iconItem]}>
                            <Image source={scale < 4 ? require('./imgs/p-42g.png') : require('./imgs/p-42.png')}
                                style={[pageStyles.icons]}></Image>
                            <Text style={[styles.textCenter, styles.textBlack, styles.text11]}>友邻实验室</Text>
                        </View>
                    </View>
                </View>

                <View style={[pageStyles.titleSection]}>
                    <View style={[pageStyles.titleCell, styles.row]}>
                        <Image style={[styles.avatarSmall, styles.avatarRoundSmall]}
                            source={scale < 5 ? require('./imgs/s-1.png') : (scale > 5 ? require('./imgs/s-2.png') : {uri: avatar})}></Image>
                        <View style={[pageStyles.VipDesc]} >
                            <Text style={[styles.text14, styles.textGrey]}>超级学霸</Text>
                            <Text style={[styles.text11, styles.textGrey]}>需超级学霸邀请方能升级</Text>
                        </View>
                    </View>
                    <View style={[pageStyles.vipContent, styles.row]}>
                        <View style={[pageStyles.iconItem]}>
                            <Image source={scale < 5 ? require('./imgs/p-51g.png') : require('./imgs/p-51.png')}
                                style={[pageStyles.icons]}></Image>
                            <Text style={[styles.textCenter, styles.textBlack, styles.text11]}>友邻代言人</Text>
                        </View>
                    </View>
                </View>
            </View>
        )
    }
}


var pageStyles = StyleSheet.create({
    top: {
        paddingVertical: 20,
        alignItems: "center",
        backgroundColor: "#fff",
        position: "relative"
    },
    Body: {
        paddingHorizontal: 45,
        paddingVertical: 20,
    },
    titleIcon: {
        height: 38,
        borderRadius: 19
    },
    icons: {
        height: 30,
        width: 30,
        marginBottom: 8,
    },
    titleCell: {

    },
    titleSection: {
        marginBottom: 10
    },
    iconItem: {
        marginRight: 15,
        alignItems: "center",
        justifyContent: "center",
    },
    vipContent: {
        marginHorizontal: 5,
        marginLeft: 17,
        borderLeftWidth: 1,
        borderLeftColor: "#b41930",
        paddingLeft: 34,
        marginVertical: 10
    },

    VipDesc: {
        justifyContent: "space-around",
        marginLeft: 14
    },

    value: {
        paddingTop: 30
    },
    title: {
        marginTop: 50,
        paddingBottom: 8
    },
    progressBar: {
        position: "absolute",
        top: 12,
        left: Dimensions.get("window").width / 2 - 60
    }

})
