//  AlbumNote
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
    InteractionManager,
} from 'react-native';
//common
import Util from '../../../common/util.js';
//configs
import * as ImgUrl from '../../../configs/BaseImgUrl.js';
import g_AppValue from '../../../configs/AppGlobal.js';


import YLYKNatives from "../../../configs/ylykbridges/YLYKNatives.js";
import YLYKServices from "../../../configs/ylykbridges/YLYKServices.js";
import YLYKStorages from "../../../configs/ylykbridges/YLYKStorages.js";


//component
import BlankPages from '../../../component/AlbumCell/BlankPages.js';
import Loading from '../../../component/Loading/Loading.js';
import NoteCell from '../../../component/AlbumCell/NoteCell.js';
//pages
import MyThumbNoteDetails from './MyThumbNoteDetails.js';
import MyThumbNoteBusinessDetails from './MyThumbNoteBusinessDetails.js';
//组件
import UltimateListView from "react-native-ultimate-listview";








export default class MyThumbNote extends Component {

    _dataSource = new ListView.DataSource({rowHasChanged: (row1, row2) => row1 !== row2});
    _alldata = [];
    _followeeArr = [];
    constructor(props) {
        super(props);
        this.state = {
            dataSource: this._dataSource.cloneWithRows(this._alldata),
            is_followee: this._followeeArr,
            isLoading: true,
        };
    }

    // 加载完成
    componentDidMount() {
        DeviceEventEmitter.addListener('MyThumbNote', (rowID) => {
            var arr = this.state.is_followee;
            arr[rowID] = !arr[rowID];
            this.setState({
                is_followee: arr,
                dataSource: this._dataSource.cloneWithRows(this._alldata),
            });
        });
        this._onListRefersh();
    }

    _noteGotoPlay(playID, is, is2) {
         YLYKNatives.$player.openPlayerController(playID + '', is, is2)
    }

    // view卸载
    componentWillUnmount() {
        this.showNoteTabBar && this.showNoteTabBar.remove();
    }

    componentWillMount() {
        this.showNoteTabBar = DeviceEventEmitter.addListener('showNoteTabBar', (res) => {
            if (res[0] == 1) {
                YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
            } else {
                YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
            }
        });
    }

    _foucsAction(rowData, sectionID, rowID) {
        if (this.state.is_followee == true) {
            YLYKServices.$followee.deleteFollowee({'user_id': rowData.user.id + ''})
            .then((data) => {
                var followeeArr = this.state.is_followee;
                followeeArr[rowID] = !followeeArr[rowID];
                this.setState({
                    is_followee: followeeArr,
                    dataSource: this._dataSource.cloneWithRows(this._alldata)
                })
            }).catch((err) => {
            });
        } else {
           YLYKServices.$followee.createFollowee({'user_id': rowData.user.id + ''})
            .then((data) => {
                var FocusFollowee = this.state.is_followee;
                FocusFollowee[rowID] = !FocusFollowee[rowID];
                this.setState({
                    is_followee: FocusFollowee,
                    dataSource: this._dataSource.cloneWithRows(this._alldata)
                });

            }).catch((err) => {
            });
        }
    }
    //点赞

    _renderItem(item) {
        return (
            <TouchableOpacity activeOpacity={1} style={styles.imageItem}>
                <Image style={styles.imageItem} source={{ uri: item }} />
            </TouchableOpacity>
        );
    }

    _goToDetailsView(fansId, nickname, rowData, nextfollowee, rowID) {
        this.props.navigator.push({
            component: MyThumbNoteDetails,
            params: {
                fansId: fansId,
                nickname: nickname,
                rowData: rowData,
                nextfollowee: nextfollowee,
                rowID: rowID
            }
        })
    }

    _noDataView() {
        return (
            <BlankPages ImageUrl={require('../../../imgs/couse.png')} titleText='课程' contentText='喜欢的课程 值得反复学习' />
        )
    }

    _renderHeaderAction(fansId, rowID) {
        var nextfollowee = this.state.is_followee[rowID];
       YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        this.props.navigator.push({
            component: MyThumbNoteBusinessDetails,
            params: {
                fansId: fansId,
                nextfollowee: nextfollowee,
                rowID: rowID,
                navigator: this.props.navigator,
                isVip: this.props.isVip,
            }
        })
    }

    _rowRow(rowData, sectionID, rowID) {
        var playID = rowData.course.id;
        var str = rowData.content;
        var st = str.replace(/<br>/g, '\n')
        var fansId = rowData.user.id;
        var nickname = rowData.user.nickname;
        var noteID = rowData.id;
        var is_liked = rowData.is_liked;
        var nextfollowee = this.state.is_followee[rowID];

        return (
            <TouchableOpacity activeOpacity={1} onPress={() => {this._goToDetailsView(fansId, nickname, rowData, nextfollowee, rowID)}}>

                <NoteCell
                    navigator={this.props.navigator}
                    headerImageAction={() => { this._renderHeaderAction(fansId, rowID) }}
                    headPortraitImage={!rowData.user.id ? require('../../../imgs/11.png') : { uri: ImgUrl.baseImgUrl + 'user/' + rowData.user.id + '/avatar' }}
                    name={rowData.user.nickname}
                    time={Util.getDiffTime(new Date(rowData.in_time * 1000))}
                    content={st}
                    playImage={!rowData.user.id ? require('../../../imgs/43.png') : { uri: ImgUrl.baseImgUrl + 'course/' + rowData.course.id + '/cover' }}
                    playTitle={rowData.course.name}
                    numberOfLines={6}
                    palyAction={() => this._noteGotoPlay(playID, false, '[]')}
                    thumbNumber={rowData.like_count}
                    noteId={noteID}
                    is_liked={is_liked}
                    imagesData={rowData.images}
                    />


            </TouchableOpacity>
        );
    }

