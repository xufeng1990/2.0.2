//  NoteList
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, { Component, } from 'react';
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
  NativeEventEmitter,
} from 'react-native';
//common
import Util from '../../common/util.js';
//configs
import g_AppValue from '../../configs/AppGlobal.js';


import YLYKNatives from "../../configs/ylykbridges/YLYKNatives.js";
import YLYKServices from "../../configs/ylykbridges/YLYKServices.js";
import YLYKStorages from "../../configs/ylykbridges/YLYKStorages.js";


import * as ImgUrl from '../../configs/BaseImgUrl.js';
//component
import NoteCell from '../../component/AlbumCell/NoteCell.js';
import BlankPages from '../../component/AlbumCell/BlankPages.js';
import Loading from '../../component/Loading/Loading.js';
//pages
import NoteFocusDetails from './NoteFocusDetails.js';
import FousBusinessDetails from './FousBusinessDetails.js';
//组件
import UltimateListView from "react-native-ultimate-listview";

const CACHE_KEY = "__CACHE_HOME_6_NOTELIST";

var LoginEvents = NativeModules.LoginEvent;
const myLoginEvent = new NativeEventEmitter(LoginEvents);
var loginSubscription;
export default class NoteList extends Component {
  // 构造函数
  _page = 1;
  _dataSource = new ListView.DataSource({ rowHasChanged: (row1, row2) => row1 !== row2 })
  _alldata = [];//加载数组
  _followeeArr = [];//管组数组
  constructor(props) {
    super(props);
    this.state = {
      is_followee: this._followeeArr,
      dataSource: this._dataSource.cloneWithRows(this._alldata),
      isShowLoadMore: false,
      thumbNumber: '',
      isLoading: true,
      isConnected: true,
    };
  }

  // 加载完成
  componentDidMount() {
    this._onListRefersh();
    // DeviceEventEmitter.emit('noteID',rowID);
    // this.noteListener = DeviceEventEmitter.addListener('notefocusID',(rowID)=>{
    //     var number = this.state.thumbNumber;
    //     number[rowID] =(number[rowID] + 1);
    //
    //  this.setState({
    //    dataSource :this._dataSource.cloneWithRows(this._alldata),
    //    thumbNumber:number,
    //  })
    //
    // })



  }
  componentWillMount() {
    let that = this;
    YLYKStorages.$keyValueStorage.getItem(CACHE_KEY).then(function (data) {
      that._alldata = JSON.parse(data);
      that.setState({
        dataSource: that._dataSource.cloneWithRows(that._alldata)
      });
    });

    this.loginSubscription = myLoginEvent.addListener('LoginSuccess', (reminder) => {
      // console.log(reminder.LoginSuccess + "loginsuccess");
      this._getCourseList();
    });

    this.showNoteTabBar = DeviceEventEmitter.addListener('showNoteTabBar', (res) => {
      if (res[0] == 1) {
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
      } else {
        return;
      }
    });

    this.showNote = DeviceEventEmitter.addListener('showNote', () => {
      YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
    });


  }

  // view卸载
  componentWillUnmount() {
    this.noteListener && this.noteListener.remove();
    this.loginSubscription && this.loginSubscription.remove();
    this.showNoteTabBar && this.showNoteTabBar.remove();
    this.showNote && this.showNote.remove();
  }



  _noteGotoPlay(palyId, is, is2) {
    YLYKNatives.$player.openPlayerController(palyId + '', is, is2)
  }
  //thumbNumber ={this.state.thumbNumber[rowID]}
  _goToDetailsView(fansId, nickname, rowData, rowID) {
    var thumbNumber = this.state.thumbNumber[rowID];
    YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
    this.props.navigator.push({
      component: NoteFocusDetails,
      params: {
        fansId: fansId,
        nickname: nickname,
        rowData: rowData,
        rowID: rowID,
        thumbNumber: thumbNumber,

      }
    })
  }

  _renderHeaderAction(fansId, rowID) {
    //  alert('跳转')
    var nextfollowee = this.state.is_followee[rowID];
    YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
    this.props.navigator.push({
      component: FousBusinessDetails,
      params: {
        fansId: fansId,
        nextfollowee: nextfollowee,
        rowID: rowID,
      }
    })
  }
  //

