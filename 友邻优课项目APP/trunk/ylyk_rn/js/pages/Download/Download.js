/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
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
    Dimensions,
    DeviceEventEmitter,
    NetInfo,
    Platform,
    InteractionManager,
} from 'react-native';
//common
import styles from "../../common/styles.js";
import Util from "../../common/util.js";
import Enums from "../../common/enums.js";
import Icon from "../../common/Icon.js";
//configs

import YLYKNatives from "../../configs/ylykbridges/YLYKNatives.js";
import YLYKServices from "../../configs/ylykbridges/YLYKServices.js";
import YLYKStorages from "../../configs/ylykbridges/YLYKStorages.js";





//component
import Header from "../../component/HeaderBar/HeaderBar.js";
//pages
import DownloadFilter from "../DownLoadFilter/DownloadFilter.js";
import BottomCheckbox from "../../component/BottomCheckbox/BottomCheckbox.js";
import DownloadItem from "./DownloadItem.js";

var TimerMixin = require('react-timer-mixin');
// var publicService = Service.publicService;
export default class Download extends Component {
    constructor(props) {
        super(props);
        mixins: [TimerMixin];
        //创建一个DataSource对象，通过判断来决定哪些行需要渲染
        const ds = new ListView.DataSource({ rowHasChanged: (r1, r2) => r1 !== r2 });
        this.state = {
            //设置DataSource时，不直接使用原始数据，而是使用cloneWithRows复制
            //使用复制后的数据实例化ListView
            dataSource: ds.cloneWithRows([]),
            isCheckedAll: false,
            albumId: 0,
            albumName: "",
            selectCount: 0,
        };
    }

    //挂载
    componentDidMount() {
        /**  延长加载数据防止进入界面卡死  **/
        InteractionManager.runAfterInteractions(()=>{
            YLYKServices.GET(JSON.stringify({
                url: ["album", this.state.albumId + "", "course"],
                body: {},
                query: {}
            })).then(info => {
                let courseList = JSON.parse(info);
                courseList.forEach(item => {
                    this.sourcedata.push({
                        id: item.id,
                        name: item.name,
                        album: {
                            id: this.state.albumId,
                            name: this.state.albumName,
                        },
                        duration: item.duration,
                        durationFormat: Util.timeFormat(item.duration),
                        isChecked: false,
                        isDownloaded: false,
                        inTime: +item.in_time * 1000,
                    })
                })

                YLYKNatives.$download.getDownloadList().then((downloadList) => {
                    //获取下载中的列表
                    let downloadedList = JSON.parse(downloadList).filter((item) =>
                        +item.flag !== Enums.downloads.DOWNLOAD_NONE
                    );
                    if (downloadedList && downloadedList.length > 0) {
                        //已在下载列表中的不再标记已下载
                        this.sourcedata.forEach((item, index) => {
                            if (downloadedList.some(i => i.extra.id == item.id)) {
                                this.sourcedata[index].isDownloaded = true;
                            }
                        });
                    }
                    this.setState({
                        dataSource: this.state.dataSource.cloneWithRows(this.sourcedata),
                    });
                });
            })
        });

    }

    // renderRow={(rowData, sectionId, rowId) =>
    //
    // }

    _renderRow(rowData, sectionId, rowId){
      let that =this;
      return(
        <View>
            <DownloadItem rowId={rowId} selectCount = {that.state.selectCount} rowData={rowData} onTapItem={this._onTapItem} />
        </View>
      );
    }

    //渲染前
    componentWillMount() {
        this.setState({
            albumId: this.props.albumId,
            albumName: this.props.albumName,
        })
        this.sourcedata = [];
    }

