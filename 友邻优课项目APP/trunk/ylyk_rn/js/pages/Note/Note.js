//  "NOteTabBar"
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2017
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
  DeviceEventEmitter
} from 'react-native';
//configs

import YLYKNatives from "../../configs/ylykbridges/YLYKNatives.js";
import YLYKServices from "../../configs/ylykbridges/YLYKServices.js";
import YLYKStorages from "../../configs/ylykbridges/YLYKStorages.js";

//component
import NavigationBar from '../../component/Navigator/NavigationBar.js';
import NoteTab from '../../component/tabs/NoteTab.js';
//pages
import NoteList from './NoteList.js';
import FoundList from './FoundList.js';
//组件
import ScrollableTabView from 'react-native-scrollable-tab-view';
// 类
let tabNames = ['关注', '发现'];
export default class Note extends Component {
  // 构造函数
  constructor(props) {
    super(props);
    this.state = {
      // your code
    };
  }

  componentWillMount() {
    this.showNote = DeviceEventEmitter.addListener('showNote', () => {
      YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
    })

  }
  // 加载完成
  componentDidMount() {

  }

  // view卸载
  componentWillUnmount() {
    this.showNote && this.showNote.remove();
  }
  
  goToPlayerView() {
     YLYKNatives.$player.openPlayerController('0', false, '[]')
  }

  // render
  render() {

    return (

      <View style={{ flex: 1 }}>
        <ScrollableTabView
          initialPage={0}
          locked={true}
          renderTabBar={() => <NoteTab navigator={this.props.navigator} tabNames={tabNames} goToPlayerView={() => { this.goToPlayerView() }} />}
        >
          <NoteList navigator={this.props.navigator} />
          <FoundList navigator={this.props.navigator} />
        </ScrollableTabView>

      </View>
    );
  }



}
