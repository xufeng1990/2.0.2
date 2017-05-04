//  "NewClass"
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, {
  Component,
} from 'react';
import {
  Navigator,
  BackAndroid,
  ToastAndroid,
  Platform,
  DeviceEventEmitter,
  NativeModules,
  NetInfo
} from 'react-native';

import g_AppValue from './js/configs/AppGlobal.js';
import Home from './js/pages/Home/Home.js';
import Note from './js/pages/Note/Note.js';
import Profile from './js/pages/Profile/Profile.js';
import Course from './js/pages/Course/Course.js';
import * as RnNativeModules from './js/configs/RnNativeModules.js';
import NoteListView from './js/pages/Course/NoteListView.js';
import VideoView from './js/component/Video/VideoView.js';
import HomePage from './js/HomePage.js';
import AndroidNavigator from './js/pages/Course/androidNavigator.js';
// import LoginSucessView from './js/pages/Profile/LoginScussView.js';
// import NotLoginView from './js/pages/Profile/NotLoginView.js';

var Birge = NativeModules.BridgeNative;
var time = 0;
var lastBackPressed = 0;
export default class Root extends Component {
  // 构造函数
  constructor(props) {
    super(props);
    //this.props.customHandleBackAndroid = false;
    this.state = {};
  }
  componentWillMount() {

    if (Platform.OS === 'android') {
      BackAndroid.addEventListener('hardwareBackPress', this.onBackAndroid);
    }
    //监听全局的网络情况
    NetInfo.addEventListener(
      'change',
      (res) => {

        if (res == 'none' || res == 'NONE') {
          g_AppValue.isConnected = false
        } else {
          g_AppValue.isConnected = true
        }
      }
    );


  }

  _handleConnectivityChange(isConnected) {
    // ToastAndroid.show((isConnected ? 'online' : 'offline'),ToastAndroid.SHORT

  }
  // view卸载
  componentWillUnmount() {
    if (Platform.OS === 'android') {
      BackAndroid.removeEventListener('hardwareBackPress', this.onBackAndroid);
    }
    NetInfo.removeEventListener(
      'change',
      (res) => {
        if (res == 'none' || res == 'NONE') {
          g_AppValue.isConnected = false
        } else {
          g_AppValue.isConnected = true
        }
      }
    );


  }
  //安卓物理键
  onBackAndroid = () => {
    //if (!this.props.customHandleBackAndroid) {
    //  return true;
    //}
    // const navigator = this.navigator;
    // const routers = navigator.getCurrentRoutes();
    // if (routers.length > 1) {
    //   navigator.pop();
    //
    //   var pressTime = new Date().getTime();
    //
    //   if (pressTime - time < 1000) {
    //     return true
    //   }
    //
    //   if (routers.length == 2) {
    //     RnNativeModules.hideTabBar('show')
    //   }
    //   return true;
    //
    // }
    //
    // return false;


    //   // 当前页面为root页面时的处理
    //   if ((lastBackPressed + 2000 >= Date.now())) {
    //     //最近2秒内按过back键，可以退出应用。
    //     return false;
    //   }
    //  lastBackPressed = Date.now();
    //   ToastAndroid.show('再按一次退出应用', ToastAndroid.SHORT);
    //   return true;

    const nav = this.navigator;
    const routers = nav.getCurrentRoutes();

    if (routers.length > 1) {
      const top = routers[routers.length - 1];
      if (top.ignoreBack || top.component.ignoreBack) {
        // 路由或组件上决定这个界面忽略back键
        return true;
      }
      const handleBack = top.handleBack || top.component.handleBack;
      if (handleBack) {
        // 路由或组件上决定这个界面自行处理back键
        return handleBack();
      }

      var pressTime = new Date().getTime();
      if (pressTime - time < 2000) {
        //ToastAndroid.show('再按一次退出应用', ToastAndroid.SHORT);
        return true
      }
      time = pressTime
      //

      // 默认行为： 退出当前界面。
      nav.pop();
      return true;
    }

    return false;
  }
  //   // 加载完成
  componentDidMount() {
    //Birge.dismiss();
  }
  _renderNavSubComponent(route, navigator) {
    var NavSubComponent = route.component;
    if (NavSubComponent) {
      return <NavSubComponent {...route.params} navigator={navigator} />
    }
  }
  //动画跳转样式
  _setNavAnimationType(route) {
    if (route.animationType) return route.animationType;

      if (g_AppValue.page == 'VideoView') {
          return Navigator.SceneConfigs.FadeAndroid;
      }

    if (Platform.OS === 'android') {
      return Navigator.SceneConfigs.FadeAndroid;
    }
    return Navigator.SceneConfigs.PushFromRight;
  }
  // render
  render() {

    if (g_AppValue.init_type == 'homepage') {
      return (
        <Navigator
          ref={component => this.navigator = component}
          style={{ flex: 1 }}
          configureScene={(route) => this._setNavAnimationType(route)}
          initialRoute={{ component: Home }}
          renderScene={this._renderNavSubComponent.bind(this)}
        />
      );
    } else if (g_AppValue.init_type == 'course') {
      return (

        <Navigator
          ref={component => this.navigator = component}
          style={{ flex: 1 }}
          configureScene={(route) => this._setNavAnimationType(route)}
          initialRoute={{ component: Course }}
          renderScene={this._renderNavSubComponent.bind(this)}
        />

      );
    } else if (g_AppValue.init_type == 'note') {
      return (
        <Navigator
          ref={component => this.navigator = component}
          style={{ flex: 1 }}
          configureScene={(route) => this._setNavAnimationType(route)}
          initialRoute={{ component: Note }}
          renderScene={this._renderNavSubComponent.bind(this)}
        />

      );
    } else if (g_AppValue.init_type == 'profile') {
      return (
        <Navigator
          ref={component => this.navigator = component}
          style={{ flex: 1 }}
          configureScene={(route) => this._setNavAnimationType(route)}
          initialRoute={{ component: Profile }}
          renderScene={this._renderNavSubComponent.bind(this)}
        />
      );

    } else if (g_AppValue.init_type == 'NoteListView') {
      // console.log('ssssssssss' + g_AppValue.courseInfo);
      return (
        <Navigator
          ref={component => this.navigator = component}
          style={{ flex: 1 }}
          configureScene={(route) => this._setNavAnimationType(route)}
          initialRoute={{ component: NoteListView }}
          renderScene={this._renderNavSubComponent.bind(this)}
        />
      );

    }
  }

  // 自定义方法区域
  // your method

}
