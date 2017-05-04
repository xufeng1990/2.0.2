//  AlbumShows
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
    Alert,
    Modal,
    DeviceEventEmitter
} from 'react-native';
//common
import Icon from "../../common/Icon.js";
import Util from '../../common/util.js';
//configs
import g_AppValue from '../../configs/AppGlobal.js';
import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js'
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js'
//pages
import Download from "../../pages/Download/Download.js";
import Pay from "../../pages/Pay/pay.js";
// 类
export default class AlbumShows extends Component {
    // 构造函数
    _sortingView1 = true;
    constructor(props) {
        super(props);
        this.state = {
            sortingView: this.props.is_finished,
              noLogin: false,
              filterStatus:true,

        };
    }
    goToQiView() {
        YLYKNatives.$qiyu.goToQiyu();
    }
    //打开支付
    goToPayView() {
        this.props.navigator.push({component: Pay})
    }
    //打开下载页面
    _goToDownloadView() {
        YLYKNatives.$oauth.getUserInfo().then((info) => {
            if (info == 0 || info == '0') {
                Util.AppToast('请先登录');
                this.setState({noLogin: false});
            } else {
                this.setState({noLogin: true});
                if (!info.id) {
                    info = JSON.parse(info);
                }
                if (!Util.isVip(info)) {
                    Util.alertDialog({
                        msg: '成为友邻学员即可下载任意课程!',
                        oneBtn: '立即入学',
                        okBtn: '咨询阿树老师',
                        cancelBtn: '取消',
                        okFun: () => {
                            this.goToQiView()
                        },
                        oneFun: () => {
                            this.goToPayView()
                        }
                    });
                } else {
                    this.props.navigator.push({
                        component: Download,
                        params: {
                            albumId: this.props.albumId,
                            albumName: this.props.albumName
                        }
                    });
                }
            }
        })
    }


    _sortingView(identify) {
        if (this._sortingView1) {
            DeviceEventEmitter.emit('changSorting', identify);
          if (identify === 'sort') {
            this.setState({
                sortingView: !this.state.sortingView
            });
          }
            this._sortingView1 = false;
        } else {
            DeviceEventEmitter.emit('changSorting', identify);
          if (identify === 'sort') {
            this.setState({
                sortingView: !this.state.sortingView,

            });
          }

            this._sortingView1 = true;
        }
    }
    render() {
      var identify = ['sort','filter']
        return (
            <View style={{flex: 1}}>
                <View style={styles.topView}>
                    <View style={styles.leftView}>
                        <Text style={styles.numberText}>
                            {this.props.is_finished ? '共' + this.props.course_count + '集' : '更新至' + this.props.course_count + '集'}</Text>
                        <Image style={styles.lineImage}/>
                        <TouchableOpacity activeOpacity={1} onPress={() => {this._sortingView(identify[0])}}>
                            <Text
                                style={[styles.numberText, {marginLeft: 7 * g_AppValue.precent}]}>{this.state.sortingView ? '正序' : '倒序'}</Text>
                        </TouchableOpacity>
                    </View>

                        <View style={styles.rightView}>
                              <TouchableOpacity activeOpacity={1} onPress={() => {this._goToDownloadView()}}>
                              <View style={{flexDirection:'row'}} >
                              <Text style={[styles.numberText, {fontFamily: 'iconfont'}]}>{Icon.download}</Text>
                              <Text style={[styles.numberText,{marginRight:10 * g_AppValue.precent}]}>下载</Text>
                              </View>
                              </TouchableOpacity>



                        </View>

                </View>
            </View>
        );
    }
    // <TouchableOpacity activeOpacity={1} onPress={() => {this._sortingView(identify[1])}}>
    // <View style={{flexDirection:'row'}} >
    // <Text style={[styles.numberText, {fontFamily: 'iconfont'}]}>{Icon.filter}</Text>
    // <Text style={styles.numberText}>筛选</Text>
    // </View>
    // </TouchableOpacity>
}
var styles = StyleSheet.create({
    topView: {
        width: g_AppValue.screenWidth,
        height: 40 * g_AppValue.precent,
        alignItems: 'center',
        backgroundColor: '#ffffff',
        flexDirection: 'row'
    },
    leftView: {
        flexDirection: 'row',
        alignItems: 'center',
        marginLeft: 12 * g_AppValue.precent,
        width: 175.5 * g_AppValue.precent,
    },
    numberText: {
        fontSize: 14 * g_AppValue.precent,
        color: '#9a9b9c'
    },
    lineImage: {
        width: 1 * g_AppValue.precent,
        height: 14 * g_AppValue.precent,
        backgroundColor: 'black',
        marginLeft: 6 * g_AppValue.precent
    },
    arrangementImage: {
        width: 16 * g_AppValue.precent,
        height: 14 * g_AppValue.precent,
        backgroundColor: 'black',
        marginLeft: 8 * g_AppValue.precent
    },
    rightView: {
        justifyContent: 'flex-end',
        alignItems: 'center',
        flexDirection: 'row',
        width: 175.5 * g_AppValue.precent,
    }
})