    // render
    render() {
        return (
            <View style={{ flex: 1, backgroundColor: '#f2f5f6' }}>
                <Loading visible={this.state.isLoading} />
                {this.state.isLoading ? null : (!g_AppValue.isConnected
                    ? <BlankPages ImageUrl={require('../../../imgs/none.png')} contentText='无法连接到服务器,请检查你的网络设置' />
                    :
                    <UltimateListView
                        ref='listView'
                        onFetch={this._onListRefersh.bind(this)}
                        enableEmptySections
                        //----Normal Mode----
                        separator={false}
                        rowView={this._rowRow.bind(this)}
                        refreshableTitleWillRefresh="下拉刷新..."
                        refreshableTitleInRefreshing="下拉刷新..."
                        refreshableTitleDidRefresh="Finished"
                        emptyView={this._noDataView.bind(this)}
                        refreshableTitleDidRefreshDuration={10000}
                        allLoadedText=''
                        waitingSpinnerText=''
                    />)
                }
            </View>

        );
    }

    _getCourseList(page, callback, options) {
        const pageLimit = 10;
        InteractionManager.runAfterInteractions(() => {
            YLYKServices.$note.getNoteList({ 'is_liked': 'true', 'limit': pageLimit, page: page })
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
                    });

                }

                this.setState({
                    dataSource: this._dataSource.cloneWithRows(this._alldata),
                    isShowLoadMore: true,
                    is_followee: this._followeeArr,
                    isLoading: false,
                });

                options.pageLimit = pageLimit;
                callback(resultData, options);
            }).catch((err) => {
                this.setState({ isLoading: false})
            });
        });
    }

    _onListRefersh(page = 1, callback, options) {
        this._getCourseList(page, callback, options);
    }
}

var styles = StyleSheet.create({
    listView: {
        flex: 1,
        backgroundColor: '#f2f5f6'
    },
    container: {
        flex: 1,
        width: g_AppValue.screenWidth,
        backgroundColor: '#ffffff',
        marginTop: 10 * g_AppValue.precent,
        flexDirection: 'row'
    },
    HeadPortraitImage: {
        width: 39 * g_AppValue.precent,
        height: 39 * g_AppValue.precent,
        marginTop: 12 * g_AppValue.precent,
        marginLeft: 12 * g_AppValue.precent
    },
    FocusImage: {
        width: 54 * g_AppValue.precent,
        height: 21 * g_AppValue.precent,
        position: 'absolute',
        top: 0 * g_AppValue.precent,
        right: 12 * g_AppValue.precent
    },
    rightBigView: {
        flex: 1,
        width: 295 * g_AppValue.precent,
        marginTop: 17 * g_AppValue.precent,
        marginLeft: 10 * g_AppValue.precent
    },
    nameText: {
        width: 200 * g_AppValue.precent,
        fontSize: 14 * g_AppValue.precent,
        color: '#5a5a5a',
        textAlign: 'left'
    },
    timeText: {
        width: 200 * g_AppValue.precent,
        marginTop: 5 * g_AppValue.precent,
        fontSize: 11 * g_AppValue.precent,
        color: '#9a9b9c',
        textAlign: 'left'
    },
    contentText: {
        width: 295 * g_AppValue.precent,
        marginTop: 8 * g_AppValue.precent,
        fontSize: 13 * g_AppValue.precent,
        color: '#5a5a5a',
        textAlign: 'left'
    },
    ImageView: {
        flex: 1,
        width: 294 * g_AppValue.precent,
        marginLeft: -20 * g_AppValue.precent,
        flexWrap: 'wrap',
        flexDirection: 'row'
    },
    imageItem: {
        width: 88 * g_AppValue.precent,
        height: 88 * g_AppValue.precent,
        marginTop: 10 * g_AppValue.precent,
        marginLeft: 10 * g_AppValue.precent
    },
    payView: {
        marginTop: 20 * g_AppValue.precent,
        width: 284 * g_AppValue.precent,
        height: 48 * g_AppValue.precent,
        flexDirection: 'row'
    },
    payImageOne: {
        width: 64 * g_AppValue.precent,
        height: 48 * g_AppValue.precent
    },
    payImageTwo: {
        position: 'absolute',
        top: 0 * g_AppValue.precent,
        width: 64 * g_AppValue.precent,
        height: 48 * g_AppValue.precent
    },
    payRightView: {
        marginLeft: 10 * g_AppValue.precent,
        width: 210 * g_AppValue.precent,
        height: 48 * g_AppValue.precent
    },
    payRightTitleText: {
        marginTop: 8 * g_AppValue.precent,
        fontSize: 13 * g_AppValue.precent,
        color: '#5a5a5a',
        textAlign: 'left'
    },
    payRightNameText: {
        marginTop: 4 * g_AppValue.precent,
        fontSize: 12 * g_AppValue.precent,
        color: '#5a5a5a',
        textAlign: 'left'
    },
    ThumbView: {
        flex: 1,
        height: 16 * g_AppValue.precent,
        marginTop: 15 * g_AppValue.precent,
        marginBottom: 14 * g_AppValue.precent,
        marginRight: 12 * g_AppValue.precent,
        justifyContent: 'flex-end',
        flexDirection: 'row'
    },
    thumbImage: {
        width: 16 * g_AppValue.precent,
        height: 16 * g_AppValue.precent,
        marginRight: 6 * g_AppValue.precent
    },
    thumbText: {
        fontSize: 14 * g_AppValue.precent,
        color: '#9a9b9c',
        textAlign: 'right'
    }
})
