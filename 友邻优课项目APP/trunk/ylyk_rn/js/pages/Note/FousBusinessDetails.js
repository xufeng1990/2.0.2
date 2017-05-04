//  同学资料
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2017
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
    NativeEventEmitter,
    InteractionManager
} from 'react-native';

import NavigationView from '../../component/Navigator/NavigationView.js';
import UltimateListView from "react-native-ultimate-listview";
import * as ImgUrl from '../../configs/BaseImgUrl.js';
import g_AppValue from '../../configs/AppGlobal.js';
import Util from '../../common/util.js';
import NoteCell from '../../component/AlbumCell/NoteCell.js';
import Icon from '../../common/Icon.js';



import YLYKNatives from "../../configs/ylykbridges/YLYKNatives.js";
import YLYKServices from "../../configs/ylykbridges/YLYKServices.js";
import YLYKStorages from "../../configs/ylykbridges/YLYKStorages.js";

import Loading from '../../component/Loading/Loading.js';
import StudentDetailHeader from '../../component/AlbumCell/StudentDetailsHeader.js';
import BlankPages from '../../component/AlbumCell/BlankPages.js';

var Bridges = NativeModules.BridgeEvents;
const myEvent = new NativeEventEmitter(Bridges);
var subscription;

export default class FousBusinessDetails extends Component {

    _dataSource = new ListView.DataSource({rowHasChanged: (row1, row2) => row1 !== row2})
    _alldata = [] //加载数组
    constructor(props) {
        super(props);
        this.state = {
            is_followee: this.props.nextfollowee,
            focusData: '',
            noteList: '',
            dataSource: this._dataSource.cloneWithRows(this._alldata),
            isShowLoadMore: false,
            thumbNumber: '',
            isLoading: true,
            isPlayingOrPause: 0,
            isExistPlayedTrace: 1
        };
    }

    // 加载完成
    componentDidMount() {
        YLYKServices.$user.getUserById(this.props.fansId + '')
        .then((data) => {
            this.setState({focusData: JSON.parse(data)});
        }).catch((err) => {
        });

        this._onListRefersh();

        this.subscription = myEvent.addListener('playOrPauseToRN', (reminder) => {
            this.setState({isPlayingOrPause: reminder.isPlayingOrPause, isExistPlayedTrace: 1})
        });

        YLYKNatives.$player.isPlayingOrPause().then((data) => {
            this.setState({isPlayingOrPause: data.isPlayingOrPause});

        }).catch((err) => {
        });

    }

    //播放页跳转
    _goToPlayerView(palyId) {
        YLYKNatives.$player.openPlayerController('0', false, '[]');
    }
      //返回按钮
    _goBack() {
       YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show')
        this.props.navigator.pop()
    }


    componentWillUnmount() {
        this.subscription && this.subscription.remove();
        if (this.props.from == 0) {return;}

        DeviceEventEmitter.emit('showNoteTabBar', '1');
        this.showNoteTabBar && this.showNoteTabBar.remove();
    }

    componentWillMount() {
         YLYKNatives.$player.isExistPlayedTrace().then((data) => {
            this.setState({isExistPlayedTrace: data})
        });

        this.showNoteTabBar = DeviceEventEmitter.addListener('showNoteTabBar', (res) => {
            if (res[1] == 2) {
                YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
            } else {
                return;
            }

        });
    }

    _focusStateAction() {
        var rowID = this.props.rowID;
        if (this.state.is_followee == true) {
            YLYKServices.$followee.deleteFollowee({'user_id': this.props.fansId + ''})
            .then((data) => {
                DeviceEventEmitter.emit('noteID', rowID);
                this.setState({
                    is_followee: !this.state.is_followee
                });
            }).catch((err) => {
                console.log("取消错误" + err)
            })
        } else {
            YLYKServices.$followee.createFollowee({'user_id': this.props.fansId + ''})
            .then((data) => {
                DeviceEventEmitter.emit('noteID', rowID);
                this.setState({
                    is_followee: !this.state.is_followee
                });

            }).catch((err) => {
            });
        }
    }


    _noteGotoPlay(playId, is, is2) {
       YLYKNatives.$player.openPlayerController(playId + '', is, is2);
    }

