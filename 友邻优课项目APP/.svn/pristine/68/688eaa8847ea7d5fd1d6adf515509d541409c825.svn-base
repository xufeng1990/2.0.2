/**
 * Created by 艺术家 on 2017/3/3.
 */


import React, { Component } from 'react';
import {
    Text,
    View,
    Image,
    ListView,
    StyleSheet,
    TouchableOpacity,
    Alert,
    Dimensions,
    ProgressBarAndroid,
    DeviceEventEmitter,
    Animated,
    Easing,
    Platform
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
import BottomCheckbox from "../../component/BottomCheckbox/BottomCheckbox.js";
import Header from "../../component/HeaderBar/HeaderBar.js";
//组件
import CachedImage from 'react-native-cached-image';


export default class DownloadCourse extends Component {
    constructor(props) {
        super(props);
        const ds = new ListView.DataSource({ rowHasChanged: (r1, r2) => r1 !== r2 });
        this.state = {
            dataSource: ds.cloneWithRows([]),
            isShowBottomBar: false,
            isCheckedAll: false,
        };
    }

    //挂载
    componentWillMount() {
        //初始化一个Animated.Value
        this._animValue = new Animated.Value(-56);
        this._getStateData(this.props.dataSource);
    }

    componentDidMount() {

    }

    // view卸载
    componentWillUnmount() {
        DeviceEventEmitter.removeAllListeners("downloadEvent");
    }

    //删除操作
    delete(courseIdList) {
        let newData = JSON.stringify(this.state.dataSource._dataBlob.s1);
        let newDataSource = JSON.parse(newData);
        YLYKNatives.$download.deleteDownload(courseIdList).then((info) => {
        });
        newDataSource.forEach((item, index) => {
            if (courseIdList.some(i => i == item.id)) {
                newDataSource[index].isShow = false;
            }
        });
        this.setState({
            dataSource: this.state.dataSource.cloneWithRows(newDataSource),
        });
    }

    //删除
    deleteItem(rowId) {
        let courseId = [this.state.dataSource._dataBlob.s1[rowId].id];
        this.delete(courseId);
    }

    //批量删除
    deleteBatch() {
        let urlList = [];
        this.state.dataSource._dataBlob.s1.forEach((item) => {
            if (item.isChecked) {
                urlList.push(item.id);
            }
        });
        this.delete(urlList);
    }

    //批量管理切换
    manager() {
        if (this.state.isShowBottomBar) {
            this._animValue.setValue(-56);
            this.setState({
                isShowBottomBar: false
            })
        } else {
            this._animValue.setValue(0);
            this.setState({
                isShowBottomBar: true
            })
        }
    }

    //全选
    checkedAllFun() {
        //使用JSON.parse 实现简单的深复制
        let stateData = this.state.dataSource._dataBlob.s1;
        let newDataSource = JSON.parse(JSON.stringify(stateData));
        newDataSource.forEach((item) => {
            item.isChecked = !this.state.isCheckedAll;
        });
        //刷新视图
        this.setState({
            dataSource: this.state.dataSource.cloneWithRows(newDataSource),
            isCheckedAll: !this.state.isCheckedAll
        });
    }

    //点击其中的一条
    onPressItem(rowId) {
        let stateData = this.state.dataSource._dataBlob.s1;
        if (this.state.isShowBottomBar) {
            let newDataSource = JSON.parse(JSON.stringify(stateData));
            newDataSource[rowId].isChecked = !newDataSource[rowId].isChecked;
            //取消全选状态
            if (!newDataSource[rowId].isChecked) {
                this.setState({ isCheckedAll: false })
            }
            this.setState({
                dataSource: this.state.dataSource.cloneWithRows(newDataSource),
            });
        } else {
            let msg = this.state.dataSource._dataBlob.s1;
            //跳转播放
             YLYKNatives.$player.openPlayerController(JSON.stringify(msg[rowId].id), true, msg);
        }
    }

    render() {
        if (this.state.dataSource._dataBlob.s1.length == 0) {
            return <BlankPages />
        }
        return (
            <View style={[styles.primary, styles.bgGrey]}>
                <Header backFun={this._backFun} title={this.props.name} />
                <ListView style={[styles.listView]}
                    dataSource={this.state.dataSource}
                    enableEmptySections={true}
                    renderRow={(rowData, sectionId, rowId) =>
                        rowData.isShow ?
                            <Animated.View style={[styles.section, styles.row,
                            styles.bgWhite, pageStyles.container, pageStyles.transformItem,
                            { transform: [{ translateX: this._animValue }] }]}>
                                {/*复选框*/}
                                <TouchableOpacity activeOpacity={1} style={[styles.alignCenter, { width: 56, marginRight: 12 }]} onPress={() => {
                                    this.onPressItem(rowId);
                                }}>
                                    <Text style={[rowData.isChecked ? styles.textGreen : styles.textGrey, styles.icon, styles.text21]}>
                                        {rowData.isChecked || rowData.isDownloaded ? Icon.checked : Icon.checkBox}
                                    </Text>
                                </TouchableOpacity>
                                <TouchableOpacity activeOpacity={1} onPress={() => { this.onPressItem(rowId) }} style={[styles.primary, styles.row]}>
                                    <CachedImage source={{ uri: rowData.cover }}
                                        style={{ width: 120, height: 90 }} />
                                    <View style={[styles.container, styles.primary, pageStyles.borderRight,]}>
                                        <Text style={[styles.textBlack, styles.text14, styles.textLeft, { marginVertical: 4 }]}>{rowData.name}</Text>
                                        <View style={[{ marginTop: 6 }]}>
                                            <Text style={[styles.textGrey, styles.text13, styles.textLeft]}>{
                                                rowData.durationFormat + "\t\t\t" + (rowData.totalSize / 1024 / 1024).toFixed(1) + "M"}
                                            </Text>
                                        </View>
                                    </View>
                                    {/*删除按钮*/}
                                    <TouchableOpacity activeOpacity={1} style={[styles.alignCenter, { width: 56 }]} onPress={() => {
                                        this.deleteItem(rowId);
                                    }}>
                                        <Text style={[styles.icon, styles.textGrey, styles.text20]}>{Icon.delete}</Text>
                                    </TouchableOpacity>
                                </TouchableOpacity>
                            </Animated.View> : null
                    }
                />
                <View>
                    {this.state.isShowBottomBar ?
                        <BottomCheckbox checkedCallBack={() => { this.checkedAllFun() }}
                            onPressBtnCallBack={() => { this.deleteBatch() }}
                            btnText={"删除"}
                            isShowCheckBox={true}
                            checkState={this.state.isCheckedAll}
                        /> : null
                    }
                </View>
            </View>
        );
    }

    _backFun = () => {
        this.props.navigator.pop();
    }

    //下载列表 --> this.state.dataSource
    _getStateData(downloadList) {
        if (downloadList && downloadList.length > 0) {
            this.setState({
                dataSource: this.state.dataSource.cloneWithRows(downloadList),
            });
        }
    }
}

var pageStyles = StyleSheet.create({
    container: {
        paddingVertical: 10,
    },
    borderRight: {
        borderRightColor: "#f2f5f6",
        borderRightWidth: 1,
    },
    transformItem: {
        width: Dimensions.get('window').width + 56,
    }
});
