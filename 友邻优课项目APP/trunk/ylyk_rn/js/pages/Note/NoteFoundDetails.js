//  NoteDetails
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
    NativeModules,
    DeviceEventEmitter,
    Platform,
    NativeEventEmitter
} from 'react-native';
//common
import Util from '../../common/util.js';
import Icon from '../../common/Icon.js';
//configs
import * as ImgUrl from '../../configs/BaseImgUrl.js';
import g_AppValue from '../../configs/AppGlobal.js';


import YLYKNatives from "../../configs/ylykbridges/YLYKNatives.js";
import YLYKServices from "../../configs/ylykbridges/YLYKServices.js";
import YLYKStorages from "../../configs/ylykbridges/YLYKStorages.js";

//component
import NoteCell from '../../component/AlbumCell/NoteCell.js';
//pages
import BusinessDetails from './BusinessDetails.js';
import Pay from '../Pay/pay.js';



var Bridges = NativeModules.BridgeEvents;
const myEvent = new NativeEventEmitter(Bridges);
var subscription;

//登陆监听
var LoginEvents = NativeModules.LoginEvent;
const myLoginEvent = new NativeEventEmitter(LoginEvents);
var loginSubscription;
//退出登录成功
var LogoutEvents = NativeModules.LogoutEvent;
const myLogoutEvent = new NativeEventEmitter(LogoutEvents);
var logoutSubscription
export default class NoteFoundDetails extends Component {

    _dataSource = new ListView.DataSource({
        rowHasChanged: (row1, row2) => row1 !== row2
    });
    _alldata = []; //加载数组
    _followeeArr = []; //点赞数组
    constructor(props) {
        super(props);
        this.state = {
            dataSource: this._dataSource.cloneWithRows(this._alldata),
            thumbNumber: this.props.thumbNumber,
            isPlayingOrPause: 0,
            noLogin: false,
            noVip: false,
            isExistPlayedTrace: 1,

        };
    }

    componentWillMount() {
        this.showNoteTabBar = DeviceEventEmitter.addListener('showNoteTabBar', (res) => {
            if (res[1] == 2 || res[1] == '2') {
                YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
            } else {
                return;
            }
        });

        this.subscription = myEvent.addListener('playOrPauseToRN', (reminder) => {
            this.setState({isPlayingOrPause: reminder.isPlayingOrPause, isExistPlayedTrace: 1})
        });

        YLYKNatives.$player.isPlayingOrPause().then((data) => {
            this.setState({isPlayingOrPause: data.isPlayingOrPause});
        }).catch((err) => {
        });

        this._getUserID();

        //登陆成功监听
        this.loginSubscription = myLoginEvent.addListener('LoginSuccess', (reminder) => {
            this._getUserID();
        });

        this.logoutSubscription = myLogoutEvent.addListener('LogoutSuccess', (reminder) => {
            if (reminder.LogoutSuccess) {
                this._getUserID();
            }
        });

        YLYKNatives.$player.isExistPlayedTrace().then((data) => {
            this.setState({isExistPlayedTrace: data})
        });
    }

    // 加载完成
    componentDidMount() {}

    // view卸载
    componentWillUnmount() {
        var hide = [1, 2];
        DeviceEventEmitter.emit('showNote', hide);
        this.showNoteTabBar && this.showNoteTabBar.remove();
        this.loginSubscription && this.loginSubscription.remove();
        this.logoutSubscription && this.logoutSubscription.remove();
        this.subscription && this.subscription.remove();
        //
    }

    _noteGotoPlay(payId, is, is2) {
        YLYKNatives.$player.openPlayerController(payId + '', is, is2)
    }

    _goBack() {
       YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
        this.props.navigator.pop();

    }

    _goToPlayerView() {
        if (this.state.noLogin == false) {
            Util.AppToast('请先登录');
        } else {
            if (this.state.noVip == false) {
                this._alert();
            } else {
                YLYKNatives.$player.openPlayerController('0', false, '[]');
            }
        }

    }

    _Business(nextfollowee, rowID) {
        this.props.navigator.push({
            component: BusinessDetails,
            params: {
                from: 0,
                fansId: this.props.fansId,
                nextfollowee: nextfollowee,
                rowID: rowID
            }
        })
    }


    goToQiView() {
        YLYKNatives.$qiyu.goToQiyu();
    }

    goToPayView() {
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        this.props.navigator.push({component: Pay})
    }

