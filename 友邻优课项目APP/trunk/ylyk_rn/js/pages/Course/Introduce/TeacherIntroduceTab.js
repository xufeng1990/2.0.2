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
import g_AppValue from '../../../configs/AppGlobal.js';
import YLYKServices from '../../../configs/ylykbridges/YLYKServices.js';
//pages
import IntroduceHeaderCell from '../../../component/AlbumCell/IntroduceHeaderCell.js';
//组件
import HTMLView from 'react-native-htmlview';
// 类
export default class TeacherIntroduceTab extends Component {
  // 构造函数
  constructor(props) {
    super(props);
    this.state = {
      isLoading:true,
      teacherIntroduce:'',
    };
  }

  // 加载完成
  componentDidMount(){
    YLYKServices.$teacher.getTeacherById(this.props.teacherId + '')
    .then((data)=>{
      var resultData = JSON.parse(data);
      this.setState({
        teacherIntroduce:resultData,
      })

    }).catch((err)=>{
      console.log('数据错误' + err);
    })
  }

  // view卸载
  componentWillUnmount(){

  }

  // render
  render(){

      var htmlContent = this.state.teacherIntroduce.intro;
       var eduHtmlContent = this.state.teacherIntroduce.edu;//教育背景
       var expHtmlContent = this.state.teacherIntroduce.exp;//职业履历
    return (
      <ScrollView>
      <View style={styles.container} >
        <View style={styles.topView}>
          <View style={styles.contentView}>
            <View style={styles.content}>
                <HTMLView value={htmlContent} stylesheet={styles} />
            </View>
          </View>
        </View>
          {
            !this.state.teacherIntroduce.edu ? null
            :<View style={styles.albunIntroduceView} >
             <IntroduceHeaderCell
               titleName = '教育背景'
               titleNameTwo = 'E d u c a t i o n'
             />
           <View style = {[styles.contentText,{marginBottom:40 *g_AppValue.precent,}]} >
               <HTMLView value={eduHtmlContent} stylesheet={styles} />
           </View>
           </View>
          }

          {
            !this.state.teacherIntroduce.exp ? null
            : <View style={styles.albunIntroduceView} >
              <IntroduceHeaderCell
                titleName = '职业履历'
                titleNameTwo = 'E x p e r i e n c e s'
              />
              <View style = {styles.contentText} >
                <HTMLView value={expHtmlContent} stylesheet={styles} />
              </View>
              </View>
          }
      </View>
    </ScrollView>
    );
  }

  // 自定义方法区域
  // your method

}

var  styles = StyleSheet.create({
  container:{
     flex:1,
     backgroundColor:'#f2f5f6',
  },
  topView:{
    marginTop:10*g_AppValue.precent,
    width:g_AppValue.screenWidth,
    backgroundColor:'#ffffff',
  },
  contentView:{
    width:305*g_AppValue.precent,
    backgroundColor:'#f2f5f6',
    justifyContent:'center',
    alignItems:'center',
    margin:35*g_AppValue.precent,
    shadowColor:'black',
  shadowRadius:1,
  shadowOffset:{height:0,width:0},
  shadowOpacity:0.2,

  },
  content:{
    marginTop:10*g_AppValue.precent,
    marginBottom:10*g_AppValue.precent,
    width:278*g_AppValue.precent,
  },
  contentTextOne:{
    fontSize:13*g_AppValue.precent,
    color:'#5a5a5a',
    marginTop:14*g_AppValue.precent,
    marginLeft:13*g_AppValue.precent,
    marginBottom:14*g_AppValue.precent,

  },

  albunIntroduceView:{
    width:g_AppValue.screenWidth,
    backgroundColor:'#ffffff',
    marginTop:10*g_AppValue.precent,


  },
  contentText:{
    width:335*g_AppValue.precent,
    marginTop:18*g_AppValue.precent,
    marginLeft:20*g_AppValue.precent,
    marginBottom:20*g_AppValue.precent,
    fontSize:14*g_AppValue.precent,
    color:'#5a5a5a',
  },
})
