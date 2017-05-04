//  同学资料
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2017
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, { Component } from 'react';
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
    NativeEventEmitter,
    InteractionManager,
} from 'react-native';
//common
import Util from '../../common/util.js';
import Icon from '../../common/Icon.js';
//configs
import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js';
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js';
import * as ImgUrl from '../../configs/BaseImgUrl.js';
import g_AppValue from '../../configs/AppGlobal.js';
//component
import NavigationView from '../../component/Navigator/NavigationView.js';
import NavigationBar from '../../component/Navigator/NavigationBar.js';
import NoteCell from '../../component/AlbumCell/NoteCell.js';
import BlankPages from '../../component/AlbumCell/BlankPages.js';
import StudentDetailHeader from '../../component/AlbumCell/StudentDetailsHeader.js';
import Loading from '../../component/Loading/Loading.js';
//pages
import ProfileView from './ProfileView.js';
import FoucsClass from './FocusClass.js';
//组件
import UltimateListView from "react-native-ultimate-listview";

var Bridges = NativeModules.BridgeEvents;
const myEvent = new NativeEventEmitter(Bridges);
var subscription;
export default class StudentsInformation extends Component {

    _dataSource = new ListView.DataSource({rowHasChanged: (row1, row2) => row1 !== row2});
    _alldata = [];  // 加载数组
    constructor(props) {
        super(props);
        this.state = {
            StudentsData: '',
            is_followee: this.props.is_followee,
            dataSource: this._dataSource.cloneWithRows(this._alldata),
            isShowLoadMore: false,
            // 点赞数
            thumbNumber: '',
            isLoading: true,
            isPlayingOrPause: 0,
            isExistPlayedTrace: 1,
        };
    }

    // 加载完成
    componentDidMount() {
      YLYKServices.$user.getUserById(this.props.fansId + '').then((data) => {
            this.setState({ StudentsData: JSON.parse(data) });
        }).catch((err) => {
        });
        //git状态监听
        this.subscription = myEvent.addListener('playOrPauseToRN', (reminder) => {
            this.setState({ isPlayingOrPause: reminder.isPlayingOrPause, isExistPlayedTrace: 1 });
        });

          YLYKNatives.$player.isPlayingOrPause()
            .then((data) => {
                this.setState({ isPlayingOrPause: data.isPlayingOrPause });
            }).catch((err) => {
            })
    }

    // view卸载
    componentWillUnmount() {
        this.chengFans && this.chengFans.remove();
        this.showNoteTabBar && this.showNoteTabBar.remove();
        this.subscription && this.subscription.remove();
    }

    //跳转播放页
    _goToPlayerView() {
        YLYKNatives.$player.openPlayerController('0', false, '[]');

    }

    componentWillMount() {
          YLYKNatives.$player.isExistPlayedTrace()
            .then((data) => {
                this.setState({ isExistPlayedTrace: data })
            });

        this.showNoteTabBar = DeviceEventEmitter.addListener('showNoteTabBar', (res) => {
            if (res[1] == 2) {
                 YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
            } else {
                return;
            }
        })
    }
    //返回按键
    _goBack() {
        this.props.navigator.pop();
        DeviceEventEmitter.emit('fansData', '1');
    }
    //关注实现
    _focusStateAction() {
        var rowID = this.props.rowID;
        if (this.state.is_followee == true) {
            YLYKServices.$followee.deleteFollowee({'user_id': this.props.fansId + ''})
            .then((data) => {
                DeviceEventEmitter.emit('changeRowId', rowID);
                this.setState({
                    is_followee: !this.state.is_followee
                });
            }).catch((err) => {
            });
        } else {
          YLYKServices.$followee.createFollowee({'user_id': this.props.fansId + ''})
            .then((data) => {
                DeviceEventEmitter.emit('changeRowId', rowID);
                this.setState({
                    is_followee: !this.state.is_followee
                });
            }).catch((err) => {
            });
        }
    }

    //心得点击播放
    _noteGotoPlay(payId, is, is2) {
      YLYKNatives.$player.openPlayerController(payId + '', is, is2);

    }

    _copyWechat(wechat) {
        if (!wechat) {
            Util.AppToast('该同学尚未填写微信号');
        } else {
            Util.alert({
                msg: "微信号" + wechat + "已复制到粘贴板，请到微信添加朋友页面粘贴并搜索",
                okBtn: "打开微信",
                cancelBtn: "取消",
                okFun: () => {
                    Util.openWx(wechat);
                }
            })
        }
    }

