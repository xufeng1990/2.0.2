/**
 * Created by 艺术家 on 2017/3/9.
 * page: webview
 */

import React, {Component} from 'react';
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
import ActionSheet from '@yfuks/react-native-action-sheet';
import DateTimePicker from 'react-native-modal-datetime-picker';
//common
import  styles from "../../common/styles.js";
import  Util from  "../../common/util.js";
import Enums from "../../common/enums.js";
import Icon from "../../common/Icon.js";
// import  Header from "../../component/HeaderBar/HeaderBar.js";


export default class Setting extends Component {
    constructor(props) {
        super(props);
        this.state = {
            title: "",
            source: "",
            mesg: "",
        }
    }
    componentDidMount() {
    }
    //返回
    _backFun = () => {
        this.props.navigator.pop();
    };
    render() {
        let cellsData = this.state;
        return (
            <View style={[styles.bgWhite,styles.primary]}>
                {/*<Header backFun={this._backFun} title={this.state.title}  />*/}
                <WebView style={[styles.primary]}
                         ref={webview => { this.webview = webview; }}
                         source={{uri:this.state.source}}
                />
            </View>
        )
    }
}
