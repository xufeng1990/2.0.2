//  teacherAlbum
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, { Component,} from 'react';
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
} from 'react-native';
//configs
import YLYKServices from '../../../configs/ylykbridges/YLYKServices.js';
import * as ImgUrl from '../../../configs/BaseImgUrl.js';
import YLYKNatives from '../../../configs/ylykbridges/YLYKNatives.js';
//component
import AlbumCell from '../../../component/AlbumCell/AlbumCell.js';
//pages
import AlbumDetails from '../AlbumDetails/AlbumDetails.js';

// 类
export default class TeacherAlbum extends Component {
  _dataSource = new ListView.DataSource({rowHasChanged: (row1, row2) => row1 !== row2})
  //全部数据
  _alldata = [];
  constructor(props) {
    super(props);
    this.state = {
      dataSource: this._dataSource.cloneWithRows(this._alldata),
      is_finished:[],

    };
  }

  // 加载完成
  componentDidMount(){
    YLYKServices.$album.getAlbumList({'page': 1,'teacher_id':this.props.teacherId + '','is_free': 'false'})
    .then((data)=>{
      var resultData = JSON.parse(data);
      for (var i = 0; i < resultData.length; i++) {
          this._alldata.push(resultData[i])
      }

      this.setState({
        dataSource: this._dataSource.cloneWithRows(this._alldata),
        is_finished:this._alldata.map((item, i) => {return item.is_finished}),
      });

    }).catch((err)=>{
      console.log('数据错误' + err)
    })
  }

  // view卸载
  componentWillUnmount(){
    //
  }
  //跳转专辑页面
  _goToAlbumDetails(rowData, sectionId, rowId) {
    YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
      var albumId = rowData.id;
      var albumName = rowData.name;
      var hide = 'hide';
      this.props.navigator.push({
          component: AlbumDetails,
          params: {
              rowID: rowId,
              rowData: rowData,
              albumName: albumName,
              album: albumId,
              course_count: rowData.course_count,
              is_finished: rowData.is_finished,
              hideTabbar:hide,
          }
      })
  }

  _renderRow(rowData,sectionId,rowId){
    return(
      <AlbumCell
        titleName = {rowData.name}
        number = {this.state.is_finished[rowId] ? '共' + rowData.course_count + '集' : '更新至' + rowData.course_count + '集'}
        cellBackgrondColor = '#ffffff'
        imageSource = {{uri: ImgUrl.baseImgUrl + 'album/' + rowData.id + '/avatar'}}
        actionFnc= {() => {this._goToAlbumDetails(rowData,sectionId,rowId)}}
        />
    );
  }
  // render
  render(){

        if (!this.state.dataSource) {
          return(<View></View>)
        }
      return (
          <ListView
            dataSource={this.state.dataSource}
            enableEmptySections={true}
            scrollEnabled = {true}
            renderRow={this._renderRow.bind(this)}
            contentContainerStyle={styles.contentViewStyle}
            />

    );
  }

  // 自定义方法区域
  // your method

}

var  styles = StyleSheet.create({

  contentViewStyle:{
    // 主轴方向
     flexDirection:'row',
     // 换行
     flexWrap:'wrap',
     marginTop:10,
     backgroundColor:'#ffffff',
  },
})
