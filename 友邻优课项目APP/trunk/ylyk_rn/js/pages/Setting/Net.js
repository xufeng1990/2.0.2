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
//component
import Cell from "../../component/Cells/Cell.js";
import Header from "../../component/HeaderBar/HeaderBar.js";
//组件
import ActionSheet from '@yfuks/react-native-action-sheet';
import DateTimePicker from 'react-native-modal-datetime-picker';
export default class Setting extends Component {
    constructor(props) {
        super(props);
        this.state = {
            version: "1.11.33 Alpha 170809",
        }
    }

    componentDidMount() {
        //获取版本号

    }


    //返回
    _backFun = () => {
        this.props.navigator.pop();
    };

    render() {
        let cellsData = this.state;
        // console.log('url' + this.props.url)
        return (
            <View style={[styles.bgWhite, styles.primary]}>
                <Header backFun={this._backFun} title={"友邻优课"} />
                <WebView style={[styles.primary]}
                    ref={webview => { this.webview = webview; }}
                    source={{ uri: this.props.url }}
                />

            </View>
        )
    }
}


var pageStyles = StyleSheet.create({
    logo: {
        borderRadius: 50,
        borderColor: "#979797",
        borderWidth: 1,
        height: 80,
        width: 80,


    },
    top: {
        paddingTop: 68,
        paddingBottom: 40,
        alignItems: "center",
        borderBottomColor: "#979797",
        borderBottomWidth: StyleSheet.hairlineWidth,
    },
    topContainer: {
        height: 163,
        paddingTop: 10

    },
    courseName: {
        marginTop: 8,
    }
});
