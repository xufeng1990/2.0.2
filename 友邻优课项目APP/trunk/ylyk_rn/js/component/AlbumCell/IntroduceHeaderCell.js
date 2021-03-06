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
import g_AppValue from '../../configs/AppGlobal.js';
// 类
export default class IntroduceHeaderCell extends Component {
    static defaultProps = {
        titleName: 'name',//标题
        titleNameTwo: 'nameTwo'
    }
    static propTypes = {
        titleName: PropTypes.string,
        titleNameTwo: PropTypes.string,
    }
    // render
    render() {
        return (
            <View style={styles.speakerTeachersTextView}>
                <Image style={styles.leftImage} source={require('../../pages/Course/images/IntroduceLine1.png')}/>
                <Image style={styles.rightImage} source={require('../../pages/Course/images/IntroduceLine1.png')}/>
                <Text style={styles.speakerTeachersText}>{this.props.titleName}</Text>
                <Text style={styles.speakerTeachersTextTwo}>{this.props.titleNameTwo}</Text>
            </View>
        );
    }
    // 自定义方法区域
    // your method
}
var styles = StyleSheet.create({
    speakerTeachersTextView: {
        width: g_AppValue.screenWidth,
        height: 75,
        backgroundColor: '#ffffff',
        alignItems: 'center',
    },
    speakerTeachersText: {
        fontSize: 16,
        color: '#5a5a5a',
        marginTop: 20,
    },
    speakerTeachersTextTwo: {
        fontSize: 11,
        color: '#9a9b9c',
        marginTop: 8,
    },
    leftImage: {
        position: 'absolute',
        top: 52,
        left: 44,
        width: 80,
        height: 1,
    },
    rightImage: {
        position: 'absolute',
        top: 52,
        right: 44,
        width: 80,
        height: 1,
        transform: [{rotateZ: '-180deg'}],
    },
})
