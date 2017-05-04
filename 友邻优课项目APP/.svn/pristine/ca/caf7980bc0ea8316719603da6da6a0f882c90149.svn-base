//  MyNoteList
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
    Modal,
    DeviceEventEmitter,
    InteractionManager,
    Platform,
    ActivityIndicator
} from 'react-native';

import {SwRefreshScrollView, SwRefreshListView, RefreshStatus, LoadMoreStatus} from 'react-native-swRefresh';
//common
import Icon from '../../common/Icon.js';
import Until from '../../common/util.js';
//configs
import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js';
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js';
import YLYKStorages from '../../configs/ylykbridges/YLYKStorages.js';

import g_AppValue from '../../configs/AppGlobal.js';
import * as ImgUrl from '../../configs/BaseImgUrl.js';
//component
import BlankPages from '../../component/AlbumCell/BlankPages.js';
import Loading from '../../component/Loading/Loading.js';
//组件
import UltimateListView from "react-native-ultimate-listview";
import ImageViewer from 'react-native-image-zoom-viewer';
import ImageZoom from 'react-native-image-pan-zoom';
// 类
export default class MyNoteList extends Component {
    _dataSource = new ListView.DataSource({
        rowHasChanged: (row1, row2) => row1 !== row2
    });
    _alldata = [];
    _followeeArr = [];
    constructor(props) {
        super(props);
        this.state = {
            dataSource: this._dataSource.cloneWithRows(this._alldata),
            modalVisible: false,
            isLoading: true,
            isConnected: true,
            saveModalVisible: false,
            showImages: [],
            item:'',
            imageIndex: 0
        };
    }

    // 加载完成
    componentDidMount() {}

    componentWillMount() {}

    // view卸载
    componentWillUnmount() {
        DeviceEventEmitter.emit('showProfileTabBar', '1');
    }

    _goBack() {
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
        DeviceEventEmitter.emit('refreshData');
        this.props.navigator.pop();
    }

    _showModal(item,images, i) {
        this.setState({modalVisible: true, imageIndex: i, showImages: images,item:item})
    }

    _closeModal() {
        this.setState({modalVisible: false,})
    }

    //保存图片
    _save(img) {
        YLYKStorages.$fileStorage.saveImage(img).then((data) => {}).catch((err) => {})
    }

    _goToPlayView(payId) {
        YLYKNatives.$player.openPlayerController(payId + '', false, '[]');
    }



    _renderItem(item, images, i) {
        return (
            <TouchableOpacity activeOpacity={1} style={styles.imageItem} onPress={() => {
                this._showModal(item,images, i)
            }}>

                    <Image style={styles.imageItem}  source={{uri: item.url + '$c180w180h'}} />

            </TouchableOpacity>
        );
    }

    _deleteFunc(noteId, sectionID, rowID) {
      YLYKServices.$note.deleteNote(noteId + '').then((data) => {
            this._alldata.splice(rowID, 1);

            this.setState({
                dataSource: this._dataSource.cloneWithRows(this._alldata),
            });

        }).catch((err) => {
            if (err.code == '401' || err.code == 401) {
                Util.AppToast('登录失效,请重新登陆')
            }
        })
    }

    _deleteNote(noteId, sectionID, rowID) {
        console.log('删除心得')
        Until.alert({
            msg: '确定要删除这条心得吗',
            okBtn: '删除',
            cancelBtn: '取消',
            okFun: () => { this._deleteFunc(noteId, sectionID, rowID) }
        })
    }