  _rowRow(rowData, sectionID, rowID) {
    var str = rowData.content;
    //console.log('jjjjjjjjj' + str)
    var st = str.replace(/<br>/g, '\n')
    var fansId = rowData.user.id;
    var nickname = rowData.user.nickname;
    var payId = rowData.course.id;
    var noteID = rowData.id;
    var is_liked = rowData.is_liked;
    return (
      <TouchableOpacity activeOpacity={1} onPress={() => { this._goToDetailsView(fansId, nickname, rowData, rowID) }}>

        <NoteCell
          navigator={this.props.navigator}
          headPortraitImage={!rowData.user.id ? require('../../imgs/43.png') : { uri: ImgUrl.baseImgUrl + 'user/' + rowData.user.id + '/avatar' }}
          headerImageAction={() => this._renderHeaderAction(fansId, rowID)}
          name={rowData.user.nickname}
          time={Util.getDiffTime(new Date(rowData.in_time * 1000))}
          content={st}
          playImage={!rowData.course.id ? require('../../imgs/43.png') : { uri: ImgUrl.baseImgUrl + 'course/' + rowData.course.id + '/cover' }}
          playTitle={rowData.course.name}
          palyAction={() => { this._noteGotoPlay(payId, false, '[]') }}
          numberOfLines={6}
          thumbNumber={rowData.like_count}
          noteId={noteID}
          is_liked={is_liked}
          imagesData={rowData.images}
        />
      </TouchableOpacity>


    );
  }

  _noDataView() {
    return (
      <BlankPages ImageUrl={require('../../imgs/focus.png')} contentText='你还没有关注其他同学去发现里看看吧' />
    );
  }
  //  <Loading visible = {this.state.isLoading}/>

  // render
  render() {
    // console.log('note isConnected' + g_AppValue.isConnected)

    return (
      <View style={styles.container}>
        <Loading visible={this.state.isLoading} />
        {this.state.isLoading ? null : (g_AppValue.isConnected ?
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
            refreshableTitleDidRefreshDuration={10000}
            emptyView={this._noDataView.bind(this)}
            allLoadedText=''
            waitingSpinnerText={null}
          />
          : <BlankPages ImageUrl={require('../../imgs/none.png')} contentText='无法连接到服务器,请检查你的网络设置' />)
        }
      </View>
    );
  }



  _getCourseList(page, callback, options) {
    const pageLimit = 10;
    let that = this;
    if (that._isLoading)
      return;
    InteractionManager.runAfterInteractions(() => {
      YLYKServices.$note.getNoteList({ 'page': page, 'limit': pageLimit, 'is_followee': 'true' }).then((data) => {
        // console.log('dbvierbviuerbvuiebrvuebrouvberouvber' + data)
        if (page <= 1) {
          that._alldata = [];
        }

        var resultData = JSON.parse(data);


        for (let i = 0; i < resultData.length; i++) {
          this._alldata.push(resultData[i])
          YLYKServices.$user.getUserById(resultData[i].user.id + '')
            .then((data) => {
              var userByIdDate = JSON.parse(data)

              this._followeeArr.push(userByIdDate.is_followee);


            }).catch((err) => {
              //  console.log('数据错误' + err);
            })
        }
        this.setState({
          dataSource: this._dataSource.cloneWithRows(this._alldata),
          isShowLoadMore: true,
          is_followee: this._followeeArr,
          thumbNumber: this._alldata.map((countN) => { return countN.like_count }),
          isLoading: false,

        })
        YLYKStorages.$keyValueStorage.setItem(CACHE_KEY, JSON.stringify(this._alldata));

        options.pageLimit = pageLimit;
        callback(resultData, options);


      }).catch((err) => {
        this.setState({ isLoading: false, isConnected: false, })


        // console.log("数据错误...." + err)
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
      ios: { marginBottom: 45 * g_AppValue.precent }
    }),
    backgroundColor: '#f2f5f6',
    flex: 1,
  },
  listView: {
    // flex:1,
    height: Platform.OS == 'ios' ? g_AppValue.screenHeight - 104 * g_AppValue.precent : g_AppValue.screenHeight - 100 * g_AppValue.precent,
    backgroundColor: '#f2f5f6',
  }
})