    render() {
        return (
            <View style={[styles.primary, styles.bgGrey, { paddingBottom: 55 }]}>
                <Header title={"下载"} backFun={() => { this._back() }}
                />
                <ListView style={styles.listView}
                    dataSource={this.state.dataSource}
                    enableEmptySections={true}
                    renderRow={this._renderRow.bind(this)}

                />
                <BottomCheckbox checkedCallBack={() => { this.checkedAllCallback() }}
                    onPressBtnCallBack={() => { this._downloadCallback() }}
                    btnText={"下载"}
                    textContent={"已选择" + this.state.selectCount + "节课"}
                    isShowCheckBox={false}
                    checkState={this.state.isCheckedAll} />
            </View>
        );
    }

    //跳转到筛选
    _goToFilterView() {
        this.props.navigator.push({
            name: "filter",
            component: DownloadFilter,
            params: {
                sourceDatea: this.sourcedata
            }
        })
    }

    //返回
    _back() {
        this.props.navigator.pop();
    }

    //执行下载
    _downloadCallback() {
        //判断网络类型
        NetInfo.fetch().done((reach) => {
            let _this = this;
            if (reach.toLowerCase() !== "wifi") {
                Util.alert({
                    msg: "确定要使用流量下载课程？",
                    okFun: () => {
                        _this.download();
                    }
                })
            } else {
                _this.download();
            }
        });
    }
    download() {
        //开始下载
        let downloadQueue = this.sourcedata.filter((item) =>
            item.isChecked && !item.isDownloaded
        );
        if (downloadQueue.length == 0) {
            Util.AppToast("请选择要下载的课程");
            return;
        }

        this.interval = setInterval(()=>{
            updateDownloadInfo();
        },1000);
     updateDownloadInfo=()=>{
         YLYKNatives.$download.startDownload(downloadQueue)
             .then((downloadInfo) => {
                 Util.AppToast("已加入下载队列");
                 if (downloadInfo == '0') {
                     console.log('未完成');
                     //updateDownloadInfo();
                 } else  if (downloadInfo == '1'){
                     alert('完成');
                 }
                 this.props.navigator.pop();
             });
        }
           YLYKNatives.$download.startDownload(downloadQueue)
           .then((downloadInfo) => {
            Util.AppToast("已加入下载队列");
            if (downloadInfo == '0') {
               alert('未完成');
                updateDownloadInfo();
            } else  if (downloadInfo == '1'){
                alert('完成');
            }
            this.props.navigator.pop();
        });
    }



    //点击其中的一条
    _onTapItem = (rowId) => {
        if (this.sourcedata[rowId].isDownloaded) {
            return;
        }
        //取消全选状态
        // if (this.state.isCheckedAll && this.sourcedata[rowId].isChecked) {
        //     this.setState({isCheckedAll: false})
        // }
        if (this.sourcedata[rowId].isChecked) {
            this.setState({
                selectCount: --this.state.selectCount
            })
          }

          if (this.state.selectCount < 20) {

            if (!this.sourcedata[rowId].isChecked) {
                this.setState({
                    selectCount: ++this.state.selectCount
                })
            }

            this.sourcedata[rowId].isChecked = !this.sourcedata[rowId].isChecked;

          }else {

            DeviceEventEmitter.emit('selectCount','1');
                  Util.AppToast("最多能下载20节课");

          }



    }

    //全选
    checkedAllCallback() {
        //使用JSON.parse 实现简单的深复制
        //  let newData = JSON.stringify(this.state.dataSource._dataBlob.s1);
        //  let newDataSource = JSON.parse(newData);
        //刷新视图
        // this.setState({  });
        //  this.sourcedata = newDataSource;
        // this.setState({
        //     dataSource: this.state.dataSource.cloneWithRows(this.sourcedata),
        //     isCheckedAll: !this.state.isCheckedAll
        // });
        // arrDownloadItem.forEach((item) => {
        //     item.setChecked(!this.state.isCheckedAll);
        // });
    }
}

var pageStyles = StyleSheet.create({
    sections: {
        paddingTop: 11,
        paddingBottom: 9,
        //IOS
        shadowColor: '#000',
        shadowOffset: { w: 0, h: 0 },
        shadowOpacity: 0.1,
        shadowRadius: 8,
    },
    courseName: {
        marginTop: 8,
    }
});
