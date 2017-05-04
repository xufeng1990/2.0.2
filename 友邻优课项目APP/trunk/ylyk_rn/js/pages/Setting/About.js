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
    WebView,
    TouchableOpacity,
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
import * as RnNativeModules from "../../configs/RnNativeModules.js";
//component
import Cell from "../../component/Cells/Cell.js";
import Header from "../../component/HeaderBar/HeaderBar.js";
//pages
import Net from "./Net.js"
//组件
import ActionSheet from '@yfuks/react-native-action-sheet';
import DateTimePicker from 'react-native-modal-datetime-picker';
import OrientationLoadingOverlay from 'react-native-orientation-loading-overlay';
const WEBSITEURL = 'http://www.youlinyouke.com/';
const LICENSEURL = 'http://m.youlinyouke.com/app/license.html';
export default class Setting extends Component {
    constructor(props) {
        super(props);
        this.state = {
            version: "1.11.33 Alpha 170809",
        }
    }


    //渲染前
    componentWillMount() {
        //获取版本号
        YLYKNatives.$application.getVersion().then((version) => {
            YLYKNatives.$application.getBuild().then((build) => {
                this.setState({
                    version: version + " build " + build
                })
            })
        })
    }

    componentDidMount() {


    }

    _openWeb() {
        this.props.navigator.push({
            component: Net,
            params: {
                url: WEBSITEURL
            }
        })
    }
    _weixin() {
        Util.alert({
            msg: "微信公众号" + 'youlinyouke' + "已复制到粘贴板，请到微信添加公众号页面粘贴并搜索",
            okBtn: "打开微信",
            cancelBtn: "取消",
            okFun: () => {
                Util.openWx('youlinyouke');
            }
        })
    }

    _license() {
        this.props.navigator.push({
            component: Net,
            params: {
                url: LICENSEURL,

            }
        })
    }


    //返回
    _backFun = () => {
        this.props.navigator.pop();
    };

    render() {
        let cellsData = this.state;
        return (
            <View style={[styles.bgWhite, styles.primary]}>
                <Header backFun={this._backFun} title={"关于我们"} />
                <View style={pageStyles.top} >


                    <Image style={{ width: 80 * g_AppValue.precent, height: 80 * g_AppValue.precent, resizeMode: 'cover' }}
                        source={require('../../imgs/logo.png')}
                    />


                    <Text style={[styles.text16, { marginTop: 20 * g_AppValue.precent }]} >
                        友邻优课
                            </Text>
                    <Text style={[styles.textGrey, { marginTop: 12 * g_AppValue.precent }]} >
                        {this.state.version}
                    </Text>
                </View>

                <View >
                    <Text style={[{ paddingTop: 42 * g_AppValue.precent }, styles.textCenter, styles.text14]}
                        onPress={() => {
                            this._openWeb();
                        }}
                    >
                        访问官方网站
                        </Text>

                    <Text style={[{ paddingTop: 48 * g_AppValue.precent }, styles.textCenter, styles.text14]} onPress={() => { this._weixin() }} >
                        关注微信公众号
                        </Text>
                    <Text style={[{ paddingTop: 48 * g_AppValue.precent }, styles.textCenter, styles.text14]} onPress={() => { this._license() }} >
                        查看隐私政策及许可协议
                        </Text>
                </View>

            </View>
        )
    }
}


var pageStyles = StyleSheet.create({
    logo: {
        borderRadius: 40 * g_AppValue.precent,
        borderColor: "#979797",
        borderWidth: 1 * g_AppValue.precent,
        height: 80 * g_AppValue.precent,
        width: 80 * g_AppValue.precent,
        justifyContent: 'center',
        alignItems: 'center',


    },
    top: {
        paddingTop: 68 * g_AppValue.precent,
        paddingBottom: 40 * g_AppValue.precent,
        alignItems: "center",
        borderBottomColor: "#979797",
        borderBottomWidth: StyleSheet.hairlineWidth,
    },
    topContainer: {
        height: 163 * g_AppValue.precent,
        paddingTop: 10 * g_AppValue.precent

    },
    courseName: {
        marginTop: 8 * g_AppValue.precent,
    }
});
