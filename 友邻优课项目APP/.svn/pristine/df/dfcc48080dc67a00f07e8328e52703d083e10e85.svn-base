//  TeacherIntroduce
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
  NativeModules,
  NativeEventEmitter
} from 'react-native';
//common
import Icon from '../../../common/Icon.js';
//configs
import  g_AppValue from '../../../configs/AppGlobal.js';
import * as ImgUrl from '../../../configs/BaseImgUrl.js';
import YLYKNatives from '../../../configs/ylykbridges/YLYKNatives.js';
//component
import TeacherTab from '../../../component/tabs/TeacherTab.js';
import NavigationView from '../../../component/Navigator/NavigationView.js';
//pages
import TeacherAlbum from './teacherAlbumTab.js';
import TeacherIntroduceTab from './TeacherIntroduceTab.js';
//组件
import ScrollableTabView from 'react-native-scrollable-tab-view';

var Bridges = NativeModules.BridgeEvents;
const myEvent = new NativeEventEmitter(Bridges);
var subscription;

// 类
 const tabNames = [{key:'简介'},{key:'专辑'}];
export default class TeacherIntroduce extends Component {
  // 构造函数
  constructor(props) {
    super(props);
    this.state = {
      isPlayingOrPause: 0,
      isExistPlayedTrace:1,
    };
  }

  // 加载完成
  componentDidMount(){
    this.subscription = myEvent.addListener('playOrPauseToRN', (reminder) => {
        this.setState({isPlayingOrPause: reminder.isPlayingOrPause, isExistPlayedTrace: 1})
    });

    YLYKNatives.$player.isExistPlayedTrace().then((data) => {
        this.setState({isExistPlayedTrace: data})
    });

    YLYKNatives.$player.isPlayingOrPause()
    .then((data) => {
        this.setState({isPlayingOrPause: data.isPlayingOrPause})
    }).catch((err) => {
        Util.AppToast('网络出错,请稍后再试')
    })
  }

  // view卸载
  componentWillUnmount(){
    this.subscription && this.subscription.remove();
  }
_goBack(){
  this.props.navigator.pop();
}
_goToPlayerView(is1, is, is2){
    YLYKNatives.$player.openPlayerController(is1, is, is2);
}
  // render
  render(){
    return (

      <View style={styles.container}>
        <NavigationView
          navigator={this.props.navigator}
          leftItemTitle={Icon.back}
          leftItemFunc={this._goBack.bind(this)}
          rightItemFunc={() => this._goToPlayerView('0', false, '[]')}
          rightImageSource={this.state.isExistPlayedTrace == 1 ? this.state.isPlayingOrPause == 0 ? require('../../../imgs/play1.png') : require('../../../imgs/play.gif') : null}
          />
        <View style = {styles.headerView} >
            <Image style={styles.headerImage} source={{uri: ImgUrl.baseImgUrl + 'teacher/' + this.props.teacherData.id + '/avatar'}}/>
            <Text style={styles.nameText} >{this.props.teacherData.name}</Text>
            <Text style={styles.introduceText} >{this.props.teacherData.desc}</Text>
        </View>
        <ScrollableTabView
          initialPage ={0}
            locked={true}
          renderTabBar = {() => <TeacherTab tabNames = {tabNames} />}
          >
          <TeacherIntroduceTab  navigator = {this.props.navigator} teacherId = {this.props.teacherData.id} tabLabel = '简介' />
          <TeacherAlbum  navigator = {this.props.navigator} teacherId = {this.props.teacherData.id} tabLabel= '专辑' />

        </ScrollableTabView>

      </View>

    );
  }

  // 自定义方法区域
  // your method

}

var styles = StyleSheet.create({
  container:{
    flex:1,
    backgroundColor:'#f2f5f6'
  },
  headerView:{
    width:g_AppValue.screenWidth,
    height:180 *g_AppValue.precent,
    backgroundColor:'#ffffff',
    alignItems:'center',
  },

  headerImage:{
    width:77*g_AppValue.precent,
    height:77*g_AppValue.precent,
    borderRadius:38.5*g_AppValue.precent,
    marginTop:20*g_AppValue.precent,

  },
  nameText:{
    fontSize:14*g_AppValue.precent,
    color:'#5a5a5a',
    marginTop:10*g_AppValue.precent,
  },
  introduceText:{
    fontSize:11*g_AppValue.precent,
    color:'#9a9b9c',
    marginTop:8*g_AppValue.precent,
  }


})
