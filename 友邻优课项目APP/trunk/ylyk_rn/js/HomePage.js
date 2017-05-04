//  "NewClass"
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, { Component, } from 'react';
import {
  StyleSheet,
  Text,
  View,
  Image,
  Navigator,
  Alert,
  TouchableOpacity,
  NativeModules,
  Platform,
  WebView,
  ScrollView,
  DeviceEventEmitter,
  NativeAppEventEmitter,
  NetInfo,
} from 'react-native';
import { connect } from 'react-redux';
import Home from './pages/Home/Home.js';
import Course from './pages/Course/Course.js';
import Note from './pages/Note/Note.js';
import Profile from './pages/Profile/Profile.js';
import  NoteListView from './pages/Course/NoteListView.js';
import g_AppValue from './configs/AppGlobal.js';
// 类
export default class HomePage extends Component {
  // 构造函数
  constructor(props) {
    super(props);
    this.state = {

    };

  }

  // 加载完成
  componentDidMount() {
    //

  }
  componentWillMmount() {

  }


  // view卸载
  componentWillUnmount() {
    //

  }

  // render
  render() {
    // if (g_AppValue.init_type == 'homepage') {
    //   return <Home navigator = {this.props.navigator}/>
    //
    //
    // } else if (g_AppValue.init_type == 'course') {
    //
    //   return <Course navigator = {this.props.navigator}/>
    //
    // } else if (g_AppValue.init_type == 'note') {
    //
    //   return <Note navigator = {this.props.navigator}/>
    //
    // } else if (g_AppValue.init_type == 'profile') {
    //
    //   return <Profile navigator = {this.props.navigator}/>
    //
    //
    // } else if (g_AppValue.init_type == 'NoteListView') {
    //
    //   return <NoteListView navigator = {this.props.navigator}/>
    //
    //
    // }


  }

  // 自定义方法区域
  // your method

}
