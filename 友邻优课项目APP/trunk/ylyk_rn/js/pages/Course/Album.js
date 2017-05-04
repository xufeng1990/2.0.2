

//  "NewClass"
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
    Platform
} from 'react-native';
//common
import Util from '../../common/util.js';
//configs
import g_AppValue from '../../configs/AppGlobal.js';
import * as ImgUrl from '../../configs/BaseImgUrl.js';
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js';
import YLYKStorages from '../../configs/ylykbridges/YLYKStorages.js';
import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js';

//component
import AlbumCell from '../../component/AlbumCell/AlbumCell.js';
//pages
import AlbumDetails from './AlbumDetails/AlbumDetails.js';

//缓存常亮
const CACHE_KEY = "__CACHE_HOME_2_ALBUMS";
// 类
export default class Album extends Component {

    _dataSource = new ListView.DataSource({rowHasChanged: (row1, row2) => row1 !== row2})

    _alldata = [];//页面数据

    // 构造函数
    constructor(props) {
        super(props);
        this.state = {
            dataSource: this._dataSource.cloneWithRows(this._alldata),//
            is_finished: [],
        };
    }

    componentWillMount() {
        let that = this;
        //取缓存数据
        YLYKStorages.$keyValueStorage.getItem(CACHE_KEY)
        .then(function(data) {
            that._alldata = JSON.parse(data);
            that.setState({
                dataSource: that._dataSource.cloneWithRows(that._alldata)
            });
        });

        YLYKNatives.$listenedAlbum.getListenAlbumList()
        .then((data)=>{
          console.log('最近听过的专辑' + data)
        })
    }

    // 加载完成
    componentDidMount() {
      //获取专辑数据
      YLYKServices.$album.getAlbumList({'page': 1, 'is_free': 'false'})
        .then((data) => {
            var resultData = JSON.parse(data);
            this._alldata = [];
            var data = [];
            for (let i = 0; i < resultData.length; i++) {
              data.push(resultData[i]);

            };
            this._alldata = data.filter((item, i) => item.id !== 6);
            this.setState({
                dataSource: this._dataSource.cloneWithRows(this._alldata),
                is_finished: this._alldata.map((item, i) => {return item.is_finished}),
            });
            //存数据
            YLYKStorages.$keyValueStorage.setItem(CACHE_KEY, JSON.stringify(this._alldata));
        }).catch((err) => {
        });

    }

    // view卸载
    componentWillUnmount() {
        //
    }

    //跳转专辑页面
    _goToAlbumDetails(rowData, sectionID, rowID) {
        var albumID = rowData.id;
        var albumName = rowData.name;
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        this.props.navigator.push({
            component: AlbumDetails,

            params: {
                rowID: rowID,
                rowData: rowData,
                albumName: albumName,
                album: albumID,
                course_count: rowData.course_count,
                is_finished: rowData.is_finished,
                hideTabbar:'show',
            }
        })
    }
    _renderRow(rowData, sectionID, rowID) {
            //  console.log('图片地址' + ImgUrl.baseImgUrl + 'album/' + rowData.id + '/avatar')
        return (

          <AlbumCell
            titleName={rowData.name}
            number={this.state.is_finished[rowID] ? '共' + rowData.course_count + '集' : '更新至' + rowData.course_count + '集'}
            cellBackgrondColor='#ffffff'
            imageSource={{uri: ImgUrl.baseImgUrl + 'album/' + rowData.id + '/avatar'}}
            actionFnc= {() => {this._goToAlbumDetails(rowData,sectionID,rowID)}}
            />

        );

    }

    // render
    render() {
        if (!this.state.dataSource) {return (<View></View>)}
        return (
            <View style={styles.container}>

                <View style={styles.titleView}>
                    <Text style={styles.titleText}>课程专辑</Text>
                </View>

                <ListView
                  ref='listView'
                  dataSource={this.state.dataSource}
                  scrollEnabled={false}
                  enableEmptySections={true}
                  renderRow={this._renderRow.bind(this)}
                  contentContainerStyle={styles.contentViewStyle}
                  />

            </View>
        );

    }

    // 自定义方法区域
    // your method

}

var styles = StyleSheet.create({
    container: {
        ...Platform.select({
            ios: {
                marginBottom: 45 * g_AppValue.precent
            }
        }),
        marginTop: 10 * g_AppValue.precent,
        flex: 1,
        backgroundColor: '#ffffff',
        width: g_AppValue.screenWidth
    },
    titleView: {
        marginTop: 19 * g_AppValue.precent,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: 15 * g_AppValue.precent
    },
    titleText: {
        fontSize: 18* g_AppValue.precent,
        fontWeight: 'bold'
    },
    contentViewStyle: {
        // 主轴方向
        flexDirection: 'row',
        // 换行
        flexWrap: 'wrap'
    },
    itemStyle: {
        // 对齐方式
        // alignItems:'center',
        // justifyContent:'center',
        // 尺寸
        width: 170 * g_AppValue.precent,
        height: 215 * g_AppValue.precent,
        // 左边距
        marginLeft: 12 * g_AppValue.precent,
        marginBottom: 15 * g_AppValue.precent,
        backgroundColor: 'red',
        borderColor: 'rgba(0,0,0,0.20)',
        borderWidth: 1 * g_AppValue.precent
    },
    cellView: {
        width: 150 * g_AppValue.precent,
        height: 195 * g_AppValue.precent,
        //backgroundColor:'yellow',
        marginLeft: 10 * g_AppValue.precent,
        marginTop: 10 * g_AppValue.precent
    },
    ImageView: {
        width: 150 * g_AppValue.precent,
        height: 150 * g_AppValue.precent,
        //backgroundColor:'red',

    },
    nameTitle: {
        marginTop: 10 * g_AppValue.precent,
        fontSize: 14 * g_AppValue.precent,
        color: '#5a5a5a'
    },
    numberText: {
        marginTop: 6 * g_AppValue.precent,
        fontSize: 11 * g_AppValue.precent,
        color: '#9a9b9c'
    }
});
