/**
 * Created by 艺术家 on 2017/3/10.
 */

/** Created by 艺术家 on 2017/3/9. cell */
import React, { Component } from 'react';
import { Text, View, TouchableOpacity, StyleSheet, ListView, NativeModules, DeviceEventEmitter, Platform, Dimensions } from 'react-native';
//common
import styles from "../../common/styles.js"
import Icon from "../../common/Icon.js";
//configs


import YLYKNatives from "../../configs/ylykbridges/YLYKNatives.js";
import YLYKServices from "../../configs/ylykbridges/YLYKServices.js";
import YLYKStorages from "../../configs/ylykbridges/YLYKStorages.js";
//pages
import Downloading from "./Downloading.js";
import DownloadCourse from "./DownloadCourse.js";
import DownloadAlbum from "./DownloadAlbum.js";
//组件
import ScrollableTabView, { DefaultTabBar, } from 'react-native-scrollable-tab-view';




//导航条
class DTabBar extends Component {
    render() {
        return (
            <View style={[styles.row, styles.alignCenter, pageStyles.tab, styles.bgWhite, { height: 44 }]}>
                {[
                    <Text key="tab0"
                        style={[styles.icon, styles.text20, styles.textCenter, { width: 40 }]}
                        onPress={this.props.backFun}>
                        {Icon.back}
                    </Text>,
                    <TouchableOpacity activeOpacity={1} key="tab1" style={[styles.primary, styles.alignCenter, pageStyles.tabItem, { borderBottomColor: this.props.activeTab == 0 ? '#B41930' : '#ffffff' }]} onPress={() => { this.props.goToPage(0) }}>
                        <Text style={[styles.text18, styles.textCenter, this.props.activeTab == 0 ? styles.textRed : styles.textBlack]}>课程</Text>
                    </TouchableOpacity>,
                    <TouchableOpacity activeOpacity={1} key="tab2" style={[styles.primary, styles.alignCenter, pageStyles.tabItem, { borderBottomColor: this.props.activeTab == 1 ? '#B41930' : '#ffffff' }]} onPress={() => { this.props.goToPage(1) }}>
                        <Text style={[styles.text18, styles.textCenter, this.props.activeTab == 1 ? styles.textRed : styles.textBlack]}>专辑 </Text>
                    </TouchableOpacity>,
                    <TouchableOpacity activeOpacity={1} key="tab3" style={[styles.primary, styles.alignCenter, pageStyles.tabItem, { borderBottomColor: this.props.activeTab == 2 ? '#B41930' : '#ffffff' }]} onPress={() => { this.props.goToPage(2) }}>
                        <Text style={[styles.text18, styles.textCenter, this.props.activeTab == 2 ? styles.textRed : styles.textBlack]}>下载中</Text>
                    </TouchableOpacity>,
                    <Text key="tab4" style={[styles.icon, styles.text20, styles.textCenter, { width: 40 }]}>{Icon.disc}</Text>,
                ]}
            </View>
        )
    }

    componentDidMount() {
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
    }
}

export default class BottomCheckbox extends Component {
    /* 构造*/
    constructor(props) {
        super(props);
        this.state = {
            downloadList: "[]",
            isShowAlbum: false,
            courseHideList: [],
            TotalDiskSize:'',//全部空间
            freeDiskSize:'',//剩余空间


        };
    }

    back = () => {
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
        this.props.navigator.pop()
    }

    //渲染前
    componentWillMount() {
        this.heideList = [];
    }
  componentWillMount(){
    //获取全部内存
    YLYKNatives.$application.getTotalDiskSize()
    .then((data)=>{
      this.setState({
        TotalDiskSize:parseInt(data / 1024),
      })
      console.log('手机全部内存' + data);
    })
    //获取剩余内存
    YLYKNatives.$application.freeDiskSpaceInBytes()
    .then((data)=>{
      this.setState({
        freeDiskSize:data,
      })
      console.log('获取剩余内存' + data);
    })
  }

    //渲染完成
    // componentDidMount(){
    //         //设置监听
    //         DeviceEventEmitter.addListener("downloadEvent",(message)=>{
    //             let messages =JSON.parse(message.downloadEvent);
    //             let progress = messages.downloadSize;
    //            if(progress==1){
    //                 //通知节目页面刷新
    //                 this.setState({
    //                      ShowCourseId: messages.extra.id,
    //                 })
    //            }
    //         })
    // }

    // view卸载
    componentWillUnmount() {
        DeviceEventEmitter.emit('showProfileTabBar', '1');
        DeviceEventEmitter.removeAllListeners("downloadEvent");
        this._downloadList = [];
    }

    render() {
        return (
          <View style={{flex:1}}>

            <ScrollableTabView
                style={[Platform.OS == "ios" ? { paddingTop: 20 } : null]}
                locked={true}
                onChangeTab={tabChage => {
                    YLYKNatives.$download.getDownloadList().then(list => {
                        let stateChage = list != this._downloadList;
                        this.setState({
                            isShowAlbum: tabChage.i === 1 && stateChage,
                            isshowCourse: tabChage.i === 0 && stateChage,
                        })
                        this._downloadList = list;
                    })
                }}
                renderTabBar={() => <DTabBar backFun={this.back} />}
            >
                <DownloadCourse
                    isShow={this.state.isshowCourse} />
                <DownloadAlbum isShow={this.state.isShowAlbum}
                    navigator={this.props.navigator}
                    courseHideList={this.state.courseHideList} />
                <Downloading />
            </ScrollableTabView>
            <View style={pageStyles.spaceView} >
              <Text style={{fontSize:11,color:'#ffffff',marginLeft:12}}>{'总空间' + this.state.TotalDiskSize +'G' + '/' + (this.state.freeDiskSize < 1024 ?'剩余' +   Number(this.state.freeDiskSize).toFixed(2) + 'MB' : '剩余' + Number(this.state.freeDiskSize / 1024 ).toFixed(2) + 'G')}</Text>
            </View>
          </View>
        )
    }
}
//+ this.state.freeDiskSize < 1024 ? this.state.freeDiskSize.toFixed(2) + 'MB' : (this.state.freeDiskSize / 1024 ).toFixed(2) + 'G'
var pageStyles = StyleSheet.create({
    tab: {
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: "#9a9b9c"
    },
    tabsActive: {
        borderBottomColor: "#0fabfa",
        borderBottomWidth: 1,
    },
    tabItem: {
        height: 43,
        borderBottomWidth: 2,
    },
    spaceView:{
      width:Dimensions.get('window').width,
      height:21,
      flexDirection:'row',
      alignItems:'center',
      backgroundColor:'rgba(0,0,0,0.30)',
    },
})
