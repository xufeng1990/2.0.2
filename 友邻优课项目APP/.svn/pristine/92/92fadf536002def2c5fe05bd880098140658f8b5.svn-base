/**
 * Created by 艺术家 on 2017/3/12.
 */

import React, { Component } from 'react';
import { Text, View, TouchableOpacity, TextInput, Platform } from 'react-native';
//common
import styles from "../../common/styles.js";
import Util from "../../common/util.js";
import Enums from "../../common/enums.js";
import Icon from "../../common/Icon.js";

export default class Header extends Component {
    render() {
        var isIOS = Platform.OS === 'ios'
        var barHeight = isIOS ? 64 : 44;
        var barTopPadding = isIOS ? 20 : 0;
        return (
            <View style={[styles.alignCenter, styles.row, styles.bgWhite,
            { height: barHeight, paddingHorizontal: 12, paddingTop: barTopPadding, }]}
            >
                <View style={{ width: 60 }}>
                    <TouchableOpacity activeOpacity ={1} onPress={this.props.backFun || this.props.LeftFun}>
                        <Text style={[styles.icon, styles.text18,]}>
                            {this.props.LeftBtn || Icon.back}
                        </Text>
                    </TouchableOpacity>
                </View>
                <Text style={[styles.text16, styles.textBlack, styles.primary, styles.textCenter]}>
                    {this.props.title || ""}
                </Text>
                <View style={{ width: 50 }}>
                    <TouchableOpacity activeOpacity ={1} style={{ flexDirection: "row", justifyContent: "flex-end" }} onPress={this.props.rightFun}>

                        <Text style={[styles.icon, styles.text16]}>
                            {this.props.rightBtn || ""}
                        </Text>
                        <Text style={[styles.text14]}>
                            {this.props.rightText || ""}
                        </Text>
                    </TouchableOpacity>
                </View>
            </View>
        )
    }
}
