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
    Platform,
} from 'react-native';
//common
import Styles from '../../common/styles.js';
import Icon from "../../common/Icon.js";
import Util from "../../common/util.js";
//configs
import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js'
import YLYKServices from '../../configs/ylykbridges/YLYKServices.js'
import YLYKStorages from '../../configs/ylykbridges/YLYKStorages.js'
import g_AppValue from '../../configs/AppGlobal.js';
//组件
import ImageViewer from 'react-native-image-zoom-viewer';


export default class CourseNote extends Component {
    // 构造函数
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
            likeCount: 0,
            isLiked: false,
            noteId: 0,
            isMe: false,
            isShow: true,
            imageIndex: 0,
            showImages: [],
            item:'',
        };
    }
    componentDidMount() {
    }
    static defaultProps = {
        name: 'name',//标题
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
        },
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
    }
    _showModal(item,images, i) {
        this.setState({
            modalVisible: true,
            imageIndex: i,
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
    _save(url) {
        YLYKStorages.$fileStorage.saveImage(url).then((data) => {}).catch((err) => {})

    }
    _renderItem(item, images, i) {
        return (
            <TouchableOpacity style={styles.imageItem} onPress={() => { this._showModal(item,images,i) }}>
                <Image style={styles.imageItem} source={{ uri: item.url + '$c180w180h'}}/>
            </TouchableOpacity>
        );
    }
    //为渲染，加载数据
    componentWillMount() {
        let isMe = this.props.isMe;
        this.setState({isMe})
        this.setState({
            likeCount: this.props.thumbNumber,
            isLiked: this.props.isLiked,
            noteId: this.props.noteId,
        })
    }
    //改变点赞的状态 / 刪除心得
    _chengeLikeState(isUpdate) {
        if (this.state.isMe) return;
        let isLiked = this.state.isLiked,
            likeCount = isLiked ? --this.state.likeCount : ++this.state.likeCount;
        this.setState({
            likeCount: likeCount,
            isLiked: !isLiked
        })
        this._updateLike(isLiked);
    }
    //上传点赞状态
    _updateLike(isLike) {
        if (!isLike) {
            YLYKServices.$note.likeNote(this.state.noteId + '');
        } else {
            YLYKServices.$note.unlikeNote(this.state.noteId + '');
        }
    }
//删除笔记
    _delete() {
        if (Platform.OS == 'ios') {
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
        } else {
            YLYKServices.$note.deleteNote(this.state.noteId + '');
            this.setState({
                isShow: false
            })
        }
    }
    render() {
        if (!this.props.imagesData) {
            return;
        }
        var images = [];
        for (var i = 0; i < this.props.imagesData.length; i++) {
            var image = {url: this.props.imagesData[i]}
            images.push(image);
        }
        return (
            <View style={[styles.container,this.state.isShow?{}:{height:0}]}>
                <TouchableOpacity onPress={this.props.headerImageAction}>
                    <Image style={styles.HeadPortraitImage} source={this.props.headPortraitImage}/>
                </TouchableOpacity>
                <View style={styles.rightBigView}>
                    <TouchableOpacity onPress={this.props.foucsActionFnc}>
                        <Image style={styles.FocusImage} source={this.props.focusChangeImage}/>
                    </TouchableOpacity>
                    <Text style={styles.nameText}>{this.props.name}</Text>
                    <Text style={styles.timeText}>{this.props.time} </Text>
                    <View
                        style={{ width: 295 * g_AppValue.precent, marginTop: 8 * g_AppValue.precent, marginBottom: this.props.content == '' ? - 10 * g_AppValue.precent :10 * g_AppValue.precent}}>
                        <Text style={styles.contentText} selectable = {true}
                              numberOfLines={this.props.numberOfLines}>{this.props.content}</Text>
                    </View>
                    <View style={styles.ImageView}>
                        {images.map((item, i) => this._renderItem(item, images, i))}
                    </View>
                    <View style={[styles.row]}>
                        {this.state.isMe ?
                            <Text style={[Styles.icon, styles.thumbText,styles.delText]} onPress={()=>{this._delete()}}>删除</Text> :
                            <Text></Text>}
                        <Text style={[Styles.icon, styles.thumbText]} onPress={() => {
                          this.props.noteId && this._chengeLikeState(true);
                          //调用父组件的方法
                          this.props.thumActionFnc && this.props.thumActionFnc();
                      }}>
                            { (this.state.isLiked ? Icon.likeFill : Icon.like ) + " " + this.state.likeCount }
                        </Text>
                        {/*<Text style={[Styles.icon, styles.thumbText]} onPress={() => {
                         this.props.noteId && this._chengeLikeState(true);
                         //调用父组件的方法
                         this.props.thumActionFnc && this.props.thumActionFnc();
                         }}>
                         </Text>*/}
                    </View>
                </View>
                <Modal style={{
            backgroundColor: 'black'
        }} visible={this.state.modalVisible}>
                    <ImageViewer
                        index={this.state.imageIndex}
                        onClick={()=>{this._closeModal()}}
                        imageUrls={images}
                        onSave={(url)=>{this._save(url)}}
                        loadingRender = {() => {
                          return <View style = {{width:100 * g_AppValue.precent,height:100 * g_AppValue.precent}} >
                                    <Image style = {{width:100 * g_AppValue.precent,height:100 * g_AppValue.precent}} source = {{uri: this.state.item.url + '$c180w180h'}}/>
                                  </View>
                        }}
                    />
                </Modal>
            </View>
        );
    }

    // 自定义方法区域
    // your method
}
var styles = StyleSheet.create({
    listView: {
        flex: 1,
        backgroundColor: '#f2f5f6',
    },
    container: {
        flex: 1,
        width: g_AppValue.screenWidth,
        backgroundColor: '#ffffff',
        marginBottom: 10 * g_AppValue.precent,
        flexDirection: 'row',
    },
    HeadPortraitImage: {
        width: 39 * g_AppValue.precent,
        height: 39 * g_AppValue.precent,
        marginTop: 12 * g_AppValue.precent,
        marginLeft: 12 * g_AppValue.precent,
        borderRadius: 19.5 * g_AppValue.precent,
    },
    FocusImage: {
        width: 54 * g_AppValue.precent,
        height: 21 * g_AppValue.precent,
        position: 'absolute',
        top: 0 * g_AppValue.precent,
        right: 12 * g_AppValue.precent,
    },
    rightBigView: {
        flex: 1,
        width: 295 * g_AppValue.precent,
        //  backgroundColor:'green',
        marginTop: 17 * g_AppValue.precent,
        marginLeft: 10 * g_AppValue.precent,
    },
    nameText: {
        width: 200 * g_AppValue.precent,
        fontSize: 14 * g_AppValue.precent,
        color: '#5a5a5a',
        textAlign: 'left',
    },
    timeText: {
        width: 200 * g_AppValue.precent,
        marginTop: 5 * g_AppValue.precent,
        fontSize: 11 * g_AppValue.precent,
        color: '#9a9b9c',
        textAlign: 'left',
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
        marginLeft: 10 * g_AppValue.precent,
    },
    payView: {
        //marginTop:20 * g_AppValue.precent,
        width: 284 * g_AppValue.precent,
        height: 48 * g_AppValue.precent,
        flexDirection: 'row',
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
        height: 48 * g_AppValue.precent,
    },
    payRightView: {
        marginLeft: 10 * g_AppValue.precent,
        width: 210 * g_AppValue.precent,
        height: 48 * g_AppValue.precent,
    },
    payRightTitleText: {
        marginTop: 8 * g_AppValue.precent,
        fontSize: 13 * g_AppValue.precent,
        color: '#5a5a5a',
        textAlign: 'left',
    },
    payRightNameText: {
        marginTop: 4 * g_AppValue.precent,
        fontSize: 12 * g_AppValue.precent,
        color: '#5a5a5a',
        textAlign: 'left',
    },
    ThumbView: {
        flex: 1,
        height: 16 * g_AppValue.precent,
        marginTop: 15 * g_AppValue.precent,
        marginBottom: 14 * g_AppValue.precent,
        marginRight: 12 * g_AppValue.precent,
        justifyContent: 'flex-end',
        flexDirection: 'row',
    },
    thumbImage: {
        width: 16 * g_AppValue.precent,
        height: 16 * g_AppValue.precent,
        marginRight: 6 * g_AppValue.precent,
    },
    thumbText: {
        fontSize: 14 * g_AppValue.precent,
        color: '#9a9b9c',
        width: 40 * g_AppValue.precent,
        //backgroundColor:'red',
    },
    row: {
        flexDirection: "row",
        justifyContent: "space-between",
        paddingVertical: 20 * g_AppValue.precent,
        backgroundColor: '#ffffff',
    },
    delText: {
        fontSize: 11 * g_AppValue.precent
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
})
