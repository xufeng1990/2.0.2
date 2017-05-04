//  "NewClass"
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, {Component} from 'react';
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
    NativeModules,
    NativeEventEmitter,
    DeviceEventEmitter
} from 'react-native';
//common
import Util from '../../common/util.js';
import Icon from '../../common/Icon.js';
//configs
import g_AppValue from '../../configs/AppGlobal.js';
import * as ImgUrl from '../../configs/BaseImgUrl.js';
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js';
import YLYKStorages from '../../configs/ylykbridges/YLYKStorages.js';
import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js';
//pages
import AlbumDetails from './AlbumDetails/AlbumDetails.js';
import CachedImage from 'react-native-cached-image';
import Pay from '../Pay/pay.js';

const CACHE_KEY = "__CACHE_HOME_2_DAILYNEWS";


//登陆成功
var LoginEvents = NativeModules.LoginEvent;
const myLoginEvent = new NativeEventEmitter(LoginEvents);
var loginSubscription;

//退出登录成功
var LogoutEvents = NativeModules.LogoutEvent;
const myLogoutEvent = new NativeEventEmitter(LogoutEvents);
var logoutSubscription;

//支付成功
var PaySuccessEvents = NativeModules.PayEvent;
const myPaySuccessEvents = new NativeEventEmitter(PaySuccessEvents);
var paySuccessSubscription;

export default class DailyNews extends Component {
    // 构造函数
    constructor(props) {
        super(props);
        this.state = {
            dayNews: [],//每日新闻数据
            noVip: false,//非会员
            noLogin: false//未登录
        };
    }

    componentWillMount() {
        let that = this;
        //获取缓存
      YLYKStorages.$keyValueStorage.getItem(CACHE_KEY)
        .then(function(data) {
            that.setState({dayNews: JSON.parse(data)});
        });
        //登陆监听 刷新用户信息
        loginSubscription = myLoginEvent.addListener('LoginSuccess', (reminder) => {
            this._getUserID();
        });
        //突出成功  舒心用户信息
        logoutSubscription = myLogoutEvent.addListener('LogoutSuccess', (reminder) => {
            if (reminder.LogoutSuccess) {
                this._getUserID();
            }
        })
        //侧滑先死TabBar
        this.showNoteTabBar = DeviceEventEmitter.addListener('showNoteTabBar', (res) => {
            if (res[0] == 1) {
              YLYKNatives.$showOrHideTabbar.showOrHideTabbar('show');
            } else {
                return;
            }

        })

        //支付成功  刷新用户信息
        this.paySuccessSubscription = myPaySuccessEvents.addListener('PayEvent', (reminder) => {
            if (reminder.PaySuccess) {
                this.interval = setInterval(() => {
                    this._getUserID();
                }, 5000);
            }

        })
    }


    componentDidMount() {
      //获取每日新闻解读数据
        YLYKServices.$course.getCourseList({'page': 1, 'album_id': 6, 'limit': 5})
        .then((data) => {
            this.setState({dayNews: JSON.parse(data)});
            //存入缓存
          YLYKStorages.$keyValueStorage.setItem(CACHE_KEY, data);
        }).catch((err) => {
        });
        this._getUserID();
    }

    // view卸载
    componentWillUnmount() {
        this.loginSubscription && this.loginSubscription.remove();
        this.logoutSubscription && this.logoutSubscription.remove();
        this.showNoteTabBar && this.showNoteTabBar.remove();
        this.paySuccessSubscription && this.paySuccessSubscription.remove();
    }

    //专辑详情跳转
    _goToAlbumDetails(album,albumName) {
      YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        this.props.navigator.push({
            component: AlbumDetails,
            params: {
                album: album,
                albumName:albumName,
                hideTabbar:'show',
            }

        })
    }

    //咨询页面
    goToQiView() {
        YLYKNatives.$qiyu.goToQiyu();
    }

