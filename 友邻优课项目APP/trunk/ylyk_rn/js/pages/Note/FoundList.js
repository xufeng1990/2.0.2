//  FoundList
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
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
    Platform,
    InteractionManager,
    NativeEventEmitter
} from 'react-native';
//common
import Util from '../../common/util.js';
//configs
import * as ImgUrl from '../../configs/BaseImgUrl.js';
import g_AppValue from '../../configs/AppGlobal.js';



import YLYKNatives from "../../configs/ylykbridges/YLYKNatives.js";
import YLYKServices from "../../configs/ylykbridges/YLYKServices.js";
import YLYKStorages from "../../configs/ylykbridges/YLYKStorages.js";

//component
import NoteCell from '../../component/AlbumCell/NoteCell.js';
import NoteBanner from '../../component/Banner/NoteBanner.js';
import Loading from '../../component/Loading/Loading.js';
import BlankPages from '../../component/AlbumCell/BlankPages.js';
//pages
import BusinessDetails from './BusinessDetails.js';
import NoteFoundDetails from './NoteFoundDetails.js';
//组件
import UltimateListView from "react-native-ultimate-listview";
//登陆
var LoginEvents = NativeModules.LoginEvent;
const myLoginEvent = new NativeEventEmitter(LoginEvents);
var loginSubscription;

export default class FoundList extends Component {

    _dataSource = new ListView.DataSource({
        rowHasChanged: (row1, row2) => row1 !== row2
    });
    _alldata = []; //加载数组
    _followeeArr = []; //关注数组

    constructor(props) {
        super(props);
        this.state = {
            is_followee: this._followeeArr,
            dataSource: this._dataSource.cloneWithRows(this._alldata),
            thumbNumber: '',
            isLoading: true,
            //自己的id
            myId: 0,
            like_count: 0,
            isConnected: true
        };
    }

    // 加载完成
    componentDidMount() {

        this._onListRefersh();

        this.noteListener = DeviceEventEmitter.addListener('noteID', (rowID) => {
            var arr = this.state.is_followee;
            arr[rowID] = !arr[rowID];
            var number = this.state.like_count;

            this.setState({
                is_followee: arr,
                dataSource: this._dataSource.cloneWithRows(this._alldata),
                thumbNumber: number
            })

        })

        //获取自己ID
        YLYKNatives.$oauth.getUserInfo().then((data) => {
            this.setState({ myId: data.id })
        });
    }

    // view卸载
    componentWillUnmount() {
        this.noteListener && this.noteListener.remove();
        this.showNote && this.showNote.remove();
        this.showNoteTabBar && this.showNoteTabBar.remove();
        this.loginSubscription && this.loginSubscription.remove();

    }
    componentWillMount() {
        this.showNote = DeviceEventEmitter.addListener('showNote', () => {
            YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
        });

        this.showNoteTabBar = DeviceEventEmitter.addListener('showNoteTabBar', (res) => {
            if (res[1] == 2) {
                YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
            } else {
                return;
            }
        });

        this.loginSubscription = myLoginEvent.addListener('LoginSuccess', (reminder) => {
            this._getCourseList();
        });

    }

    _noteGotoPlay(payId, is, is2) {
        YLYKNatives.$player.openPlayerController(payId + '', is, is2);
    }

    _foucsAction(rowData, sectionID, rowID) {
        if (this.state.is_followee == true) {
            YLYKServices.$followee.deleteFollowee({ 'user_id': rowData.user.id + '' })
                .then((data) => {
                    var followeeArr = this.state.is_followee;
                    followeeArr[rowID] = !followeeArr[rowID];

                    this.setState({
                        is_followee: followeeArr,
                        dataSource: this._dataSource.cloneWithRows(this._alldata)
                    })
                }).catch((err) => {
                })
        } else {
            YLYKServices.$followee.createFollowee({ 'user_id': rowData.user.id + '' })
                .then((data) => {
                    DeviceEventEmitter.emit('refreshData', rowData.user.id);
                    var FocusFollowee = this.state.is_followee;
                    FocusFollowee[rowID] = !FocusFollowee[rowID];
                    this.setState({
                        is_followee: FocusFollowee,
                        dataSource: this._dataSource.cloneWithRows(this._alldata)
                    })
                }).catch((err) => {
                })
        }
    }

    _renderHeader() {
        return (
            <View style={{ flex: 1 }}>
                <View style={styles.sectionView}>
                    <Text style={styles.sectionText}>全部心得</Text>
                </View>
            </View>
        );
    }

    //跳转详情页
    _goToDetailsView(fansId, nickname, rowData, rowID) {
        var thumbNumber = this.state.thumbNumber[rowID];
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        this.props.navigator.push({
            component: NoteFoundDetails,
            params: {
                fansId: fansId,
                nickname: nickname,
                rowData: rowData,
                rowID: rowID,
                thumbNumber: thumbNumber
            }
        })
    }

