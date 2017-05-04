//  AlbumNote
//  功能: TODO 该类的作用
//  Created by 刘云强 on  2016-10-20
//  Copyright © 2017年  琢磨科技.

'use strict';
import React, {Component, PropTypes} from 'react';
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
    Modal,
    NativeEventEmitter
} from 'react-native';
//common
import Util from '../../common/util.js';
import Icon from '../../common/Icon.js';
//configs
import g_AppValue from '../../configs/AppGlobal.js';
import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js'
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js'
import YLYKStorages from '../../configs/ylykbridges/YLYKStorages.js'

//pages
import Pay from '../../pages/Pay/pay.js';
//组件
import ImageZoom from 'react-native-image-pan-zoom';
import ImageViewer from 'react-native-image-zoom-viewer';
import CachedImage from 'react-native-cached-image';

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

export default class NoteCell extends Component {
    // 构造函数
    _images = [];
    constructor(props) {
        super(props);
        this.focus = true;
        this.modalImageVisible = false;
        this.saveImageModalVisible = false;
        this.state = {
            focusChange: true,
            modalVisible: false,
            transparent: false,
            saveModalVisible: false,
            isShow: true,
            //点赞
            noteId: this.props.noteId,
            thumbNumber: this.props.thumbNumber,
            //点赞次数判断
            isLiked: this.props.is_liked,
            hideNoVip: false,
            noLogin: false,
            isMe: false,
            index1: 0,
            showImages: [],
            imageIndex: 0,
            item:'',
        };
    }
    static defaultProps = {
        name: 'name', //标题
        cellBackgrondColor: '#ffffff',
        actionFnc() {
        },
        focusChange() {
        },
        foucsActionFnc() {
        },
        touchImage() {
        },
        imageSourceFunc() {
        },
        noteTouchInage() {
        },
        palyAction() {
        },
        thumActionFnc() {
        },
        headerImageAction() {
        }
    }
    static propTypes = {
        name: PropTypes.string,
        headPortraitImage: PropTypes.object,
        time: PropTypes.string,
        focusChange: PropTypes.func,
        focusChangeImage: PropTypes.number,
        content: PropTypes.string,
        cellBackgrondColor: PropTypes.string,
        thumActionFnc: PropTypes.func,
        imagesArray: PropTypes.array,
        touchImage: PropTypes.func,
        playImage: PropTypes.object,
        playTitle: PropTypes.string,
        playName: PropTypes.string,
        thumbNumber: PropTypes.number,
        imagesData: PropTypes.array,
        noteTouchImage: PropTypes.func,
        palyAction: PropTypes.func,
        numberOfLines: PropTypes.number,
        headerImageAction: PropTypes.func,
        isMe: PropTypes.string,
    }
    _showModal(item, i) {
        this.setState({
            modalVisible: true,
            imageIndex: i,
            index1: i,
            item:item,
        })
    }
    _closeModal() {
        this.setState({
            modalVisible: false,
            currentImageUrl: "",
        })
    }
    //保存图片
    _save() {
        YLYKStorages.$fileStorage.saveImage(this.state.showImages[this.state.imageIndex].url)
            .then((data) => {
                this.setState({saveModalVisible: false})
            }).catch((err) => {
        })
    }
    //删除自己心得
    _deleteMyNote() {
        Util.alert({
            msg: "确定删除该心得吗？",
            okBtn: "删除",
            okFun: () => {

                YLYKServices.$note.deleteNote(this.state.noteId + '');

                this.setState({
                    isShow: false
                })
            }
        })
    }
    //咨询页面
    goToQiView() {
        YLYKNatives.$qiyu.goToQiyu();
    }
    goToPayView() {
        YLYKNatives.$showOrHideTabbar.showOrHideTabbar('hide');
        this.props.navigator.push({
            component: Pay,
        })
    }
    _alertDayNew() {
        Util.alertDialog({
            msg: '成为友邻学员即可收听此课程',
            oneBtn: '立即入学',
            okBtn: '咨询阿树老师',
            cancelBtn: '取消',
            okFun: () => {this.goToQiView()},
            oneFun: () => {this.goToPayView()},
        })
    }
    _noLoginView() {
        return Util.AppToast('请先登录');
    }
    componentWillMount() {
        let isMe = this.props.isMe;
        this.setState({isMe})
        if (this.props.imagesData) {
            var images = [];
            for (var i = 0; i < this.props.imagesData.length; i++) {
                var image = {url: this.props.imagesData[i]}
                images.push(image);
            }
            this.setState({showImages: images})
        } else {
            return;
        }
    }
    componentWillReceiveProps(newValue) {
        this.setState({
            isLiked: newValue.is_liked,
            thumbNumber: newValue.thumbNumber,
        });
    }
    componentDidMount() {
        this._getUserID();
        loginSubscription = myLoginEvent.addListener('LoginSuccess', (reminder) => {
            //console.log(reminder.LoginSuccess + "loginsuccess");
            this._getUserID();
        });
        logoutSubscription = myLogoutEvent.addListener('LogoutSuccess', (reminder) => {
            //console.log('新注销成功' + reminder.LogoutSuccess )
            if (reminder.LogoutSuccess) {
                this._getUserID();
            }
        })
        this.paySuccessSubscription = myPaySuccessEvents.addListener('PayEvent', (reminder) => {
            if (reminder.PaySuccess) {
                this.interval = setInterval(() => {
                    this._getUserID();
                }, 5000);
            }
        })
    }
    componentWillUnmount() {
        this.loginSubscription && this.loginSubscription.remove();
        this.logoutSubscription && this.logoutSubscription.remove();
    }
    _getUserID() {

        YLYKNatives.$oauth.getUserInfo().then((data) => {

            var resultData = JSON.parse(data);
            if (data == 0 || data == '0') {
                this.setState({noLogin: false})
            } else {
                this.setState({noLogin: true})

                let isVip = Util.isVip(resultData)
                if (isVip == false) {
                    this.setState({
                        hideNoVip: false,
                    })
                } else {
                    this.setState({
                        hideNoVip: true,
                    })
                    this.interval && this.interval.remove();
                }
            }
        }).catch((err) => {
            //   console.log('albunShow获取userID失败' + err)
        })
    }
    //点赞
    _chengeLikeState() {
        // console.log('点赞状态' + is_liked);
        if (this.state.isLiked == true) {
            this.setState({
                thumbNumber: --this.state.thumbNumber,
                isLiked: !this.state.isLiked
            })

            YLYKServices.$note.unlikeNote(this.state.noteId + '')

                .then((data) => {
                }).catch((err) => {
                //   console.log("点赞失败" + err)
            })
        } else {
            this.setState({
                thumbNumber: ++this.state.thumbNumber,
                isLiked: !this.state.isLiked
            })

            YLYKServices.$note.likeNote(this.state.noteId + '').then((data) => {

            }).catch((err) => {
                // console.log("点赞失败" + err)
            })
        }
    }
    _renderItem(item, i) {
        var url = item.url;
        return (
            <TouchableOpacity activeOpacity={1} style={styles.imageItem} onPress={()=>{this._showModal(item,i)}}>
                <Image style={styles.imageItem} source={ !item ?  require('../../imgs/11.png') : {uri: item.url + '$c180w180h'}}/>
            </TouchableOpacity>
        );
    }
    render() {
        return (
            <View style={[styles.container,this.state.isShow?{}:{height:0}]}>
                <TouchableOpacity activeOpacity={1} onPress={this.props.headerImageAction}>
                    <Image style={styles.HeadPortraitImage} source={this.props.headPortraitImage}/>
                </TouchableOpacity>
                <View style={styles.rightBigView}>
                    <TouchableOpacity activeOpacity={1} onPress={this.props.foucsActionFnc}>
                        <Image style={styles.FocusImage} source={this.props.focusChangeImage}/>
                    </TouchableOpacity>
                    <Text style={styles.nameText}>{this.props.name}</Text>
                    <Text style={styles.timeText}>{this.props.time}
                    </Text>
                    <View style={{
                        width: 295 * g_AppValue.precent,
                        marginTop: 8 * g_AppValue.precent,
                        marginBottom: this.props.content == '' ? - 10 * g_AppValue.precent :10 * g_AppValue.precent,
                    }}>
                        <Text style={styles.contentText} selectable = {true}
                              numberOfLines={this.props.numberOfLines}>{this.props.content}</Text>
                    </View>
                    <View style={styles.ImageView}>
                        {this.state.showImages.map((item, i) => this._renderItem(item, i))}
                    </View>
                    <TouchableOpacity activeOpacity={1}
                                      onPress={ this.state.noLogin == false ? ()=>{this._noLoginView()}  : this.state.hideNoVip == false ? ()=>{this._alertDayNew()} : this.props.palyAction}>
                        <View style={styles.payView}>
                            <Image style={styles.payImageOne} source={this.props.playImage}/>

                            <View style={styles.payRightView}>
                                <Text numberOfLines={1} style={styles.payRightTitleText}>{this.props.playTitle}</Text>
                                <Text style={styles.payRightNameText}>{this.props.playName}</Text>
                            </View>
                        </View>
                    </TouchableOpacity>
                    <View style={styles.ThumbView}>
                        {this.state.isMe ? (<TouchableOpacity activeOpacity={1} style={styles.deleteTextAction}
                                                              onPress={() => {this._deleteMyNote()}}>
                            <Text style={styles.deleteText}>删除</Text>
                        </TouchableOpacity>) : null}
                        <Text style={[{fontFamily:'iconfont'}, styles.thumbText]} onPress={() => {
                                   this._chengeLikeState(true);
                        }}>
                            {(this.state.isLiked ? Icon.likeFill : Icon.like) + " " + this.state.thumbNumber}
                        </Text>

                    </View>
                </View>
                <Modal style={{
                    backgroundColor: 'black'
                }} visible={this.state.modalVisible}>
                    <ImageViewer
                        index={this.state.index1}
                        onClick={()=>{this._closeModal()}}
                        imageUrls={this.state.showImages}
                        onSave={()=>{this._save()}}
                        onChange={(i)=>{this.setState({imageIndex:i})}}
                        loadingRender = {() => {
                          return <View style = {{width:100 * g_AppValue.precent,height:100 * g_AppValue.precent}} >
                                    <Image style = {{width:100 * g_AppValue.precent,height:100 * g_AppValue.precent}} source = {{uri:this.state.item.url + '$c180w180h'}}/>
                                  </View>
                        }}
                    />
                </Modal>
            </View>
        );
    }
}
var styles = StyleSheet.create({
    listView: {
        flex: 1,
        backgroundColor: '#f2f5f6'
    },
    container: {
        flex: 1,
        width: g_AppValue.screenWidth,
        backgroundColor: '#ffffff',
        marginTop: 10 * g_AppValue.precent,
        flexDirection: 'row'
    },
    HeadPortraitImage: {
        width: 39 * g_AppValue.precent,
        height: 39 * g_AppValue.precent,
        marginTop: 12 * g_AppValue.precent,
        marginLeft: 12 * g_AppValue.precent,
        borderRadius: 19.5 * g_AppValue.precent
    },
    FocusImage: {
        width: 54 * g_AppValue.precent,
        height: 21 * g_AppValue.precent,
        position: 'absolute',
        top: 0 * g_AppValue.precent,
        right: 12 * g_AppValue.precent
    },
    rightBigView: {
        flex: 1,
        width: 295 * g_AppValue.precent,
        //  backgroundColor:'green',
        marginTop: 17 * g_AppValue.precent,
        marginLeft: 10 * g_AppValue.precent
    },
    nameText: {
        width: 200 * g_AppValue.precent,
        fontSize: 14 * g_AppValue.precent,
        color: '#5a5a5a',
        textAlign: 'left'
    },
    timeText: {
        width: 200 * g_AppValue.precent,
        marginTop: 5 * g_AppValue.precent,
        fontSize: 11 * g_AppValue.precent,
        color: '#9a9b9c',
        textAlign: 'left'
    },
    contentText: {
        //width:295 * g_AppValue.precent,
        //marginTop:8 * g_AppValue.precent,
        fontSize: 13 * g_AppValue.precent,
        color: '#5a5a5a',
        textAlign: 'left',
        //  backgroundColor:'yellow',
        //  marginBottom:10* g_AppValue.precent,
    },
    ImageView: {
        width: 294 * g_AppValue.precent,
        marginLeft: -20 * g_AppValue.precent,
        flexWrap: 'wrap',
        flexDirection: 'row',
        //  backgroundColor:'red',
    },
    imageItem: {
        width: 88 * g_AppValue.precent,
        height: 88 * g_AppValue.precent,
        marginBottom: 10 * g_AppValue.precent,
        marginLeft: 10 * g_AppValue.precent
    },
    payView: {
        //marginTop:20 * g_AppValue.precent,
        width: 284 * g_AppValue.precent,
        height: 48 * g_AppValue.precent,
        borderWidth: 1,

        borderColor: 'rgba(200,200,200,0.5)',
        flexDirection: 'row'
    },
    payImageOne: {
        marginTop: 1 * g_AppValue.precent,
        marginLeft: 1 * g_AppValue.precent,
        marginBottom: 1 * g_AppValue.precent,
        width: 64 * g_AppValue.precent,
        height: 44 * g_AppValue.precent
    },
    payImageTwo: {

        width: 64 * g_AppValue.precent,
        height: 47 * g_AppValue.precent
    },
    payRightView: {
        //backgroundColor:'yellow',
        marginLeft: 10 * g_AppValue.precent,
        width: 200 * g_AppValue.precent,
        height: 48 * g_AppValue.precent
    },
    payRightTitleText: {
        //  backgroundColor:'red',
        marginTop: 8 * g_AppValue.precent,
        fontSize: 13 * g_AppValue.precent,
        color: '#5a5a5a',
        textAlign: 'left'
    },
    payRightNameText: {
        //backgroundColor:'green',
        marginTop: 4 * g_AppValue.precent,
        fontSize: 12 * g_AppValue.precent,
        color: '#5a5a5a',
        textAlign: 'left'
    },
    ThumbView: {
        flex: 1,
        height: 16 * g_AppValue.precent,
        marginTop: 15 * g_AppValue.precent,
        marginBottom: 14 * g_AppValue.precent,
        marginRight: 12 * g_AppValue.precent,
        justifyContent: 'flex-end',
        flexDirection: 'row'
    },
    thumbImage: {
        width: 16 * g_AppValue.precent,
        height: 16 * g_AppValue.precent,
        marginRight: 6 * g_AppValue.precent
    },
    thumbText: {
        fontSize: 14 * g_AppValue.precent,
        color: '#9a9b9c',
        textAlign: 'right'
    },
    saveImageView: {
        position: 'absolute',
        bottom: 0,
        width: g_AppValue.screenWidth,
        height: 120 * g_AppValue.precent,
        backgroundColor: '#f2f5f6',
        // opacity:0.3,
    },
    saveView: {
        width: g_AppValue.screenWidth,
        height: 55 * g_AppValue.precent,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#ffffff',
    },
    deleteTextAction: {
        position: 'absolute',
        top: 5 * g_AppValue.precent,
        left: 0 * g_AppValue.precent,
        marginBottom: 14 * g_AppValue.precent
    },
    deleteText: {
        fontSize: 11 * g_AppValue.precent,
        color: '#9a9b9c'
    },
})
