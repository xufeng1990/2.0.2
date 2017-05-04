//  Album
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, { Component, PropTypes } from 'react';
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
    Alert
} from 'react-native';
//configs
import g_AppValue from '../../configs/AppGlobal.js';
//组件
import CachedImage from 'react-native-cached-image';
// 类
export default class Album extends Component {

    static defaultProps = {
        titleName: 'name', //标题
        number: 'number', //集数
        cellBackgrondColor: '#ffffff',
        actionFnc() {
        }
    }
    static propTypes = {
        titleName: PropTypes.string,
        number: PropTypes.string,
        cellBackgrondColor: PropTypes.string,
        actionFnc: PropTypes.func,
        imageSource: PropTypes.object
    }
    // render
    render() {
      
        return (
            <View style={styles.itemStyle}>
                <TouchableOpacity activeOpacity={1} onPress={this.props.actionFnc}>
                    <View style={styles.cellView}>
                        <CachedImage defaultSource={require('../../imgs/11.png')} style={styles.ImageView}
                            source={this.props.imageSource} />
                        <Text numberOfLines={1} style={styles.nameTitle}>{this.props.titleName}</Text>
                        <Text style={styles.numberText}>{this.props.number}</Text>
                    </View>
                </TouchableOpacity>
            </View>
        );
    }
}

var styles = StyleSheet.create({
    itemStyle: {
        width: 170 * g_AppValue.precent,
        height: 215 * g_AppValue.precent,
        marginTop: 1 * g_AppValue.precent,
        // 左边距
        marginLeft: 12 * g_AppValue.precent,
        marginBottom: 15 * g_AppValue.precent,
        backgroundColor: '#ffffff',
        shadowColor: 'black',
        shadowRadius: 1,
        shadowOffset: {
            height: 0,
            width: 0
        },
        shadowOpacity: 0.2
    },
    cellView: {
        width: 150 * g_AppValue.precent,
        marginLeft: 10 * g_AppValue.precent,
        marginTop: 10 * g_AppValue.precent
    },
    ImageView: {
        width: 150 * g_AppValue.precent,
        height: 150 * g_AppValue.precent,
    },
    nameTitle: {
        marginTop: 10 * g_AppValue.precent,
        fontSize: 14 * g_AppValue.precent,
        color: '#5a5a5a'
    },
    numberText: {
        marginTop: 6 * g_AppValue.precent,
        fontSize: 11 * g_AppValue.precent,
        color: '#9a9b9c'
    }
})