    _rowRow(rowData, sectionID, rowID) {
        let that = this;
        if (!rowData) {
            return (
                <View></View>
            );
        }
        var payId = rowData.course.id;
        var noteId = rowData.id;
        var in_time = Until.dateFormat(rowData.in_time, 'yyyy-MM-dd');
        var str = in_time.split('-');
        var is_liked = rowData.is_liked;
        var images = [];
        for (var i = 0; i < rowData.images.length; i++) {
            var image = {url: rowData.images[i]}
            images.push(image);
        }
        console.log('qwertyuiop[]' + is_liked)

        return (
            <View style={styles.cellView}>
                <View style={styles.cellContentView}>
                    <Text selectable = {true} style={styles.contentText}>{rowData.content.replace(/<br>/g, '\n')}</Text>
                    <View style={styles.ImageView}>
                        {images.map((item, i) => that._renderItem(item, images, i))}
                    </View>

                    <TouchableOpacity activeOpacity={1} onPress={() => that._goToPlayView(payId)}>
                        <View style={styles.payView}>
                            <Image style={styles.payImageOne} source={!rowData.course.id
                                ? require('../../imgs/43.png')
                                : {
                                    uri: ImgUrl.baseImgUrl + 'course/' + rowData.course.id + '/cover'
                                }}/>

                            <View style={styles.payRightView}>
                                <Text style={styles.payRightTitleText}>{rowData.course.name}</Text>
                                <Text style={styles.payRightNameText}></Text>
                            </View>
                        </View>
                    </TouchableOpacity>
                    <View style={styles.ThumbView}>
                        <TouchableWithoutFeedback style={styles.deleteTextAction} onPress={() => {that._deleteNote(noteId, sectionID, rowID)}}>
                            <Text style={styles.deleteText}>删除</Text>
                        </TouchableWithoutFeedback>
                        <View style={{flexDirection:'row'}}>
                        <Text style={{fontSize:14* g_AppValue.precent,fontFamily:'iconfont',  color: '#9a9b9c'}}>{Icon.like}</Text>
                        <Text style={{fontSize:14* g_AppValue.precent,marginLeft:5* g_AppValue.precent,  color: '#9a9b9c'}}>{rowData.like_count}</Text>
                        </View>
                    </View>
                </View>

                <View style={styles.timeView}>
                    <Text style={{fontSize: 18 * g_AppValue.precent,color: '#5a5a5a'}}>{str[2]}
                    </Text>
                    <Text style={{fontSize: 11 * g_AppValue.precent,color: '#9a9b9c',marginTop: 7 * g_AppValue.precent}}>
                        {str[1]}月</Text>
                </View>
                <Modal style={{
                    backgroundColor: 'black'
                }} visible={this.state.modalVisible}>
                    <ImageViewer
                      index={this.state.imageIndex}
                      loadingRender = {() => {
                        return <View style = {{width:100 * g_AppValue.precent,height:100 * g_AppValue.precent}} >
                                  <Image style = {{width:100 * g_AppValue.precent,height:100 * g_AppValue.precent}} source = {{uri: this.state.item.url + '$c180w180h'}}/>
                                </View>
                      }}
                       onClick={() => {that._closeModal()}}
                       imageUrls={this.state.showImages}
                       onSave={(url) => {that._save(url)}}/>
                </Modal>
            </View>
        );
    }
    _noDataView() {
        return (<BlankPages ImageUrl={require('../../imgs/note.png')} titleText='心得' contentText='学习除了大量输入之外也要有内化和输出的过程'/>)
    }

    // render
    render() {
        if (!this.state.dataSource) {
            return;
        }

        return (
            <View style={styles.container}>
                <View style={styles.headerView}>
                    <View style={styles.headerContentView}>
                        <TouchableOpacity activeOpacity={1} style={styles.backButtomA} onPress={() => {
                            this._goBack()
                        }}>
                            <Text style={styles.backButtom}>{Icon.back}</Text>
                        </TouchableOpacity>
                        <Text style={styles.headerTitle}>我的心得</Text>
                    </View>
                </View>
                <Loading visible={this.state.isLoading}/>
                {this.state.isLoading
                    ? <UltimateListView ref='listview'
                        onFetch={this._onListRefersh.bind(this)}
                        enableEmptySections
                        separator={false}
                        rowView={this._rowRow.bind(this)}
                        refreshableTitleWillRefresh="下拉刷新..."
                        refreshableTitleInRefreshing="下拉刷新..."
                        refreshableTitleDidRefresh="Finished"
                        refreshableTitleDidRefreshDuration={10000}
                        emptyView={this._noDataView.bind(this)}
                        allLoadedText=''
                        waitingSpinnerText=''
                            />
                    : (g_AppValue.isConnected
                        ? <UltimateListView
                            ref='listview'
                            onFetch={this._onListRefersh.bind(this)}
                            enableEmptySections
                            separator={false}
                            rowView={this._rowRow.bind(this)}
                            refreshableTitleWillRefresh="下拉刷新..."
                            refreshableTitleInRefreshing="下拉刷新..."
                            refreshableTitleDidRefresh="Finished"
                            refreshableTitleDidRefreshDuration={10000}
                            emptyView={this._noDataView.bind(this)}
                            allLoadedText=''
                            waitingSpinnerText=''
                              />

                        : <BlankPages ImageUrl={require('../../imgs/none.png')} contentText='无法连接到服务器,请检查你的网络设置'/>)
}
            </View>
        );
    }