    //支付页面跳转
    goToPayView() {
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        this.props.navigator.push({component: Pay})
    }

    //提示弹出
    _alert() {
        Util.alertDialog({
            msg: '成为友邻学员即可收听此课程',
            oneBtn: '立即入学',
            okBtn: '咨询阿树老师',
            cancelBtn: '取消',
            okFun: () => {
                this.goToQiView()
            },
            oneFun: () => {
                this.goToPayView()
            }
        })
    }

    //获取用户信息
    _getUserID() {
        YLYKNatives.$oauth.getUserInfo()
        .then((data) => {
            var resultData = JSON.parse(data);
            if (data == 0 || data == '0') {
                this.setState({noLogin: false});
            } else {
                this.setState({noLogin: true});
                let isVip = Util.isVip(resultData);
                if (isVip == false) {
                    this.setState({noVip: false});
                } else {
                    this.setState({noVip: true});
                    this.interval && this.interval.remove();
                }
            }
        }).catch((err) => {
        })

    }

    //播放按钮
    _gaToPayerView(play_id, is, is2) {
        if (this.state.noLogin == false) {
            Util.AppToast('请先登录');
        } else {
            if (this.state.noVip == false) {
                this._alert();
            } else {
                YLYKNatives.$player.openPlayerController(play_id + '', is, is2);

            }
        }

    }

    _renderRow(rowData) {
        let play_id = rowData.id;
        var diffTime = new Date(rowData.in_time * 1000);
        return (
            <TouchableOpacity activeOpacity ={1} onPress={() => this._gaToPayerView(play_id, false, '[]')}>

                <View style={styles.rowView}>

                    <View style={styles.contentView}>

                        <CachedImage defaultSource={require('../../imgs/11.png')} style={styles.contentImage} source={{
                            uri: ImgUrl.baseImgUrl + 'course/' + rowData.id + '/cover'
                        }}/>

                        <Text numberOfLines={1} style={styles.titleText}>{rowData.name}</Text>
                        <Text style={styles.timeText}>{Util.getDiffTime(diffTime)} | {rowData.teachers.map((item, i) => {return item.name})}</Text>

                    </View>

                </View>

            </TouchableOpacity>
        );
    }

    _renderFooter() {
        var album = '6';
        var albumName = this.state.dayNews.name;
        return (
            <TouchableOpacity activeOpacity ={1} onPress={() => {this._goToAlbumDetails(album,albumName)}}>
                <View style={[styles.rowView, {marginRight: 12 * g_AppValue.precent}]}>
                    <View style={styles.moreView}>
                        <Text style={styles.moreText}>查看更多</Text>
                    </View>
                </View>
            </TouchableOpacity>
        );
    }

    render() {
        if (!this.state.dayNews) {
            return (<View></View>)
        }
        var data = this.state.dayNews;
        var ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        var dataSource = ds.cloneWithRows(data);
        var album = '6';
        var albumName = data.name;
        return (
            <View style={styles.container}>

                <View style={styles.newsTitleView}>
                    <Text style={styles.newsTitle}>每日新闻解读</Text>
                    <TouchableWithoutFeedback onPress={() => {this._goToAlbumDetails(album,albumName)}}>
                        <Text style={{position: 'absolute',right: 12 * g_AppValue.precent,fontSize: 15 * g_AppValue.precent,fontFamily: 'iconfont'}}>{Icon.rightArrow}</Text>
                    </TouchableWithoutFeedback>
                </View>

                <ListView
                  ref='scrollView'
                  style={styles.listView}
                  enableEmptySections={true}
                  horizontal={true}
                  showsHorizontalScrollIndicator={false}
                  pagingEnabled={true}
                  dataSource={dataSource}
                  renderRow={this._renderRow.bind(this)}
                  renderFooter={this._renderFooter.bind(this)}
                  />

            </View>
        );
    }