    //跳转同学资料页
    _renderHeaderAction(fansId, nextfollowee, rowID) {
        var thumbNumber = this.state.thumbNumber[rowID];
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        this.props.navigator.push({
            component: BusinessDetails,
            params: {
                fansId: fansId,
                nextfollowee: nextfollowee,
                rowID: rowID,
                thumbNumber: thumbNumber
            }
        })
    }
    //
    _renderRow(rowData, sectionID, rowID) {

        var payId = rowData.course.id;
        var str = rowData.content;
        var st = str.replace(/<br>/g, '\n')
        var fansId = rowData.user.id;
        var nickname = rowData.user.nickname;
        var nextfollowee = this.state.is_followee[rowID];
        var noteID = rowData.id;
        var is_liked = rowData.is_liked;
        var isMe = rowData.user.id == this.state.myId;

        return (
            <TouchableOpacity
                activeOpacity={1}
                onPress={() => this._goToDetailsView(fansId, nickname, rowData, nextfollowee, rowID)}
            >
                <NoteCell
                    navigator={this.props.navigator}
                    headPortraitImage={!rowData.user.id ? require('../../imgs/11.png') : { uri: ImgUrl.baseImgUrl + 'user/' + rowData.user.id + '/avatar' }}
                    headerImageAction={() => this._renderHeaderAction(fansId, nextfollowee, rowID)}
                    name={rowData.user.nickname}
                    time={Util.getDiffTime(new Date(rowData.in_time * 1000))}
                    content={st}
                    playImage={!rowData.user.id ? require('../../imgs/43.png') : { uri: ImgUrl.baseImgUrl + 'course/' + rowData.course.id + '/cover' }}
                    playTitle={rowData.course.name}
                    palyAction={() => this._noteGotoPlay(payId, false, '[]')}
                    numberOfLines={6}
                    isMe={isMe}
                    foucsActionFnc={() => { this._foucsAction(rowData, sectionID, rowID) }}
                    thumbNumber={rowData.like_count}
                    noteId={noteID}
                    is_liked={is_liked}
                    imagesData={rowData.images}
                />

            </TouchableOpacity>

        );
    }
    //没有数据页面
    _noDataView() {
        return (<BlankPages ImageUrl={require('../../imgs/note.png')} titleText='关注评价' contentText='学习除了大量输入之外也要有内化和输出的过程' />);
    }

    render() {
        if (!this.state.dataSource) { return (<View></View>) }
        return (
            <View style={styles.container}>

                <Loading visible={this.state.isLoading} />
                {this.state.isLoading ? null : (g_AppValue.isConnected
                    ? <UltimateListView
                        ref='listView'
                        onFetch={this._onListRefersh.bind(this)}
                        enableEmptySections
                        //----Normal Mode----
                        separator={false}
                        headerView={this._renderHeader.bind(this)}
                        rowView={this._renderRow.bind(this)}
                        refreshableTitleWillRefresh="下拉刷新..."
                        refreshableTitleInRefreshing="下拉刷新..."
                        refreshableTitleDidRefresh="Finished"
                        refreshableTitleDidRefreshDuration={10000}
                        emptyView={this._noDataView.bind(this)}
                        allLoadedText='' waitingSpinnerText='' />

                    : <BlankPages ImageUrl={require('../../imgs/none.png')} contentText='无法连接到服务器,请检查你的网络设置' />)
                }
            </View>
        );
    }

    //获取数据
    _getCourseList(page, callback, options) {
        const pageLimit = 10;
        InteractionManager.runAfterInteractions(() => {
            YLYKServices.$note.getNoteList({ 'page': page, 'limit': pageLimit })
                .then((data) => {
                    if (page <= 1) {
                        this._alldata = [];
                    }

                    var resultData = JSON.parse(data);
                    for (let i = 0; i < resultData.length; i++) {
                        this._alldata.push(resultData[i]);
                         YLYKServices.$user.getUserById(resultData[i].user.id + '').then((data) => {
                            var userByIdDate = JSON.parse(data);
                            this._followeeArr.push(userByIdDate.is_followee);
                        }).catch((err) => {
                        })
                    };

                    this.setState({
                        dataSource: this._dataSource.cloneWithRows(this._alldata),
                        is_followee: this._followeeArr,
                        thumbNumber: this._alldata.map((countN) => { return countN.like_count }),
                        isLoading: false
                    });

                    options.pageLimit = pageLimit;
                    callback(resultData, options);

                }).catch((err) => {
                    this.setState({ isLoading: false })

                })
        })
    }

    _onListRefersh(page = 1, callback, options) {
        this._getCourseList(page, callback, options);
    }

}

var styles = StyleSheet.create({
    container: {
        ...Platform.select({
            ios: {
                marginBottom: 45 * g_AppValue.precent
            }
        }),
        backgroundColor: '#f2f5f6',
        flex: 1
    },
    sectionView: {
        width: g_AppValue.screenWidth,
        height: 56 * g_AppValue.precent,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#ffffff',
        borderBottomWidth: 1 * g_AppValue.precent,
        borderBottomColor: '#c8c8c8'
    },
    sectionText: {
        fontSize: 16 * g_AppValue.precent,
        color: '#5a5a5a'
    }
})
