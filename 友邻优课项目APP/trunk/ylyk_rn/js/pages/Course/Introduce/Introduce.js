//  introduce
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
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
    DeviceEventEmitter,
    Platform,
    InteractionManager,
} from 'react-native';
//configs
import YLYKServices from '../../../configs/ylykbridges/YLYKServices.js';
import * as ImgUrl from '../../../configs/BaseImgUrl.js';
import g_AppValue from '../../../configs/AppGlobal.js';
//component
import IntroduceHeaderCell from '../../../component/AlbumCell/IntroduceHeaderCell.js';
import Loading from '../../../component/Loading/Loading.js';
import BlankPages from '../../../component/AlbumCell/BlankPages.js';
//pages
import TeacherIntroduce from './TeacherIntroduce.js';
import NoVipDetailsView from '../NoVipDetails.js';
//组件
import HTMLView from 'react-native-htmlview';
import ExtraDimensions from 'react-native-extra-dimensions-android';

export default class Introduce extends Component {
    // 构造函数
    _alldata = [];
    _teacher = [];
    constructor(props) {
        super(props);
        this.state = {
            teacherData: '',
            isLoading: true
        };
    }

    componentWillMount() {
        if (g_AppValue.isConnected == false) {
            this.setState({ isLoading: false })
        }
    }
    // 加载完成
    componentDidMount() {
        YLYKServices.$album.getAlbumById(this.props.album + '').then((data) => {
            var resultData = JSON.parse(data);
            this.setState({ teacherData: resultData, isLoading: false })

        }).catch((err) => {
            console.log('album数据错误' + err)
            this.setState({ teacherData: resultData, isLoading: false })
        })
    }

    // view卸载
    componentWillUnmount() {
        //
    }

    _goToTeacherPage(item,i) {

        this.props.navigator.push({
          component: TeacherIntroduce ,
          params:{
            teacherData:item
          }
        })

    }
    //onPress={()=>{this._goToTeacherPage(item,i)}}
    _renderRow(item,i) {
      var teacherId = item.id;
      console.log("this.state.teacherData.teachers" + teacherId);

        return (
            <TouchableOpacity activeOpacity = {1} >
            <View style={styles.teachersImageRowView}>
                <Image style={styles.teachersHeaderImage} source={{uri: ImgUrl.baseImgUrl + 'teacher/' + item.id + '/avatar'}} />
                <View style={styles.teachersNameView}>
                    <Text style={styles.teachersNameText}>{item.name}</Text>
                    <Text style={styles.teachersIntroduceText} numberOfLines={2}>{item.desc}</Text>
                </View>
            </View>
            </TouchableOpacity>
        );
    }
    // render
    render() {
        if (!this.state.teacherData) {
            return <Loading visible={this.state.isLoading} />;
        } else {

            var htmlContent = this.state.teacherData.intro;

            return (
                <View style={[styles.container, {
                    ...Platform.select({
                        ios: { height: this.props.noVip == false ? 365 * g_AppValue.precent : 410 * g_AppValue.precent },
                        android: { height: this.props.noVip == false ? 340 * g_AppValue.precent : 390 * g_AppValue.precent }
                    }),
                }]}>
                    {g_AppValue.isConnected ? <ScrollView>
                        <View style={styles.speakerTeachersView}>
                            <IntroduceHeaderCell titleName='主讲大咖' titleNameTwo='I n s t r u c t o r' />

                            <View style={styles.teachersImageView}>
                                {this.state.teacherData.teachers.map((item, i) => this._renderRow(item, i))}
                            </View>
                        </View>
                        <View style={styles.albunIntroduceView}>
                            <IntroduceHeaderCell titleName='专辑介绍' titleNameTwo='I n t r o d u c t i o n' />
                            <View style={styles.contentText}>
                                <HTMLView value={htmlContent} stylesheet={styles} />
                            </View>
                        </View>
                    </ScrollView>
                        : <BlankPages ImageUrl={require('../../../imgs/none.png')} contentText='无法连接到服务器,请检查你的网络设置' />}


                </View>
            );
        }


    }


}
//
// {this.props.hideNoVip == false
//     ? <NoVipDetailsView navigator={this.props.navigator}/>
//     : null}

var styles = StyleSheet.create({

    container: {


        backgroundColor: '#f2f5f6',
    },
    speakerTeachersView: {
        marginTop: 10 * g_AppValue.precent,
        width: g_AppValue.screenWidth,
        backgroundColor: '#ffffff'
    },

    teachersImageView: {
        width: g_AppValue.screenWidth,
        //height:145 * g_AppValue.precent,
        backgroundColor: '#ffffff',
        justifyContent: 'center',
        marginBottom: 20 * g_AppValue.precent
    },

    ContainerStyle: {
        justifyContent: 'space-around',
        flexDirection: 'row'
    },
    teachersImageRowView: {
        width: g_AppValue.screenWidth,
        height: 80 * g_AppValue.precent,
        //  backgroundColor:'green',
        alignItems: 'center',
        flexDirection: 'row'
    },
    teachersHeaderImage: {
        width: 60 * g_AppValue.precent,
        height: 60 * g_AppValue.precent,
        borderRadius: 30 * g_AppValue.precent,
        // marginTop:10 * g_AppValue.precent,
        marginLeft: 20 * g_AppValue.precent
    },
    teachersNameView: {
        width: 250 * g_AppValue.precent,
        height: 60 * g_AppValue.precent,
        //backgroundColor:'red',
        marginLeft: 20 * g_AppValue.precent
    },
    teachersNameText: {
        marginTop: 10 * g_AppValue.precent,
        fontSize: 14 * g_AppValue.precent,
        color: '#5a5a5a'
    },
    teachersIntroduceText: {
        marginTop: 13 * g_AppValue.precent,
        fontSize: 11 * g_AppValue.precent,
        color: '#9a9b9c'
    },
    albunIntroduceView: {
        width: g_AppValue.screenWidth,
        backgroundColor: '#ffffff',
        marginTop: 10 * g_AppValue.precent
    },
    contentText: {
        width: 335 * g_AppValue.precent,
        marginTop: 18 * g_AppValue.precent,
        marginLeft: 20 * g_AppValue.precent,
        marginBottom: 20 * g_AppValue.precent,
        fontSize: 14 * g_AppValue.precent,
        color: '#5a5a5a'
    },
    p: {
        lineHeight: 20,

    }
})