    //复制微信号
    _copyWechat(wechat) {
        if (!wechat) {
            Util.AppToast('该同学尚未填写微信号')
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

    renderHeader() {
        if (!this.state.focusData) {return (<View></View>);}
        var focusData = this.state.focusData;
        var wechat = this.state.focusData.info.wechat;
        var birthday = this.state.focusData.info.birthday.split('-')[0];
        var newYear = new Date().getFullYear();
        var age = newYear - birthday;

        return (
          <StudentDetailHeader
            age={age}
            bullyText={focusData.vip.title}
            headerImage={!this.props.fansId? require('../../imgs/11.png'): {uri: ImgUrl.baseImgUrl + 'user/' + this.props.fansId + '/avatar'}}
            adressText={focusData.info.city}
            nameText={focusData.info.nickname}
            contentText={focusData.info.intro}
            learningTime={parseInt(focusData.stat.listened_time / 60)}
            learningTimeText='学习时长/分钟'
            fansNumber={focusData.stat.fans_count}
            fansText='粉丝' focusNumber={focusData.stat.followee_count}
            focusText='关注'
            focusBuddyfunc={() => {this._focusStateAction()}}
            focusAdd={this.state.is_followee ? '': Icon.plus}
            focusAddText={this.state.is_followee? '已关注': '关注'}
             AddBuddyfunc={() => {this._copyWechat(wechat)}}
             add={Icon.wechat} addText='加好友'/>);
    }

    _renderRow(rowData, sectionID, rowID) {

        var payId = rowData.course.id;
        var str = rowData.content;
        var noteID = rowData.id;
        var is_liked = rowData.is_liked;
        var st = str.replace(/<br>/g, '\n')

        return (
          <NoteCell
            navigator={this.props.navigator}
            headPortraitImage={!this.state.focusData.id? require('../../imgs/11.png'): {uri: ImgUrl.baseImgUrl + 'user/' + this.state.focusData.id + '/avatar'}}
            name={this.state.focusData.info.nickname}
            time={Util.getDiffTime(new Date(rowData.in_time * 1000))}
            content={st} playImage={!this.state.focusData.id? require('../../imgs/43.png'): {uri: ImgUrl.baseImgUrl + 'course/' + rowData.course.id + '/cover'}}
            playTitle={rowData.course.name}
            palyAction={() => this._noteGotoPlay(payId, false, '[]')}
            thumbNumber={rowData.like_count} noteId={noteID}
            is_liked={is_liked} imagesData={rowData.images}
            noteTouchInage={() => {this._noteTouchImages()}}
            />
        );

    }

    //空白页
    _noDataView() {
        return (
            <View style={{justifyContent: 'center',  alignItems: 'center',marginTop: 20 * g_AppValue.precent}}>
                <Text style={{color: '#c8c8c8'}}>Ta还没有发布心得</Text>
            </View>
        );
    }


    render() {

        if (!this.state.focusData && !this.state.noteList) {return (<View></View>)}
        var user_id = this.state.focusData.id;
        <Loading visible = {this.state.isLoading} />
      return (
            <View style={{flex: 1,backgroundColor: '#f2f5f6'  }}>

                <NavigationView
                  navigator={this.props.navigator}
                  leftItemTitle={Icon.back}
                  leftItemFunc={this._goBack.bind(this)}
                  rightItemFunc={() => this._goToPlayerView()}
                  rightImageSource={this.state.isExistPlayedTrace == 1? this.state.isPlayingOrPause == 0? require('../../imgs/play1.png'): require('../../imgs/play.gif'): null}
                  />

                <Loading visible={this.state.isLoading}/>
                {!g_AppValue.isConnected
                    ? <BlankPages ImageUrl={require('../../imgs/none.png')} contentText='无法连接到服务器,请检查你的网络设置'/>
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
                var resultData = JSON.parse(data);
                if (page <= 1) {
                    this._alldata == [];
                };
                for (let i = 0; i < resultData.length; i++) {
                    this._alldata.push(resultData[i])
                };

                this.setState({
                    dataSource: this._dataSource.cloneWithRows(this._alldata),
                    thumbNumber: this._alldata.map((countN) => {return countN.like_count}),
                    isLoading: false
                });

                options.pageLimit = pageLimit;
                callback(resultData, options);

            }).catch((err) => {
                this.setState({isLoading: false})
                console.log("数据错误...." + err)
            })
        })
    }

    _onListRefersh(page = 1, callback, options) {
        this._getCourseList(page, callback, options);
    }

}
