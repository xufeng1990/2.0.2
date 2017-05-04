
//  TeacherIntroduce
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
} from 'react-native';
//configs
import g_AppValue from '../../../configs/AppGlobal.js';


import YLYKNatives from "../../../configs/ylykbridges/YLYKNatives.js";
import YLYKServices from "../../../configs/ylykbridges/YLYKServices.js";
import YLYKStorages from "../../../configs/ylykbridges/YLYKStorages.js";



//component
import MyThumbTab from '../../../component/tabs/MyThumbTab.js';
//pages
import MyThumbNote from './MyThumbNote.js';
import MyThumbShow from './MyThumbShow.js';
//组件
import ScrollableTabView from 'react-native-scrollable-tab-view';
// 类
const tabNames = ['心得', '课程'];
export default class MyThumb extends Component {
  // 构造函数
  constructor(props) {
    super(props);
    this.state = {
      // your code
    };
  }

  // 加载完成
  componentDidMount() {
    //
  }

  // view卸载
  componentWillUnmount() {
    DeviceEventEmitter.emit('showProfileTabBar', '1');
  }

  componentWillMount() {

  }

  _goBack() {
    this.props.navigator.pop();
    YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
  }

  _goToPlayerView() {
    YLYKNatives.$player.openPlayerController('0', false, '[]');
  }

  // render
  render() {
    return (
      <View style={styles.container}>
        <ScrollableTabView
          style={{ marginTop: Platform.OS == 'ios' ? 20 * g_AppValue.precent : 0 * g_AppValue.precent }}
          initialPage={0}
          locked={true}
          renderTabBar={() => <MyThumbTab navigator={this.props.navigator} goBack={this._goBack.bind(this)} goToPlayerView={() => { this._goToPlayerView() }} tabNames={tabNames} />}
        >
          <MyThumbNote isVip={this.props.isVip} tabLabel='心得' navigator={this.props.navigator} user_id={this.props.user_id} />
          <MyThumbShow tabLabel='节目' navigator={this.props.navigator} user_id={this.props.user_id} />
        </ScrollableTabView>
      </View>
    );
  }
}

var styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#ffffff'
  },
})
