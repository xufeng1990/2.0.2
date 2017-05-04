//  DetailsHeaderView
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
//configs
import g_AppValue from '../../configs/AppGlobal.js';
//组件
import CachedImage from 'react-native-cached-image';
// 类
export default class DetailsHeaderView extends Component {
    // 构造函数
    constructor(props) {
        super(props);
        this.state = {
            // your code
        };
    }
    static defaultProps = {

        actionFnc() {
        },
        headerFunc() {
        },
        editorFunc() {
        },
        fansFunc() {
        },
        focusFunc() {
        },
        noteFunc () {
        },
        bullyFunc () {
        },
    }
    static propTypes = {
        bullyText: PropTypes.string,
        headerFunc: PropTypes.func,
        headerImage: PropTypes.node,
        nameText: PropTypes.string,
        editorFunc: PropTypes.func,
        editorImage: PropTypes.node,
        contentText: PropTypes.string,
        fansFunc: PropTypes.func,
        fansNumber: PropTypes.node,
        fansText: PropTypes.string,
        focusFunc: PropTypes.func,
        focusNumber: PropTypes.node,
        focusText: PropTypes.string,
        noteFunc: PropTypes.func,
        noteNumber: PropTypes.node,
        noteText: PropTypes.string,
        setingFunc: PropTypes.func,
        setText: PropTypes.string,
        playFunc: PropTypes.func,
        playImage: PropTypes.node,
        bullyFunc: PropTypes.func,
    }
    // render
    render() {
        return (
            <View style={styles.renderForegroundView}>
                <View style={styles.ForegroundView}>
                    <TouchableOpacity activeOpacity={1} onPress={this.props.headerFunc}>
                        <Image style={styles.headerImage} source={this.props.headerImage}/>
                    </TouchableOpacity>
                    <TouchableOpacity activeOpacity={1} style={styles.touchBull} onPress={this.props.bullyFunc}>
                        <View style={styles.bullyImage}>
                            <Text
                                style={{fontSize:11 * g_AppValue.precent,color:'#9a9b9c'}}>{this.props.bullyText}</Text>
                        </View>
                    </TouchableOpacity>
                    <View style={styles.nameView}>
                        <Text style={styles.nameText}>{this.props.nameText}</Text>
                        <TouchableOpacity activeOpacity={1} onPress={this.props.editorFunc}>
                            <Image style={styles.editorImage} source={this.props.editorImage}/>
                        </TouchableOpacity>
                    </View>
                    <View style={styles.contentView}>
                        <Text style={styles.contentText}>{this.props.contentText}</Text>
                    </View>
                    <View style={styles.buttomView}>
                        <TouchableOpacity activeOpacity={1} onPress={this.props.fansFunc}>
                            <View style={styles.FocusView}>
                                <Text style={styles.numberText}>{this.props.fansNumber}</Text>
                                <Text style={styles.FocusText}>{this.props.fansText}</Text>
                            </View>
                        </TouchableOpacity>
                        <TouchableOpacity activeOpacity={1} onPress={this.props.focusFunc}>
                            <View style={styles.FocusView}>
                                <Text style={styles.numberText}>{this.props.focusNumber}</Text>
                                <Text style={styles.FocusText}>{this.props.focusText}</Text>
                            </View>
                        </TouchableOpacity>
                        <TouchableOpacity activeOpacity={1} onPress={this.props.noteFunc}>
                            <View style={styles.FocusView}>
                                <Text style={styles.numberText}>{this.props.noteNumber}</Text>
                                <Text style={styles.FocusText}>{this.props.noteText}</Text>
                            </View>
                        </TouchableOpacity>
                    </View>
                </View>
            </View>
        );
    }
}
var styles = StyleSheet.create({
    renderBackground: {
        width: g_AppValue.screenWidth,
        height: 252 * g_AppValue.precent,
        backgroundColor: '#ffffff'
    },
    renderForegroundView: {
        height: 252 * g_AppValue.precent,
        backgroundColor: '#ffffff',
    },
    leftImg: {
        fontSize: 18 * g_AppValue.precent,
        fontFamily: 'iconfont',
        marginTop: 12.5 * g_AppValue.precent,
        marginLeft: 13 * g_AppValue.precent,
    },
    ForegroundView: {
        width: g_AppValue.screenWidth,
        height: 212 * g_AppValue.precent,
        // backgroundColor:'green',
        marginTop: 20 * g_AppValue.precent,
        alignItems: 'center'
    },
    headerImage: {
        width: 77 * g_AppValue.precent,
        height: 77 * g_AppValue.precent,
        borderRadius: 38.5 * g_AppValue.precent
    },
    nameView: {
        width: g_AppValue.screenWidth,
        height: 20 * g_AppValue.precent,
        marginTop: 8 * g_AppValue.precent,
        //backgroundColor:'red',
        justifyContent: 'center',
        alignItems: 'center',
        flexDirection: 'row'
    },
    nameText: {
        fontSize: 14 * g_AppValue.precent,
        color: '#5a5a5a',
        textAlign: 'center',
        marginLeft: 10 * g_AppValue.precent
    },
    editorImage: {
        width: 16 * g_AppValue.precent,
        height: 16 * g_AppValue.precent,
        marginLeft: 10 * g_AppValue.precent
    },
    contentView: {
        width: 218 * g_AppValue.precent,
        height: 26 * g_AppValue.precent,
        //  backgroundColor:'green',
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 10 * g_AppValue.precent
    },
    contentText: {
        fontSize: 11 * g_AppValue.precent,
        color: '#9a9b9c',
        textAlign: 'center'
    },
    buttomView: {
        width: g_AppValue.screenWidth,
        height: 200,
        //backgroundColor:'yellow',
        marginTop: 22 * g_AppValue.precent,
        flexDirection: 'row',
        justifyContent: 'space-around',
        marginBottom: 20 * g_AppValue.precent
    },
    FocusView: {
        //backgroundColor:'green',
        alignItems: 'center'
    },
    numberText: {
        fontSize: 16 * g_AppValue.precent,
        color: '#5a5a5a'
    },
    FocusText: {
        fontSize: 11 * g_AppValue.precent,
        color: '#9a9b9c',
        marginTop: 6 * g_AppValue.precent,
        marginBottom: 2 * g_AppValue.precent
    },
    touchBull: {
        position: 'absolute',
        width: 57 * g_AppValue.precent,
        height: 23 * g_AppValue.precent,
        top: 45 * g_AppValue.precent,
        right: 0 * g_AppValue.precent,
    },
    bullyImage: {
        width: 57 * g_AppValue.precent,
        height: 23 * g_AppValue.precent,
        borderTopLeftRadius: 15 * g_AppValue.precent,
        borderBottomLeftRadius: 15 * g_AppValue.precent,
        backgroundColor: 'rgb(242,245,246)',
        borderWidth: 1 * g_AppValue.precent,
        borderColor: 'rgb(200,200,200)',
        justifyContent: 'center',
        alignItems: 'center',
    }
})
