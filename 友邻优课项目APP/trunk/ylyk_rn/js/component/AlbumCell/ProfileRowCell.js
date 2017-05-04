//  ProfileRowCell
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, {Component, PropTypes} from 'react';
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
} from 'react-native';
import g_AppValue from '../../configs/AppGlobal.js';
// 类
export default class ProfileRowCell extends Component {
    // 构造函数
    static defaultProps = {
        name: 'name',//标题
        foucsActionFnc() {
        },
        cellBackgrondColor: '',
        contentText: '',
    }
    static propTypes = {
        name: PropTypes.string,
        contentText: PropTypes.string,
        cellBackgrondColor: PropTypes.string,
        foucsActionFnc: PropTypes.func,
        headerImage: PropTypes.object,
        focusImagePath: PropTypes.number,
    }
    // render
    render() {
        return (
            <View style={styles.rowView}>
                <Image style={styles.headerImage} source={this.props.headerImage}/>
                <View style={styles.cintentView}>
                    <Text style={styles.nameText}>{this.props.name}</Text>
                    <Text style={styles.introduceText}>{this.props.contentText}</Text>
                </View>
                <TouchableOpacity style={styles.touchFocusImage} onPress={this.props.foucsActionFnc}>
                    <Image style={styles.focusImage} source={this.props.focusImagePath}/>
                </TouchableOpacity>
            </View>
        );
    }
}
var styles = StyleSheet.create({
    rowView: {
        width: g_AppValue.screenWidth,
        height: 82 * g_AppValue.precent,
        backgroundColor: '#ffffff',
        marginTop: 10 * g_AppValue.precent,
        flexDirection: 'row',
    },
    headerImage: {
        width: 58 * g_AppValue.precent,
        height: 58 * g_AppValue.precent,
        marginTop: 15 * g_AppValue.precent,
        marginLeft: 12 * g_AppValue.precent,
        borderRadius: 29 * g_AppValue.precent,
    },
    cintentView: {
        width: 200 * g_AppValue.precent,
        height: 35 * g_AppValue.precent,
        // backgroundColor:'red',
        marginLeft: 12 * g_AppValue.precent,
        marginTop: 25 * g_AppValue.precent,
    },
    nameText: {
        fontSize: 14 * g_AppValue.precent,
        color: '#5a5a5a',
    },
    introduceText: {
        fontSize: 11 * g_AppValue.precent,
        color: '#9a9b9c',
        marginTop: 8 * g_AppValue.precent,
    },
    touchFocusImage: {
        //  backgroundColor:'black',
        position: 'absolute',
        top: 31 * g_AppValue.precent,
        right: 12 * g_AppValue.precent,
        bottom: 30 * g_AppValue.precent,
    },
    focusImage: {
        width: 54 * g_AppValue.precent,
        height: 21 * g_AppValue.precent,
    }
})
