/**
 * Created by 艺术家 on 2017/3/12.
 */

import React, { Component } from 'react';
import { Text, View, TouchableOpacity, TextInput, Switch,  DeviceEventEmitter } from 'react-native';
//common
import Icon from "../../common/Icon.js";
import styles from "../../common/styles.js";
import Util from "../../common/util.js";
//configs


import YLYKNatives from "../../configs/ylykbridges/YLYKNatives.js";
import YLYKServices from "../../configs/ylykbridges/YLYKServices.js";
import YLYKStorages from "../../configs/ylykbridges/YLYKStorages.js";

//component
import Header from "../../component/HeaderBar/HeaderBar.js";



//颜色常量
const GREEN = "#B41930";


export default class WeChat extends Component {
    constructor(props) {
        super(props);
        this.state = {
            wechat: this.props.wechat,
            switch: true,
            id: this.props.id,
        }
    }

    componentWillMount() {
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar("hide");
        this.setState({
            wechat: this.props.wechat,
            switch: this.props.isPublic,
        })
    }
    componentWillUnmount() {
        DeviceEventEmitter.emit('showProfileTabBar', '1');
    }
    //返回
    _backFun = () => {
            YLYKNatives.$showOrHideTabbar.showOrHideTabbar("show");
        this.props.navigator.pop();
    };

    //保存微信
    _saveWechat() {
        let wechat = this.state.wechat;

        if (Util.isMobilephone(wechat) || Util.isQQ(wechat) || Util.isWechat(wechat)) {
            this.props.setWechat(this.state.wechat, this.state.switch);
            this.props.navigator.pop();
        } else {
            Util.alert({
                msg: "请填写正确的微信号",
                cancelBtn: ""
            })
        }
    }


    render() {
        return (
            <View style={[styles.bgGrey, styles.primary]}>
                <Header backFun={this._backFun} title={"我的微信"} rightBtn={Icon.save} rightFun={() => { this._saveWechat() }} />
                <View style={[styles.section]}>
                    <View style={[styles.bgWhite,]}>
                        <TextInput style={[styles.text16, { height: 60, padding: 10, textAlignVertical: "top" }]} multiline={false}
                            placeholder={"请输入您的微信号"}
                            maxLength={20} value={this.state.wechat} autoFocus={true}
                            underlineColorAndroid="transparent"
                            onChangeText={(wechat) => {
                                this.setState({ wechat })
                            }} />
                    </View>
                </View>

            </View>
        )
    }
}

// <View style={[styles.row, styles.section, styles.bgWhite, styles.alignCenter, { paddingHorizontal: 12, height: 57 }]} >
//     <Text style={[styles.primary, styles.textLeft, styles.textBlack, styles.text16]}>
//         向他人公开微信号
//         </Text>
//     <Switch onTintColor={GREEN} value={this.state.switch} onValueChange={(newValue) => {
//         this.setState({
//             switch: newValue
//         })
//     }}
//     />
// </View>