    _noDataView() {
        return (
            <View style={{ justifyContent: 'center', alignItems: 'center', marginTop: 20 * g_AppValue.precent }}>
                <Text style={{ color: '#c8c8c8' }}>Ta还没有发布心得</Text>
            </View>
        );
    }
    renderHeader() {
        if (!this.state.StudentsData) {return (<View></View>);}
        var HeaderData = this.state.StudentsData;
        var wechat = this.state.StudentsData.info.wechat;
        var birthday = this.state.StudentsData.info.birthday.split('-')[0];
        var newYear = new Date().getFullYear();
        var age = newYear - birthday;

        return (
            <StudentDetailHeader
                age={age}
                bullyText={this.props.isVip == false ? '普通用户' : HeaderData.vip.title}
                headerImage={!this.props.fansId ? require('../../imgs/11.png') : { uri: ImgUrl.baseImgUrl + 'user/' + this.props.fansId + '/avatar' }}
                nameText={HeaderData.info.nickname}
                contentText={HeaderData.info.intro}
                learningTime={parseInt(HeaderData.stat.listened_time / 60)}
                learningTimeText='学习时长/分钟'
                fansNumber={HeaderData.stat.fans_count}
                fansText='粉丝'
                AddBuddyfunc={() => { this._copyWechat(wechat) }}
                focusNumber={HeaderData.stat.followee_count}
                focusText='关注'
                focusBuddyfunc={() => { this._focusStateAction() }}
                focusAdd={this.state.is_followee ? '' : Icon.plus}
                focusAddText={this.state.is_followee ? '已关注' : '关注'}
                adressText={HeaderData.info.city}
                add={Icon.wechat}
                addText='加好友'
            />
        );
    }

    _renderRow(rowData, sectionID, rowID) {
        var payId = rowData.course.id;
        var noteID = rowData.id;
        var is_liked = rowData.is_liked;
        var str = rowData.content;
        var st = str.replace(/<br>/g, '\n')
        var like_count = rowData.like_count;
        return (

            <NoteCell
                navigator={this.props.navigator}
                headPortraitImage={!this.state.StudentsData.id ? require('../../imgs/11.png') : { uri: ImgUrl.baseImgUrl + 'user/' + this.state.StudentsData.id + '/avatar' }}
                name={this.state.StudentsData.info.nickname}
                time={Util.getDiffTime(new Date(rowData.in_time * 1000))}
                content={st}
                playImage={!rowData.course.id ? require('../../imgs/43.png') : { uri: ImgUrl.baseImgUrl + 'course/' + rowData.course.id + '/cover' }}
                playTitle={rowData.course.name}
                palyAction={() => this._noteGotoPlay(payId, false, '[]')}
                thumbNumber={like_count}
                noteId={noteID}
                is_liked={is_liked}
                imagesData={rowData.images}
            />);
    }

    // render
    render() {
        if (!this.state.dataSource && !this.state.StudentsData) {return (<View></View>)}
        var HeaderData = this.state.StudentsData;

        return (

            <View style={{flex: 1,backgroundColor: '#f2f5f6'}}>

                <NavigationView
                    navigator={this.props.navigator}
                    leftItemTitle={Icon.back}
                    leftItemFunc={this._goBack.bind(this)}
                    rightItemFunc={() => this._goToPlayerView()}
                    rightImageSource={this.state.isExistPlayedTrace == 1 ? this.state.isPlayingOrPause == 0 ? require('../../imgs/play1.png') : require('../../imgs/play.gif') : null}
                />

                <Loading visible={this.state.isLoading} />

                {!g_AppValue.isConnected
                    ? <BlankPages ImageUrl={require('../../imgs/none.png')} contentText='无法连接到服务器,请检查你的网络设置' />
                    : <UltimateListView
                        ref='listView'
                        onFetch={this._onListRefersh.bind(this)}
                        enableEmptySections
                        //----Normal Mode----
                        separator={false}
                        headerView={this.renderHeader.bind(this)}
                        rowView={this._renderRow.bind(this)}
                        refreshableTitleWillRefresh="下拉刷新..."
                        refreshableTitleInRefreshing="下拉刷新..."
                        refreshableTitleDidRefresh="Finished"
                        refreshableTitleDidRefreshDuration={10000}
                        emptyView={this._noDataView.bind(this)}
                        allLoadedText=''
                        waitingSpinnerText=''
                    />

                }

            </View>
        );
    }

    _getCourseList(page, callback, options) {
        const pageLimit = 10;
        InteractionManager.runAfterInteractions(() => {
        YLYKServices.$note.getNoteList({'page': page,'limit': pageLimit,'user_id': this.props.fansId + ''})
            .then((data) => {
                if (page <= 1) {
                    this._alldata = [];
                }

                var resultData = JSON.parse(data);

                for (let i = 0; i < resultData.length; i++) {
                    this._alldata.push(resultData[i]);
                }

                this.setState({
                    dataSource: this._dataSource.cloneWithRows(this._alldata),
                    isLoading: false
                });

                options.pageLimit = pageLimit;
                callback(resultData, options);

            }).catch((err) => {
                this.setState({ isLoading: false, })
            });

        });
    }

    _onListRefersh(page = 1, callback, options) {
        this._getCourseList(page, callback, options);
    }
}
