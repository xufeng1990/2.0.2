//  AlbumDetailsCell
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, {Component} from 'react';
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
//common
import Util from '../../../common/util.js';
//configs
import g_AppValue from '../../../configs/AppGlobal.js';
import YLYKNatives from '../../../configs/ylykbridges/YLYKNatives.js';
import * as ImgUrl from '../../../configs/BaseImgUrl.js';
//pages
import Pay from '../../Pay/pay.js';
//组件
import CachedImage from 'react-native-cached-image';
// 类
export default class AlbumShowsCell extends Component {
    // 构造函数
    constructor(props) {
        super(props);
        this.state = {
            activeColor: false,
            is_listened: this.props.listened,//听过的课
            noVip: false,//非会员
            noLogin: false,//未登录
        }
    }

    // 加载完成
    componentDidMount() {

        this._getUserID();
    }

    //播放
    _goToPage(is1, is, is2) {
        if (this.state.noLogin == false) {
            Util.AppToast('请先登录');
        } else {
            if (this.state.noVip == false) {
                this._alert();
            } else {
                YLYKNatives.$player.openPlayerController(is1, is, is2);

            }
        }

        this.setState({activeColor: true})

    }

    //咨询页面
    goToQiView() {
      YLYKNatives.$qiyu.goToQiyu();
       YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');


    }
    //支付页面
    goToPayView() {
       YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        this.props.navigator.push({component: Pay});
    }

    _alert() {
        Util.alertDialog({
            msg: '成为友邻学员即可收听此课程',
            oneBtn: '立即入学',
            okBtn: '咨询阿树老师',
            cancelBtn: '取消',
            okFun: () => {
                this.goToQiView()
            },
            oneFun: () => {
                this.goToPayView()
            }
        })
    }

//获取用户信息
    _getUserID() {
      YLYKNatives.$oauth.getUserInfo()
        .then((data) => {
            var resultData = JSON.parse(data);
            if (data == 0 || data == '0') {
                this.setState({noLogin: false});
            } else {
                this.setState({noLogin: true});
                let isVip = Util.isVip(resultData);
                if (isVip == false) {
                    this.setState({noVip: false});
                } else {
                    this.setState({noVip: true});
                }
            }
        }).catch((err) => {
        })

    }

    render() {
        if (!this.props.data) {return (<View></View>)}

        return (

            <TouchableOpacity activeOpacity ={1} onPress={() => this._goToPage(this.props.data.id + '', true, this.props.allData)}>
                <View style={[styles.backgroundView, {backgroundColor: '#ffffff'}]}>

                    <CachedImage defaultSource={require('../../../imgs/43.png')} source={{uri: ImgUrl.baseImgUrl + 'course/' + this.props.data.id + '/cover'}} style={styles.leftImage}/>
                    <View style={styles.rightBigView}>
                        <Text numberOfLines={1} style={[styles.titleText, {color: this.state.is_listened? '#c8c8c8': '#5a5a5a'}]}>{this.props.data.name}</Text>
                        <View style={{flexDirection: 'row',justifyContent: 'space-between'}}>

                            <View>
                                <Text style={[styles.teacherNameText, {color: this.state.is_listened ? '#c8c8c8': '#5a5a5a'}]}>{this.props.data.teachers[0].name}</Text>
                                <View style={{flexDirection: 'row'}}>
                                    <Text style={[styles.timeText, {color: this.state.is_listened? '#c8c8c8': '#5a5a5a'}]}>{Util.timeFormat(this.props.data.duration)}</Text>

                                    {this.props.albumId == 6 || this.props.albumId == 31
                                        ? <Text style={[styles.timeText, {marginLeft: 20 * g_AppValue.precent,color: this.state.is_listened? '#c8c8c8': '#5a5a5a'}]}>{Util.dateFormat(this.props.data.in_time, 'yyyy-MM-dd')}</Text>: null}

                                </View>

                            </View>

                            <TouchableOpacity activeOpacity ={1}>
                                <Image style={styles.playButton} source={require('../images/showPlay.png')}/>
                            </TouchableOpacity>
                        </View>
                    </View>

                </View>
            </TouchableOpacity>

        );
    }

    // 自定义方法区域
    // your method

}

var styles = StyleSheet.create({
    backgroundView: {
        height: 110 * g_AppValue.precent,
        width: g_AppValue.screenWidth,
        marginTop: 10 * g_AppValue.precent,
        flexDirection: 'row'
    },
    leftImage: {
        width: 120 * g_AppValue.precent,
        height: 90 * g_AppValue.precent,
        marginTop: 10 * g_AppValue.precent,
        marginLeft: 13 * g_AppValue.precent
    },
    rightBigView: {
        marginLeft: 15 * g_AppValue.precent,
        marginTop: 24 * g_AppValue.precent,
        width: 206 * g_AppValue.precent,
        //height:64 * g_AppValue.precent,
        //backgroundColor:'green',
    },
    titleText: {
        fontSize: 14 * g_AppValue.precent,
        fontWeight: 'bold'
    },
    teacherNameText: {
        fontSize: 12 * g_AppValue.precent,

        marginTop: 20 * g_AppValue.precent
    },
    timeText: {
        fontSize: 11 * g_AppValue.precent,

        marginTop: 2 * g_AppValue.precent
    },
    playButton: {
        marginTop: 25 * g_AppValue.precent,
        width: 24 * g_AppValue.precent,
        height: 24 * g_AppValue.precent,

        // right:21 * g_AppValue.precent,
        // top:65 * g_AppValue.precent,
        //backgroundColor:'green',
    }
})