    _alert() {
        Util.alertDialog({
            msg: '成为友邻学员即可收听此课程',
            oneBtn: '立即入学',
            okBtn: '咨询阿树老师',
            cancelBtn: '取消',
            okFun: () => {this.goToQiView()},
            oneFun: () => {this.goToPayView()}
        })
    }
    _getUserID() {
        YLYKNatives.$oauth.getUserInfo().then((data) => {
            var resultData = JSON.parse(data);
            if (data == 0 || data == '0') {
                this.setState({noLogin: false});
            } else {
                this.setState({noLogin: true});
                let isVip = Util.isVip(resultData);
                if (isVip == false) {
                    this.setState({noVip: false});
                } else {
                    this.setState({noVip: true})
                }

            }
        }).catch((err) => {
        })

    }
    // render
    render() {
        var str = this.props.rowData.content;
        var st = str.replace(/<br>/g, '\n')
        var payId = this.props.rowData.course.id;
        var nextfollowee = this.props.nextfollowee;
        var rowID = this.props.rowID;
        var noteID = this.props.rowData.id;
        var is_liked = this.props.rowData.is_liked;
        var liked_count = this.props.rowData.like_count;

        return (
            <View style={styles.container}>

                <View style={styles.headerView}>

                    <View style={styles.headerContentView}>

                        <TouchableOpacity activeOpacity={1} style={styles.backButtomA} onPress={() => {this._goBack()}}>
                            <Text style={styles.backButtom}>{Icon.back}</Text>
                        </TouchableOpacity>

                        <Text style={styles.headerTitle}>心得详情</Text>

                        <TouchableOpacity activeOpacity={1} style={styles.gotoPalyButtomA} onPress={() => {this._goToPlayerView()}}>

                            <Image style={styles.gotoPalyButtom} source={this.state.isExistPlayedTrace == 1
                                ? this.state.isPlayingOrPause == 0
                                    ? require('../../imgs/play1.png')
                                    : require('../../imgs/play.gif')
                                : null}/>

                        </TouchableOpacity>
                    </View>

                </View>

                <ScrollView>

                    <NoteCell
                      navigator={this.props.navigator}
                      headPortraitImage={!this.props.rowData.user.id? require('../../imgs/11.png'): {uri: ImgUrl.baseImgUrl + 'user/' + this.props.rowData.user.id + '/avatar'  }}
                      headerImageAction={() => {this._Business(nextfollowee, rowID)}}
                      name={this.props.rowData.user.nickname}
                      time={Util.getDiffTime(new Date(this.props.rowData.in_time * 1000))}
                      content={st}
                      playImage={!this.props.rowData.user.id? require('../../imgs/11.png'): {uri: ImgUrl.baseImgUrl + 'course/' + this.props.rowData.course.id + '/cover'}}
                      playTitle={this.props.rowData.course.name}
                      palyAction={() => {this._noteGotoPlay(payId, false, '[]')}}
                      thumbNumber={liked_count} noteId={noteID}
                      is_liked={is_liked}
                      imagesData={this.props.rowData.images}
                      />

                </ScrollView>
            </View>
        );
    }


}

var styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#ffffff'
    },
    headerView: {
        width: g_AppValue.screenWidth,
        height: Platform.OS == 'ios'
            ? 64 * g_AppValue.precent
            : 44 * g_AppValue.precent,
        backgroundColor: '#ffffff'
    },
    headerContentView: {
        width: g_AppValue.screenWidth,
        height: 24 * g_AppValue.precent,
        marginTop: Platform.OS == 'ios'
            ? 31 * g_AppValue.precent
            : 11 * g_AppValue.precent,
        justifyContent: 'center',
        alignItems: 'center'
    },
    headerTitle: {
        fontSize: 18 * g_AppValue.precent,
        color: '#5a5a5a'
    },
    backButtomA: {
        position: 'absolute',
        left: 12 * g_AppValue.precent,
        marginTop: Platform.OS == 'ios'
            ? 0
            : 3 * g_AppValue.precent
    },
    backButtom: {
        fontSize: 18 * g_AppValue.precent,
        fontFamily: 'iconfont',
    },
    gotoPalyButtomA: {
        position: 'absolute',
        width: 24 * g_AppValue.precent,
        top: 5 * g_AppValue.precent,
        height: 24 * g_AppValue.precent,
        right: 11 * g_AppValue.precent,
        marginTop: Platform.OS == 'ios'
            ? 0
            : 3 * g_AppValue.precent
    },
    gotoPalyButtom: {

        width: 18 * g_AppValue.precent,
        height: 18 * g_AppValue.precent,

    }
})
