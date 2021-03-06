//  AlbumNoteCell
//
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
import g_AppValue from '../../../configs/AppGlobal.js';
import Util from '../../../common/util.js';
import NoteCell from '../../../component/AlbumCell/NoteCell.js';
import * as ImgUrl from '../../../configs/BaseImgUrl.js';
import ANoteCell from '../../../component/AlbumCell/AlbumNoteCell.js';
// 类
export default class AlbumNoteCell extends Component {
  // 构造函数
  constructor(props) {
    super(props);
    this.focus = true
    this.state = {
      focusChange:true,
    };
  }

  render(){

    return (
      <ANoteCell
        hidetime = {1}
        headPortraitImage = {{uri:ImgUrl.baseImgUrl + 'user/' + this.props.data.user.id +'/avatar'}}
        name = {this.props.data.user.nickname}
        content = {this.props.data.content.replace(/<br>/g, '\n')}
        />

    );
  }

  // 自定义方法区域
  // your method

}