    _onListRefersh(page = 1, callback, options) {

        let that = this;
        const pageLimit = 10;
        let logId = parseInt(Math.random() * 100000);
        InteractionManager.runAfterInteractions(() => {
            YLYKServices.$note.getNoteList({'page': page, 'user_id': this.props.user_id, 'limit': pageLimit}).then((data) => {
                var resultData = JSON.parse(data);
                if (page === 1) {
                    that._alldata = [];
                    that._alldata = resultData;
                } else {
                    that._alldata = that._alldata.concat(resultData);
                }
                that.setState({isLoading: false});
                options.pageLimit = pageLimit;
                callback(resultData, options);
                //end()
            }).catch((err) => {
                this.setState({isLoading: false})
            });
        })
    }
}

var styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f2f5f6'
    },
    headerView: {
        width: g_AppValue.screenWidth,
        height: Platform.OS == 'ios'
            ? 64 * g_AppValue.precent
            : 44 * g_AppValue.precent,
        backgroundColor: '#ffffff'
    },
    listView: {
        marginTop: 10 * g_AppValue.precent
    },
    headerContentView: {
        width: g_AppValue.screenWidth,
        height: 24 * g_AppValue.precent,
        marginTop: Platform.OS == 'ios'
            ? 31 * g_AppValue.precent
            : 10 * g_AppValue.precent,
        justifyContent: 'center',
        alignItems: 'center'
    },
    headerTitle: {
        fontSize: 18 * g_AppValue.precent,
        color: '#5a5a5a'
    },
    backButtomA: {
        position: 'absolute',
        top: 3 * g_AppValue.precent,
        width: 18 * g_AppValue.precent,
        height: 18 * g_AppValue.precent,
        left: 12 * g_AppValue.precent
    },
    backButtom: {
        fontSize: 18,
        fontFamily: 'iconfont'
    },
    cellView: {
        width: g_AppValue.screenWidth,
        backgroundColor: '#ffffff',
        marginTop: 10 * g_AppValue.precent
    },
    cellContentView: {
        width: 284 * g_AppValue.precent,
        marginTop: 20 * g_AppValue.precent,
        marginLeft: 79 * g_AppValue.precent,
        marginRight: 12 * g_AppValue.precent
    },
    contentText: {
        fontSize: 14 * g_AppValue.precent,
        color: '#5a5a5a',
        marginBottom: 12 * g_AppValue.precent
    },
    ImageView: {
        width: 304 * g_AppValue.precent,
        marginLeft: -20 * g_AppValue.precent,
        flexWrap: 'wrap',
        flexDirection: 'row'
    },
    imageItem: {
        width: 88 * g_AppValue.precent,
        height: 88 * g_AppValue.precent,
        marginBottom: 10 * g_AppValue.precent,
        marginLeft: 10 * g_AppValue.precent,
        resizeMode:'cover',
    },
    payView: {
        width: 284 * g_AppValue.precent,
        height: 48 * g_AppValue.precent,
        borderWidth: 1,
        borderColor: 'rgba(200,200,200,0.5)',
        flexDirection: 'row'
    },
    payImageOne: {
        marginTop: 1 * g_AppValue.precent,
        marginLeft: 1 * g_AppValue.precent,
        marginBottom: 1 * g_AppValue.precent,
        width: 64 * g_AppValue.precent,
        height: 44 * g_AppValue.precent
    },
    payImageTwo: {
        position: 'absolute',
        top: 0 * g_AppValue.precent,
        width: 64 * g_AppValue.precent,
        height: 48 * g_AppValue.precent
    },
    payRightView: {
        marginLeft: 10 * g_AppValue.precent,
        width: 200 * g_AppValue.precent,
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
        // marginRight: 12 * g_AppValue.precent,
        justifyContent:'space-between',
        flexDirection: 'row',
        alignItems:'center',
      //  backgroundColor:'red',
    },

    deleteTextAction: {
        marginTop: 5 * g_AppValue.precent,
        marginBottom: 14 * g_AppValue.precent
    },
    deleteText: {
        fontSize: 14 * g_AppValue.precent,
        color: '#9a9b9c'
    },
    timeView: {
        width: 50 * g_AppValue.precent,
        position: 'absolute',
        top: 19 * g_AppValue.precent,
        left: 12 * g_AppValue.precent,
        flexDirection: 'row'
    },
    saveImageView: {
        position: 'absolute',
        bottom: 0,
        width: g_AppValue.screenWidth,
        height: 120 * g_AppValue.precent,
        backgroundColor: '#f2f5f6'
    },
    saveView: {
        width: g_AppValue.screenWidth,
        height: 55 * g_AppValue.precent,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#ffffff'
    }
})
