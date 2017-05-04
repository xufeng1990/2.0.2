//  AlbumShows
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
    PanResponder,
    DeviceEventEmitter,
    Platform,
    InteractionManager,
    NativeEventEmitter,
    Modal,
} from 'react-native';
//common
import Util from '../../../common/util.js';
//configs
import YLYKNatives from '../../../configs/ylykbridges/YLYKNatives.js';
import YLYKServices from '../../../configs/ylykbridges/YLYKServices.js';
import YLYKStorages from '../../../configs/ylykbridges/YLYKStorages.js';
import g_AppValue from '../../../configs/AppGlobal.js';
//component
import BlankPages from '../../../component/AlbumCell/BlankPages.js';
import Arrangement from '../../../component/AlbumCell/Arrangement.js';
import Loading from '../../../component/Loading/Loading.js';
//pages
import AlbumShowsCell from './AlbumShowsCell.js';
import NoVipDetailsView from '../NoVipDetails.js';
import FilterView from '../FilterView.js';
//组件
import UltimateListView from "react-native-ultimate-listview";

var CACHE_KEY = "__CACHE_HOME_4_COURSESHOW";
const CourseList = NativeModules.NativeNetwork;

//登陆成功
var LoginEvents = NativeModules.LoginEvent;
const myLoginEvent = new NativeEventEmitter(LoginEvents);
var loginSubscription;

//退出登录成功
var LogoutEvents = NativeModules.LogoutEvent;
const myLogoutEvent = new NativeEventEmitter(LogoutEvents);
var logoutSubscription;

export default class AlbumShows extends Component {

    _dataSource = new ListView.DataSource({rowHasChanged: (row1, row2) => row1 !== row2})
    //全部数据
    _alldata = [];
    //听过数组
    _listened = [];
    //筛选数据
    _filterData = [];
    _page = 1;
    _pageLimit = 10;
    constructor(props) {

        super(props);
        this.state = {
            dataSource: this._dataSource.cloneWithRows(this._alldata),
            is_listened: this._listened,
            sorting: this.props.is_finished,
            isLoading: true,
            filterView:false,
            filterData:this._filterData,
            page:this._page,
            pageLimit:this._pageLimit,
            loadingMore:true,
        };


    }



    componentWillMount() {
      //判断是否有网
      if (g_AppValue.isConnected == false) {
        this.setState({isLoading:false})
      };

        let that = this;
          InteractionManager.runAfterInteractions(()=>{
              YLYKStorages.$keyValueStorage.getItem(CACHE_KEY + this.props.course_id + '')
              .then(function (data) {
                that._alldata = JSON.parse(data);
                that.setState({
                dataSource: that._dataSource.cloneWithRows(that._alldata),
                isLoading: false,
            });
        });
        //获取筛选数据
        YLYKServices.GET(JSON.stringify({
            url: ["album", this.props.course_id + "", "course"],
            body: {},
            query: {}
        })).then(info => {
          var resultData = JSON.parse(info);
          for (var i = 0; i < resultData.length; i++) {
            this._filterData.push(resultData[i])
          }
          this.setState({
          filterData:this._filterData,
      });

        });


        //  YLYKServices.$course.getCourseList({'album_id': this.props.course_id + ''})
        //   .then((data) => {
        //             var data = JSON.parse(data);
        //             for (let i = 0; i < data.length; i++) {
        //                 this._filterData.push(data[i]);
        //             };
        //             this.setState({
        //               filterData:this._filterData,
        //             });
        //           }).catch((err) => {
         //
        //           });
  })




        //登陆成功  获取数据
        loginSubscription = myLoginEvent.addListener('LoginSuccess',(reminder)=>{
              this._getCourseList();
            });

            //退出成功
            logoutSubscription = myLogoutEvent.addListener('LogoutSuccess',(reminder)=>{
                  if (reminder.LogoutSuccess) {
                        this._getCourseList();
                  }
                });

    }

