//  头像编辑
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
//common
import Icon from '../../common/Icon.js';
//configs
import g_AppValue from '../../configs/AppGlobal.js';
// 类
export default class PictureEditing extends Component {
  // 构造函数
  constructor(props) {
    super(props);
    this.state = {
      // your code
    };
  }

  // 加载完成
  componentDidMount(){

  }
  componentWillMount(){

  }

  // view卸载
  componentWillUnmount(){
    //
  }
  _back(){
    this.props.navigator.pop();
  }

  // render
  render(){
    return (

      <View style={{flex:1}}>
        <TouchableOpacity onPress={this.props.back}>
      <View style={styles.container}>

        <View style={styles.cntentView}>
          <TouchableOpacity onPress={this.props.camera}>
          <View style={[styles.cellView,{height:70*g_AppValue.precent}]}>
              <Text style={{fontSize:14*g_AppValue.precent,color:'#5a5a5a'}}>拍照</Text>
          </View>
          </TouchableOpacity>
          <View style={{height:1*g_AppValue.precent,width:319*g_AppValue.precent,marginLeft:20*g_AppValue.precent,backgroundColor:'rgba(200,200,200,0.50)'}}/>
          <TouchableOpacity onPress={this.props.Photo}>
          <View style={[styles.cellView,{height:60*g_AppValue.precent}]}>
              <Text style={{fontSize:14*g_AppValue.precent,color:'#5a5a5a'}}>相册选取</Text>
          </View>
          </TouchableOpacity>
          <TouchableOpacity onPress={this.props.back}>
          <View style={[styles.cellView,{height:49*g_AppValue.precent,backgroundColor:'#f8fbfc'}]}>
              <Text style={{fontSize:14*g_AppValue.precent,color:'#5a5a5a',fontFamily:'iconfont'}}>{Icon.close}</Text>
          </View>

          </TouchableOpacity>

          </View>
      </View>
      </TouchableOpacity>
    </View>


    );
  }

  // 自定义方法区域
  // your method

}

var styles = StyleSheet.create({
  container:{
    width:g_AppValue.screenWidth,
    height:g_AppValue.screenHeight,
    backgroundColor:'rgba(0,0,0,0.30)',
    flexDirection:'column-reverse',
  },
  cntentView:{
    width:359*g_AppValue.precent,
    height:180*g_AppValue.precent,
    backgroundColor:'#ffffff',
    marginLeft:8*g_AppValue.precent,
    marginBottom:8*g_AppValue.precent,
  },
  cellView:{
    width:359*g_AppValue.precent,
    justifyContent:'center',
    alignItems:'center',
  }
})