    // 自定义方法区域
    // your method

}
var styles = StyleSheet.create({
    container: {
        flex: 1,
        width: g_AppValue.screenWidth,
        height: 230 * g_AppValue.precent,
        backgroundColor: '#ffffff',
        marginTop: 10 * g_AppValue.precent
    },
    newsTitleView: {
        width: g_AppValue.screenWidth,
        height: 18 * g_AppValue.precent,
        marginTop: 17 * g_AppValue.precent,
        // backgroundColor:'red',
        justifyContent: 'center',
        alignItems: 'center',
        flexDirection: 'row'
    },
    newsTitle: {
        textAlign: 'center',
        fontSize: 18 * g_AppValue.precent,
        fontWeight: 'bold',
        //  marginLeft:120 * g_AppValue.precent,
    },
    touchRightImage: {
        marginTop: 2.5 * g_AppValue.precent,
        flexDirection: 'row-reverse',
        position: 'absolute',
        right: 12 * g_AppValue.precent,
        width: 7 * g_AppValue.precent,
        height: 13 * g_AppValue.precent,
        //backgroundColor:'yellow',
    },
    rightImage: {
        // flexDirection:'row-reverse',
        // position:'absolute',
        // right:12,
        width: 7 * g_AppValue.precent,
        height: 13 * g_AppValue.precent,
        //backgroundColor:'yellow',

    },
    listView: {
        flex: 1
    },
    rowView: {
        width: 160 * g_AppValue.precent,
        height: 170 * g_AppValue.precent,
        //backgroundColor:'red',
        marginTop: 12 * g_AppValue.precent,
        marginLeft: 12 * g_AppValue.precent,
        justifyContent: 'space-between',
        shadowColor: 'black',
        shadowRadius: 1,
        shadowOffset: {
            height: 0,
            width: 0
        },
        shadowOpacity: 0.2
    },
    contentView: {
        marginTop: 10 * g_AppValue.precent,
        marginLeft: 10 * g_AppValue.precent,
        width: 140 * g_AppValue.precent,
        height: 200 * g_AppValue.precent,
        //  backgroundColor:'yellow',
    },
    contentImage: {
        width: 140 * g_AppValue.precent,
        height: 105 * g_AppValue.precent
    },
    titleText: {
        marginTop: 8 * g_AppValue.precent,
        fontSize: 14 * g_AppValue.precent,
        color: '#5a5a5a',
        textAlign: 'left'
    },
    timeText: {
        marginTop: 6 * g_AppValue.precent,
        fontSize: 11 * g_AppValue.precent,
        color: '#9a9b9c',
        textAlign: 'left',
        //  backgroundColor:'red',
    },
    moreView: {
        width: 140 * g_AppValue.precent,
        height: 150 * g_AppValue.precent,
        marginTop: 10 * g_AppValue.precent,
        marginLeft: 10 * g_AppValue.precent,
        backgroundColor: '#f2f5f6',
        justifyContent: 'center',
        alignItems: 'center'
    },
    moreText: {
        fontSize: 14 * g_AppValue.precent,
        color: '#9a9b9c'
    },
    blackView: {
        position: 'absolute',
        width: 140 * g_AppValue.precent,
        height: 105 * g_AppValue.precent,
        top: 0 * g_AppValue.precent,
        left: 0 * g_AppValue.precent,
        backgroundColor: 'rgba(0,0,0,0.4)',
        justifyContent: 'center',
        alignItems: 'center'
    },
    blackText: {
        fontSize: 18 * g_AppValue.precent,
        color: '#ffffff'
    },
    lineView: {
        width: 50 * g_AppValue.precent,
        height: 1 * g_AppValue.precent,
        backgroundColor: '#d8d8d8'
    },
    lineViewTwo: {
        marginTop: 2 * g_AppValue.precent,
        width: 44 * g_AppValue.precent,
        height: 0.5 * g_AppValue.precent,
        backgroundColor: '#ffffff'
    }
})
