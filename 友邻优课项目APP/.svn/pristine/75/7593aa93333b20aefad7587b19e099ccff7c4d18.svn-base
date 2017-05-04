//  StudentDetailHeader
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
    Platform,
} from 'react-native';
//configs
import g_AppValue from '../../configs/AppGlobal.js';
// 类
export default class StudentDetailHeader extends Component {
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
    }
    static propTypes = {
        bullyText: PropTypes.string,
        headerImage: React.PropTypes.node,
        nameText: PropTypes.string,
        contentText: PropTypes.string,
        learningTime: PropTypes.number,
        learningTimeText: PropTypes.string,
        fansNumber: PropTypes.node,
        fansText: PropTypes.string,
        focusFunc: PropTypes.func,
        focusNumber: PropTypes.node,
        focusText: PropTypes.string,
        leftFunc: PropTypes.func,
        leftText: PropTypes.string,
        rightFunc: PropTypes.func,
        rightImage: PropTypes.node,
        focusAdd: PropTypes.string,
        focusAddText: PropTypes.string,
        focusBuddyfunc: PropTypes.func,
        AddBuddyfunc: PropTypes.func,
        add: PropTypes.string,
        addText: PropTypes.string,
        adressText: PropTypes.string,
        age: PropTypes.string,
    }
    // render
    render() {
        return (
            <View style={styles.renderForegroundView}>
                <View style={styles.bullyImage}>
                    <Text style={{fontSize:11 * g_AppValue.precent,color:'#9a9b9c'}}>{this.props.bullyText}</Text>
                </View>
                <TouchableOpacity activeOpacity={1} style={styles.leftImage} onPress={this.props.leftFunc}>
                    <Text style={styles.leftImg}>{this.props.leftText}</Text>
                </TouchableOpacity>
                <TouchableOpacity activeOpacity={1} style={styles.rightImage} onPress={this.props.rightFunc}>
                    <Image style={styles.rightImg} source={this.props.rightImage}/>
                </TouchableOpacity>
                <View style={styles.ForegroundView}>
                    <TouchableOpacity activeOpacity={1}>
                        <Image style={styles.headerImage} source={this.props.headerImage}/>
                    </TouchableOpacity>
                    <View style={styles.nameView}>
                        <Text style={styles.nameText}>{this.props.nameText} </Text>
                        <Text style={{fontSize:14 *g_AppValue.precent,color:'#9a9b9c',marginTop:-2*g_AppValue.precent}}>
                            | </Text>
                        <Text
                            style={{fontSize:11*g_AppValue.precent,color:'#9a9b9c',marginTop:3*g_AppValue.precent }}>{this.props.age}岁 · {this.props.adressText}</Text>
                    </View>
                    <View style={styles.contentView}>
                        <Text style={styles.contentText}>{this.props.contentText}</Text>
                    </View>
                    <View style={styles.buttomView}>
                        <View style={styles.FocusView}>
                            <Text style={styles.numberText}>{this.props.learningTime}</Text>
                            <Text style={styles.FocusText}>{this.props.learningTimeText}</Text>
                        </View>
                        <View style={styles.FocusView}>
                            <Text style={styles.numberText}>{this.props.fansNumber}</Text>
                            <Text style={styles.FocusText}>{this.props.fansText}</Text>
                        </View>
                        <View style={styles.FocusView}>
                            <Text style={styles.numberText}>{this.props.focusNumber}</Text>
                            <Text style={styles.FocusText}>{this.props.focusText}</Text>
                        </View>
                    </View>
                    <View style={styles.buttomOneView}>
                        <TouchableOpacity activeOpacity={1} onPress={this.props.focusBuddyfunc}>
                            <View style={styles.FocusButtonImage}>
                                <Text
                                    style={{fontSize:14 *g_AppValue.precent,color:'#B41930',fontFamily:'iconfont'}}>{this.props.focusAdd} </Text>
                                <Text
                                    style={{fontSize:14 *g_AppValue.precent,color:'#B41930',}}>{this.props.focusAddText}
                                </Text>
                            </View>
                        </TouchableOpacity>
                        <TouchableOpacity activeOpacity={1} onPress={this.props.AddBuddyfunc}>
                            <View style={styles.weiXinButtonImage}>
                                <Text
                                    style={{fontSize:14 *g_AppValue.precent,color:'#B41930',fontFamily:'iconfont',marginTop:3 *g_AppValue.precent}}>{this.props.add} </Text>
                                <Text
                                    style={{fontSize:14 *g_AppValue.precent,color:'#B41930',}}>{this.props.addText}</Text>
                            </View>
                        </TouchableOpacity>
                    </View>
                </View>
            </View>
        );
    }
    // 自定义方法区域
    // your method
}
var styles = StyleSheet.create({
    renderBackground: {
        width: g_AppValue.screenWidth,
        height: 325 * g_AppValue.precent,
        backgroundColor: '#ffffff',
    },
    renderForegroundView: {
        height: 325 * g_AppValue.precent,
        backgroundColor: '#ffffff',
        //marginBottom:10* g_AppValue.precent,
    },
    ForegroundView: {
        width: g_AppValue.screenWidth,
        height: 285 * g_AppValue.precent,
        //  backgroundColor:'red',
        marginTop: 20 * g_AppValue.precent,
        alignItems: 'center',
    },
    headerImage: {
        width: 77 * g_AppValue.precent,
        height: 77 * g_AppValue.precent,
        borderRadius: 38.5 * g_AppValue.precent
    },
    nameView: {
        width: g_AppValue.screenWidth,
        height: 25 * g_AppValue.precent,
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
        fontWeight: 'bold',
    },
    contentView: {
        width: 218 * g_AppValue.precent,
        height: 26 * g_AppValue.precent,
        //  backgroundColor:'green',
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 10 * g_AppValue.precent,
    },
    contentText: {
        fontSize: 11 * g_AppValue.precent,
        color: '#9a9b9c',
        textAlign: 'center',
    },
    buttomView: {
        width: g_AppValue.screenWidth,
        //backgroundColor:'yellow',
        marginTop: 22 * g_AppValue.precent,
        flexDirection: 'row',
    },
    FocusView: {
        //backgroundColor:'green',
        width: 125 * g_AppValue.precent,
//  backgroundColor:'red',
        justifyContent: 'center',
        alignItems: 'center',
    },
    numberText: {
        fontSize: 16 * g_AppValue.precent,
        color: '#5a5a5a',
    },
    FocusText: {
        fontSize: 11 * g_AppValue.precent,
        color: '#9a9b9c',
        marginTop: 6 * g_AppValue.precent,
    },
    bullyImage: {
        position: 'absolute',
        borderTopLeftRadius: 15 * g_AppValue.precent,
        borderBottomLeftRadius: 15 * g_AppValue.precent,
        width: 57 * g_AppValue.precent,
        height: 23 * g_AppValue.precent,
        top: 65 * g_AppValue.precent,
        right: 0 * g_AppValue.precent,
        backgroundColor: 'rgb(242,245,246)',
        borderWidth: 1 * g_AppValue.precent,
        borderColor: 'rgb(200,200,200)',
        justifyContent: 'center',
        alignItems: 'center',
    },
    buttomOneView: {
        width: g_AppValue.screenWidth,
        height: 40 * g_AppValue.precent,
//  backgroundColor:'black',
        marginTop: 30 * g_AppValue.precent,
        marginBottom: 30 * g_AppValue.precent,
        flexDirection: 'row',
    },
    FocusButtonImage: {
        width: 116 * g_AppValue.precent,
        height: 36 * g_AppValue.precent,
        //  backgroundColor: 'red',
        marginLeft: 55 * g_AppValue.precent,
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 20 * g_AppValue.precent,
        borderWidth: 1 * g_AppValue.precent,
        borderColor: '#B41930',
        flexDirection: 'row',
        marginTop: 2 * g_AppValue.precent,
    },
    weiXinButtonImage: {
        width: 116 * g_AppValue.precent,
        height: 36 * g_AppValue.precent,
        //  backgroundColor: 'green',
        marginLeft: 34 * g_AppValue.precent,
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 20 * g_AppValue.precent,
        borderWidth: 1 * g_AppValue.precent,
        borderColor: '#B41930',
        flexDirection: 'row',
        marginTop: 2 * g_AppValue.precent,
    }
});