  // 加载完成
    componentDidMount() {
        let that = this;
        //正倒序
        this._changSorting = DeviceEventEmitter.addListener('changSorting', (identify) => {
          if (identify === 'sort') {
            this.setState({
                sorting: !this.state.sorting
            }, function () {
              this.refs.listView && this.refs.listView.refresh();

            });
          }
          if (identify === 'filter') {
            this.setState({
              filterView:!this.state.filterView,
            })
          }
          });

        this.courseFilter = DeviceEventEmitter.addListener('courseFilter',(res)=>{

          this.setState({
              page:this._page * res,
              pageLimit:this._pageLimit * 2,
              filterView:false,
              loadingMore:false,
          }, function () {
            this.refs.listView && this.refs.listView.setPage(this.state.page);
            this.refs.listView && this.refs.listView.refresh();


          });
          });

    }




    // view卸载
    componentWillUnmount() {
        this._changSorting  &&   this._changSorting .remove();
        this.loginSubscription && this.loginSubscription.remove();
        this.logoutSubscription && this.logoutSubscription.remove();
        this.courseFilter &&   this.courseFilter.remove();
    }

    _renderRow(rowData, sectionID, rowID) {
        return <AlbumShowsCell rowID={rowID} listened={this.state.is_listened[rowID]} data={rowData} navigator={this.props.navigator}  albumId={this.props.course_id}  allData = {this._alldata} />
    }

      //LIST头部
    _renderHeader() {
        return <Arrangement rowID={this.props.rowID} is_finished={this.props.is_finished} course_count={this.props.course_count} albumName = {this.props.albumName} albumId={this.props.course_id} navigator={this.props.navigator} />
    }

    _back(){
      this.setState({
        filterView:false,
      })
    }

    render() {


        return (
            <View style={{backgroundColor: '#f2f5f6',height: Platform.OS == 'ios'? (this.props.nooVip == false ? 365* g_AppValue.precent : 410 * g_AppValue.precent) : (this.props.noVip == false ? 340* g_AppValue.precent :  390 * g_AppValue.precent)}}>

            <Loading visible = {this.state.isLoading} />
              {
                  g_AppValue.isConnected ?<UltimateListView
                                               ref= 'listView'
                                               onFetch={this._onListRefersh.bind(this)}
                                               enableEmptySections
                                               headerView={this._renderHeader.bind(this)}
                                               //----Normal Mode----
                                               separator={false}
                                               rowView={this._renderRow.bind(this)}
                                               refreshableTitleWillRefresh="下拉刷新..."
                                               refreshableTitleInRefreshing="下拉刷新..."
                                               refreshableTitleDidRefresh="Finished"
                                               refreshableTitleDidRefreshDuration={10000}
                                               autoPagination = {this.state.loadingMore}
                                               onEndReachedThreshold = {0}
                                               allLoadedText=''
                                               waitingSpinnerText=''
                                           />

                                          :  <BlankPages ImageUrl={require('../../../imgs/none.png')}  contentText='无法连接到服务器,请检查你的网络设置'/>
              }

              <Modal animationType = {'slide'} visible={this.state.filterView} transparent={true} >
                <FilterView back = {()=>{this._back()}} albumId = {this.props.course_id} filterData = {this.state.filterData} />
              </Modal>


            </View>

        );
    }

    //获取数据
    _getCourseList(page, callback, options) {
        var  pageLimit = this.state.pageLimit;

        console.log('pageLimit' + pageLimit);
        let that = this;

          InteractionManager.runAfterInteractions(()=>{
             YLYKServices.$course.getCourseList({'page': page,'limit': pageLimit,'album_id': this.props.course_id + '','sorting': this.state.sorting ? 'asc' : 'desc'})
              .then((data) => {
                        if (page <= 1) {
                            that._alldata = [];
                        }

                        data = JSON.parse(data);
                           var con =  data.length;

                        for (let i = 0; i < data.length; i++) {
                            this._alldata.push(data[i]);
                            this._listened.push(data[i].is_listened);
                        };

                        this.setState({
                            dataSource: this._dataSource.cloneWithRows(this._alldata),
                            is_listened: this._listened,
                            isLoading:false,
                        });

              YLYKStorages.$keyValueStorage.setItem(CACHE_KEY + this.props.course_id + '', JSON.stringify(this._alldata));


                options.pageLimit = pageLimit;
                callback(data, options);


        }).catch((err) => {
          this.setState({isLoading:false})
          console.warn('load failed: ', err);
        });
      })
    }

    _onListRefersh(page =1,callback, options) {

      this._getCourseList(page , callback, options);
    }

}
var styles = StyleSheet.create({
    listView: {
        backgroundColor: '#f2f5f6'
    },

})
