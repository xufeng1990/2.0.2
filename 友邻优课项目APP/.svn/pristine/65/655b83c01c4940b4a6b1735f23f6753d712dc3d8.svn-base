//  筛选页面
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
  DeviceEventEmitter,
} from 'react-native';

//configs
import g_AppValue from '../../configs/AppGlobal.js';
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js';
// 类
export default class FilterView extends Component {
  // 构造函数
  constructor(props) {
    super(props);
    this.state = {
      data:[],
    };
  }

  componentWillMount(){

  }

  // 加载完成
  componentDidMount(){
       let rowData = this.props.filterData.reverse();
      //  //筛选
       let dataLenght = rowData.length;
       let itemLenght = Math.floor(dataLenght / 20);//一共有几个分组
       let lastItemCount = dataLenght % 20;//最后的分组的个数
       let sourceData = [];

       //筛选每日新闻
       if (dataLenght > 0 && this.props.albumId == 6) {
         rowData.reverse().forEach((item)=>{
           let inTime = new Date(item.in_time * 1000);
           let year = inTime.getFullYear();
           let month = inTime.getMonth() + 1;
           let lable = year + '年' + month + '月';
           let dataLenght = sourceData.length;
           if (dataLenght == 0) {
             sourceData.push({
               data:lable,
               courseList:[item],
             })
           }

           for (var i = 0; i < dataLenght; i++) {
             if (sourceData[i].data == lable) {
               sourceData[i].courseList.push(item);
             } else  if (i == dataLenght - 1){
               sourceData.push({
                 data:lable,
                 courseList:[item],
               })
             }
           }
         })
       }else {
         for (var i = 0; i <= itemLenght; i++) {
            if (i < itemLenght) {
              sourceData.push({
                data: i * 20 + 1 + "-" + (i + 1) * 20 + "集",
                courseList: rowData.slice(i * 20, (i + 1) * 20 - 1)
              })
            }else if (i == itemLenght) {
              sourceData.push({
                        data: (i * 20 + 1) + "-" + (i * 20 + lastItemCount) + "集",
                        courseList: rowData.slice(i * 20, i * 20 + lastItemCount)
                    })
            }
             }
       }
        this.setState({ data: sourceData });

  }

  // view卸载
  componentWillUnmount(){

    //
  }
  _courseFilter(i){
    var res = i + 1;
      DeviceEventEmitter.emit('courseFilter',res);
  }

  _renderItem(item,i){
    console.log('下表' + i)

    return(
      <TouchableHighlight  style={styles.itemView} underlayColor={'#B41930'} onPress = {()=>{this._courseFilter(i)}}>
        <Text style={{fontSize:14,color:'black'}}>{item.data}</Text>

      </TouchableHighlight>
    );
  }

  // render
  render(){

    return (
      <View style={{flex:1}}>
      <TouchableOpacity activeOpacity={1} onPress={this.props.back}>
      <View style={{ flexDirection:'column-reverse',width:375,height:667,}}>
          <View style={styles.container} >
            <ScrollView >
              <View style={[styles.container,{marginBottom:20}]} >
            {this.state.data.map((item,i)=>this._renderItem(item,i))}
          </View>
              </ScrollView>
            <TouchableOpacity activeOpacity={1}  style={styles.backView} onPress={this.props.back}>
              <Text style={{fontSize:14}}>取消</Text>
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
    width:375,
    height:365,
    flexWrap:'wrap',
    flexDirection:'row',
    backgroundColor:'#f2f5f6',
  },
  itemView:{
    width:90,
    height:34,
    marginTop:20,
    marginLeft:25,
    borderColor:'rgba(0,0,0,0.30)',
    borderWidth:1,
    borderRadius:5,
    backgroundColor:'#ffffff',
    justifyContent:'center',
    alignItems:'center',
  },
  backView:{
    width:375,
    height:60,
    backgroundColor:'#f2f5f6',
    justifyContent:'center',
    alignItems:'center',
    bottom:0,
    position:'absolute'
  }
})
