//  "NewClass"
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

// 类
import g_AppValue from '../../configs/AppGlobal.js';
export default class BlankPages extends Component {
    static propTypes = {
        contentText: PropTypes.string,
        titleText: PropTypes.string,          // nav标题
        buttomText: PropTypes.string,          // nav标题
        ImageUrl: PropTypes.object,
        buttonFunc: PropTypes.func,
    };
    render() {
        return (
            <View style={styles.container}>
                <Image style={styles.ImageView} source={this.props.ImageUrl}/>
                <Text style={styles.titleText}>{this.props.titleText}</Text>
                <Text style={styles.textStyle}>{this.props.contentText}</Text>
                <TouchableOpacity onPress={this.props.buttonFunc}>
                    <Text style={styles.titleText}>{this.props.buttomText}</Text>
                </TouchableOpacity>
            </View>
        );
    }
    // 自定义方法区域
    // your method
}
var styles = StyleSheet.create({
    container: {
        backgroundColor: '#ffffff',
        height: g_AppValue.screenHeight,
        alignItems: 'center',
    },
    ImageView: {
        marginTop: 117 * g_AppValue.precent,
        width: 115 * g_AppValue.precent,
        height: 115 * g_AppValue.precent,
        //  backgroundColor:'black',
        borderRadius: 57.5 * g_AppValue.precent,
        resizeMode: 'contain',
    },
    titleText: {
        fontSize: 24 * g_AppValue.precent,
        color: '#5a5a5a',
        marginTop: 30 * g_AppValue.precent,
    },
    textStyle: {
        width: 140 * g_AppValue.precent,
        marginTop: 25 * g_AppValue.precent,
        fontSize: 14 * g_AppValue.precent,
        color: '#5a5a5a',
        justifyContent: 'center',
        alignItems: 'center',
        textAlign: 'center',
        flexWrap: 'wrap',
    },
    buttomView: {
        width: 105 * g_AppValue.precent,
        height: 31 * g_AppValue.precent,
        borderRadius: 20 * g_AppValue.precent,
        backgroundColor: '#0fabfa',
        marginTop: 40 * g_AppValue.precent,
        justifyContent: 'center',
        alignItems: 'center',
    },
    buttomText: {
        fontSize: 16 * g_AppValue.precent,
        color: '#ffffff',
    }
})
