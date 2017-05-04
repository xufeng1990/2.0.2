//  AlbumNote
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
    InteractionManager
} from 'react-native';
//configs
import YLYKServices from '../../../configs/ylykbridges/YLYKServices.js';
import g_AppValue from '../../../configs/AppGlobal.js';
//component
import BlankPages from '../../../component/AlbumCell/BlankPages.js';
import Loading from '../../../component/Loading/Loading.js';
//pages
import AlbumNoteCell from './AlbumNoteCell.js';
import NoVipDetailsView from '../NoVipDetails.js';
//组件
import UltimateListView from "react-native-ultimate-listview";


export default class AlbumNote extends Component {

    _alldata = [];//全部数据
    _dataSource = new ListView.DataSource({rowHasChanged: (row1, row2) => row1 !== row2});

    constructor(props) {
        super(props);
        this.state = {
            dataSource: this._dataSource.cloneWithRows(this._alldata),
            isLoading: true,
        };
    }

    // 加载完成
    componentDidMount() {

        this._onListRefersh();
    }

    // view卸载

    componentWillMount() {
        //判断网络
        if (g_AppValue.isConnected == false) {
            this.setState({isLoading: false})
        }
    }

    _renderRow(rowData) {
        return <AlbumNoteCell data={rowData}/>
    }

    //空白页
    _noDataView() {
        return (<BlankPages ImageUrl={require('../../../imgs/note.png')} titleText='暂无评价'/>);
    }

    render() {
        let that = this;
        return (
            <View style ={{backgroundColor: '#f2f5f6',height: Platform.OS == 'ios'
                    ? (this.props.noVip == false
                        ? 370 * g_AppValue.precent
                        : 415 * g_AppValue.precent)
                    : (this.props.noVip == false
                        ? 340 * g_AppValue.precent
                        : 390 * g_AppValue.precent)
            }}>

                <Loading visible={this.state.isLoading}/>
                {!g_AppValue.isConnected ? <BlankPages ImageUrl={require('../../../imgs/none.png')} contentText='无法连接到服务器,请检查你的网络设置'/>
                    : <UltimateListView
                                ref='listView'
                                onFetch={this._onListRefersh.bind(this)}
                                enableEmptySections
                                //----Normal Mode----
                                separator={false}
                                rowView={this._renderRow.bind(this)}
                                refreshableTitleWillRefresh="下拉刷新..."
                                refreshableTitleInRefreshing="下拉刷新..."
                                refreshableTitleDidRefresh="Finished"
                                refreshableTitleDidRefreshDuration={10000}
                                emptyView={this._noDataView.bind(this)}
                                allLoadedText='' waitingSpinnerText=''
                                />
                            }

            </View>

        );
    }

    //获取数据
    _getCourseList(page, callback, options) {
        const pageLimit = 10;
        let that = this;

        InteractionManager.runAfterInteractions(() => {
            YLYKServices.GET(JSON.stringify({
                url: [
                    "album", that.props.course_id + "",
                    "comment"
                ],
                body: {},
                query: {}
            })).then((data) => {
                if (page <= 1) {
                    that._alldata = [];
                }

                var resultData = JSON.parse(data);
                for (let i = 0; i < resultData.length; i++) {
                    that._alldata.push(resultData[i])
                };

                this.setState({
                    dataSource: this._dataSource.cloneWithRows(this._alldata),
                    isLoading: false
                })


                options.pageLimit = pageLimit;
                callback(resultData, options);

                //end()
            }).catch((err) => {
                console.warn('数据err', err);
                this.setState({isLoading: false,})
            });
        })
    }

    _onListRefersh(page = 1, callback, options) {
        this._getCourseList(page, callback, options);
    }

}
var styles = StyleSheet.create({
    listView: {
        backgroundColor: '#f2f5f6'
    },
    container: {
        backgroundColor: '#ffffff',
        height: g_AppValue.screenHeight,
        alignItems: 'center'
    },
    ImageView: {
        marginTop: 50 * g_AppValue.precent,
        width: 115 * g_AppValue.precent,
        height: 115 * g_AppValue.precent,
        borderRadius: 57.5 * g_AppValue.precent
    },
    titleText: {
        fontSize: 24 * g_AppValue.precent,
        color: '#5a5a5a',
        marginTop: 30 * g_AppValue.precent
    },
    textStyle: {
        width: 140 * g_AppValue.precent,
        marginTop: 25 * g_AppValue.precent,
        fontSize: 14 * g_AppValue.precent,
        color: '#5a5a5a',
        justifyContent: 'center',
        alignItems: 'center',
        textAlign: 'center',
        flexWrap: 'wrap'
    }
})
