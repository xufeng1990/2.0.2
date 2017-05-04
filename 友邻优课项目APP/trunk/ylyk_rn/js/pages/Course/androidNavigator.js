//  "NewClass"
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, { Component,} from 'react';
import {
Navigator,
AppRegistry

} from 'react-native';

// 类
import NoteListView from './NoteListView.js';
import g_AppValue from '../../configs/AppGlobal.js';
export default class AndroidNavigator extends Component {
  // 构造函数
  constructor(props) {
    super(props);
    this.state = {
      // your code
    };
  }

  componentWillMount(){
      g_AppValue.courseInfo = this.props.courseInfo;
  }

  // render
  render(){
    return (

      <Navigator
      initialRoute={{ component: NoteListView }}
      configureScene={(route) => {
          return Navigator.SceneConfigs.FadeAndroid;
      }}
      renderScene={(route, navigator) => {
          let Component = route.component;
          return <Component {...route.params} navigator={navigator} />
          //  上面的route.params 是为了方便后续界面间传递参数用的
      }} />

    );
  }

  // 自定义方法区域
  // your method

}

AppRegistry.registerComponent('AndroidNavigator', () => AndroidNavigator);
